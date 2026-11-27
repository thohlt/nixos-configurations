#!/usr/bin/env bash
# PreToolUse (git push, opening/updating a PR): block unless scripts/check passes.
# Exit 2 blocks the tool call and shows stderr to Claude.
cd "$CLAUDE_PROJECT_DIR" || exit 0
if ! out=$(scripts/check 2>&1); then
  {
    echo "Blocked: scripts/check failed. Fix these before pushing or opening a PR:"
    echo "$out" | grep -vE '^(copying|building|evaluating|checking|derivation evaluated)' | tail -40
  } >&2
  exit 2
fi
