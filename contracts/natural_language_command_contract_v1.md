# NATURAL LANGUAGE COMMAND CONTRACT v1

Owner: Harrison  
Scope: Harry + Jimmy prompt interpretation and execution behavior

## Why this contract exists
- Prevent mode ambiguity (diagnostic vs execute vs review)
- Prevent success-criteria drift
- Prevent instruction collisions and approval confusion
- Make responses machine-checkable and consistent

## Command Envelope (required interpretation fields)
For every operational prompt, parse and lock:
- `intent`
- `mode` (`diagnostic` | `execute` | `review`)
- `change_policy` (`no-change` | `config-only` | `full`)
- `target` (`local-gateway` | `remote-gateway` | `node-id`)
- `success_gate` (explicit pass condition)
- `output_schema` (required response format)

## Execution Policy
- Single active objective per turn
- Max one blocking question when blocked
- No implicit retries beyond stated retry budget
- Stricter constraint wins on conflict (`no-change` overrides mutation directives)

## Safety + Approval Policy
- Low risk (read/probe/status): execute directly
- Medium risk (restart/reconnect/kill): execute with clear evidence and rollback
- High risk (token/auth rotation, security/policy widening, destructive actions): require explicit same-thread approval

Valid approval examples:
- `approved`
- `approve`
- `go ahead`
- `proceed`
- scoped forms like `approved-run`, `rotate-now`

Approval scope rule:
- Approval is narrow and applies only to explicitly scoped step set.

## Evidence Policy
Every execution response must include raw evidence line(s) tied to success gate.

## Gate Policy
- **Gate B is globally mandatory** for any "connected" operational claim in execute/diagnostic contexts.
- Gate B definition: lightweight executable proof (e.g., `LIGHT_OK`) succeeds.
- Exception: review/plan-only mode may omit Gate B and must explicitly state "no execution".

## Operator UX Policy
- No-terminal-first by default
- If terminal is unavoidable: provide one concise copy/paste block

## Phrase Mapping (v1 examples)
- “Run Known-Good checkpoint” → verify mode, no policy drift, Gate B required
- “No changes / no edits” → force `change_policy=no-change`
- “Proceed now” → `mode=execute` with ordered goals
- “If blocked, ask one question” → enforced
- “Gate B mandatory” → execution proof required before connected claims

## Execution Authority Reminder
- Default executor: HARRY
- Default reviewer/CTO: JIMMY
- Jimmy executes only on explicit delegation phrase: `DELEGATE TO JIMMY: <bounded task>`
