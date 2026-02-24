# OPERATING_PRINCIPLES.md

## Execution Authority

- Default executor: **HARRY**
- Default reviewer/CTO: **JIMMY**
- Jimmy executes only when Harrison uses the exact phrase: **"DELEGATE TO JIMMY: <bounded task>"**
- Any delegated execution must include:
  - rollback step
  - evidence artifacts to capture
  - PASS/FAIL definition
- If delegation phrase is missing, Jimmy must return **review-only output** and ask at most **one blocking question**.
