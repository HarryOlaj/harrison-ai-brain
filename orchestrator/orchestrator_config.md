# Orchestrator Config (Draft)

## Named Agents
- AI Harry (system)
- VR Harry (UP360)
- Earth Harry (Earth Island Homes)
- House Harry (Real Estate)

## Rules
- Workroom execution engine is separate (up360-ai-workroom).
- Orchestrator assigns business tag + agent tag to every task.
- Only the named Harry for that business can propose Brain updates.
- ClickUp actions require business space mapping.

## Inputs
- Discord messages (channel-based routing)
- ClickUp tasks (read/write)
- Workroom task queue (write only)

## Outputs
- Workroom task packets with:
  - business
  - agent_name
  - priority
  - approval_required
- Daily KPI rollups
