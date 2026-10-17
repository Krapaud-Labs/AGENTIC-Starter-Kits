#!/usr/bin/env bash
set -euo pipefail

reset_command="${QA_FIXTURE_RESET_COMMAND:-}"
scope="${QA_FIXTURE_SCOPE:-local}"
storage_state="${QA_STORAGE_STATE:-.qa/storage-state.json}"
[ "$scope" = "local" ] || { echo "QA FIXTURE: scope refusé, seule la fixture locale est autorisée" >&2; exit 2; }
[ -n "$reset_command" ] || { echo "QA FIXTURE: définir QA_FIXTURE_RESET_COMMAND pour recréer le compte et le storage-state local" >&2; exit 2; }
case "$reset_command" in
  *production*|*prod.*|*https://*|*http://*) echo "QA FIXTURE: commande potentiellement externe refusée" >&2; exit 2 ;;
esac
echo "QA FIXTURE: régénération locale de la fixture et du compte de test"
bash -lc "$reset_command" >/tmp/qa-fixture-reset.log 2>&1 || {
  echo "QA FIXTURE: la régénération locale a échoué; consulter le résultat du projet sans afficher de secret" >&2
  exit 1
}
[ -s "$storage_state" ] || { echo "QA FIXTURE: QA_STORAGE_STATE absent après régénération" >&2; exit 1; }
echo "QA FIXTURE: storage-state local régénéré"
