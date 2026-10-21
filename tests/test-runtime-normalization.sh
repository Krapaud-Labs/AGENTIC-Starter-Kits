#!/usr/bin/env bash
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
for kit in codex claude; do
  hidden="$root/starter-kit-$kit/.$kit"
  tmp="$(mktemp -d)"
  cat > "$tmp/RUNTIME-STATE.md" <<'EOF'
- execution_status: blocked
- goal_status: blocked
- current_action: old
- next_action: old
- last_observable_evidence: old
- goal_budget: 100
- current_action: new
- next_action: resume
- last_observable_evidence: verified
EOF
  bash "$hidden/scripts/normalize-runtime-state.sh" "$tmp/RUNTIME-STATE.md" >/dev/null
  bash "$hidden/scripts/validate-runtime-schema.sh" "$tmp/RUNTIME-STATE.md" >/dev/null
  test "$(grep -c '^- current_action:' "$tmp/RUNTIME-STATE.md")" -eq 1
  test "$(grep -c '^- next_action:' "$tmp/RUNTIME-STATE.md")" -eq 1
  grep -q '^- next_action: resume$' "$tmp/RUNTIME-STATE.md"
  before="$(shasum -a 256 "$tmp/RUNTIME-STATE.md")"
  bash "$hidden/scripts/normalize-runtime-state.sh" "$tmp/RUNTIME-STATE.md" >/dev/null
  after="$(shasum -a 256 "$tmp/RUNTIME-STATE.md")"
  test "$before" = "$after"
  rm -rf "$tmp"
done
echo "Normalisation runtime Codex/Claude: OK"
