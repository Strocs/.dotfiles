#!/usr/bin/env zsh
setopt errexit pipefail

repo_root=${0:A:h:h:h}
tmp_dir=$(mktemp -d)
trap '[[ -n ${tmp_dir:-} ]] && command rm -rf -- "$tmp_dir"' EXIT
fake_bin="$tmp_dir/bin"
mkdir -p "$fake_bin"
export REMOTE_TEST_STATE="$tmp_dir/state"
export REMOTE_TEST_LOG="$tmp_dir/calls.log"
export PATH="$fake_bin:$PATH"
export REMOTE_READY_TIMEOUT=0.12
export REMOTE_READY_INTERVAL=0.01
export REMOTE_SSH_TIMEOUT=0.12
export REMOTE_SSH_INTERVAL=0.01

cat > "$fake_bin/tailscale" <<'FAKE'
#!/usr/bin/env zsh
print -r -- "tailscale $*" >> "$REMOTE_TEST_LOG"
case "$1" in
  debug) print -r -- '"OperatorUser": ""' ;;
  status)
    if [[ "$2" == --json ]]; then
      count=0
      [[ -f "$REMOTE_TEST_STATE.count" ]] && count=$(<"$REMOTE_TEST_STATE.count")
      (( count += 1 ))
      print -r -- "$count" > "$REMOTE_TEST_STATE.count"
      threshold=$(<"$REMOTE_TEST_STATE.threshold")
      state=$(<"$REMOTE_TEST_STATE.backend")
      if (( count > threshold )); then state=$(<"$REMOTE_TEST_STATE.after"); fi
      print -r -- "{\"BackendState\":\"$state\"}"
      return "${REMOTE_TEST_STATUS_JSON_RC:-0}"
    elif [[ "$2" == --self ]]; then
      count=0
      [[ -f "$REMOTE_TEST_STATE.count" ]] && count=$(<"$REMOTE_TEST_STATE.count")
      threshold=$(<"$REMOTE_TEST_STATE.threshold")
      if (( count > threshold )); then state=$(<"$REMOTE_TEST_STATE.after"); else state=$(<"$REMOTE_TEST_STATE.backend"); fi
      [[ "$state" == Running ]] && print -r -- '100.64.0.1 host.example'
      [[ "$state" == Running ]]
    fi
    ;;
  ip) print -r -- '100.64.0.1' ;;
esac
FAKE
cat > "$fake_bin/systemctl" <<'FAKE'
#!/usr/bin/env zsh
print -r -- "systemctl $*" >> "$REMOTE_TEST_LOG"
case "$1" in
  cat) exit 0 ;;
  start) exit 0 ;;
  is-active) print -r -- "${REMOTE_TEST_SERVICE_STATE:-active}" ;;
esac
FAKE
cat > "$fake_bin/collie" <<'FAKE'
#!/usr/bin/env zsh
print -r -- "collie $*" >> "$REMOTE_TEST_LOG"
case "$1" in
  status) print -r -- '127.0.0.1:8787' ;;
  serve|start) exit 0 ;;
  url) print -r -- 'https://example.test' ;;
esac
FAKE
cat > "$fake_bin/curl" <<'FAKE'
#!/usr/bin/env zsh
print -r -- "curl $*" >> "$REMOTE_TEST_LOG"
if [[ ${REMOTE_TEST_CURL_UP:-false} == true ]]; then exit 0; fi
print -u2 -- 'curl: (7) Failed to connect'
exit 7
FAKE
cat > "$fake_bin/sudo" <<'FAKE'
#!/usr/bin/env zsh
print -r -- "sudo $*" >> "$REMOTE_TEST_LOG"
case "$1" in
  -v) exit 0 ;;
  ssh-keygen|systemctl) command "$@" ;;
  tailscale) shift; command tailscale "$@" ;;
esac
FAKE
chmod +x "$fake_bin"/*

export USER=remote-test
export IS_DESKTOP=true
export PLATFORM=""
export IS_WSL=""
source "$repo_root/zsh/.config/.zsh/aliases.zsh"

passes=0
failures=0
reset_fakes() {
  : > "$REMOTE_TEST_LOG"
  print -r -- 0 > "$REMOTE_TEST_STATE.count"
  print -r -- "${1:-Starting}" > "$REMOTE_TEST_STATE.backend"
  print -r -- "${2:-0}" > "$REMOTE_TEST_STATE.threshold"
  print -r -- "${3:-Running}" > "$REMOTE_TEST_STATE.after"
  unset REMOTE_TEST_CURL_UP REMOTE_TEST_STATUS_JSON_RC REMOTE_TEST_SERVICE_STATE
  remote_rc=0
}
check_case() {
  local label=$1 result=$2
  if (( result == 0 )); then
    print -r -- "PASS: $label"
    (( passes += 1 ))
  else
    print -r -- "FAIL: $label"
    (( failures += 1 ))
  fi
}

# Starting must be polled until Running, then remote should continue cleanly.
reset_fakes Starting 3 Running
remote_rc=0
output=$(remote 2>"$tmp_dir/stderr") || remote_rc=$?
if (( remote_rc == 0 )) && [[ "$output" != *"not connected"* ]] && [[ "$output" != *"tailscale up"* ]] && [[ $(<"$REMOTE_TEST_STATE.count") -ge 4 ]] && grep -q '^sudo tailscale status --json$' "$REMOTE_TEST_LOG"; then
  check_case 'Starting polls until Running without false login advice' 0
else
  print -r -- "RED/GREEN evidence (case a): rc=$remote_rc polls=$(<"$REMOTE_TEST_STATE.count") stderr=$(<"$tmp_dir/stderr")"
  check_case 'Starting polls until Running without false login advice' 1
fi

reset_fakes NeedsLogin 0 NeedsLogin
if _remote_wait_tailscale_ready 0.04 0.01 >/dev/null 2>&1; then rc=0; else rc=$?; fi
[[ $rc == 2 ]] && check_case 'NeedsLogin returns 2' 0 || check_case 'NeedsLogin returns 2' 1

reset_fakes Starting 0 Starting
if _remote_wait_tailscale_ready 0.04 0.01 >/dev/null 2>&1; then rc=0; else rc=$?; fi
[[ $rc == 1 ]] && check_case 'never-ready state times out with 1' 0 || check_case 'never-ready state times out with 1' 1

reset_fakes Running 0 Running
# The fake debug prefs response is empty-operator; verify grant precedes non-root queries.
remote >/dev/null 2>"$tmp_dir/stderr" || true
operator_line=$(grep -n 'sudo tailscale set --operator=' "$REMOTE_TEST_LOG" | head -n 1 | cut -d: -f1)
status_line=$(grep -n '^tailscale status --self$' "$REMOTE_TEST_LOG" | head -n 1 | cut -d: -f1)
ip_line=$(grep -n '^tailscale ip -4$' "$REMOTE_TEST_LOG" | head -n 1 | cut -d: -f1)
if [[ -n $operator_line && -n $status_line && -n $ip_line ]] && (( operator_line < status_line && operator_line < ip_line )); then
  check_case 'operator grant precedes non-root status and ip calls' 0
else
  check_case 'operator grant precedes non-root status and ip calls' 1
fi

reset_fakes Running 0 Running
REMOTE_TEST_CURL_UP=false
remote_output=$(remote 2>"$tmp_dir/stderr") || true
if [[ $(<"$tmp_dir/stderr") != *'curl: (7)'* ]] && [[ $(grep -c '^collie start$' "$REMOTE_TEST_LOG") -eq 1 ]]; then
  check_case 'curl failure is silent and reports Collie not up via start' 0
else
  check_case 'curl failure is silent and reports Collie not up via start' 1
fi

reset_fakes Running 0 Running
export REMOTE_TEST_CURL_UP=true
remote >/dev/null 2>"$tmp_dir/stderr" || true
if [[ $(grep -c '^collie serve$' "$REMOTE_TEST_LOG" || true) -eq 1 ]] && [[ $(grep -c '^collie start$' "$REMOTE_TEST_LOG" || true) -eq 0 ]]; then
  check_case 'successful curl probe selects Collie serve' 0
else
  check_case 'successful curl probe selects Collie serve' 1
fi

reset_fakes Starting 0 Running
export REMOTE_TEST_STATUS_JSON_RC=7
if _remote_wait_tailscale_ready 0.04 0.01 >/dev/null 2>&1; then rc=0; else rc=$?; fi
[[ $rc == 0 ]] && check_case 'non-zero status exit still resolves Running' 0 || check_case 'non-zero status exit still resolves Running' 1

reset_fakes Running 0 Running
export REMOTE_TEST_STATUS_JSON_RC=7
if (setopt pipefail; _remote_wait_tailscale_ready 0.04 0.01); then rc=0; else rc=$?; fi
[[ $rc == 0 ]] && check_case 'pipefail does not discard parsed Running state' 0 || check_case 'pipefail does not discard parsed Running state' 1

reset_fakes Stopped 0 Stopped
if _remote_wait_tailscale_ready 0.04 0.01 >/dev/null 2>&1; then rc=0; else rc=$?; fi
[[ $rc == 2 ]] && check_case 'Stopped returns 2' 0 || check_case 'Stopped returns 2' 1
remote_rc=0
remote_stderr=$(remote >/dev/null 2>"$tmp_dir/stderr") || remote_rc=$?
if (( remote_rc != 0 )) && [[ $(<"$tmp_dir/stderr") == *"sudo tailscale up"* ]]; then
  check_case 'Stopped remote advice names sudo tailscale up' 0
else
  check_case 'Stopped remote advice names sudo tailscale up' 1
fi

reset_fakes Running 0 Running
export REMOTE_TEST_SERVICE_STATE=inactive
if _remote_wait_service_active ssh 0.04 0.01 >/dev/null 2>&1; then rc=0; else rc=$?; fi
[[ $rc == 1 ]] && check_case 'service wait times out with 1 when inactive' 0 || check_case 'service wait times out with 1 when inactive' 1
remote_rc=0
remote >/dev/null 2>"$tmp_dir/stderr" || remote_rc=$?
if (( remote_rc != 0 )) && [[ $(<"$tmp_dir/stderr") == *'did not become active in time'* ]]; then
  check_case 'remote aborts when SSH service stays inactive' 0
else
  check_case 'remote aborts when SSH service stays inactive' 1
fi

print -r -- "Summary: $passes passed, $failures failed"
(( failures == 0 ))
