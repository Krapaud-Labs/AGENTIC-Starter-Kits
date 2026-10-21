#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
for kit in codex claude; do
  hidden="$root/starter-kit-$kit/.${kit}"
  helper="$hidden/scripts/is-recovery-command.sh"
  bash -n "$helper" "$hidden/hooks/pre-tool-use.sh"
  for command in \
    "bash .$kit/scripts/init-project.sh" \
    "bash .$kit/scripts/session-start-gate.sh" \
    "bash .$kit/scripts/reconcile-runtime.sh" \
    "bash .$kit/scripts/normalize-runtime-state.sh" \
    "bash .$kit/scripts/resolve-user-input.sh request answer" \
    "bash .$kit/scripts/verify-recovery-state.sh"; do
    bash "$helper" Bash "$command"
  done
  if bash "$helper" Bash "git push origin main"; then
    echo "Commande de livraison incorrectement autorisée pour $kit" >&2
    exit 1
  fi
done
echo "Scénarios de récupération sans deadlock Codex/Claude: OK"
