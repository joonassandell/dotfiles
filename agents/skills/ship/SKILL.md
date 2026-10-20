---
name: ship
description: Use when I ask to ship, finish, or merge the current branch. Reviews it with the `code-review` skill, then opens a PR (workflow pr) or merges to the base branch (workflow main).
disable-model-invocation: true
argument-hint: "[pr|main]"
---
Ship the current branch.

1. Resolve `<base>` as the AGENTS.md rule says (`Base:` line, then `origin/HEAD`, then `main`/`master`/`develop`, else ask). Refuse if on `<base>` or the working tree is dirty (offer to commit atomically first).
2. Check `git remote`. If there is no remote, `pr` is impossible: say so and use `main` in local mode (skip every fetch, push and remote-branch step). Determine workflow: the argument I gave (`pr` or `main`), else the `Workflow:` line in the project's AGENTS.md or CLAUDE.md. If neither, ask me.
3. Run the `code-review` skill (from `mattpocock/skills`) with `<base>` as the fixed point. It reviews the diff on two axes, Standards and Spec, in parallel sub-agents. If a documented-standard breach or a missing or partial spec requirement is reported, show it and stop; fix it first. If the `code-review` skill is not installed, review the diff yourself and tell me the check was not independent.
4. **main only:** rebase the branch on `<base>` (on `origin/<base>` after a fetch if a remote exists). Resolve conflicts carefully; re-run checks if the rebase changed anything.
5. By workflow:
   - **pr**: first draft the title and body (see below) and show them to me. Do NOT push or create anything until I explicitly approve or edit the draft. After approval: `git push -u origin HEAD`, then open a pull/merge request with the host's CLI, picked from the remote URL (`gh pr create` for GitHub, `glab mr create` for GitLab). Title = conventional-commit style. Body: if the repo has a PR/MR template (`.github/pull_request_template.md`, `.github/PULL_REQUEST_TEMPLATE/`, `docs/` or root `pull_request_template.md`, `.gitlab/merge_request_templates/`), fill in that template's sections from the branch changes and keep its headings and checklists (leave checkboxes I must confirm unchecked). If there are several templates, pick the best match or ask me. Without a template, write the body with the `pr` skill (from `mattpocock/skills`): Summary, Evidence and Merge Danger. If the `pr` skill is not installed, body = what/why. If there is no CLI for the host, print the pushed branch and tell me to open it in the web UI. Stop there and print the PR URL. Never merge, rebase onto `<base>`, or delete the branch; the team does that manually on the host.
   - **main**: checkout `<base>`, `git merge --ff-only <branch>`, `git push origin <base>` (if a remote exists), delete the branch locally and on the remote (if any).
6. **main:** return to updated `<base>` and report the commits shipped. **pr:** stay on the branch.

Stop and ask before any force-push or if anything unexpected happens.
