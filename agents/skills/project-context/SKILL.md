---
name: project-context
description: Use when setting up or syncing a project's context docs.
---

# Project context

Keeps a project's context in plain Markdown files in its project folder, so every chat in any agent can read it. Chats hold no context, files do. Commands: `init`, `update`, `sync`, `review`. If no command is given, ask which one.

## Scope: folder projects only

Project folders live under `Projects/<Project Name>/` and are not git repos. Never create context files (`IDEA.md`, `CONTEXT.md`, `GLOSSARY.md`, `Docs/`) inside a git repo. Nothing is written into a repo, not even a pointer: a repo may be a team repo. A repo is linked to its project by one line in `~/.agents/PROJECTS.md` (`<repo path> -> <project folder>`), which a global rule in `AGENTS.md` makes every agent read. The real file is `~/Joonas Sandell/Projects/PROJECTS.md` (the one allowed file in the `Projects/` root, synced by the NAS), and `~/.agents/PROJECTS.md` links to it: create both if missing. Write paths with `~`. Never copy it into dotfiles or a repo. If the cwd is a repo with no project, say this and stop.

## Files (project folder)

- `IDEA.md`: what the project is. Written by the Hermes desktop app. Create it only if missing, never overwrite it.
- `AGENTS.md`: pointer block from `templates/pointer.md`, between its marker comments.
- `CONTEXT.md`: from `templates/context.md`. Goals, status, decided, folders, related, open questions, tips. Do not repeat `IDEA.md`.
- `GLOSSARY.md` and `Docs/adr/NNNN-slug.md`: use the formats in the `domain-modeling` skill (`GLOSSARY-FORMAT.md`, `ADR-FORMAT.md`). Create lazily, only when there is something to write.
- `Docs/ideas.md`: ideas not decided. Never mix them into decided files.
- `Docs/inbox.md`: proposals waiting for review, written by `sync`.

Project folder = the nearest folder upward from the cwd that has a `CONTEXT.md`. It is the main folder under `Projects/`; other folders and repos belong to the project but hold none of these files. If the cwd's `AGENTS.md` has a `Project folder:` line, that path is the project folder (a repo that belongs to a project). Context files are written only in the project folder. Refuse to use `~` or a `Projects/` root as a project folder: project files go inside `Projects/<Project Name>/`.

## Rules for every command

- Propose, then write. Show a numbered list of proposed changes, each with its target file. Write only the ones I approve ("all", numbers, or edits). Never edit silently, never overwrite existing text; extend or propose a replacement.
- Write only in the project folder, plus lines in `~/.agents/PROJECTS.md`. Project folders have no version control, so never mention commits or git status in reports. Shared team folders, like a team Google Drive, are always read-only.
- Before proposing anything, read the existing files and skip what is already there. If something contradicts an existing entry, say so and propose superseding it.
- File text is plain prose for a human reader (no caveman style). One fact per line, short.
- Where an item goes: a term goes to `GLOSSARY.md`. A decision that is hard to reverse, surprising without context and a real trade-off becomes an ADR; any other decision is one dated line under `Decided` in `CONTEXT.md`. An undecided idea goes to `Docs/ideas.md`. Status or focus goes to `CONTEXT.md`. A how-to or tip for working in this project goes under Tips in `CONTEXT.md`.
- No secrets, no personal data, nothing from HR or finance folders.

## init

Sets up or repairs the project in the current folder. Safe to re-run.

1. Resolve the project folder (above). If the cwd is a git repo, it must belong to a project: ask for that project folder (`hermes project list`, `hermes project show <slug>`), then do only the repo steps: add a line `<path> -> <project folder>` to `~/.agents/PROJECTS.md`, under that project's `## <Project>` heading (create the heading if missing), unless a listed path already contains the repo, and in the project folder add that path to `CONTEXT.md` Folders. If the repo's parent folder is not a git repo and holds other repos too, ask whether to list the parent folder instead of the repo: one line for the parent covers every repo in it. Write nothing in the repo. Skip steps 2 to 5.
2. Inventory: list the folder, read `IDEA.md`, `AGENTS.md`, README and any existing docs. If a per-project skill exists for it, read it as source material and offer to move its content into the files, then to delete it or cut it to a two-line pointer.
3. In Hermes, find the project's chats: `hermes sessions list --workspace <folder name>`. Mention the count; offer `sync --all` afterwards.
4. Ask only what the files do not answer, one question at a time: goal, current focus, related projects (absolute paths of their `CONTEXT.md`).
5. Draft `IDEA.md` if it is missing (one sentence on what the project is, from the goal), `CONTEXT.md`, the pointer block, `GLOSSARY.md` terms already clear from the material. Show the drafts as the numbered list.
6. Write the approved ones. For `AGENTS.md`, create it or replace only the block between `<!-- project-context:start -->` and `<!-- project-context:end -->`; keep everything else.
7. Report in a few lines what was written and what was skipped.

## update

Brings this chat and the project files up to date: loads the latest project files into the chat, and saves what the chat settled. Run it before archiving or deleting a chat, when the pointer's "Save to context?" is answered yes, or to bring an old chat up to date.

1. Resolve the project folder and read its files. This is what brings the chat up to date.
2. List decisions, terms, ideas and status changes from this chat that the files lack.
3. Show the numbered list with targets, write the approved ones, report.

## sync [--days N] [--all]

Hermes only. Finds what other chats settled and queues it; it never writes decided files.

1. Resolve the project folder. List chats with `hermes sessions list --workspace <folder name> --limit 100`. Keep those active in the last N days (default 2), or all with `--all`.
2. For each, export it: `hermes sessions export --format md --session-id <id> <scratch dir>` (the argument is a directory), then read the human messages and the final answers.
3. Find items as in `update`, skipping those already in the files or in `Docs/inbox.md`.
4. Append each to `Docs/inbox.md` as `- [ ] <target>: <text> (from "<chat title>", <id>, <date>) > <one-line quote>`. Keep the first line of the file, `<!-- last sync: <ISO time> -->`, updated.
5. Report counts and the top three as one-line questions ("Chat X decided Y. Add to context?").

## review

Goes through `Docs/inbox.md` one item at a time: accept (write it to the target as in `update`), edit, or drop. Remove each processed line and keep the `last sync` comment. Stop when I say so.
