# dotfiles-claude

Personal Claude Code configuration, managed as a dotfiles repo.

## Install

```bash
git clone https://github.com/huxint/dotfiles-claude.git ~/dotfiles-claude
cd ~/dotfiles-claude
./install.sh
source ~/.bashrc
```

`install.sh` backs up your existing `~/.claude/settings.json`, copies config files (settings, skills, memory, providers) to `~/.claude/`, and adds `providers/` to PATH.

## Provider switching

Default: `claude` runs with `settings.json`.

```bash
# set DeepSeek API key in ~/.bashrc
export CLAUDE_KEY_DEEPSEEK="sk-xxx"

# then:
deepseek
```

`deepseek` overlays `providers/deepseek.json` (which only contains the fields that differ) onto the default config via `claude --settings`. No jq, no temp files.

## Uninstall

```bash
./uninstall.sh
source ~/.bashrc
```

Removes the PATH entry and restores the most recent `settings.json` backup.

## Adding a provider

Three files, following the deepseek pattern:

1. `providers/<name>` — run script
2. `providers/<name>.json` — override fields only
3. `CLAUDE_KEY_<NAME>` env var in `~/.bashrc`

## What's included

- `settings.json` — default config
- `providers/` — DeepSeek provider switch, extensible
- `skills/` — skill-creator, read-url, skillify
- `memory/` — persistent memory config
