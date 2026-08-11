# AgentX Homebrew tap

Homebrew formulae for [AgentX](https://www.agentxhq.com/) on macOS.

## Install

```bash
brew install agentxhq/tap/agentx
```

Then start the daemon and open the console:

```bash
agentx-daemon background
agentx-daemon status
open http://127.0.0.1:3333/console
```

To run it at login instead:

```bash
brew services start agentx
```

## What gets installed

| Binary | Role |
|--------|------|
| `agentx-daemon` | Host daemon — web console and gRPC |
| `agentx` | CLI and Work Plane MCP bridge |
| `agentx-browser` | Symlink to `agentx` |

State lives under `~/.agentx/` — config, SQLite database, and logs.

## Requirements

macOS on Apple Silicon (arm64) or Intel (amd64). You supply your own agent CLIs
— Claude Code, Codex, Grok CLI — with your own API keys. The daemon resolves
them from `PATH` plus the usual install locations including `/opt/homebrew/bin`.

## Signing

These builds are not yet signed or notarized. Homebrew installs them without a
Gatekeeper prompt, but if you see one after a manual download:

```bash
xattr -dr com.apple.quarantine $(brew --prefix)/bin/agentx-daemon
```

## Other platforms

Debian, Ubuntu, and Arch Linux packages, plus Docker images for Windows, are at
[agentxhq.com/install](https://www.agentxhq.com/install).

## Notes

The `version`, `url`, and `sha256` lines in `Formula/agentx.rb` are stamped from
the published AgentX release feed, after the artifacts they point at are live
and publicly downloadable — so the download URL always resolves. Don't hand-edit
those five lines; they're replaced on the next release. The rest of the formula
is maintained by hand.
