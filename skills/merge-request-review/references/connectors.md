# Connectors

Identify platform from URL and match to correct MCP connector.

## Table of Contents

1. [Parse URL domain](#1-parse-url-domain)
2. [Self-hosted instances](#2-self-hosted-instances)
3. [Check connector enabled](#3-check-connector-enabled)
4. [If nothing matches](#4-if-nothing-matches)

---

## 1. Parse URL domain

| Domain pattern | Platform | Server MCP |
|---|---|---|
| `github.com` | GitHub | `github` |
| `gitlab.com` | GitLab | `gitlab` |
| `bitbucket.org` | Bitbucket | `atlassian` |
| `dev.azure.com` / `*.visualstudio.com` | Azure DevOps | `azure-devops` |
| Other | Possibly self-hosted | See §2 |

## 2. Self-hosted instances

Custom domains often run GitLab CE/EE, GitHub Enterprise, Gitea, Gogs, or Forgejo.

- **Path clues**: GitHub Enterprise uses `/owner/repo/pull/N`; GitLab/Gitea use `/owner/repo/-/merge_requests/N`
- **Available connector wins** over URL guessing
- **Ambiguous**: ask user — wrong guess wastes tool call

## 3. Check connector enabled

Look for MCP tools prefixed `mcp__<server>__` (e.g. `mcp__github__`, `mcp__gitlab__`, `mcp__atlassian__`).

- Not connected: surface it as something user can enable — don't fall back to unrelated connector
- Multiple matches: confirm which instance before fetching

## 4. If nothing matches

**Stop immediately** and report:

> **Cannot proceed.** Detected platform: **[platform]**. No matching connector available. Connect the **[Server MCP]** connector and retry.
