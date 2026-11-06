#!/usr/bin/env bash
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
script="$root/scripts/validate-card-gitflow.sh"
test -x "$script" || { echo "ECHEC: garde GitFlow absente ou non executable" >&2; exit 1; }
for kit_script in "$root/starter-kit-codex/.codex/scripts/validate-card-gitflow.sh" "$root/starter-kit-claude/.claude/scripts/validate-card-gitflow.sh"; do
  test -s "$kit_script" || { echo "ECHEC: garde GitFlow absente du kit" >&2; exit 1; }
  bash "$kit_script" in-progress 0 dev feat/630-gitflow origin/dev >/dev/null
done
bash "$script" in-progress 0 dev feat/card-630 origin/dev >/dev/null
bash "$script" complete 1 dev feat/card-630 origin/dev >/dev/null
if bash "$script" complete 2 dev feat/card-630 origin/dev >/dev/null 2>&1; then exit 1; fi
if bash "$script" complete 0 main feat/card-630 origin/main >/dev/null 2>&1; then exit 1; fi
if bash "$script" complete 0 dev dev origin/dev >/dev/null 2>&1; then exit 1; fi
if bash "$script" complete 0 dev feat/card-630 origin/main >/dev/null 2>&1; then exit 1; fi
if bash "$script" in-progress 0 staging feat/card-630 origin/staging >/dev/null 2>&1; then exit 1; fi
echo "GITFLOW-PR-EFFICIENCY: OK"
