#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

mkdir -p "$CODEX_HOME/skills" "$CODEX_HOME/rules"

rsync -a \
  --exclude '.DS_Store' \
  --exclude '__pycache__/' \
  --exclude '*.pyc' \
  "$ROOT/skills/" "$CODEX_HOME/skills/"

rsync -a \
  --exclude '.DS_Store' \
  "$ROOT/rules/" "$CODEX_HOME/rules/"

install -m 0644 "$ROOT/AGENTS.md" "$CODEX_HOME/AGENTS.md"

echo "Installed Codex global config into $CODEX_HOME"
echo "Restart Codex to load new or changed skills."
