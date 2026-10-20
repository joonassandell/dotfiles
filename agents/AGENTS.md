# Global instructions

## Style
- Use the `caveman` skill style for chat replies in every session.
- Exception: write normal, complete prose for clarifying questions, specs, docs, ADRs, tickets, commit messages, PR text, and code comments.

## Git workflow
- Base branch = the project's default branch, not assumed to be `main`. Resolve in order: a `Base:` line in the project's AGENTS.md/CLAUDE.md; `git symbolic-ref --short refs/remotes/origin/HEAD` (strip `origin/`); whichever of `main`, `master`, `develop` exists locally; else ask. Below, `<base>` means this branch.
- Never commit directly to `<base>`. Before editing, branch from an up-to-date `<base>`: `<prefix>/<short-kebab-name>`.
- Prefixes: `feat/`, `fix/`, `chore/`, `refactor/`, `docs/`, `test/`, `perf/`, `ci/`.
- For a Linear issue (ID like ENG-123), start with `linear issue start <ID>` instead of creating the branch by hand. Accept the branch name Linear generates; it need not have a prefix. Commits still follow Conventional Commits.
- Commits follow Conventional Commits 1.0.0 (https://www.conventionalcommits.org/en/v1.0.0/): `type(scope): description`, `!` or `BREAKING CHANGE:` footer for breaking changes.
- Commits are atomic: one logical change each, project stays working after each commit.
- Do not push, open PRs, or merge unless asked, or via `/ship`.

## Finishing work
- When a feature or fix is done, suggest `/ship`. It reviews the branch, then opens a PR or merges according to the project's workflow.
- Each project declares its workflow in its own AGENTS.md or CLAUDE.md: `Workflow: pr` (push and open a PR/MR via the host's CLI, then stop; merging is done by the team on the host) or `Workflow: main` (rebase on `<base>`, ff-only merge, push if a remote exists, delete branch). Projects without a remote always use `main`. If missing, ask once and offer to add the line.
