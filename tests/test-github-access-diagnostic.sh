#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
fake_bin="$tmp/bin"
mkdir -p "$fake_bin" "$tmp/home"

cat > "$fake_bin/curl" <<'SH'
#!/bin/sh
printf '%s\n' "${FAKE_CURL_OUTPUT:-}"
exit "${FAKE_CURL_EXIT:-0}"
SH
cat > "$fake_bin/gh" <<'SH'
#!/bin/sh
if [ "${1:-}" = "--version" ]; then
  echo 'gh version test'
  exit 0
fi
if [ "${1:-}" = "auth" ] && [ "${2:-}" = "status" ]; then
  exit "${FAKE_GH_AUTH_EXIT:-0}"
fi
exit 0
SH
chmod +x "$fake_bin/curl" "$fake_bin/gh"

assert_case() {
  local script="$1" expected_status="$2" expected_marker="$3" absent_marker="$4"
  local curl_exit="$5" curl_output="$6" gh_auth_exit="$7"
  shift 7
  local output="$tmp/output" actual_status=0

  if env PATH="$fake_bin:/usr/bin:/bin" HOME="$tmp/home" \
    FAKE_CURL_EXIT="$curl_exit" FAKE_CURL_OUTPUT="$curl_output" \
    FAKE_GH_AUTH_EXIT="$gh_auth_exit" \
    /bin/bash "$script" "$@" >"$output" 2>&1; then
    actual_status=0
  else
    actual_status=$?
  fi

  if [ "$actual_status" -ne "$expected_status" ]; then
    cat "$output" >&2
    echo "ECHEC TEST: $script devait sortir $expected_status, a sorti $actual_status" >&2
    return 1
  fi
  if [ -n "$expected_marker" ]; then
    local marker
    while IFS= read -r marker; do
      if ! grep -Fq "$marker" "$output"; then
        cat "$output" >&2
        echo "ECHEC TEST: marqueur absent: $marker" >&2
        return 1
      fi
    done < <(printf '%s' "$expected_marker" | tr '|' '\n')
  fi
  if [ -n "$absent_marker" ] && grep -Fq "$absent_marker" "$output"; then
    cat "$output" >&2
    echo "ECHEC TEST: marqueur trompeur présent: $absent_marker" >&2
    return 1
  fi
  printf 'OK %s: %s (%s)\n' "${script#"$root"/}" "$expected_marker" "$expected_status"
}

for script in \
  "$root/starter-kit-codex/.codex/scripts/verify-github-access.sh" \
  "$root/starter-kit-claude/.claude/scripts/verify-github-access.sh"; do
  # A resolver failure must never be reported as an outage of GitHub itself.
  assert_case "$script" 2 DNS_RESOLUTION_FAILED GITHUB_EXTERNAL_UNAVAILABLE 6 \
    'curl: (6) Could not resolve host: api.github.com' 1
  assert_case "$script" 2 DNS_RESOLUTION_FAILED GITHUB_EXTERNAL_UNAVAILABLE 6 \
    'curl: (6) Could not resolve host: api.github.com' 0 --after-network-enabled-retry

  # A sandbox permission error is explicitly classified as an execution limit.
  assert_case "$script" 2 SANDBOX_LIMITATION GITHUB_EXTERNAL_UNAVAILABLE 7 \
    'curl: (7) Operation not permitted' 0

  # A network error in the default context is inconclusive until retried.
  assert_case "$script" 2 NETWORK_ACCESS_UNVERIFIED GITHUB_EXTERNAL_UNAVAILABLE 28 \
    'curl: (28) Failed to connect after timeout' 0

  # The same non-DNS error after an explicit network-enabled retry can be external.
  assert_case "$script" 1 GITHUB_EXTERNAL_UNAVAILABLE '' 28 \
    'curl: (28) Failed to connect after timeout' 0 --after-network-enabled-retry

  # An authenticated CLI must not be confused with API reachability when curl works.
  assert_case "$script" 0 'GitHub API accessible par curl' GITHUB_EXTERNAL_UNAVAILABLE 0 '' 0

  # A failed gh auth check is reported as unverified, never as an invalid token.
  assert_case "$script" 0 'GH_AUTH_UNVERIFIED|GitHub API accessible par curl' 'gh non authentifié' 0 '' 1
done

echo "Diagnostic accès GitHub: scénarios Codex et Claude validés"
