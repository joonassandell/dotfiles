# Agents

My global setup for agents (Hermes, Claude and others): shared rules, my own skills, and how I work with them.

- [Agent workflows](WORKFLOW.md): How I work on code, from branch to PR.
- [Project workflow](PROJECTS.md): How I start and keep up projects, so every chat knows the context.
- [Global instructions](AGENTS.md): Rules every agent follows.

## Claude Code hooks

`setup.sh` links the scripts in `hooks/` to `~/.claude/hooks/`. Each prints context at session start, `/clear` and compaction. What it prints is in its header comment.

They are turned on in `claude/settings.json`, under `hooks.SessionStart`.
