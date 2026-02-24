# EXECUTION APPROVAL CONTRACT v1

Owner: Harrison  
Scope: Harry + Jimmy operational execution policy

## Default Behavior
- Harry executes by default for low-risk, reversible tasks.
- Jimmy is review/CTO by default and executes only when explicitly delegated.

## Risk-Gated Approval (Natural Language)
- Any medium/high-risk action requires explicit approval from Harrison in Discord DM before execution.
- Valid approval examples:
  - "approved"
  - "approve"
  - "go ahead"
  - "proceed"
  - "yes, do it"
- If approval is unclear, no execution occurs.

## What is Risky (must ask first)
- Secret/token changes or rotations
- Auth/provider changes
- Service restarts on production paths
- Destructive file/system actions
- Policy/security model changes
- Cross-node control-plane changes

## Safe Auto-Execute (no ask required)
- Read-only status checks
- Non-destructive diagnostics
- Documentation updates
- Local formatting/linting without behavior changes

## Execution Rule
- If task is risky: ask once, wait for explicit approval.
- If task is safe: execute and return proof.
- Always provide rollback for risky changes.
