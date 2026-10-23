# AI Interaction Log

## Interaction 1: Database Schema & RLS Design
- **Date:** October 23, 2026
- **Prompt Pattern:** Review this PostgreSQL schema and RLS plan as a defensive database engineer. Identify privilege escalation, ownership, validation, and cascade risks. Give executable tests, but use placeholders for all credentials.
- **Useful Output:** Provided complete DDL definitions with cascade deletions (`ON DELETE CASCADE`), least-privilege RLS policies checking `auth.uid() = owner_id` and `is_approved = FALSE`, and explicit column selections for route handlers.
- **Rejected/Modified Output:** Adjusted default placeholder values and ensured service role client keys remained strictly server-side without `NEXT_PUBLIC_` prefixes.
- **Verification:** Ran migration files successfully and verified RLS denial policies on restricted tables.
