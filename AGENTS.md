# AGENTS.md

This file provides guidance to Codex (Codex.ai/code) when working with code in this repository.

## Overview

Personal Codex dotfiles repo. `settings.json` is the source of truth for all configuration,
deployed to `~/.Codex/` via `./install.sh`.

## Architecture

**Provider switching** uses `Codex --settings` overlay — no jq merges, no temp files.

- `settings.json` — default config. No API key inside; Codex reads `ANTHROPIC_AUTH_TOKEN` from the shell environment.
- `providers/deepseek.json` — only the fields that differ from default (`env`, `model`, `effortLevel`). Also no API key.
- `providers/deepseek` — exports `ANTHROPIC_AUTH_TOKEN=$CLAUDE_KEY_DEEPSEEK`, then `exec Codex --settings providers/deepseek.json`. `--settings` deep-merges onto `~/.Codex/settings.json`.

When editing `settings.json` (adding plugins, changing permissions), both `Codex` and `deepseek` pick up the changes automatically — deepseek only overrides what's in its JSON.

### Adding a new provider

Each third-party provider needs exactly three files, following the deepseek pattern:

1. **Run script** `providers/<name>` — exports the API key env var, then `exec Codex --settings providers/<name>.json "$@"`
2. **Override config** `providers/<name>.json` — only the fields that differ from `settings.json` (`env`, `model`, `effortLevel`). No API key.
3. **Env var** — a `CLAUDE_KEY_<NAME>` variable holding the API key, set in `~/.bashrc`. `install.sh` adds a commented placeholder.

`--settings` deep-merges the override onto `~/.Codex/settings.json`, so everything not listed in the override JSON is inherited from default.

## Commands

```bash
./install.sh    # backup ~/.Codex/settings.json → copy files (settings, skills, memory, providers) → add PATH
./uninstall.sh  # remove PATH entry → restore latest backup
```

After setup: `deepseek` (the command) switches to DeepSeek; `Codex` stays default.

## Conventions

- Never commit API keys. Keys come from `ANTHROPIC_AUTH_TOKEN` (default) or `CLAUDE_KEY_DEEPSEEK` env vars.
- `extraKnownMarketplaces` references `Codex-hud` (jarrodwatts/Codex-hud) and `codex` (openai/codex-plugin-cc).
- Machine-local overrides go in `~/.Codex/settings.local.json` (gitignored).
- Custom skills live in `skills/` and get copied to `~/.Codex/skills/` by install.
- `memory/` contains persistent memory config — copied to `~/.Codex/memory/` by install.
