#!/bin/bash
# 🎵 Now Playing hook for Claude Code
# Grabs current track from Spotify and injects it as ambient context
# Only outputs when the track changes

TOGGLE_FILE="$HOME/.claude/nowplaying-enabled"
CACHE_FILE="$HOME/.claude/nowplaying-last"

# Check toggle
if [ ! -f "$TOGGLE_FILE" ]; then
  exit 0
fi

# Check if Spotify is running
if ! osascript -e 'tell application "System Events" to (name of processes) contains "Spotify"' 2>/dev/null | grep -q true; then
  exit 0
fi

# Get track info
INFO=$(osascript -e 'tell application "Spotify"
  if player state is playing then
    set trackName to name of current track
    set trackArtist to artist of current track
    return trackName & " by " & trackArtist
  else
    return ""
  end if
end tell' 2>/dev/null)

if [ -z "$INFO" ]; then
  exit 0
fi

# Check if track changed
LAST=$(cat "$CACHE_FILE" 2>/dev/null)
if [ "$INFO" = "$LAST" ]; then
  exit 0
fi

# New track — cache it and announce
echo "$INFO" > "$CACHE_FILE"
printf '\033[32m🎵 #nowplaying: %s\033[0m\n' "$INFO"
