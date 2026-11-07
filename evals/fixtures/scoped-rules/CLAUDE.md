# CLAUDE.md

## Commands

- Tests: `npm test`; one file: `npm test -- tests/users.test.ts`.

## Gotchas

- `src/api/users.ts` caches lookups in a module-level map, so tests must call `resetUsers()` first.
