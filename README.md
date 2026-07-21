# Codex Global Config

This repository stores portable Codex global configuration that is safe to sync across machines.

## Contents

- `AGENTS.md`: global Codex instructions.
- `hooks.json`: user-level Codex lifecycle hook registration.
- `skills/`: globally installed non-system skills.
- `rules/`: global reusable rules.
- `hooks/`: user-level Codex lifecycle hooks.
- `ccb/ccb.config`: portable CCB agent and window configuration.
- `install.sh`: installs this repository into `$CODEX_HOME`, defaulting to `~/.codex`.

Do not store Codex or CCB runtime state here, such as credentials, history, sqlite databases, logs, sessions, agent state, backups, or shell snapshots.
CCB regenerates `.ccb/agents/` from `ccb.config`; do not copy or commit that directory because it contains project paths, runtime bindings, task history, and provider state.

## Install On A Machine

```bash
cd ~/projects/codex-global
chmod +x install.sh
./install.sh
```

Restart Codex after installing so new or changed skills are loaded.

## Update From This Machine

When you intentionally change global skills, rules, hooks, or `AGENTS.md`, refresh this repo manually:

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

rsync -a --delete \
  --exclude '.DS_Store' \
  --exclude '__pycache__/' \
  --exclude '*.pyc' \
  ~/.codex/hooks/ ~/projects/codex-global/hooks/

cp ~/.codex/AGENTS.md ~/projects/codex-global/AGENTS.md
cp ~/.codex/hooks.json ~/projects/codex-global/hooks.json
cp ~/.ccb/ccb.config ~/projects/codex-global/ccb/ccb.config
```

Then review the diff and commit.
