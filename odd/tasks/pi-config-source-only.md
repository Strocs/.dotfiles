# Pi config source-only cleanup

Goal: Keep only durable, shareable Gentle Pi profile configuration in the Pi dotfiles package. Move user skills to a central dotfiles Stow package linked to `~/.agents/skills`; stop tracking/stowing Pi runtime assets and per-machine configuration.

## Tasks

- [x] Preserve the user's Pi settings locally while removing `settings.json` from tracked/Stow scope; retain `profiles.json` as the only tracked `.pi` file, import all remote feature profiles, and select `cheap`.
- [x] Copy local skills byte-for-byte to `agent-skills/.agents/skills/` and install that central Stow package to the general skills location.
- [x] Remove Pi agents, chains, skills, MCP config, subagent routing, generated manifests, and runtime configs from Git/Stow ownership without deleting local worktree copies or global links.
- [x] Configure Git/Stow ignores and Pi installer behavior to retain/stow only `profiles.json` under `pi-agent/.pi`.
- [x] Verify JSON, shell syntax, tracked file inventory, skill copy identity, and Stow behavior in isolated temporary targets.

## Evidence

- `git ls-files pi-agent/.pi` lists only `pi-agent/.pi/gentle-ai/profiles.json`; 178 former tracked paths were removed from the index without deleting their worktree copies.
- `profiles.json` preserves all four profiles from `origin/feat/integrate-ubu-termux-local-changes`, with `active: cheap`; its cheap orchestrator is `openai-codex/gpt-6-sol` at `low`.
- Local `settings.json` remains physically present but untracked/ignored with the agreed defaults, `hideThinkingBlock: true`, `pi-notify`, no profiles-manager or rpiv package, and Pi changelog version `0.87.1`.
- 140 skill files under `agent-skills/.agents/skills/` match the existing Pi skills byte-for-byte.
- Installer adds `agent-skills` and uses `--adopt` for an existing skill package so identical existing global skill files can be linked into the central source.
- Stow simulation for `pi-agent` with `--no-folding` links only `.pi/gentle-ai/profiles.json`; simulation for central skills passed with an empty target and with an isolated copy of the existing skills target using the install adoption flow.
- `git diff --check`, profile/settings JSON validation, and `bash -n scripts/install.sh` passed.

## Notes

- Work-unit commit `2003004` (`chore(pi-agent): track shared profiles and skills`) records the cleanup on branch `chore/pi-profiles-only`; `main` has not yet been updated, and the six remote feature commits have not yet been integrated.
- `gentle-ai sync` and Stow were not run against the actual home directory. Existing home symlinks were left untouched; the prior sync attempt remains blocked by Gentle AI's refusal to operate on symlinked global settings/assets.
- Applying the saved `cheap` profile on another device may need to materialize local `settings.json`/`models.json`/`subagents.json`; those generated per-device files are intentionally not tracked.
