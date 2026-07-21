# Codex Global Config

This repository stores portable Codex global configuration that is safe to sync across machines.

## Contents

- `AGENTS.md`: global Codex instructions.
- `hooks.json`: user-level Codex lifecycle hook registration.
- `skills/`: globally installed non-system skills.
- `rules/`: global reusable rules.
- `hooks/`: user-level Codex lifecycle hooks.
- `ccb/ccb.config`: portable CCB agent and window configuration.
- `ccb/roles.json`: Role packages required by the portable CCB configuration.
- `install.sh`: installs this repository into `$CODEX_HOME`, defaulting to `~/.codex`.

Do not store Codex or CCB runtime state here, such as credentials, history, sqlite databases, logs, sessions, agent state, backups, or shell snapshots.
CCB regenerates `.ccb/agents/` from `ccb.config`; do not copy or commit that directory because it contains project paths, runtime bindings, task history, and provider state.

## Automatic Sync

The `SessionStart` hook pulls this repository and synchronizes the managed Codex files into `$CODEX_HOME`. It also treats `ccb/ccb.config` as remote-authoritative and installs it into `${CCB_HOME:-~/.ccb}/ccb.config`, backing up a different local copy first and preserving user-only file permissions.

The hook installs Role packages declared in `ccb/roles.json` with `--skip-tools`. Successful installations are recorded per device; unavailable or timed-out packages are logged and retried on later sessions without blocking Codex startup.

The hook does not reload or restart CCB. A running CCB project keeps its mounted service graph until the operator applies a supported reload or starts CCB again. Generated `.ccb/agents/` directories are never synchronized.

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
