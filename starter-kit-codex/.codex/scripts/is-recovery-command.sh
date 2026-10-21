#!/usr/bin/env bash
set -euo pipefail

[ "${1:-}" = "Bash" ] || exit 1
command_text="${2:-}"
case "$command_text" in
  bash\ .codex/scripts/init-project.sh*) exit 0 ;;
  bash\ .codex/scripts/session-start-gate.sh*) exit 0 ;;
  bash\ .codex/scripts/reconcile-runtime.sh*) exit 0 ;;
  bash\ .codex/scripts/normalize-runtime-state.sh*) exit 0 ;;
  bash\ .codex/scripts/resolve-user-input.sh\ *) exit 0 ;;
  bash\ .codex/scripts/verify-recovery-state.sh*) exit 0 ;;
  *) exit 1 ;;
esac
