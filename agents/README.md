# Agents

My global setup for agents (Hermes, Claude and others): shared rules, my own skills, and how I work with them.

- [Agent workflows](WORKFLOW.md): How I work on code, from branch to PR.
- [Project workflow](PROJECTS.md): How I start and keep up projects, so every chat knows the context.
- [Global instructions](AGENTS.md): Rules every agent follows.

## Hermes skills

My own Hermes skills live in `~/.hermes/skills/`, not here, because they hold private project details and Hermes keeps editing them. They come back with the Hermes backup (`hermes import`). The ones this setup leans on:

- `herdr-agents`: worktrees, agents, briefs and clean up in Herdr. `skills/issue` hands off to it in the orchestrator chat.
- `coding-agent-workflow-setup`: editing these agent rules, the PR flow and project docs.
- `dotfiles-maintenance`: checking before editing this repo.
- `dependency-upgrade`: updating npm and bun packages.
- `flutter-device-testing`: running Flutter apps on simulators and real devices, next to `zsh/ios-android-capture`.
- `hermes-cron-jobs`: the scheduled Hermes jobs and their scripts.

## Claude Code hooks

`setup.sh` links the scripts in `hooks/` to `~/.claude/hooks/`. Each prints context at session start, `/clear` and compaction. What it prints is in its header comment.

They are turned on in `claude/settings.json`, under `hooks.SessionStart`.
