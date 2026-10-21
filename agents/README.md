# Agent workflow

My global setup for coding agents (Claude Code, Codex, Hermes). The rules and my own skills live here. Third party skills are installed from `skills/skills.txt`.

## The flow

1. **Set up the repo (only if the project needs it):** `/setup-matt-pocock-skills`. Run it once per repo, before the first use of the other engineering skills. It asks where issues live (GitHub, GitLab, local markdown or other), and writes `docs/agents/` and an `## Agent skills` block into the repo's `AGENTS.md` or `CLAUDE.md`. Skip it for small or personal projects. `/code-review` needs it to find the spec from an issue.
2. **Start the work:** for a Linear issue run `linear issue start <ID>` and accept the branch name Linear generates. Otherwise branch from `<base>` with `<prefix>/<short-kebab-name>`.
3. **Shape the idea:** `/grill-me` by default. It writes no files. Use `/grill-with-docs` instead in projects that keep domain docs, since it also writes `GLOSSARY.md` and ADRs as it goes. Which one fits depends on the project.
4. **Build:** commit atomically as Conventional Commits.
5. **Review:** `/code-review <base>`. It reviews the diff on two axes, Standards (does it follow the repo's documented standards) and Spec (does it do what the issue or spec asked), in parallel sub-agents. The axes are reported separately and never merged into one verdict.
6. **Write the PR body:** `/pr`. Summary as a small visual, Evidence that it works, and Merge Danger (one-way or two-way door, and the blast radius).
7. **Finish:** `/ship pr` or `/ship main`. It refuses on `<base>` or with a dirty tree, runs `/code-review`, then does one of:
   - `pr`: draft the title and body, wait for approval, push, open the PR or MR with `gh` or `glab`, and stop. Merging is done by the team.
   - `main`: rebase on `<base>`, fast-forward merge, push if there is a remote, and delete the branch. Without a remote it works locally.

## Rules

`AGENTS.md` holds the rules that apply in every session. Short version:

- `<base>` is the project's default branch. It is resolved from a `Base:` line in the project's `AGENTS.md` or `CLAUDE.md`, then `origin/HEAD`, then `main`, `master` or `develop`, otherwise the agent asks.
- Never commit directly to `<base>`. Branch prefixes: `feat/`, `fix/`, `chore/`, `refactor/`, `docs/`, `test/`, `perf/`, `ci/`.
- Conventional Commits, atomic commits.
- No push, PR or merge unless asked, or through `/ship`.
- Chat replies use the `caveman` style. Questions, specs, docs, commit messages, PR text and code comments are normal prose.

## Where things live

- `AGENTS.md` is linked to `~/.agents/AGENTS.md`, and from there to `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md`. It is one file for all agents.
- `skills/ship/` is my own skill, linked into `~/.agents/skills/` and `~/.claude/skills/`.
- Other skills are installed with `skills add` into `~/.agents/skills/`, recorded in `~/.agents/.skill-lock.json`, and listed in `skills/skills.txt`: Matt Pocock's engineering skills, Emil Kowalski's animation and design skills, `good-css`, `caveman`, `linear-cli` and `find-skills`. `skills/setup.sh` installs them and `skills/update.sh` updates them.
- `setup.sh` in this folder creates the links. `bootstrap.sh` runs it.
- Hermes does not read `~/.agents/skills` by default. `skills.external_dirs: [~/.agents/skills]` in `~/.hermes/config.yaml` fixes that. That file is not in this repo, so it comes back with `hermes import <backup.zip>`.
