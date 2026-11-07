---
type: llm
---

The file `.claude/rules/web.md` is correct, and this grader only checks that the reply does not list it as a problem. A reply that uses `web.md` as the example of the right format, calls it fine, or does not mention it passes, even when it reports problems in other files.

PASS unless the reply says that the `paths` glob in `web.md` itself is invalid or matches nothing.
FAIL only if it says so.
