#!/usr/bin/env python3
"""
Channel-based task router for Harrison AI Brain orchestrator layer.

- Reads inbound message metadata (JSON file or JSON string)
- Maps channel -> (business, agent_name)
- Builds task packet from task_packet_template.json reference
- Writes packet into ~/ai_ops/up360-ai-workroom/tasks/
- Supports --dry-run to print packet without writing
"""

from __future__ import annotations

import argparse
import datetime as dt
import json
import re
import sys
from pathlib import Path
from typing import Any, Dict, Tuple

BRAIN_ROOT = Path.home() / "ai_ops" / "harrison-ai-brain"
ORCH_DIR = BRAIN_ROOT / "orchestrator"
TEMPLATE_PATH = ORCH_DIR / "task_packet_template.json"
WORKROOM_TASKS_DIR = Path.home() / "ai_ops" / "up360-ai-workroom" / "tasks"
LOG_DIR = ORCH_DIR / "logs"
LOG_FILE = LOG_DIR / "channel_router.log"

# Name-based mapping requested by user
CHANNEL_NAME_MAP: Dict[str, Tuple[str, str]] = {
    "main": ("SYSTEM", "AI Harry"),
    "up360": ("UP360", "VR Harry"),
    "earth-island-homes": ("EarthIsland", "Earth Harry"),
    "realestate": ("RealEstate", "House Harry"),
}

# Optional ID-based map (fill with real IDs if desired later)
CHANNEL_ID_MAP: Dict[str, Tuple[str, str]] = {}


def log(msg: str) -> None:
    LOG_DIR.mkdir(parents=True, exist_ok=True)
    ts = dt.datetime.now(dt.timezone.utc).isoformat()
    with LOG_FILE.open("a", encoding="utf-8") as f:
        f.write(f"{ts} {msg}\n")


def now_iso_utc() -> str:
    return dt.datetime.now(dt.timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")


def slugify(value: str) -> str:
    value = value.strip().lower()
    value = re.sub(r"[^a-z0-9]+", "-", value)
    value = re.sub(r"-+", "-", value).strip("-")
    return value or "task"


def parse_metadata(metadata_arg: str) -> Dict[str, Any]:
    p = Path(metadata_arg)
    if p.exists() and p.is_file():
        return json.loads(p.read_text(encoding="utf-8"))
    return json.loads(metadata_arg)


def normalize_channel_name(raw: str | None) -> str:
    if not raw:
        return ""
    c = raw.strip().lower()
    if c.startswith("#"):
        c = c[1:]
    return c


def extract_channel(metadata: Dict[str, Any]) -> Tuple[str, str]:
    # Try common shapes
    channel_name = normalize_channel_name(
        metadata.get("channel_name")
        or metadata.get("channel")
        or metadata.get("room")
        or metadata.get("discord_channel_name")
    )

    channel_id = str(
        metadata.get("channel_id")
        or metadata.get("chat_id")
        or metadata.get("discord_channel_id")
        or ""
    )

    # If chat_id is like channel:147...
    if channel_id.startswith("channel:"):
        channel_id = channel_id.split(":", 1)[1]

    return channel_name, channel_id


def route(metadata: Dict[str, Any]) -> Tuple[str, str]:
    channel_name, channel_id = extract_channel(metadata)

    if channel_name in CHANNEL_NAME_MAP:
        return CHANNEL_NAME_MAP[channel_name]

    if channel_id in CHANNEL_ID_MAP:
        return CHANNEL_ID_MAP[channel_id]

    raise ValueError(
        f"No route for channel_name='{channel_name}' channel_id='{channel_id}'. "
        "Add mapping in CHANNEL_NAME_MAP or CHANNEL_ID_MAP."
    )


def build_task_packet(
    template: Dict[str, Any],
    *,
    task_id: str,
    title: str,
    requested_by: str,
    allowed_commands: list[str],
    business: str,
    agent_name: str,
    risk_level: str,
) -> Dict[str, Any]:
    t = dict(template)  # shallow copy is enough for this structure

    t["task_id"] = task_id
    t["title"] = title
    t["business"] = business
    t["agent_name"] = agent_name
    t["risk_level"] = risk_level
    t["created_at"] = now_iso_utc()
    t["requested_by"] = requested_by

    # Required system defaults from instruction
    t["state"] = "WAIT_FOR_APPROVAL"
    t["approval_required"] = True
    t["approval"] = None
    t["allowed_hosts"] = ["harry-macbook-pro"]

    t["allowed_commands"] = allowed_commands
    t["execution_log_path"] = f"runs/{task_id}/log.txt"

    # Keep template's default placeholders where not explicitly supplied
    t.setdefault("inputs", [])
    t.setdefault("artifacts_paths", [])

    # Output expectations + estimates for simple echo checks
    is_single_echo = len(allowed_commands) == 1 and "echo" in allowed_commands[0].lower()
    if any("echo" in cmd.lower() for cmd in allowed_commands):
        t["outputs_expected"] = ["Echo output in run log"]
    else:
        t["outputs_expected"] = ["See run log at execution_log_path"]

    if is_single_echo:
        t["estimate_low_sec"] = 5
        t["estimate_high_sec"] = 30

    return t


def main() -> int:
    parser = argparse.ArgumentParser(description="Route channel metadata -> tagged task packet")
    parser.add_argument("--metadata", required=True, help="JSON string or path to metadata JSON file")
    parser.add_argument("--title", required=True, help="Task title")
    parser.add_argument("--command", action="append", dest="commands", required=True, help="Allowed command (repeatable)")
    parser.add_argument("--task-id", default="", help="Optional explicit task_id")
    parser.add_argument("--requested-by", default="Harrison")
    parser.add_argument("--risk-level", default="LOW", choices=["LOW", "MEDIUM", "HIGH"])
    parser.add_argument("--dry-run", action="store_true", help="Print packet only; do not write")
    args = parser.parse_args()

    template = json.loads(TEMPLATE_PATH.read_text(encoding="utf-8"))
    metadata = parse_metadata(args.metadata)
    business, agent_name = route(metadata)

    task_id = args.task_id.strip() or f"task-{slugify(args.title)}-{dt.datetime.now().strftime('%Y%m%d%H%M%S')}"

    packet = build_task_packet(
        template,
        task_id=task_id,
        title=args.title,
        requested_by=args.requested_by,
        allowed_commands=args.commands,
        business=business,
        agent_name=agent_name,
        risk_level=args.risk_level,
    )

    if args.dry_run:
        print(json.dumps(packet, indent=2))
        print(f"Approve task {task_id}")
        print(f"Run task {task_id}")
        log(f"dry-run task_id={task_id} business={business} agent={agent_name}")
        return 0

    WORKROOM_TASKS_DIR.mkdir(parents=True, exist_ok=True)
    out = WORKROOM_TASKS_DIR / f"{task_id}.json"
    out.write_text(json.dumps(packet, indent=2) + "\n", encoding="utf-8")

    print(f"WROTE {out}")
    print(f"Approve task {task_id}")
    print(f"Run task {task_id}")
    log(f"wrote task_id={task_id} path={out} business={business} agent={agent_name}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as e:
        log(f"error: {type(e).__name__}: {e}")
        print(f"ERROR: {e}", file=sys.stderr)
        raise
