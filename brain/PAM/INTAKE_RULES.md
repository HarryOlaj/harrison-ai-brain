# INTAKE_RULES

## Mode
B mode: natural-language capture with lightweight classification.

## Classification Targets
- `note`
- `task`
- `event`
- `question`
- `chat`

## Action Rules
1. Auto-capture
   - `note`: capture immediately.
   - `task`: capture immediately.

2. Confirm-before-action
   - `event`: ask for confirmation before creating.
   - `email`: ask for confirmation before any send/draft action.

3. Uncertainty handling
   - If uncertain, ask exactly one clarifying question.

## Logging Requirements
Each intake event must log:
- `intent`
- `extracted_title` (if any)
- `extracted_due` (if any)
- `confidence` (`low` | `med` | `high`)
- `kill_switch`
- `privacy_mode`

## Guardrails
- Deny-by-default for unsupported actions.
- No business context/tool access.
- No shell or git operations.
