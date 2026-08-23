## Skills

| Skill | Use When |
|-------|----------|
| `clean-code` | Writing new code, reviewing PRs, refactoring legacy code to apply Clean Code principles (meaningful names, small functions, error handling) |
| `code-simplification` | Code works but feels heavy — deeply nested logic, readability flagged in review, refactoring under time pressure |
| `coding-guidelines` | Any coding task — enforces think-before-code, surgical changes, surfacing assumptions and tradeoffs |
| `engineering-memory` | Starting work on a project — loads persistent architectural decisions and knowledge across sessions |
| `javascript-typescript-jest` | Writing Jest tests, mocking dependencies, async testing, React component tests |
| `csharp-xunit` | Writing C# unit tests with XUnit — data-driven tests, fixtures, mocking/isolation |
| `create-technical-spike` | Researching API integrations, architecture decisions, platform capabilities before implementing |
| `reproduce-bug-report` | Investigating a bug ticket — confirms it's real via browser automation, saves structured observations |
| `writing-clearly-and-concisely` | Docs, commit messages, error messages, UI copy — strips puffery and AI generic patterns |
| `writing-claude-md` | Creating, reviewing, or trimming CLAUDE.md files — enforces structure and length limits |

---

## settings.json
```json
{
    ...
    // Disable auto memory
    "autoMemoryEnabled": false,

    // Maximum number of requests the agent can make (default: 25)
    "chat.agent.maxRequests": 50,
}
```