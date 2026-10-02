# Remove the gentle-shell beta (`main` branch) install

## Why

The `gbeta` setup pointed at a git checkout of upstream `main` (`~/src/gentle-shell`)
with its own agent home (`~/.gentle-shell-beta/agent`), provisioned with
gentle-ai/gentle-pi 3.7.0. That was necessary while no npm release existed.
`gentle-pi` 4.0.0 is now released on npm, so the beta lane is dead weight:
~528 MB across two directories and a stale alias in dotfiles.

## Scope

Migrate what is portable, remove the wiring, then delete the data.

### Migrate (portable state)

| Source | Target | Count |
| --- | --- | --- |
| `~/.gentle-shell-beta/agent/sessions/**/*.jsonl` | `~/.gentle-shell/agent/sessions/` | 17 |
| `~/.gentle-shell-beta/agent/gentle-agents/sessions/*.jsonl` | `~/.gentle-shell/agent/gentle-agents/sessions/` | 434 |
| `~/.gentle-shell-beta/agent/trust.json` entry | `~/.gentle-shell/agent/trust.json` | 1 |

Session files are self-contained JSONL (`{"type":"session","version":3,...,"cwd":...}`),
so they replay in any agent home. Verified: zero filename collisions between the
beta and release homes.

### Do not migrate

- `gentle-agents/{presence,transport,tasks}` — live runtime state of the beta instance.
- `chains/sdd-*.chain.md`, `agents/sdd-*.md` — SDD-era definitions superseded by the
  10 non-SDD agents that 4.0.0 provisions. Archived only.
- `settings.json` — the release home's own settings are current (4.0.0, `gentle-engram@0.2.0`,
  native `mcp.json` instead of the `pi-mcp-adapter` extension).
- `npm/`, `models-store.json`, `auth.json`, `mcp-cache.json` — reinstalled or refetched at runtime.

### Remove

- `zsh/.config/.zsh/aliases.zsh` — the uncommitted `gbeta` alias and its comment block.
- `~/.gentle-shell/config.json` — the `provisioned["/home/strocs/.gentle-shell-beta/agent"]` entry.
- `~/.gentle-shell-beta/` (271 MB) and `~/src/gentle-shell` (257 MB), after archiving the
  non-migrated state to `~/gentle-shell-beta-archive.tar.gz`.

## Non-goals

- Not touching the pi 1.0.0 install or its two pnpm global env dirs.
- Not cleaning the unrelated `gentle-engram` duplicate in the release `settings.json`
  packages list, nor the duplicated `alias xclean` in `zsh/.zshrc` (both pre-existing,
  reported separately).

## Tasks

- [x] 1. Migrate portable state (sessions, subagent sessions, trust entry)
- [x] 2. Verify migration with a structural readback
- [x] 3. Remove the beta wiring (alias, provisioned entry)
- [x] 4. Archive non-migrated state, then delete the beta home and the checkout

## Evidence

### 1. Migration

- `cp -rn` of `sessions/` and `gentle-agents/sessions/*.jsonl`; trust merged with node, never clobbering an existing release decision.
- Parent sessions in the release home: 66 -> 83 (+17). Subagent transcripts: 655 -> 1089 (+434); the live release instance adds its own as it runs.
- `trust.json` created in the release home with `{"\/home\/strocs\/dev\/iluminaconciencia": true}`.

### 2. Verification (read-only structural readback)

All 17 migrated parent sessions: byte-identical to the beta originals, header `type=session` / `version=3`, session id matches the filename uuid, session directory slug matches the header `cwd`, and every `cwd` still exists on disk. All 434 subagent transcripts byte-identical. Release home: 83 files, 83 unique ids, 0 duplicates. The slug rule was cross-checked against the 66 pre-existing release sessions (0 mismatches) after an initial run flagged all 17 — the rule, not the data, was wrong (a leading `/` is dropped, not turned into `-`).

### 3. Wiring removed

- `zsh/.config/.zsh/aliases.zsh`: the uncommitted `gbeta` alias and its 6-line comment reverted with `git checkout --`; the file's only diff had been that hunk. No `gbeta` reference remains.
- `~/.gentle-shell/config.json`: `provisioned["/home\/strocs\/.gentle-shell-beta\/agent"]` deleted (backup at `config.json.bak`). Only the 4.0.0 release entry remains.

### 4. Archive and delete

- `~/gentle-shell-beta-archive.tar.gz` (48 KB, 44 entries, `gzip -t` ok): the beta `chains/`, `agents/` (SDD-era definitions), `settings.json`, `subagents.json`, `mcp.json`, `trust.json`, `gentle-ai/`, plus a `MIGRATED.txt` manifest listing all 451 migrated jsonl paths.
- Deleted `~/.gentle-shell-beta` (271 MB) and `~/src/gentle-shell` (257 MB).

### Known consequence

One migrated session has `cwd: /home/strocs/src/gentle-shell`
(`--home-strocs-src-gentle-shell--/2026-09-30T01-28-00-767Z_01a0efec-….jsonl`). Its transcript is
intact and browsable, but that directory no longer exists, so resuming it has no working
directory.

### Not committed

The repo change here is only the `aliases.zsh` revert, which cancels an uncommitted hunk, so
`git status` shows no `zsh/.config/.zsh/aliases.zsh` entry at all. The only new tracked-candidate
file is this document. No commit was made: commits remain the user's decision.
