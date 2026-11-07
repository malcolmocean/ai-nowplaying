# ai-nowplaying

Ambient "now playing" context for Claude Code. The agent passively sees what music you're listening to on Spotify.

```
🎵 #nowplaying: Strasbourg St-Denis by Yohan Kim
```

## How it works

A `UserPromptSubmit` hook runs on every message you send. It checks Spotify via `osascript`, and if the track has changed since last time, injects a `#nowplaying` line into the conversation context. The agent sees it; you don't (unless you check the hook output).

Only fires when:
- The toggle file exists (`~/.claude/nowplaying-enabled`)
- Spotify is running and playing
- The track is different from last time

## Setup

1. Copy `nowplaying.sh` somewhere and make it executable:

```bash
chmod +x nowplaying.sh
```

2. Add the hook to your `~/.claude/settings.json` (merge into existing `hooks` if you have them):

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "bash /path/to/nowplaying.sh"
          }
        ]
      }
    ]
  }
}
```

3. Enable it:

```bash
touch ~/.claude/nowplaying-enabled
```

## Toggle

```bash
# off
rm ~/.claude/nowplaying-enabled

# on
touch ~/.claude/nowplaying-enabled
```

## Requirements

- macOS (uses `osascript`)
- Spotify
