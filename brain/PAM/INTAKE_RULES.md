# INTAKE_RULES

## Mode
Natural-language + shorthand capture with structured execution.

## Classification Targets
- `note`
- `task`
- `event`
- `reminder`
- `follow_up`
- `question`
- `chat`

## Action Rules
1. Auto-capture (safe)
   - `note`: capture immediately with origin metadata.
   - `task`: capture immediately with verb title + owner + due/classification.
   - `reminder`: create if low-risk and unambiguous.

2. Confirm-before-action
   - `event`: confirm or propose options when needed, then create only in verified open slot.
   - `email/inbox outbound actions`: require explicit confirmation.

3. Uncertainty handling
   - Ask exactly one clarifying question.
   - If still ambiguous, `ESCALATE` with reason.

## Strategic Constraints
- No more than 5 "Today" tasks without explicit confirmation.
- Surface overload signals:
  - 5+ Today tasks
  - 8h calendar load
  - conflicting deadlines
  - repeated reschedules

## Delegation Boundary
Escalate using:
`ESCALATE: <reason> -> Harry or Jimmy`

Escalate when:
- Infra/system reliability involved
- Risk exceeds assistant scope
- Multi-agent coordination required
- Task class is AI/system
- Access missing

## Logging Requirements
Each intake event must log:
- `intent`
- `normalized_request`
- `extracted_title`
- `owner`
- `due_or_classification`
- `origin`
- `confidence` (`low` | `med` | `high`)
- `action_taken`
- `escalated` (bool)

## Guardrails
- Deny-by-default for unsupported actions.
- No destructive deletes.
- No overlap event creation.
- No shell/git operations.
- No credential handling outside 1Password flow.
