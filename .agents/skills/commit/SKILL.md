---
name: commit
description: Create scoped Git commits using Conventional Commits. Use when asked to commit changes or prepare a commit message.
---

# Commit

## Message convention

Every commit must follow Conventional Commits:

```text
<type>(<optional-scope>): <imperative description>

<optional body explaining why>

<optional footers>
```

- Use `feat` for new functionality, `fix` for bug fixes, `docs` for documentation-only changes, `refactor` for behavior-preserving restructuring, `perf` for performance improvements, `test` for tests, `build` for build/dependency changes, `ci` for automation, and `chore` for repository maintenance or configuration.
- Choose a short scope identifying the affected tool or subsystem, such as `gh-dash` or `skills`. Omit it when no single scope fits.
- Keep the subject concise, imperative, and without a trailing period.
- Mark incompatible changes with `!` before the colon and explain them in a `BREAKING CHANGE:` footer. Do not mark ordinary dotfile edits as breaking changes.
- Do not invent issue references, verification results, or attribution.

Examples:

```text
chore(gh-dash): add sanitized configuration example
feat(skills): add conventional commit workflow
fix(zsh): select the explicit darwin configuration
```

## Workflow

1. Confirm the user requested a commit. A request for a message alone does not authorize creating a commit.
2. Inspect `git status --short`, the relevant diff, and any already-staged changes. Identify which changes belong to the request; preserve unrelated user work.
3. Review the proposed contents for secrets and private account, organization, repository, and machine details. Keep local-only values in ignored configuration; examples must use generic placeholders.
4. Run the relevant checks or smoke scenario for behavioral changes. Describe only verification actually performed. Update existing setup documentation when needed.
5. Group changes by purpose. Prefer separate commits for independent changes; keep a config example, its ignore rule, and setup documentation together.
6. Stage only explicit paths or hunks belonging to the commit. Never use blanket `git add .` or `git add -A`. Do not discard or unstage unrelated user changes without permission.
7. Review `git diff --cached` before committing. If unrelated changes are already staged, isolate the requested commit with path-specific Git operations or ask when separation is unsafe. Never include unrelated staged changes silently.
8. Create the commit with a Conventional Commits message. Use a body only when rationale or migration details are useful.
9. If a hook fails, fix the relevant issue and retry normally. Never bypass hooks, amend existing commits, rewrite history, or push unless explicitly requested.
10. Report the commit hash, subject, checks exercised, and any remaining blocker. Do not claim a commit succeeded without successful Git output.

## Repository layout

Keep repository-local skills under `.agents/skills/<name>/SKILL.md`. Use agent-neutral naming; do not create vendor-specific copies or compatibility directories.
