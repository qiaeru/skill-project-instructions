---
description: 'Audit of rule files where one frontmatter key is ignored and one glob matches nothing'
tags: [behavior]
max_turns: 40
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill, TodoWrite]
expected_outcome: 'A report, with no file changed, saying that api.md uses a globs key Claude Code ignores, so it loads every session, and that the testing.md glob matches nothing because the tests live under tests/. web.md is fine.'
---

can you audit our CLAUDE.md and .claude/rules? just tell me what's wrong, don't change anything yet
