#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

assert_contains() {
  local file="$1" pattern="$2"
  grep -Eq "$pattern" "$file" || { echo "ECHEC SANDBOX: motif absent dans $file: $pattern" >&2; exit 1; }
}

for kit in codex claude; do
  hidden=".$kit"
  source="$root/starter-kit-$kit/$hidden"
  scenario="$tmp/$kit"
  mkdir -p "$scenario/$hidden/scripts"
  cp "$source/RUNTIME-STATE.md" "$scenario/$hidden/"
  cp "$source/scripts/start-goal.sh" "$scenario/$hidden/scripts/"
  : > "$scenario/$hidden/runtime-events.log"

  # Scenario 1: une carte active crée bien un Goal et conserve la délégation.
  (cd "$scenario" && bash "$hidden/scripts/start-goal.sh" \
    "Livrer une carte multi-lots" "preuves de tests et livraison" \
    "branche dev, aucune dépense" "accès externe manquant" \
    "P23" "dev" "création de 2 agents; agent intégrateur; lots indépendants") >/dev/null
  assert_contains "$scenario/$hidden/RUNTIME-STATE.md" '^- goal_status: active$'
  assert_contains "$scenario/$hidden/RUNTIME-STATE.md" 'goal_delegation_plan: création de 2 agents'
  assert_contains "$scenario/$hidden/RUNTIME-STATE.md" 'goal_agents_created: pending-assessment'
  assert_contains "$scenario/$hidden/runtime-events.log" 'delegation=création de 2 agents'

  # Scenario 2: une réponse ne peut pas être émise pendant l'exécution.
  cp "$source/scripts/guard-before-response.sh" "$scenario/$hidden/scripts/"
  if bash "$scenario/$hidden/scripts/guard-before-response.sh" >/dev/null 2>&1; then
    echo "ECHEC SANDBOX: l'état running a autorisé une réponse pour $kit" >&2
    exit 1
  fi

  # Scenario 3: le kit exige la préparation des labels avant création de carte.
  assert_contains "$source/skills/trello-planning/SKILL.md" 'Avant toute création de carte.*étiquettes obligatoires'
  assert_contains "$source/skills/trello-planning/SKILL.md" 'Ne jamais demander.*confirmation'

  # Scenario 4: le kit couvre l'ordre des cartes et la fermeture navigateur.
  assert_contains "$source/skills/coordination/SKILL.md" 'refuse de démarrer.*03.*02'
  assert_contains "$source/policies/BROWSER-SESSION-LIFECYCLE.md" 'fermeture.*session|fermer.*session'
done

echo "Scénarios sandbox isolés OK"
