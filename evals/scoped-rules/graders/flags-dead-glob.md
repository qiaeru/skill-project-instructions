---
type: llm
---

PASS if the reply says that the glob in `.claude/rules/testing.md` matches no file because the tests live under `tests/`, not `test/`, so the rule never loads.
FAIL if it does not notice the mismatch.
