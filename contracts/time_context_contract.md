# TIME CONTEXT CONTRACT v1

Owner: Harrison  
Scope: All Harry + Jimmy operational responses

## Rule
- Never infer time context from conversation tone (e.g., "tonight", "this morning").
- Always use runtime/system time as source of truth.
- Always state timezone when reporting schedule/time-sensitive status.

## Required Behavior
- For schedule, reporting, planning, and deadline-sensitive responses:
  - include current timestamp + timezone at top of response.
- If runtime time is unavailable, explicitly state uncertainty before proceeding.

## Timezone Authority
- Contract timezone default: America/Halifax (unless explicitly overridden by Harrison).
