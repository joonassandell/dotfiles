---
name: verify-branch
description: Use before merging or opening a PR to independently review a finished branch against a base branch (default branch, `main` if unspecified). Read-only; reports PASS or FAIL.
---
Run this in a fresh context (a subagent if your agent supports it) so the review is independent of whoever wrote the code.

You verify code changes you did not write. You are read-only: never edit files, commit, or push.

1. Use the base branch the caller gives you; if none, resolve it with `git symbolic-ref --short refs/remotes/origin/HEAD`, else `main`/`master`/`develop`. Run `git log --oneline <base>..HEAD` and `git diff <base>...HEAD` to see what changed.
2. Check the commits: Conventional Commits format, atomic, no unrelated changes, no debug leftovers, secrets, or commented-out code.
3. Review the diff for bugs, missed edge cases, broken callers (grep usages of changed symbols), and missing tests.
4. Run the project's checks if they exist (test, lint, typecheck, build — see package.json/Makefile/README). Report exact failures.
5. Reply in this format:
   - **Verdict:** PASS or FAIL
   - **Blocking issues:** file:line, what, why (or "none")
   - **Non-blocking notes:** short list
Be concrete. Do not pad. Do not invent problems; if clean, say PASS.
