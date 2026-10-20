#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Hermes
# @raycast.mode silent

# Optional parameters:
# @raycast.icon hermes.png

# Documentation:
# @raycast.description Opens or closes Hermes. Needed because the Raycast hotkey doesn't close the app.
# @raycast.author Joonas Sandell
# @raycast.authorURL https://joonassandell.com

osascript -e 'tell application "System Events" to set f to name of first process whose frontmost is true' \
          -e 'if f is "Hermes" then' \
          -e '  tell application "System Events" to set visible of process "Hermes" to false' \
          -e 'else' \
          -e '  tell application "Hermes" to activate' \
          -e 'end if'


