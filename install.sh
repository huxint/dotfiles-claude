#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
TARGET="$HOME/.claude"
MARKER="# dotfiles-claude"
END_MARKER="# dotfiles-claude end"

echo "==> dotfiles-claude setup"

# --- backup settings.json ---
if [[ -f "$TARGET/settings.json" ]]; then
  bak="$TARGET/settings.json.bak.$(date +%Y%m%d_%H%M%S)"
  cp "$TARGET/settings.json" "$bak"
  echo "    backup: $bak"
fi

# --- copy config files ---
mkdir -p "$TARGET/providers" "$TARGET/skills" "$TARGET/memory" "$TARGET/agents"

cp "$REPO/settings.json" "$TARGET/settings.json"
[[ -d "$REPO/providers" ]] && find "$REPO/providers" -mindepth 1 -maxdepth 1 -exec cp -r {} "$TARGET/providers/" \;
[[ -d "$REPO/skills" ]] && find "$REPO/skills" -mindepth 1 -maxdepth 1 -exec cp -r {} "$TARGET/skills/" \;
[[ -d "$REPO/memory" ]]  && find "$REPO/memory"  -mindepth 1 -maxdepth 1 -exec cp -r {} "$TARGET/memory/" \;
[[ -d "$REPO/agents" ]]  && find "$REPO/agents"  -mindepth 1 -maxdepth 1 -exec cp -r {} "$TARGET/agents/" \;

echo "    copied: settings.json providers/ skills/ memory/ agents/"

# --- PATH ---
if ! grep -qF "$MARKER" "$HOME/.bashrc" 2>/dev/null; then
  cat >> "$HOME/.bashrc" <<EOF

$MARKER
export PATH="$TARGET/providers:\$PATH"
# export CLAUDE_KEY_DEEPSEEK="sk-xxx"    # uncomment and fill for deepseek command
# export CLAUDE_KEY_KIMI="sk-xxx"        # uncomment and fill for kimi command
# export CLAUDE_KEY_GLM="sk-xxx"         # uncomment and fill for glm command
$END_MARKER
EOF
  echo "    added PATH to ~/.bashrc"
else
  echo "    PATH already in ~/.bashrc"
fi

echo ""
echo "Done. Restart shell or: source ~/.bashrc"
echo "Then: deepseek/kimi/glm (if the matching CLAUDE_KEY_* is set)"
