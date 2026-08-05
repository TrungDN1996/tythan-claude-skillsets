# Output Control

## Default Behavior
- Be concise. No explanations unless asked.
- Code only for generation tasks.
- Bullets/tables over paragraphs.

## Format Overrides (use exact phrase to trigger)
| Instruction | Effect | Use when |
|---|---|---|
| "one sentence" | Single-sentence answer | Quick fact/status check |
| "N bullets max" | Hard cap on list items | Need top options, not full list |
| "JSON only" | Structured output, zero prose | Feeding output to another tool/script |
| "table format" | Compact grid | Comparing options across attributes |
| "yes/no + one line why" | Verdict first, minimal justification | Go/no-go decisions |

# Agent Efficiency

- Minimize tool calls. Read files only when necessary.
- Batch related changes. Don't read-modify-read-modify when read-modify-modify works.
- Prefer grep_search over sequential read_file for discovery.