# Creating a new CLAUDE.md

Read this file only when writing a `CLAUDE.md` from scratch, or rewriting one wholesale. Don't pull in `syncing.md` for this — that's a different pass with a different job.

## Quick start

Minimal skeleton — start here, then flesh out with the rules below:

```md
# <project-name>

One-line description of what this repo is.

## Product
<One short paragraph — what it does, for whom.>
See `.claude/docs/knowledge/product.md` for user flows and business rules.

## Tech stack
<Framework, language, versions, database — facts Claude can't guess.>

## Commands
- Build: `<exact command>`
- Test:  `<exact command>`
- Lint:  `<exact command>`
- Run:   `<exact command>`

## Architecture
<2–3 sentences on the shape of the system.>
See `.claude/docs/knowledge/architecture.md` for the full breakdown.

## Conventions
<Patterns a linter can't enforce: repository pattern, error handling, naming.>

## Boundaries
Do not touch: `legacy/`, generated files, vendored code.

## Docs
- `.claude/docs/knowledge/product.md` — user flows, feature breakdowns
- `.claude/docs/knowledge/architecture.md` — directory map, data flow
- `.claude/docs/knowledge/contributing.md` — branching, PR, review, commit style
```

Fill every command and version claim from the repo's actual config files (`package.json`, `pyproject.toml`, `Cargo.toml`, etc.) — never guess or write "conventional" commands.

## Rules

**1. Less is more.** Frontier thinking models track roughly 150–200 instructions reliably; smaller/non-thinking models fewer. All models degrade as instruction count rises — **adding instructions doesn't just bury new ones, it degrades adherence to all of them.** Claude Code's own system prompt already carries ~50 instructions before `CLAUDE.md` is read. Keep only instructions true for every task, not just some.

**2. Keep it short.** Task-specific instructions (e.g. "how to structure a new DB schema") just add noise on sessions where they don't apply. Target: under 300 lines, ideally under 100.

**3. Use progressive disclosure.** Split task-specific instructions into named docs and point to them from `CLAUDE.md`:

```
.claude/docs/knowledge/
  product.md              # user flows, feature breakdowns, business rules
  architecture.md         # directory responsibilities, file tree, data flow
  contributing.md         # branching, PR, review, commit style
  running_tests.md
  database_schema.md
```

List each with a one-line description; tell Claude to read the relevant ones before starting work (or propose which ones it plans to read, for approval). Prefer pointers over copies — reference `file:line` rather than pasting code, since snippets rot as code changes but pointers stay accurate.

**Pointer, not copy** — example:

```md
Bad:  We wrap all repo errors like: try {...} catch (e) { throw new RepoError(e) }
Good: Repository errors are wrapped per the pattern in `src/db/errors.ts:12`.
```

Bad pastes code that will drift out of sync; good stays accurate as the code changes.

`CLAUDE.md` should be a **map**, not the territory. Architecture, product, and contributing are the sections most likely to outgrow "map" and turn into "territory" — they're the usual candidates to split into `.claude/docs/knowledge/`.

## Review checklist

- [ ] Under 300 lines (ideally under 100)
- [ ] Every instruction is true for *most* sessions, not just one workflow
- [ ] No pasted code — `file:line` pointers instead
- [ ] No style rules a linter/formatter already enforces
- [ ] Task-specific detail lives in `.claude/docs/knowledge/`, referenced by name and one-line description
- [ ] Architecture, if more than 2–3 sentences, is split into `architecture.md` and only summarized + linked
- [ ] Real product/user-facing functionality is split into `product.md`
- [ ] Developer workflow (branching, commits, PRs, review) is split into `contributing.md`, with only always-applicable rules inlined
- [ ] Commands are exact and copy-pasteable, not "conventional"
- [ ] Off-limits areas are called out explicitly
- [ ] Re-read and ask: "would I want to see *this specific line* injected into every single session?"