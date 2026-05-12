#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/.claude"
MARKER="# dotfiles-claude"
END_MARKER="# dotfiles-claude end"

echo "==> dotfiles-claude uninstall"

# --- remove from .bashrc ---
if grep -qF "$MARKER" "$HOME/.bashrc" 2>/dev/null; then
  if grep -qF "$END_MARKER" "$HOME/.bashrc"; then
    sed -i "/^$MARKER$/,/^$END_MARKER$/d" "$HOME/.bashrc"
  else
    sed -i "/^$MARKER/,+4d" "$HOME/.bashrc"
  fi
  echo "    removed PATH from ~/.bashrc"
else
  echo "    no PATH entry found"
fi

# --- find latest backup ---
bak=$(ls -t "$TARGET"/settings.json.bak.* 2>/dev/null | head -1 || true)

if [[ -n "$bak" ]]; then
  cp "$bak" "$TARGET/settings.json"
  echo "    restored: $bak → settings.json"
else
  echo "    no backup found, skipped settings.json restore"
fi

echo ""
echo "Done. Restart shell or: source ~/.bashrc"
