# Agent workflows

My common workflows for coding agents (Hermes, Claude and any other agent). The rules and my own skills live here. Third party skills are installed from `../skills/skills.txt`. I use an operator agent in Herdr to handle workspaces and worktrees.

## Solo projects

1. `<issue-description>` or `<issue-description>. New worktree with Claude.`
2. `/grill-me` (or `/grill-with-docs`)
3. Build with conventional commits
4. `/code-review <base>`
5. `/pr`, then push and create the PR

## Yolo projects

1. `You can commit to main and push if I say commit, commit push, or push.`
2. `<issue-description>`
3. Build, then `commit`, `commit push` or `push`

## Team projects

1. `/linear-cli list issues`
2. `New worktree with issue <ID>, start the issue and Claude.`
3. `/grill-me` (or `/grill-with-docs`)
4. Build with conventional commits
5. `/code-review <base>`
6. `/pr`, then push and create the PR
7. `Clean up <ID>` once done

## Details

### Solo projects

1. **Describe the task.** Tell the operator what to do. Add "New worktree with Claude." to get its own worktree and a Claude agent. Without it the operator works on a new branch itself. Either way the branch comes from `<base>` and is named `<prefix>/<short-kebab-name>`.
2. **Shape the idea.** `/grill-me` by default. It writes no files. Use `/grill-with-docs` in repos that keep domain docs, since it also writes `GLOSSARY.md` and ADRs as it goes.
3. **Build.** Commit atomically as [Conventional Commits](https://www.conventionalcommits.org).
4. **Review.** `/code-review <base>`. It reviews the diff on two axes, Standards (does it follow the repo's documented standards) and Spec (does it do what the issue or spec asked), in parallel sub-agents. The axes are reported separately and never merged into one verdict. In a worktree, run it in the agent's own chat.
5. **PR.** `/pr` writes the PR body: a summary as a small visual, evidence that it works, and merge danger (one-way or two-way door, and the blast radius). Then the agent shows the draft, waits for my approval, pushes and creates the PR. For a private project, I can ask for a local merge instead of a PR: rebase on `<base>`, fast-forward merge, push if there is a remote, delete the branch.

### Yolo projects

For repos like my dotfiles, where a branch and a PR are more ceremony than they are worth.

1. **Allow it.** Tell the chat once: "You can commit to main and push if I say commit, commit push, or push." It lasts for that chat only, so say it again in a new one. My words in the chat override the rule in `AGENTS.md` against committing to `<base>`.
2. **Describe the task.** As in Solo projects.
3. **Build and commit.** Commit atomically as Conventional Commits, on `<base>`. A branch, `/grill-me`, `/code-review` and a PR are optional. `commit` commits, `commit push` commits and pushes, and `push` pushes what is committed. The agent doesn't push otherwise.

### Team projects

1. **Pick an issue.** `/linear-cli list issues`.
2. **Start it.** The operator creates a worktree on the issue's Linear branch, sets the issue to In Progress and starts Claude in it. I accept the branch name Linear generates.
3. **Shape, build and review.** The same as Solo projects, steps 2 to 4.
4. **PR.** `/pr`, then push and create the PR. The agent drafts the title and body (the repo's PR template if there is one, otherwise the `/pr` format), shows them and waits for my approval, then pushes and opens the PR or MR with `gh` or `glab`, and stops. Merging is done by the team on the host.
5. **Clean up.** The operator checks the branch is merged, then removes the worktree and the local branch. It asks before dropping unmerged commits.

### Notes

- For a new repo, run `/setup-matt-pocock-skills` first, if it fits the project.
- **`<base>`:** the project's default branch, usually `main`. How it is found, plus the branch prefixes and commit rules, are in the Git workflow section of [AGENTS.md](AGENTS.md).
- **The operator chat:** fine as a dispatcher. It creates worktrees, starts agents, tracks what runs. It must not be the only place where state lives. A new one should be able to continue from the repo's docs, `git worktree list`, open PRs and the issue tracker. For a single task, skip it: use a herdr worktree and start `claude` there.
