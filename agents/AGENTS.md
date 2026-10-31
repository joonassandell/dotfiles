# Global instructions

## Style

- Default to terse caveman-style replies in every chat. Keep the answer short even when asked "why". Copy strings and questions to the user stay full sentences.
- Exception: write normal, complete prose for clarifying questions, specs, docs, ADRs, tickets, commit messages, PR text, and code comments.

## Coding behavior

Bias toward caution over speed. For trivial tasks (typo, obvious one-liner), use judgment and skip the ceremony.

- Think first: state assumptions. If a request has several interpretations, present them instead of picking silently. If something is unclear, stop and ask. Push back when a simpler approach exists.
- Keep it simple: no features, abstractions, configurability or error handling for impossible cases beyond what was asked.
- Make surgical changes: every changed line traces to the request. Match existing style. Do not refactor or reformat adjacent code. Mention unrelated dead code, don't delete it. Remove only the orphans your own change created.
- Make goals verifiable: state success criteria before starting. Where tests exist, write a failing test before a fix and keep tests passing through a refactor. For multi-step work, give a short plan with a check per step.

## Project context

- Before answering or editing anything in a git repo, check `~/.agents/PROJECTS.md` if it exists. If the cwd is inside a listed path, first read the `IDEA.md` and `CONTEXT.md` of the project folder it maps to, and follow that folder's `AGENTS.md`. `project-context` never writes into a repo.

## Git workflow

- Base branch = the project's default branch, not assumed to be `main`. Resolve in order: `git symbolic-ref --short refs/remotes/origin/HEAD` (strip `origin/`); whichever of `main`, `master`, `develop` exists locally; else ask. Below, `<base>` means this branch.
- Never commit directly to `<base>`. Before editing, branch from an up-to-date `<base>`: `<prefix>/<short-kebab-name>`.
- Prefixes: `feat/`, `fix/`, `chore/`, `refactor/`, `docs/`, `test/`, `perf/`, `ci/`.
- Commits follow Conventional Commits 1.0.0 (https://www.conventionalcommits.org/en/v1.0.0/): `type(scope): description`, `!` or `BREAKING CHANGE:` footer for breaking changes.
- Commits are atomic: one logical change each, project stays working after each commit.
- Do not push, open PRs, or merge unless asked.

## Finishing work

- When a feature or fix is done, suggest `/code-review <base>`. Fix a reported standards breach or missing spec requirement before anything else.
- When asked for a PR/MR, draft the title (Conventional Commit style) and body: use the repo's PR/MR template if it has one (keep headings and checklists, leave checkboxes I must confirm unchecked), otherwise the `/pr` format. Show the draft and wait for approval before pushing or creating anything. Pick `gh` or `glab` from the remote URL; with no CLI for the host, print the pushed branch. Then stop: never merge, rebase onto `<base>`, or delete the branch of a shared repo, the team does that on the host.
- For a local merge (private or remote-less projects): rebase on `<base>`, `merge --ff-only`, push if a remote exists, delete the branch.
