---
name: cleanup
description: Use when a task is done and its branch can go. Takes an issue ID or a branch.
---

# Clean up

Finish a task that `/issue` started. Where it runs decides the rest:

- **In the orchestrator chat** (Hermes in Herdr, with the `herdr-agents` skill): follow its clean up steps for the worktree, the space and the agent.
- **Anywhere else** (Claude Code or Hermes in the repo itself): the work happened in this checkout, so there is no worktree or agent to remove.

In both:

1. **Suggest follow-ups.** Read the task's chat (the agent's in the orchestrator, this one otherwise) and suggest what belongs in the project's docs (if it has docs), in design tasks or in new issues. I pick, and you add only those.
2. **Check it's merged.** Ask before dropping commits that aren't on `<base>`, and never delete someone else's remote branch.
3. **Remove it.** Switch to `<base>`, pull with `--ff-only`, then delete the local branch. In the orchestrator, also remove the worktree and close its space.
4. **Report** in one line what is gone, and what was left running on purpose (a simulator, a dev server).

Read the argument: an issue ID (`DEV-123`, a Linear URL) means the issue's branch; a branch name means that branch. With nothing, use the current branch, or ask in the orchestrator.
