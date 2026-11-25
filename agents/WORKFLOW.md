# Agent workflows

My common workflows for coding agents (Hermes, Claude and any other agent). The rules and my own skills live here. Third party skills are installed from `../skills/skills.txt`. I use an orchestrator agent in Herdr to handle workspaces and worktrees. The flows below are my baseline, not a fixed checklist: steps often vary, get skipped or swap order depending on the task.

## Solo projects

1. `<issue-description>` or `<issue-description>. New worktree with Claude.`
2. Optional: `/grill-me` (or `/grill-with-docs`)
3. Build with conventional commits
4. `/review` or `/code-review <base>`
5. `/pr`, then push and create the PR

## Yolo projects

1. `You can commit to main and push if I say commit, commit push, or push.`
2. `<issue-description>`
3. Build, then `commit`, `commit push` or `push`

## Team projects

1. `/linear-cli list issues`
2. `New worktree with issue <ID>, start the issue and Claude.`
3. Optional: `/grill-me` (or `/grill-with-docs`)
4. Build with conventional commits
5. `/review` or `/code-review <base>`
6. `/pr`, then push and create the PR
7. `Clean up <ID>` once done

## Project details

### Solo projects

1. **Describe the task.** Tell the orchestrator what to do. Add "New worktree with Claude." to get its own worktree and a Claude agent. Without it the orchestrator works on a new branch itself. Either way the branch comes from `<base>` and is named `<prefix>/<short-kebab-name>`.
2. **Shape the idea (optional).** `/grill-me` when the task is unclear or big. It writes no files. Use `/grill-with-docs` in repos that keep domain docs, since it also writes `GLOSSARY.md` and ADRs as it goes.
3. **Build.** Commit atomically as [Conventional Commits](https://www.conventionalcommits.org).
4. **Review.** `/review` or `/code-review <base>`, in the agent's own chat when in a worktree. `/review` is Claude Code's built-in bug review: it runs on my own plan, follows `CLAUDE.md`, and `--fix` applies the findings. It isn't in the `/` menu, because my `code-review` skill takes over the `/code-review` name and `/review` is the alias that stays. `/code-review <base>` reviews the diff on two axes, Standards (does it follow the repo's documented standards) and Spec (does it do what the issue or spec asked), in parallel sub-agents, reported separately and never merged into one verdict.
5. **PR.** `/pr` writes the PR body: a summary as a small visual, evidence that it works, and merge danger (one-way or two-way door, and the blast radius). Then the agent shows the draft, waits for my approval, pushes and creates the PR. For a private project, I can ask for a local merge instead of a PR: rebase on `<base>`, fast-forward merge, push if there is a remote, delete the branch.

### Yolo projects

For repos like my dotfiles, where a branch and a PR are more ceremony than they are worth.

1. **Allow it.** Tell the chat once: "You can commit to main and push if I say commit, commit push, or push." It lasts for that chat only, so say it again in a new one. My words in the chat override the rule in `AGENTS.md` against committing to `<base>`.
2. **Describe the task.** As in Solo projects.
3. **Build and commit.** Commit atomically as Conventional Commits, on `<base>`. A branch, `/grill-me`, a review and a PR are optional. `commit` commits, `commit push` commits and pushes, and `push` pushes what is committed. The agent doesn't push otherwise.

### Team projects

1. **Pick an issue.** `/linear-cli list issues`.
2. **Start it.** The orchestrator creates a worktree on the issue's Linear branch, sets the issue to In Progress and starts Claude in it. I accept the branch name Linear generates. It sends Claude one short brief (the issue, its scope, no push or PR until I ask) and then stays out: it doesn't relay messages between Claude and me. In app repos it installs the dependencies itself and opens a pane under Claude with the run command typed but not started (the simulator's `flutter run`, `pnpm dev`), so I start it when I need it.
3. **Shape, build and review.** The same as Solo projects, steps 2 to 4. `/code-review <base>` checks the diff against the Linear issue.
4. **PR.** `/pr`, then push and create the PR. The agent drafts the title and body (the repo's PR template if there is one, otherwise the `/pr` format), shows them and waits for my approval, then pushes and opens the PR or MR with `gh` or `glab`, and stops. Merging is done by the team on the host. Screen recordings and screenshots from `ios-rec`, `ios-shot`, `android-rec` and `android-shot` (`../zsh/ios-android-capture`) land in a folder named after the worktree; before pushing, the agent attaches each one with `gh pr create --attach <file>` and lists them in a table in the PR body.
5. **Clean up.** First the orchestrator reads the finished agent's chat and suggests what belongs in the team docs (if the project has docs), in design tasks or in other issues; I pick, and it adds only those. Then it checks the branch is merged and removes the worktree and the local branch. It asks before dropping unmerged commits.

To only try someone else's PR (`Test PR <number>, no Claude.`), the orchestrator makes the worktree with the run panes and tabs but no agent and no brief. Its clean up deletes only my local branch, never theirs.

## Herdr

I use the Herdr desktop app with my custom theme and mods (`../herdr-app`). The terminal `herdr` works the same way for the points below.

- **Worktree location:** the app's own worktree command puts a checkout in `~/.herdr/worktrees/<repo folder name>/<branch, slashes as dashes>`. The orchestrator makes them itself for repos in a group (below).
- **Project context:** an agent in a worktree runs in that path, not in the repo. So `PROJECTS.md` needs a line for the worktree folder next to the repo's own line. `/project-context init` adds it.
- **A folder of repos:** say `~/Repositories/<group>/` is not a repo itself and holds `<repo-a>` and `<repo-b>`, each with its own git.
  - Each repo gets its own space.
  - The orchestrator puts worktrees in `~/.herdr/worktrees/<group>/<repo-a>/<branch>`, so the same branch name in two repos can't collide. The app's own command would use `~/.herdr/worktrees/<repo-a>/` instead, so start these worktrees from the orchestrator.
  - `PROJECTS.md` has one line for `~/Repositories/<group>` and one for `~/.herdr/worktrees/<group>`. Each covers everything inside it.
  - Hermes commonly gets `~/Repositories/<group>` as a folder.

## Notes

- For a new repo, run `/setup-matt-pocock-skills` first, if it fits the project.
- **`<base>`:** the project's default branch, usually `main`. How it is found, plus the branch prefixes and commit rules, are in the Git workflow section of [AGENTS.md](AGENTS.md).
- **The orchestrator chat:** fine as a dispatcher. It creates issues and worktrees, starts and briefs agents, tracks what runs and cleans up. It doesn't sit between me and an agent unless I ask. It must not be the only place where state lives. A new one should be able to continue from the repo's docs, `git worktree list`, open PRs and the issue tracker. For a single task, skip it: use a herdr worktree and start `claude` there.
- **Issues from the orchestrator:** I often have it create Linear issues and follow-ups, either on the fly as things come up, or from what it reads in a worktree agent's chat (findings, leftovers, ideas for later). It adds to an existing issue when one fits, instead of opening a new one.
