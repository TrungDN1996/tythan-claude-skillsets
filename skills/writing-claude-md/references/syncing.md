# Syncing CLAUDE.md with the repo

Read this file only for a sync/update/verify pass on an *existing* `CLAUDE.md`. Don't pull in `creating.md` for this — you're diffing against reality, not designing a skeleton. Don't assume the existing content is still correct; verify every claim below before signing off.

## 1. Find the source of truth for each claim, and diff against it

| CLAUDE.md claims | Check against |
|---|---|
| Build/test/lint/run commands | `package.json` `scripts`, `Makefile`, `pyproject.toml` (`[tool.*]`, `[project.scripts]`), `Cargo.toml`, `justfile`, CI config (`.github/workflows/*.yml`) — whichever exists |
| Tech stack / framework / versions | `package.json` `dependencies`/`devDependencies`, `pyproject.toml`, `go.mod`, `Cargo.toml`, lockfiles for major version pins |
| Lint/format tooling | `.eslintrc*`, `eslint.config.*`, `.prettierrc*`, `ruff.toml`/`pyproject.toml [tool.ruff]`, `.golangci.yml` |
| Test runner/framework | test config files (`jest.config.*`, `vitest.config.*`, `pytest.ini`, `pyproject.toml [tool.pytest]`) and actual test file locations |
| Doc links under `## Docs` | `.claude/docs/knowledge/` directory listing — every linked file must exist; every file present must be linked |
| Architecture summary | Spot-check against actual top-level directory structure (`ls`/`Glob`) — flag if it names directories that no longer exist or misses major new ones |

> **Scope note:** only list/reconcile files directly in the root of `.claude/docs/knowledge/`, not files inside subfolders. If a subfolder holds a topic's supporting material (images, drafts, split-out sub-pages), the root-level file is the one linked from `CLAUDE.md`; its subfolder contents aren't individually surfaced there.

## 2. Reconcile, don't just report

For each mismatch found:
- Command changed or renamed → update the exact command in CLAUDE.md.
- Dependency/framework version bumped in a way that changes behavior or commands (e.g. major version) → update tech stack line.
- A file under `.claude/docs/knowledge/` was added → add a one-line entry under `## Docs` (and mention it inline where relevant, e.g. new area of architecture).
- A file under `.claude/docs/knowledge/` was removed or renamed → remove/fix the dangling link. Never leave a link to a file that doesn't exist.
- Lint/test tooling swapped entirely (e.g. ESLint → Biome, Jest → Vitest) → update both the command and any tool-specific convention notes.
- A `file:line` pointer's target moved or the line no longer contains the referenced pattern → re-locate and fix the pointer, or drop it if the pattern no longer exists.

## 3. Don't over-sync

Only touch lines whose underlying fact actually changed. Don't rewrite prose, reorder sections, or "improve" wording as a side effect of a sync pass — that makes diffs noisy and obscures what actually changed in the repo. A sync commit should read as a small, targeted diff. (If the file also needs a structural rewrite, that's a **Create** pass, not a sync — say so and ask before mixing the two.)

## 4. Don't guess

If CLAUDE.md references something with no discoverable source of truth (e.g. a command that isn't in any config file Claude can find), flag it to the user rather than inventing or silently deleting it.

## 5. Summarize what changed

After syncing, tell the user concisely what was updated and why (e.g. "test command changed from `npm test` to `pnpm test`; added `payments.md` to Docs; removed link to deleted `legacy-arch.md`"), not a full re-print of the file unless they ask.

## Sync-specific checklist

- [ ] Every command/version/tool claim matches its source file (`package.json`, lint config, test config, etc.) as of right now
- [ ] Every link under `## Docs` resolves to an existing file, and every root-level file in `.claude/docs/knowledge/` is linked (subfolder contents not included)
- [ ] `file:line` pointers still point at the pattern they describe
- [ ] Only lines with actual drift were touched — no unrelated rewording
- [ ] Anything unverifiable was flagged to the user, not guessed at
- [ ] Total file is still under 300 lines (ideally under 100) — if a sync pushed it over, flag that the file needs a Create-style trim, don't silently let it grow