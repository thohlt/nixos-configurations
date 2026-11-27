#!/usr/bin/env bash
# PostToolUse (Edit|Write): format the edited file if it is a .nix file.
set -euo pipefail
file=$(HOOK_INPUT=$(cat) nix eval --raw --impure --expr \
  '(builtins.fromJSON (builtins.getEnv "HOOK_INPUT")).tool_input.file_path or ""')
case "$file" in
  *.nix) cd "$CLAUDE_PROJECT_DIR" && nix fmt -- "$file" >/dev/null 2>&1 || true ;;
esac
