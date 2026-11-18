#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
root="$(git -C "$PWD" rev-parse --show-toplevel 2>/dev/null || pwd)"
scope="${QA_FIXTURE_SCOPE:-local}"
storage_state="${QA_STORAGE_STATE:-.qa/storage-state.json}"
[ "$scope" = "local" ] || { echo "QA FIXTURE: scope refusé, seule la fixture locale est autorisée" >&2; exit 2; }
qa_dir="$root/.qa"
reset_script="$qa_dir/fixture-reset.sh"
[ ! -L "$qa_dir" ] && [ ! -L "$reset_script" ] && [ -f "$reset_script" ] || {
  echo "QA FIXTURE: script local requis dans .qa/fixture-reset.sh; les commandes shell fournies par variable sont refusées" >&2
  exit 2
}
resolved_state="$(python3 - "$root" "$storage_state" <<'PY'
from pathlib import Path
import sys
root, candidate = map(Path, sys.argv[1:])
path = candidate if candidate.is_absolute() else root / candidate
try:
    resolved = path.resolve(strict=False)
    qa = (root / ".qa").resolve(strict=True)
except OSError:
    raise SystemExit(1)
if qa not in resolved.parents or resolved == qa:
    raise SystemExit(1)
print(resolved)
PY
)" || { echo "QA FIXTURE: QA_STORAGE_STATE doit rester dans .qa/" >&2; exit 2; }
storage_state="$resolved_state"
echo "QA FIXTURE: régénération locale de la fixture et du compte de test"
QA_FIXTURE_SCOPE=local QA_STORAGE_STATE="$storage_state" bash --noprofile --norc "$reset_script" >/tmp/qa-fixture-reset.log 2>&1 || {
  echo "QA FIXTURE: la régénération locale a échoué; consulter le résultat du projet sans afficher de secret" >&2
  exit 1
}
[ ! -L "$storage_state" ] && [ -s "$storage_state" ] || { echo "QA FIXTURE: QA_STORAGE_STATE absent, vide ou lien symbolique après régénération" >&2; exit 1; }
echo "QA FIXTURE: storage-state local régénéré"
