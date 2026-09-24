# Ubu Termux Runtime

## Goal

Provide a generic Termux-only `ubu` command that executes project commands inside a managed Ubuntu `proot-distro` environment without modifying consumer projects.

## Constraints

- Integrate through the existing `scripts/install.sh` flow.
- Install the command through GNU Stow.
- Preserve existing Ubuntu and Arch installer behavior.
- Support installer `--dry-run` and repeated execution.
- Do not alter unrelated existing worktree changes.
- Do not implement background process management or Bun in this work unit.

## Tasks

- [x] Implement the Stow-managed `ubu` command with `help`, `setup`, `run`, `shell`, and `doctor`.
- [x] Implement the Termux-only Ubuntu bootstrap module with Node and pnpm provisioning.
- [x] Integrate `proot-distro`, bootstrap, Stow ownership, verification, and summary into the main installer.
- [x] Document usage, lifecycle, storage, and removal.
- [x] Verify Bash syntax, dry-run behavior, command argument forwarding, and available runtime checks.
- [x] Add a concise `~/dev/AGENTS.md` that conditionally routes incompatible Astro commands through `ubu` and is symlinked from the Termux-only `agents` Stow package.
- [x] Isolate guest PATH so `ubu` cannot execute Android/Termux Node binaries inside Ubuntu, then reprovision and validate the Astro server.

## Evidence

- `bash -n scripts/install.sh scripts/install-ubu-termux.sh ubu/.local/bin/ubu`
- `bash scripts/install.sh --dry-run`
- `bash scripts/install-ubu-termux.sh --dry-run`
- CLI simulations verified help/invalid input exit codes, exact argument forwarding, guest exit-status propagation, and healthy/degraded doctor behavior.
- Termux PATH simulation verified `~/.local/bin`; desktop PATH precedence remained unchanged.
- `git diff --check`
- Live Ubuntu provisioning and bind-mount execution remain pending because `proot-distro` is not installed; no 1–2 GB runtime was downloaded implicitly during verification.
- No commit was created because the user did not request one.
- Fixed a runtime isolation defect: default `proot-distro login` appended Termux `$PREFIX/bin`, so the first Ubuntu setup incorrectly detected Android Node as guest tooling. Both runtime and bootstrap now use `--isolated` with a guest-only PATH.
- Reprovisioned Ubuntu with Linux ARM64 Node.js v24.21.0 and pnpm v12.5.1.
- Reinstalled `iluminaconciencia/node_modules` from its frozen lockfile under Ubuntu; Linux ARM64 Rolldown and Sharp bindings were selected.
- Bounded Astro validation reached HTTP 200 at `http://127.0.0.1:4321/`; the cold start took approximately 20 seconds and port cleanup succeeded.
