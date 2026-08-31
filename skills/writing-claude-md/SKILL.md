---
name: writing-claude-md
description: Create a new CLAUDE.md for a Claude Code project, or sync an existing one against the current repo state. Use when the user asks to create, write, or generate a CLAUDE.md (creation) — or to sync, update, check, or verify a CLAUDE.md's accuracy against the repo (sync). Not for general repo documentation unrelated to CLAUDE.md.
argument-hint: <create or sync>
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# Writing a Good CLAUDE.md

## Core principle: Claude is stateless

Claude's weights are frozen at inference time — it doesn't learn from a codebase over time. The only thing it knows about a project is the tokens fed to it that session. `CLAUDE.md` is the one file injected into *every* session by default, so:

1. Claude knows nothing about the codebase at the start of each session.
2. Anything important must be re-told via `CLAUDE.md`.
3. Because it loads every time, every line must earn its place in *every* session — not just some.

A corollary: **CLAUDE.md doesn't know the repo changed either.** A command, dependency, or doc reference that was accurate when written silently goes stale the moment the repo moves on.

## Output location

Write file as `CLAUDE.md` in the project root (repo top-level dir, next to `.git`). Not in `.claude/`, not in a subfolder. If root already has one, edit in place — don't create a second copy elsewhere.

## Pick exactly one workflow

This skill covers two actions only. Decide which one applies, then read **only** the matching reference file — never load both in the same pass, each is written assuming the other's content is not in context.

| Action | Triggers | Read |
|---|---|---|
| **Create** | No `CLAUDE.md` exists yet; or the user wants one written/rewritten from scratch | `references/creating.md` |
| **Sync** | `CLAUDE.md` exists and the user asks to sync, update, or check it — or asks you to review one whose accuracy is in question | `references/syncing.md` |

If unsure which applies (e.g. "review my CLAUDE.md," no other context): treat it as **Sync**. A sync pass includes a correctness check against the repo, so it safely covers a plain review too — the reverse isn't true.

Both workflows share one hard constraint: keep the final `CLAUDE.md` under 300 lines, ideally under 100. Each reference file enforces this in the way that fits its action.