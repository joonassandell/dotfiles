# Agents

My global setup for agents (Hermes, Claude and others): shared rules, my own skills, and how I work with them.

- [Agent workflows](WORKFLOW.md): How I work on code, from branch to PR.
- [Project workflow](PROJECTS.md): How I start and keep up projects, so every chat knows the context.
- [Global instructions](AGENTS.md): Rules every agent follows.

## Claude Code hooks

`setup.sh` links the scripts in `hooks/` to `~/.claude/hooks/`. Each prints context at session start, `/clear` and compaction. What it prints is in its header comment.

Enable them once by adding this to `hooks.SessionStart` in `~/.claude/settings.json`:

```json
{
  "matcher": "^(startup|clear|compact)$",
  "hooks": [
    {
      "type": "command",
      "command": "sh ~/.claude/hooks/project-context.sh",
      "timeout": 10
    },
    {
      "type": "command",
      "command": "sh ~/.claude/hooks/caveman.sh",
      "timeout": 10
    }
  ]
}
```
