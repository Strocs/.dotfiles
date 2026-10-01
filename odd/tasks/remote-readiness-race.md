# remote script readiness race

Goal: Make `remote` work on the first invocation by distinguishing Tailscale's
transition state from a genuinely unauthenticated node, instead of reporting
every non-`Running` backend as "not connected".

## Why

`remote` starts `tailscaled` and probes it immediately
(`zsh/.config/.zsh/aliases.zsh:70,75`). `tailscaled` is `Type=notify`, so
systemd reports the unit active while the ipn backend is still `Starting`;
`tailscale status` exits non-zero for any state other than `Running`. Measured
on this machine: unit active 17:26:58, `NoState -> Starting` 17:27:01,
`Starting -> Running` 17:27:03. The first invocation probed inside that window,
printed a false "not connected", and only the second one worked. The 3-day
journal shows no `NeedsLogin` and no `authURL`, so the node was authenticated
all along and the suggested `sudo tailscale up` was both wrong and, per the
script's own comment, able to clear the operator grant made moments later.

## Tasks

- [x] Add a readiness probe that waits for `Running`, reports `NeedsLogin`
      and `Stopped` separately, and times out with its own message.
- [x] Reorder `remote` to grant the Tailscale operator before the first
      non-root query, so a fresh install can self-heal.
- [x] Wait for the SSH service to actually be active before reporting it,
      instead of printing `systemctl is-active` immediately.
- [x] Silence the `curl` probe stderr noise on the not-yet-listening path.
- [x] Cover the backend states and the failure paths with a standalone `zsh`
      test that runs fakes on `PATH` and never touches the real host services.

## Non-goals

- No `tailscale up` automation inside `remote`: login is interactive and
  blocking by design, and it can clear the operator grant.
- No change to `collie start` / `collie serve` / `collie stop` semantics.
- No new test framework for the repository: one self-contained `zsh` script.

## Evidence

- The readiness helper returns 0 / 2 / 1 and reads `BackendState` from
  `tailscale status --json` through `jq`, branching on the parsed value
  rather than on the command's exit status. Verified against the live daemon
  on this host under `setopt pipefail`: `state=[Running]`, branch `return 0`.
- RED before the first implementation: 0 passed / 5 failed, with the
  `Starting` case reporting `rc=0 polls=0` (the old path never polled) and
  `curl: (7)` on stderr. GREEN: 6 passed / 0 failed.
- RED before the fix round: 8 passed / 4 failed (non-zero status exit,
  pipefail, `Stopped`, and the `Stopped` advice text). GREEN: 12 passed /
  0 failed across three consecutive runs.
- The suite drives the real `_remote_*` functions and `remote` out of
  `aliases.zsh` through fake `tailscale`/`systemctl`/`collie`/`curl`/`sudo`
  on `PATH` in a `mktemp -d`, with no real service touched. `zsh -n` clean on
  both files.
- The `tailscale status --json` fake deliberately exits non-zero while emitting
  valid parseable JSON, so a regression that reintroduced the exit-code
  dependency could not pass the suite.
- Real-host smoke: the sshd wait returns 0, `_remote_collie_port` resolves
  8787, and the operator grant is a no-op on a host that already has
  `OperatorUser: strocs`. The live readiness probe was confirmed only up to
  the `jq` parse, not end to end: the sudo timestamp had expired in that shell
  and the root-run probe cannot prompt unattended.

## Notes

- Detection uses `tailscale status --json` plus a JSON field read rather than
  exit codes, because the exit code collapses `Starting`, `NeedsLogin` and
  permission failures into one indistinguishable result. Branching on the
  value also keeps the probe correct when the user has `pipefail` set, which
  would otherwise discard the parsed state through a `||` fallback.
- The probe runs as root (`sudo tailscale status --json`), so it needs no
  operator. That removes the chicken-and-egg of probing with a permission the
  same function is about to grant, and is why the operator grant stays after
  the readiness wait. `remote` already calls `sudo -v` first, so this adds no
  extra prompt on the normal path.
- Residual risk: the readiness helper's `sudo` calls rely on the timestamp
  established by `sudo -v` in `remote`. A short `timestamp_timeout` could make
  the loop prompt again, and the helper is not safe to call standalone from a
  non-interactive shell. Not fixed: the production path is covered by the
  default 5-minute timestamp, and no unattended caller exists yet.
- `Stopped` joins `NeedsLogin` as exit code 2 because both share the remedy
  `sudo tailscale up`. No fourth code was introduced.
- A second `tailscale status --self` probe remains after the readiness check.
  It is redundant on the normal path but not unreachable, so it was left in
  place rather than removed.