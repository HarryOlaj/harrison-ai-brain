# CONTACTS

## Identity Linking (Cross-Channel)
Use this table to map one person across Discord, SMS, and Email.

| person_id | display_name | relationship | discord_user_id | phone_e164 | email_primary | email_aliases | notes |
|---|---|---|---|---|---|---|---|
| | | | | | | | |

## Emergency Contacts
| name | relationship | phone_e164 | email | escalation_priority | notes |
|---|---|---|---|---|---|
| | | | | | |

## Validation Rules
- `discord_user_id` required when Discord DM is used.
- `phone_e164` required when SMS is used.
- `email_primary` required for email workflows.
- Keep aliases updated to avoid split context.
