# Codex Global Config

This repository stores portable Codex global configuration that is safe to sync across machines.

## Contents

- `AGENTS.md`: global Codex instructions.
- `skills/`: globally installed non-system skills.
- `rules/`: global reusable rules.
- `install.sh`: installs this repository into `$CODEX_HOME`, defaulting to `~/.codex`.

Do not store Codex runtime state here, such as `auth.json`, history, sqlite databases, logs, sessions, or shell snapshots.

## Install On A Machine

```bash
cd ~/projects/codex-global
chmod +x install.sh
./install.sh
```

Restart Codex after installing so new or changed skills are loaded.

## Update From This Machine

When you intentionally change global skills, rules, or `AGENTS.md`, refresh this repo manually:

```bash
rsync -a --delete \
  --exclude '.system/' \
  --exclude '.DS_Store' \
  --exclude '__pycache__/' \
  --exclude '*.pyc' \
  ~/.codex/skills/ ~/projects/codex-global/skills/

rsync -a --delete \
  --exclude '.DS_Store' \
  ~/.codex/rules/ ~/projects/codex-global/rules/

cp ~/.codex/AGENTS.md ~/projects/codex-global/AGENTS.md
```

Then review the diff and commit.
