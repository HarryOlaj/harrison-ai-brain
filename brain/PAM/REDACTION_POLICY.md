# REDACTION_POLICY

## Purpose
Prevent sensitive data from being committed to git while preserving useful operational context.

## Non-Negotiable Rules
1. No raw message dumps.
2. No tokens, API keys, passwords, OTPs, or secret material.
3. No full email quotes.
4. Summarize sensitive content instead of reproducing verbatim.
5. Redact personal identifiers to minimum necessary detail when possible.

## Allowed Content in Committed PAM Files
- Summaries of events and decisions.
- Task and calendar outcomes (non-sensitive).
- Open loops and follow-ups.
- Preference updates that are not secrets.

## Prohibited Content in Committed PAM Files
- Raw SMS bodies copied in full.
- Raw email body excerpts copied in full.
- Authentication headers, bearer tokens, cookies.
- Credential files or path contents containing secrets.

## Commit Gate Checklist (Required)
Before any digest or memory commit, verify all are true:
- [ ] No raw message dump included.
- [ ] No secrets/tokens present.
- [ ] No full email quote included.
- [ ] Sensitive items summarized + redacted.
- [ ] Diff review completed and approved.

If any item fails, do not commit.
