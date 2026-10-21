#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
for kit in codex claude; do
  hidden="$root/starter-kit-$kit/.${kit}"
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/.${kit}/scripts"
  cp "$hidden/scripts/reconcile-runtime.sh" "$hidden/scripts/validate-runtime-schema.sh" "$tmp/.${kit}/scripts/"
  chmod +x "$tmp/.${kit}/scripts/"*.sh
  git -C "$tmp" init -q
  cat > "$tmp/.${kit}/RUNTIME-STATE.md" <<'EOF'
- execution_status: blocked
- session_status: blocked
- goal_status: blocked
- native_goal_status: blocked
- native_goal_id: goal-test
- native_goal_evidence: native-blocked
- native_goal_blocked_condition: local action remains available
- current_action: recovery
- next_action: execute-local-recovery
- last_observable_evidence: initial
- goal_budget: 10
EOF
  (cd "$tmp" && bash ".${kit}/scripts/reconcile-runtime.sh") >/dev/null
  grep -q '^- execution_status: needs-review$' "$tmp/.${kit}/RUNTIME-STATE.md"
  grep -q '^- session_status: active$' "$tmp/.${kit}/RUNTIME-STATE.md"
  grep -q 'native-goal-blocked-local-recovery-available' "$tmp/.${kit}/RUNTIME-STATE.md"
  sed -i.bak 's/local action remains available/externe inaccessible/' "$tmp/.${kit}/RUNTIME-STATE.md"
  (cd "$tmp" && bash ".${kit}/scripts/reconcile-runtime.sh") >/dev/null
  grep -q '^- execution_status: blocked$' "$tmp/.${kit}/RUNTIME-STATE.md"
  rm -rf "$tmp"
done
echo "Reprise Goal natif avec fallback local Codex/Claude: OK"
