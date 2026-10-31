# Project workflow

My guide for keeping projects in order across Hermes, Claude or any other agent. This file is about starting and keeping up projects. Folder projects (design, copy, ideas, translations) live under `Projects/` and get the context files below. Code projects are repos and use the coding flow in `WORKFLOW.md`; a repo can also belong to a folder project.

The idea: **chats forget, files remember.** Every project keeps its context in a few Markdown files. Any chat, in any agent, reads them first. Deleting a chat loses nothing once its decisions are saved.

## What a project looks like

```
Projects/<Project Name>/
  IDEA.md        What the project is. The Hermes desktop app writes it.
  AGENTS.md      A short pointer that tells every agent to read the files below.
  CONTEXT.md     Goals, current focus, decisions, folders, related projects, open questions.
  GLOSSARY.md    Terms and wording.
  Docs/
    adr/         Big decisions, one file each (0001-slug.md).
    ideas.md     Ideas that aren't decided yet.
    inbox.md     Things the agents found in chats, waiting for my review.
```

The project folder is the one place to look. It syncs to the NAS and never holds a git repo.

Where things go, when a chat settles something:

| What                                                        | Where                                        |
| ----------------------------------------------------------- | -------------------------------------------- |
| A term                                                      | `GLOSSARY.md`                                |
| A big decision (hard to undo, surprising, a real trade-off) | `Docs/adr/`                                  |
| Any other decision                                          | One dated line under Decided in `CONTEXT.md` |
| An idea I haven't decided on                                | `Docs/ideas.md`                              |
| Status or focus                                             | `CONTEXT.md`                                 |

Agents propose, I approve. Nothing is written without a yes.

Related projects: `CONTEXT.md` lists other projects' `CONTEXT.md` paths with a line on why. Agents read them when relevant and never copy them.

## Rules

- **Not every project needs this.** A project follows the flow once `/project-context init` has created its `CONTEXT.md`. Projects without one are left alone.
- **Nothing goes into a repo.** Instead, `~/Joonas Sandell/Projects/PROJECTS.md` maps repos to projects, one per line: `~/Repositories/my-app -> ~/Joonas Sandell/Projects/My App`. A line can name a folder that holds several repos, which covers all of them. The global `AGENTS.md` tells agents to read it, through the symlink `~/.agents/PROJECTS.md` that `setup.sh` creates. It stays out of dotfiles because it names work repos.
- **`Projects/` holds only project folders**

## The `project-context` skill

One skill in `agents/skills/project-context/`. Its name avoids the built-in commands `/context`, `/init`, `/save` and `/review` in Hermes and Claude Code.

| Command                                    | Use it to                                                                                                                                                                                                         |
| ------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `/project-context init`                    | Set up a project, or repair one. Safe to re-run. It reads what's there, asks only what the files don't say, and writes after I approve.                                                                           |
| `/project-context update`                  | Bring this chat and the project files up to date: load the latest files into the chat, and save what the chat settled. Run it before archiving a chat, or on an old chat.                                         |
| `/project-context sync [--days N] [--all]` | Scan the project's other chats for things worth saving. Default is the last 2 days, `--all` reads every chat, for a project that already has many. It writes to `Docs/inbox.md` only, never to the decided files. |
| `/project-context review`                  | Go through `Docs/inbox.md` one item at a time: accept, edit or drop.                                                                                                                                              |

## Starting and converting

Every recipe is the short main path.

**New project**

1. In the Hermes desktop app, create a project with the folder `~/Joonas Sandell/Projects/<project-name>/`.
2. Start a chat in that project.
3. Run `/project-context init`.

**Convert an existing project**

1. Start a chat in the project folder and run `/project-context init`.
2. Run `/project-context sync --all`, then `/project-context review`. This pulls what the old chats decided into the files. Once per project, from any chat.
3. In every project chat that needs the context, run `/project-context update` once. It loads the project files.

**Add a repo to a project**

1. If the project doesn't exist yet, create it as in "New project".
2. If you don't have the repo yet, clone it into `~/Repositories/<project-name>`.
3. In the repo folder, run `herdr --session <project-name>`, then `hermes`.
4. In Hermes, run `/project-context init`. It asks which project folder the repo belongs to, links it, and writes nothing in the repo.

**New code project** (no `project-context`)

1. `mkdir ~/Repositories/<project-name> && cd ~/Repositories/<project-name> && git init -b main`
2. In `~/Repositories/<project-name>`, run `herdr --session <project-name>`, then `hermes`.
3. Continue with the coding flow in [WORKFLOW.md](WORKFLOW.md).

**New code project with project context**

1. In the Hermes desktop app, create a project with the folder `~/Joonas Sandell/Projects/<project-name>/`, then run `/project-context init` in it.
2. `mkdir ~/Repositories/<project-name> && cd ~/Repositories/<project-name> && git init -b main`
3. Follow "Add a repo to a project", from step 3.
4. Continue with the coding flow in [WORKFLOW.md](WORKFLOW.md).

## Daily use

- Open a chat in the project folder. The agent reads `IDEA.md` and `CONTEXT.md` first.
- When something settles, it asks "Save to context?". I say yes or no.
- Before archiving a chat: `/project-context update`.
- To go through what `sync` queued: `/project-context review`.
- Old chats stay searchable in Hermes, but they're a fallback, not the source.
