#!/usr/bin/env bash
set -euo pipefail
config="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
project_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [ -n "$project_root" ] && [ -d "$project_root/.claude" ]; then
  state="$project_root/.claude/RUNTIME-STATE.md"
else
  state="$config/RUNTIME-STATE.md"
fi
[ -f "$state" ] || { echo "RECONCILIATION: RUNTIME-STATE.md absent" >&2; exit 1; }
native="$(sed -n 's/^- native_goal_status: //p' "$state" | head -1)"
case "$native" in
  active) execution=running; session=active; goal=active; evidence="native-goal-active-runtime-reconciled" ;;
  blocked) execution=blocked; session=blocked; goal=blocked; evidence="native-goal-blocked-runtime-reconciled" ;;
  paused) execution=paused; session=paused; goal=paused; evidence="native-goal-paused-runtime-reconciled" ;;
  unavailable) execution=needs-review; session=active; goal=active; evidence="native-goal-unavailable-runtime-reconciled" ;;
  *) echo "RECONCILIATION: statut natif inconnu ou requis: $native" >&2; exit 4 ;;
esac
now="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
tmp="$state.reconcile.$$"
sed -e "s/^- execution_status: .*/- execution_status: $execution/" -e "s/^- session_status: .*/- session_status: $session/" -e "s/^- goal_status: .*/- goal_status: $goal/" -e "s/^- last_observable_evidence: .*/- last_observable_evidence: $now | $evidence/" "$state" > "$tmp"
mv "$tmp" "$state"
printf 'RUNTIME RECONCILIÉ: native_goal_status=%s execution_status=%s goal_status=%s\n' "$native" "$execution" "$goal"
