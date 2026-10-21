#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
report_file=""
apply=0
while [ "$#" -gt 0 ]; do
  case "$1" in
    --report) report_file="${2:?rapport manquant}"; shift 2 ;;
    --apply) apply=1; shift ;;
    *) echo "Argument inconnu: $1" >&2; exit 2 ;;
  esac
done
[ -f "$report_file" ] || { echo "CORRECTEUR: rapport introuvable" >&2; exit 2; }
command -v jq >/dev/null 2>&1 || { echo "CORRECTEUR: jq requis" >&2; exit 2; }
summary="$(sed -n '/^Résumé$/,/^Preuve anonymisée$/p' "$report_file" | sed '1d;$d' | tr '\n' ' ' | sed 's/[[:space:]]\+/ /g')"
fingerprint="$(sed -n 's/^KIT_REPORT_FINGERPRINT:\([a-f0-9]*\)$/\1/p' "$report_file" | head -1)"
[ -n "$fingerprint" ] || { echo "CORRECTEUR: empreinte absente" >&2; exit 2; }
playbook="none"
case "$summary" in
  *"Garde agentique normal"*|*"stale user-input"*|*"waiting-for-user"*) playbook="stale-user-input-deadlock" ;;
esac
if [ "$playbook" = none ]; then
  echo "CORRECTEUR: aucun playbook sûr pour $fingerprint"
  bash "$root/scripts/record-kit-report.sh" --fingerprint "$fingerprint" --status normal --note "Correction automatique non applicable; revue requise."
  exit 4
fi
if [ "$apply" -ne 1 ]; then
  echo "CORRECTEUR: playbook=$playbook détecté; relancer avec --apply"
  exit 0
fi
git diff --quiet && git diff --cached --quiet || { echo "CORRECTEUR: worktree non propre" >&2; exit 5; }
branch="chore/auto-fix-kit-report-${fingerprint:0:12}"
git switch -c "$branch"
case "$playbook" in
  stale-user-input-deadlock)
    grep -q 'Aucun input utilisateur en attente' "$root/starter-kit-codex/.codex/hooks/pre-tool-use.sh"
    grep -q 'aucune réponse en attente' "$root/starter-kit-codex/.codex/scripts/resolve-user-input.sh"
    ;;
esac
bash "$root/scripts/test-executable-gates.sh"
bash "$root/scripts/check-documentation-consistency.sh"
git switch -
echo "CORRECTEUR: playbook vérifié; aucune modification supplémentaire nécessaire"
bash "$root/scripts/record-kit-report.sh" --fingerprint "$fingerprint" --status resolved --note "Playbook $playbook vérifié et tests passés."
