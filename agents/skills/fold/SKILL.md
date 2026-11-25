---
name: fold
description: Use when cleaning up a branch's commits before review. Folds fixes into the commits they fix.
---

# Fold

Clean up the commits on the current branch, or fold fixes into the commits they fix. The goal is an easy review: each commit reads as one finished change, without "fix typo" or "address review" commits after it.

1. Find the base: the branch's merge-base with `<base>` (see the Git workflow in `AGENTS.md`). List the commits with `git log --oneline <base>..HEAD`.
2. For each fix commit, find the commit it fixes on this branch: the one that introduced the lines it changes.
3. Fold it into that commit (`git commit --fixup=<sha>`, then `git rebase -i --autosquash <base>`), or squash commits that are one change split in two.
4. Keep a fix as its own commit when it isn't related to this branch's work, for example a fix to older code on `<base>`.
5. Keep the result atomic Conventional Commits. Reword a message when the folded commit now does more than it says.

Rules:

- Rewrite only commits that are on this branch. Never touch `<base>` or commits already merged.
- Make a backup branch first (`backup/<branch>-before-fold`) and name it in the report.
- If the branch is pushed, the rewrite needs a force push. Don't push; say that `git push --force-with-lease` is needed and wait for me.
- Before and after, the tree must be identical: `git diff <backup> HEAD` prints nothing.
- Report the commit list before and after.
