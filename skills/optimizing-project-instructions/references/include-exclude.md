# What to keep, what to cut, what to reference

The keep test comes first: "Would removing this cause Claude to make a mistake?" Everything below assumes a line has passed or failed that test. Lines that pass are then sorted into keep-in-place or replace-with-a-reference.

## Keep in CLAUDE.md

These earn their tokens because Claude cannot derive them and needs them in nearly every session.

- **Commands Claude cannot guess.** The actual build, test, lint, and run commands, especially when they are non-standard (a custom Makefile target, a monorepo task runner, a wrapper script). Include the command to run a *single* test, which Claude reaches for constantly.
- **Code style that differs from the language default.** Tabs vs spaces when it is not the ecosystem norm, import style (ES modules vs CommonJS), a banned pattern. Skip anything a formatter already enforces, that is the formatter's job.
- **Repository etiquette.** Branch naming, commit message format, PR conventions, who merges, whether to push straight to main.
- **Architectural decisions specific to this project.** "State lives in the store, never in component local state", "all API calls go through `src/api/client.ts`", "this service is event-sourced". The *decision and its location*, not a tutorial on the pattern.
- **Environment quirks.** Required env vars, a local service that must be running for tests (Redis, a database), a setup step that is easy to miss, a platform-specific gotcha.
- **Non-obvious behaviors and gotchas.** The thing that bites every newcomer: a function that looks pure but writes to disk, a test that is flaky under parallelism, a generated file that must not be edited by hand.
- **Places where the code misleads.** An old pattern that is everywhere but new code must not copy, a directory that looks unused but is still live. Claude reads the code, so the code teaches it the wrong thing here.
- **Decisions and corrections that are not in the repo.** Which error helper the team settled on, what needs a migration review, anything someone has had to correct twice.
- **Compaction instructions.** A line like "When compacting, always preserve the full list of modified files and the test commands" is honored at `/compact` time and has no other home; it can only work from a file that is in context when compaction runs.

## Cut entirely

These fail the keep test. Removing them changes nothing, because Claude either already knows them or can see them.

- **Anything Claude can learn by reading the code.** Directory listings, "this project uses React", lists of dependencies already in the manifest.
- **Standard language and framework conventions.** "Use meaningful variable names", "follow PEP 8", "components go in PascalCase". Claude knows the ecosystem defaults.
- **Self-evident advice.** "Write clean code", "add tests", "handle errors gracefully", "keep functions small". Noise that dilutes the real rules.
- **Leftover boilerplate.** The `/init` opening line ("This file provides guidance to Claude Code..."), template placeholders never filled in (`<Project Name>`), empty sections, and TODO items nobody completed. They carry no instruction and signal that the rest was not curated either; so does a file whose `git log` shows a single commit.
- **Information that changes frequently.** Current version numbers, a sprint's task list, the name of whoever owns a module this month. It goes stale and starts lying.
- **File-by-file narration of the codebase.** A paragraph per file describing what it does. Claude reads the file when it needs it.
- **Coaxing written for older models.** "Be thorough", "think hard", "don't be lazy", "keep going until done", "if in doubt, use X". Effort sets the depth, current models carry an agreed task through, and these lines now cause over-work or overtriggering. A concrete check to pass is different and stays.
- **Learnings auto memory already records.** Notes that read like something Claude discovered rather than an instruction someone wrote ("turns out the flaky test is the Redis timeout", "the build needs `--legacy-peer-deps`") belong in auto memory (`MEMORY.md`, maintained by Claude itself). A standing instruction the team wants enforced stays in CLAUDE.md; a discovered fact duplicating the other memory system goes.

## Reference instead of copy

These pass the keep test (Claude does need the information) but fail the copy test (it already exists elsewhere). Replace the copy with a pointer so there is one source of truth and a one-line launch cost.

- **Detailed API or feature documentation.** Point to `docs/` instead of pasting endpoint signatures.
- **Long workflow guides.** A multi-step release or deploy runbook belongs in a doc or a skill; CLAUDE.md names where it is.
- **Contribution rules already in `CONTRIBUTING.md`.** Point to it; do not restate it and let the two drift apart.
- **Instructions already in `AGENTS.md`.** Import it or let Claude Code read it natively, never restate it; the wiring is in the AGENTS.md section of [referencing-techniques.md](referencing-techniques.md).
- **The README's project overview.** A pointer, or a single `@README.md` import only if it is short and you want it every session.
- **Schema, config, or generated reference.** Name the file; Claude opens it on demand.

## Borderline cases

- **A command that is in `package.json` scripts.** If the script name is obvious (`npm test`), a one-line reminder is fine and cheap. If the workflow is "run `npm run build:prod` then `npm run deploy:staging`, never the bare `deploy`", that ordering is a non-obvious rule worth keeping.
- **A convention that is partly enforced by tooling.** Read the linter or formatter config: if it catches the convention, cut it. If it does *not* catch it but reviewers always do, keep it.
- **Architecture that is documented in an ADR.** Keep the one-line decision and its consequence in CLAUDE.md if Claude needs it every session; point to the ADR for the reasoning.
- **Something true of only one directory.** Do not keep it in the root CLAUDE.md. Move it to a path-scoped rule or a nested CLAUDE.md so it loads only when Claude works there.
- **A rule phrased "always run X after/before Y" or "never touch Z".** If it must hold with zero exceptions, make it a hook (an action) or a `permissions.deny` rule (a ban) and cut the line: CLAUDE.md is advisory, both are enforced. Keep it as prose when judgment is involved in applying it or when it is only a preference. A command Claude needs to check its own work stays in the file even when a hook also runs it.
- **A rule about the reply, not the project.** "Keep answers short", "always explain your reasoning", a fixed response format. Move it to an output style, which the user can switch off. Conventions stay in CLAUDE.md.
- **An ancestor CLAUDE.md from another team in a monorepo.** Not yours to optimize. Suggest excluding it locally with the `claudeMdExcludes` setting instead of editing it.

## When Claude ignores a rule

Check these in order, and trim only when the file is long enough to bury the line:

1. The file loads: it appears in `/context all`, and a rule's `paths:` matches the files in play.
2. No other instruction contradicts it, in any memory file or rule.
3. It is specific enough to verify.
4. It does not compete with Claude Code's built-in guidance, as commit and PR rules do.
5. It can tolerate exceptions. If not, make it a hook or a deny rule.

## The recurring trap

CLAUDE.md is the set of standing instructions Claude needs in memory at all times, not a complete description of the project. Completeness is the README's job; CLAUDE.md's is to be short enough that every line still gets read.
