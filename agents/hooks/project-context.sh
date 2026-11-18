#!/bin/sh
# Claude Code SessionStart hook: print the project context for the session's folder.
# Reads ~/.agents/PROJECTS.md (`<path> -> <project folder>`), finds the longest listed
# path that contains the cwd, then prints that project's IDEA.md, CONTEXT.md,
# GLOSSARY.md and AGENTS.md. Prints nothing when no line matches. Never writes.

exec python3 -I -c '
import json, os, sys

home = os.path.expanduser("~")
try:
    cwd = json.load(sys.stdin).get("cwd") or os.getcwd()
except Exception:
    cwd = os.getcwd()
cwd = os.path.realpath(cwd)

def expand(p):
    return os.path.realpath(os.path.expanduser(p.strip()))

best = None
try:
    lines = open(os.path.join(home, ".agents", "PROJECTS.md"), encoding="utf-8").read().splitlines()
except OSError:
    sys.exit(0)
for line in lines:
    if " -> " not in line or line.lstrip().startswith(("#", "<")):
        continue
    src, dst = line.split(" -> ", 1)
    src, dst = expand(src), expand(dst)
    if (cwd == src or cwd.startswith(src + os.sep)) and (best is None or len(src) > len(best[0])):
        best = (src, dst)
if not best or not os.path.isdir(best[1]):
    sys.exit(0)

folder = best[1]
print("Project context for this folder (loaded by the SessionStart hook from ~/.agents/PROJECTS.md).")
print("Project folder: " + folder)
for name in ("IDEA.md", "CONTEXT.md", "GLOSSARY.md", "AGENTS.md"):
    path = os.path.join(folder, name)
    if os.path.isfile(path):
        text = open(path, encoding="utf-8").read().strip()
        print("\n===== " + name + " =====\n" + text[:20000])
inbox = os.path.join(folder, "Docs", "inbox.md")
if os.path.isfile(inbox):
    n = sum(1 for l in open(inbox, encoding="utf-8") if l.startswith("- [ ]"))
    if n:
        print("\nDocs/inbox.md has %d unreviewed entries: say so in the first reply." % n)
'
