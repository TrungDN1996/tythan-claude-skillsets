# Knowledge System

A per-domain memory of what's been learned about this codebase, so patterns
don't have to be rediscovered every session.

## Structure

```
.claude/docs/knowledge/learning
  INDEX.md                  # one line per domain folder + when to use it
  <domain>/
    knowledge.md             # observed facts and patterns (neutral, not yet a rule)
    hypotheses.md            # suspected pattern, not yet confirmed
    rules.md                 # confirmed — apply by default without re-checking
```

Domains are whatever partitions make sense for the repo (e.g. `api`,
`frontend-state`, `testing`, `db-migrations`). Create a new domain folder the
first time a task clearly belongs to it and no existing folder fits.

If `.claude/docs/knowledge/learning/` doesn't exist yet, create it along with
`INDEX.md` (empty routing table) the first time this skill runs.

## Before a task

1. Read `INDEX.md`. Identify which domain folder(s) the current task touches.
2. Read that domain's `rules.md` — apply these by default. Do not silently
   deviate; if you think a rule no longer fits, say so and treat it as
   contested rather than ignoring it.
3. Skim `hypotheses.md`. If today's work happens to touch one of them, note
   that it's a chance to gather evidence (confirm or contradict).
4. Skim `knowledge.md` for relevant context, but treat it as informative,
   not binding.

## After a task

Extract only what a *future* session in this domain would benefit from
knowing — skip anything obvious, one-off, or already captured.

- **New fact or pattern observed** → append to `knowledge.md`.
- **New suspected pattern, not yet proven** → append to `hypotheses.md`.
- **A hypothesis was tested today and held** → increment its confirmation
  count in `hypotheses.md`. At 3+ confirmations, move it to `rules.md` and
  remove it from `hypotheses.md`.
- **A rule was contradicted by today's work** → move it from `rules.md`
  back to `hypotheses.md`, reset its confirmation count to 0, and add a
  one-line note on what contradicted it.
- Update `INDEX.md` if a new domain folder was created, or if a domain's
  one-line summary is now stale.

## Entry format

Keep entries short and dated so drift is visible over time.

```md
- [YYYY-MM-DD] <the fact, pattern, or rule, stated as one sentence>
  <optional: 1-line context or example>
```

For `hypotheses.md`, also track a confirmation count inline:

```md
- [YYYY-MM-DD] (confirmed: 2/3) <hypothesis statement>
```

## INDEX.md format

```md
# Knowledge Index

- `api/` — REST endpoint conventions, auth middleware patterns
- `testing/` — fixture setup, mocking conventions
```

One line per domain: folder name + what it covers, so the agent can decide
which folder(s) to read without opening all of them.
