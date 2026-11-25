---
name: issue
description: Use when starting work on a task. Takes an issue ID or a description.
---

# Issue

Start a task on its own branch. Where it runs decides the rest:

- **In the orchestrator chat** (Hermes in Herdr, with the `herdr-agents` skill): a new worktree with its own Claude. Follow `herdr-agents` for the space, the panes, the brief and later the clean up. Claude gets the brief and waits for me; it starts on its own only when I say so ("start working", "unattended") or that I'm away. With a description and no issue, the brief carries the description text as the task.
- **Anywhere else** (Claude Code or Hermes in the repo itself): no worktree and no second agent. Create the branch in the current checkout and start the task here right away. If I want a separate worktree, I start one with `claude --worktree`.

Read the argument:

- **An issue ID** (`DEV-123`, a Linear URL): use the issue's Linear branch and set the issue to In Progress. The issue is the task.
- **A description** (anything else): branch from `<base>` as `<prefix>/<short-kebab-name>`, with `<base>` and the prefix from the Git workflow in the global `AGENTS.md`. The description is the task. If the project uses Linear, ask once whether to create the issue first; with a yes, continue as with an issue ID.
- **Nothing:** ask for the issue or a description.

Ask which repo when the project has several and the issue or description doesn't say. In the orchestrator, report the space, the branch and what was sent to Claude in a few lines, then step back: I work with Claude directly.
