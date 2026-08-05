---
name: reproduce-bug-report
description: Reproduce a raw bug using browser automation and DevTools MCP, confirm it is real, save structured observations, and report the outcome.
argument-hint: <ticket_number> [app_url]
disable-model-invocation: true
allowed-tools: Read, Write, Glob, mcp__devtools__*
---

# Bug Reproduce Devtool MCP

Knowledge: Read `.claude/docs/knowledge/product.md` if any.

## Scope & Safety

- **Read-only investigation.** This command reproduces and documents a bug — it does not fix code, submit real payments, send real emails/notifications, or delete production data. If the trigger step would require an irreversible or destructive action beyond what's needed to observe the bug, stop and report `UNSAFE_ACTION_REQUIRED` instead of proceeding.
- **Never write credentials in plaintext** to logs, snapshots, or `issue-observations.md`. Reference the username normally but always render the password as `[REDACTED]`.
- Do not edit application source, config, or the issue report itself. Tool access is restricted to Read, Write (observations file only)

## Inputs

- `TICKET_NUMBER` — required, first argument.
- `APP_URL` — second argument if given, otherwise fall back to `APP_URL` in `.claude/docs/knowledge/product.md`.
- Missing `TICKET_NUMBER`, or `APP_URL` unresolved from both sources → stop, report exactly which is missing. No continuation.

## Gate — Tool Check

Confirm the tool list includes both:
- a browser-automation tool set (navigate / fill / click / snapshot)
- a DevTools MCP tool set (`devtools/console`, `devtools/network` or equivalents)

Missing either → stop, report which is missing, ask the user to enable it. No continuation.

## Step 1 — Load Report

Read `.claude/docs/plan/{TICKET_NUMBER}/issue-report.md`.

Extract:
- The flow → split on `→` → ordered nav steps

Hard stop: file missing → report `REPORT_NOT_FOUND`, ask user to run Bug Formatter. No continuation.

## Step 2 — Login

1. Navigate to `{APP_URL}`
2. Fill credentials — log this action as `Fill credentials: username=<value>, password=[REDACTED]`, never the real password
3. Wait for dashboard/home full load
4. DevTools snapshot → confirm session active

Hard stop: login fails → delete all snapshots, report failure reason, stop.

## Step 3 — Reproduce Flow

Execute `Flow:` steps in order.

Element resolution priority (high → low): exact visible label, partial visible label, `aria-label`, `placeholder`, `name`/`id`, role + semantic similarity.

Per step:
- Identify top 3 candidates by priority
- Log each before acting: `tag | matched field | matched value`
- Attempt candidate 1; no UI state change in 2s → try 2, then 3
- Log outcome: `✅ RESOLVED via candidate [N]` or `⏭️ CANDIDATE_FAILED [N]: no UI state change`
- All 3 fail → log `⚠️ STEP_UNRESOLVED: "[step text]" — all candidates exhausted`, continue

Final (bug-trigger) step:
- Snapshot BEFORE
- 3s settle after action
- Snapshot AFTER

Trigger unresolved → log `⚠️ TRIGGER_UNRESOLVED — reproduction incomplete, human review required`, delete all snapshots, stop immediately.

Per-step checkpoint (exactly one):
- `✅ [step N] resolved normally`
- `⚠️ [step N] outcome: [reason]`

Flow completion summary:

| Category | Count | Detail |
|---|---|---|
| Resolved normally | N | — |
| Resolved via fallback | N | Candidate used, per step |
| Unresolved | N | Step text + reason |
| Trigger step | — | `RESOLVED` or `TRIGGER_UNRESOLVED` |

## Step 4 — Collect Evidence

Run after bug trigger. Both channels required.

Console (`devtools/console`): uncaught exceptions, failed assertions, framework error boundaries. Exact messages + stack trace summaries. None → `"None"`.

Network (`devtools/network`): 4xx/5xx responses → URL, status, response body. Flag missing expected API calls. None → `"None"`.

## Step 5 — Save Observations

If `.claude/docs/plan/{TICKET_NUMBER}/issue-observations.md` already exists, overwrite it — this command is the source of truth for reproduction results.

Save to `.claude/docs/plan/{TICKET_NUMBER}/issue-observations.md`:

```markdown
## Observations: {TICKET_NUMBER}

### Result
Consistent | Intermittent | Could Not Reproduce

### Trigger Steps
[Exact sequence that caused the bug]

### Broken State
- **Actual:** [What the UI showed]
- **Expected:** [What it should have shown]

### Console Errors
- [Error message and source, or "None"]

### Network Issues
- [URL + status code + summary, or "None"]

### Edge Cases
- [Any related variations noticed]
```

Hard stop: Result = `Could Not Reproduce` → complete template, save file, delete all snapshots, report `REPRODUCTION_FAILED`, stop. No continuation.

Hard stop: `issue-observations.md` not created → report `OBSERVATIONS_MISSING`, stop.

## Step 6 — Cleanup

Delete all DevTools snapshots. Retain only `issue-observations.md`.

Mandatory. Runs regardless of success or hard stop exit.

## Hard-Stop Reference

Every hard stop below deletes all snapshots first (except where none exist yet), then stops with no continuation:

| Condition | Report |
|---|---|
| `TICKET_NUMBER` or `APP_URL` unresolved | which is missing |
| Required tools unavailable | which tool set is missing |
| `issue-report.md` missing | `REPORT_NOT_FOUND` |
| Login fails | failure reason |
| Trigger step unresolved | `TRIGGER_UNRESOLVED` |
| 3+ consecutive `STEP_UNRESOLVED` | `TRIGGER_UNRESOLVED` |
| Unexpected URL/404, auth wall, crash, or unrelated env error | brief reason |
| Trigger step requires a destructive/irreversible action | `UNSAFE_ACTION_REQUIRED` |
| Result = `Could Not Reproduce` | `REPRODUCTION_FAILED` |
| `issue-observations.md` not created | `OBSERVATIONS_MISSING` |

## Output

Report exactly:

```
REPRODUCTION RESULT: [Consistent | Intermittent | Could Not Reproduce]
OBSERVATIONS FILE: .claude/docs/plan/{TICKET_NUMBER}/issue-observations.md
STATUS: [PASS | FAIL]
REASON: [If FAIL, brief explanation]
```

## Done When

`.claude/docs/plan/{TICKET_NUMBER}/issue-observations.md` saved AND Result = `Consistent` or `Intermittent`.