#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title New Kitty Window
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🐱
# @raycast.packageName Kitty
# @raycast.description Open a new kitty OS window (reuses the running instance)

KITTY="/Applications/kitty.app/Contents/MacOS/kitty"

# kitty appends its PID to the `listen_on` path, so the socket is /tmp/kitty-<pid>.
# Pick the most recently created one.
SOCKET=$(ls -t /tmp/kitty-* 2>/dev/null | head -1)

if [[ -n "$SOCKET" && -S "$SOCKET" ]] \
  && "$KITTY" @ --to "unix:$SOCKET" launch --type=os-window --cwd="$HOME" >/dev/null 2>&1; then
  # New window created in the existing instance -- bring kitty to the front.
  open -a kitty
else
  # No running instance (or remote control unavailable): start a fresh one.
  open -na kitty
fi
