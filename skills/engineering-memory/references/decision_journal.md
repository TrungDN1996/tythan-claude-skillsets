# Decision Journal

A log of decisions that affect more than the current task — architecture,
library choices, naming/error-handling conventions, anything a future
session would otherwise have to re-decide from scratch.

## Structure

```
.claude/docs/decisions/
  YYYY-MM-DD-{topic}.md
```

Flat folder, one file per decision. `{topic}` is a short kebab-case slug
(e.g. `2026-07-31-error-handling-strategy.md`).

## Logging a decision

Create `.claude/docs/decisions/YYYY-MM-DD-{topic}.md`:

```md
## Decision: {what you decided, one sentence}
## Context: {what prompted this decision — the situation, constraint, or question}
## Alternatives considered: {other options that were on the table}
## Reasoning: {why this option won over the alternatives}
## Trade-offs accepted: {what was given up by choosing this}
## Supersedes: {link to prior decision file, or "None"}
```

Keep each section to a few sentences — this is a log, not a design doc.

## Superseding a prior decision

- Create a new file rather than editing the old one; decisions are a
  history, not a mutable state.
- Set `## Supersedes:` to the old file's name.
- Optionally add a one-line note at the top of the *old* file:
  `> Superseded by YYYY-MM-DD-{topic}.md` — do this via a small edit, not a
  rewrite of its content.

## What counts as "affects more than today's task"

Examples that qualify: choice of state-management library, API
error-response shape, folder/module layout convention, retry/backoff
strategy, auth approach. Examples that don't: a variable name, the order of
two independent helper functions, formatting choices already enforced by a
linter.
