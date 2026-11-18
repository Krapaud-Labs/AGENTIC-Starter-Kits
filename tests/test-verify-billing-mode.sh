#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
scripts=(
  "$root/starter-kit-codex/.codex/scripts/verify-billing-mode.sh"
  "$root/starter-kit-claude/.claude/scripts/verify-billing-mode.sh"
)
sentinel='fixture-only-do-not-log'

if ! cmp -s "${scripts[0]}" "${scripts[1]}"; then
  echo "FAIL: Codex and Claude guards differ" >&2
  exit 1
fi

test_case() {
  local label="$1" expected_status="$2" variable="${3:-}" value="${4:-}" approved="${5:-0}"
  local script output status
  for script in "${scripts[@]}"; do
    local -a args=("AGENTIC_EXTERNAL_BILLING_APPROVED=$approved")
    if [ -n "$variable" ]; then args+=("$variable=$value"); fi
    status=0
    output="$(env -i PATH="${PATH:-/usr/bin:/bin}" "${args[@]}" bash "$script" 2>&1)" || status=$?
    if [ "$status" -ne "$expected_status" ]; then
      echo "FAIL: $label returned status $status, expected $expected_status" >&2
      exit 1
    fi
    if [[ "$output" == *"$sentinel"* ]]; then
      echo "FAIL: $label exposed a fixture value" >&2
      exit 1
    fi
    if [ -n "$variable" ] && [ "$approved" != 1 ] && [ "$expected_status" -ne 0 ] && [[ "$output" != *"$variable"* ]]; then
      echo "FAIL: $label did not identify the variable name" >&2
      exit 1
    fi
  done
  echo "PASS: $label (Codex/Claude)"
}

test_case 'no credential' 0
test_case 'empty exported credential name' 1 'EXAMPLE_API_KEY' ''
test_case 'generic key name' 1 'EXAMPLE_API_KEY' "$sentinel"
test_case 'provider token name' 1 'EXAMPLE_API_TOKEN' "$sentinel"
test_case 'auth token name' 1 'EXAMPLE_AUTH_TOKEN' "$sentinel"
test_case 'access token name' 1 'EXAMPLE_ACCESS_TOKEN' "$sentinel"
test_case 'client secret name' 1 'EXAMPLE_CLIENT_SECRET' "$sentinel"
test_case 'cloud credential name' 1 'GOOGLE_APPLICATION_CREDENTIALS' "$sentinel"
test_case 'session credential name' 1 'AWS_SESSION_TOKEN' "$sentinel"
test_case 'secret key name' 1 'EXAMPLE_SECRET_KEY' "$sentinel"
test_case 'AWS access credential name' 1 'AWS_ACCESS_KEY_ID' "$sentinel"
test_case 'AWS secret credential name' 1 'AWS_SECRET_ACCESS_KEY' "$sentinel"
test_case 'AWS profile name' 1 'AWS_PROFILE' "$sentinel"
test_case 'Azure config name' 1 'AZURE_CONFIG_DIR' "$sentinel"
test_case 'explicit external billing opt-in' 0 'EXAMPLE_API_KEY' "$sentinel" 1
if ! output="$(env -i PATH="${PATH:-/usr/bin:/bin}" AGENTIC_EXTERNAL_BILLING_APPROVED=1 bash "${scripts[0]}" 2>&1)" || [[ "$output" != *'désactivé'* ]]; then
  echo 'FAIL: opt-in message does not describe the disabled guard' >&2
  exit 1
fi
