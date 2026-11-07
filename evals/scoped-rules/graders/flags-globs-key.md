---
type: llm
---

PASS if the reply says that `.claude/rules/api.md` uses a `globs` key that Claude Code ignores, so the rule is not scoped and loads every session, and suggests `paths`.
FAIL if it treats `globs` as valid or does not mention it.
