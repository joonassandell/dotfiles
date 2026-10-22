#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Hermes + Warp
# @raycast.mode silent

# Optional parameters:
# @raycast.icon hermes.png

# Documentation:
# @raycast.description Opens Hermes on the left half and Warp on the right half. Hides both if either is frontmost.
# @raycast.author Joonas Sandell
# @raycast.authorURL https://joonassandell.com

# One osascript (JXA) call does everything. The frontmost check and the hide use
# NSWorkspace, so System Events (slow to cold-start) is only needed for placing windows.
osascript -l JavaScript <<'EOF'
ObjC.import('AppKit');

const MARGIN = 80;
const apps = ['Hermes', 'Warp'];
const ws = $.NSWorkspace.sharedWorkspace;

// The frontmost app is hidden first. Hiding it makes macOS activate another app, which
// can be the other target and un-hide it again, so the other one is hidden afterwards.
function hideBoth(front) {
  const running = ws.runningApplications;
  const targets = [];
  for (let i = 0; i < running.count; i++) {
    const app = running.objectAtIndex(i);
    if (apps.includes(ObjC.unwrap(app.localizedName))) targets.push(app);
  }
  targets.sort((a, b) => (ObjC.unwrap(b.localizedName) === front) - (ObjC.unwrap(a.localizedName) === front));
  // JXA exposes zero-argument ObjC methods as properties, so this accesses hide(), not a call.
  targets.forEach(app => { app.hide; });
}

function run() {
  const front = ObjC.unwrap(ws.frontmostApplication.localizedName);
  if (apps.includes(front)) {
    hideBoth(front);
    return;
  }
  showBoth();
}

function showBoth() {
  // Usable area of the main screen (below the menu bar, beside the Dock),
  // shrunk by MARGIN on every outer edge. The windows touch in the middle.
  const screen = $.NSScreen.screens.objectAtIndex(0);
  const f = screen.frame, v = screen.visibleFrame;
  const X = Math.round(v.origin.x) + MARGIN;
  const Y = Math.round(f.size.height - (v.origin.y + v.size.height)) + MARGIN;
  const W = Math.round(v.size.width) - 2 * MARGIN;
  const H = Math.round(v.size.height) - 2 * MARGIN;
  const HALF = Math.floor(W / 2);

  const se = Application('System Events');

  // Opens the app, waits for its window, then sets position and size directly.
  function place(name, x) {
    Application(name).activate();
    const proc = se.processes.byName(name);
    for (let i = 0; i < 30; i++) {
      try { if (proc.windows.length > 0) break; } catch (e) {}
      delay(0.1);
    }
    const win = proc.windows[0];
    win.position = [x, Y];
    win.size = [HALF, H];
  }

  place('Hermes', X);
  place('Warp', X + HALF);
}
EOF
