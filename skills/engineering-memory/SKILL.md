---
name: engineering-memory
description: Maintains a persistent, project-local memory of engineering knowledge (rules and hypotheses) and architectural decisions across sessions. Use when writing new code, refactoring existing code, designing an approach before implementing.
disable-model-invocation: false
---

# Engineering Memory

Two complementary systems live under `.claude/docs/`. Both exist to stop the
agent from re-deriving or re-litigating things a past session already
figured out. Read the relevant reference file **before** acting, not after.

| Situation | Reference | What it's for |
|---|---|---|
| Starting any coding/refactoring task | `references/knowledge_system.md` | Domain facts, patterns, confirmed rules |
| About to make a choice that outlives today's task | `references/decision_journal.md` | Precedent for architectural/design decisions |

Load only the file(s) relevant to the current step — don't load both up front
if only one applies.

## Quick start

**Before writing or refactoring code:**
1. Open `references/knowledge_system.md`, follow its "Before a task" steps.
2. If the task touches a decision with lasting impact (not just this task),
   also open `references/decision_journal.md` and follow its "Before deciding" steps.

**While working:** apply confirmed rules by default; treat hypotheses as
things to keep an eye on, not things to assume.

**After finishing the task:**
1. Follow `references/knowledge_system.md`'s "After a task" steps to extract insights.
2. If you made a lasting decision, follow `references/decision_journal.md`'s
   "Logging a decision" steps.

## Directory structure this skill maintains

```
.claude/docs/
  knowledge/learning
    INDEX.md          # routes to each domain folder below
    <domain>/
      knowledge.md     # facts and patterns
      hypotheses.md     # need more data
      rules.md          # confirmed — apply by default
  decisions/
    YYYY-MM-DD-{topic}.md
```

Create any of this that doesn't exist yet — see the reference files for
exact templates and promotion/demotion rules.

## Core principles

- Never skip the pre-task check to save time — a stale or contradicted rule
  applied blindly is worse than the lookup cost.
- Don't log or extract knowledge that's obvious, generic, or scoped only to
  this one task. Only record things future sessions in this repo would
  actually want to know.
- When knowledge and a decision overlap (e.g. a decision produces a new
  confirmed pattern), record the pattern in the knowledge system and just
  link to it from the decision log — don't duplicate the content.
