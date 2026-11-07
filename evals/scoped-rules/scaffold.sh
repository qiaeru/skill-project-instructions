#!/usr/bin/env bash
set -euo pipefail
cp -R "$(dirname "${BASH_SOURCE[0]}")/../fixtures/scoped-rules/." .
# The repo gitignores .claude/, so the rules are written here, not in the fixture.
mkdir -p .claude/rules
cat > .claude/rules/api.md <<'RULE'
---
globs: "src/api/**/*.ts"
---

- Handlers return plain strings; the web client does its own parsing.
RULE
cat > .claude/rules/testing.md <<'RULE'
---
paths:
  - "test/**/*.test.ts"
---

- Call `resetUsers()` at the top of every test file.
RULE
cat > .claude/rules/web.md <<'RULE'
---
paths:
  - "src/web/**/*.tsx"
---

- Components never import from `src/api/` directly.
RULE
