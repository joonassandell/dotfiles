---
name: direct
description: Use when I allow committing straight to the base branch in this chat. Commit and push only on my word.
---

# Direct

For this chat only, you can commit to `<base>` and push when I say `commit`, `commit push` or `push`. This overrides the rule in `AGENTS.md` against committing to `<base>`. It ends with the chat.

- `commit`: commit what I named, or the change we just made. Leave changes you didn't make alone; they may be mine or another chat's.
- `commit push`: commit, then push.
- `push`: push what is already committed.
- Commit atomically as Conventional Commits. Never push without one of those words.
