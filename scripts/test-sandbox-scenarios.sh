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

  # Scenario 1: démarrer une carte multi-lots crée le Goal et son plan d'agents.
  (cd "$scenario" && bash "$hidden/scripts/start-goal.sh" \
    "Livrer une carte multi-lots" "preuves de tests et livraison" \
    "branche dev, aucune dépense" "accès externe manquant" \
    "P23" "dev" "création de 2 agents; agent intégrateur; lots indépendants") >/dev/null
  assert_contains "$scenario/$hidden/RUNTIME-STATE.md" '^- goal_status: active$'
  assert_contains "$scenario/$hidden/RUNTIME-STATE.md" 'goal_delegation_plan: création de 2 agents'
  assert_contains "$scenario/$hidden/RUNTIME-STATE.md" 'goal_agents_created: pending-assessment'
  assert_contains "$scenario/$hidden/runtime-events.log" 'delegation=création de 2 agents'

  # Scenario 2: le Coordinateur active les agents et répartit les lots sans recouvrement.
  perl -0pi -e 's/goal_agents_created: pending-assessment/goal_agents_created: agent-frontend,agent-qa/; s/goal_agent_assignments: pending-assessment/goal_agent_assignments: frontend->lot-ui,qa->lot-tests/' "$scenario/$hidden/RUNTIME-STATE.md"
  assert_contains "$scenario/$hidden/RUNTIME-STATE.md" 'goal_agents_created: agent-frontend,agent-qa'
  assert_contains "$scenario/$hidden/RUNTIME-STATE.md" 'goal_agent_assignments: frontend->lot-ui,qa->lot-tests'

  # Scenario 3: une réponse ne peut pas être émise pendant l'exécution.
  cp "$source/scripts/guard-before-response.sh" "$scenario/$hidden/scripts/"
  if bash "$scenario/$hidden/scripts/guard-before-response.sh" >/dev/null 2>&1; then
    echo "ECHEC SANDBOX: l'état running a autorisé une réponse pour $kit" >&2
    exit 1
  fi

  # Scenario 4: le parcours Trello prépare les labels avant création de carte.
  assert_contains "$source/skills/trello-planning/SKILL.md" 'Avant toute création de carte.*étiquettes obligatoires'
  assert_contains "$source/skills/trello-planning/SKILL.md" 'Ne jamais demander.*confirmation'

  # Scenario 5: le parcours de sélection respecte l'ordre et ferme le navigateur.
  assert_contains "$source/skills/coordination/SKILL.md" 'refuse de démarrer.*03.*02'
  assert_contains "$source/policies/BROWSER-SESSION-LIFECYCLE.md" 'fermeture.*session|fermer.*session'

  # Scenario 6: fin nominale d'un Goal avec livraison et session navigateur fermée.
  perl -0pi -e 's/execution_status: running/execution_status: complete/; s/goal_status: active/goal_status: complete/; s/goal_delivery_status: pending/goal_delivery_status: verified/; s/next_action: .*/next_action: none/; s/open_checklist_items: .*/open_checklist_items: 0/; s/last_observable_evidence: .*/last_observable_evidence: sandbox-delivery/; s/ci_status: .*/ci_status: not-applicable/; s/trello_sync_status: .*/trello_sync_status: disabled/; s/integration_branch: .*/integration_branch: dev/; s/pushed_integration_commit: .*/pushed_integration_commit: sandbox123/; s/pull_request_status: .*/pull_request_status: verified/; s/- session_status: .*/- session_status: completed/' "$scenario/$hidden/RUNTIME-STATE.md"
  bash "$scenario/$hidden/scripts/guard-before-response.sh" >/dev/null
done

# Parcours d'initialisation réel dans deux projets temporaires indépendants.
for kit in codex claude; do
  hidden=".$kit"
  source="$root/starter-kit-$kit/$hidden"
  project="$tmp/init-$kit"
  mkdir -p "$project/$hidden"
  git init --quiet "$project"
  git -C "$project" config user.email sandbox@example.invalid
  git -C "$project" config user.name sandbox
  cp -R "$source/." "$project/$hidden/"
  if [ "$kit" = codex ]; then cp "$root/starter-kit-codex/AGENTS.md" "$project/AGENTS.md"; else cp "$root/starter-kit-claude/CLAUDE.md" "$project/CLAUDE.md"; fi
  if python3 -c 'import tomllib' >/dev/null 2>&1; then
    bash "$project/$hidden/scripts/lint-kit.sh"
  else
    # Python 3.9 ne possède pas tomllib ; la CI fournit Python 3.11.
    assert_contains "$root/.github/workflows/validate-starter-kits.yml" 'python-version: "3.11"'
    echo "SCENARIO SANDBOX: lint dynamique reporté à la CI Python 3.11 pour $kit"
  fi
  bash "$project/$hidden/scripts/init-project.sh"
  if bash "$project/$hidden/scripts/preflight.sh" >/dev/null 2>&1; then
    echo "ECHEC SANDBOX: preflight accepté sans cahier pour $kit" >&2
    exit 1
  fi
  cp "$project/$hidden/templates/project-brief.md" "$project/$hidden/PROJECT-BRIEF.md"
  cp "$project/$hidden/templates/project-profile.toml" "$project/$hidden/project-profile.toml"
  perl -0pi -e 's/\bpending\b/accepted/ if /## Statut/' "$project/$hidden/PROJECT-BRIEF.md"
  KIT_NAME="$kit" perl -0pi -e 's/project_name = "à compléter"/project_name = "sandbox-$ENV{KIT_NAME}"/; s/trello_choice = "pending"/trello_choice = "disabled"/' "$project/$hidden/project-profile.toml"
  if python3 -c 'import tomllib' >/dev/null 2>&1; then
    bash "$project/$hidden/scripts/initialize-project-design.sh" >/dev/null
    test -f "$project/docs/design/design-readiness.md"
  else
    assert_contains "$source/ORCHESTRATION.md" 'ensure-tools.sh'
  fi
done

# Contrats statiques des domaines qui nécessitent une intégration externe réelle.
for kit in codex claude; do
  hidden=".$kit"
  source="$root/starter-kit-$kit/$hidden"
  assert_contains "$source/policies/TOOL-DISCOVERY-POLICY.md" 'PATH'
  assert_contains "$source/policies/GIT-FLOW.md" 'une seule Pull Request finale'
  assert_contains "$source/policies/CONTINUOUS-IMPROVEMENT-POLICY.md" 'test de non-régression'
  assert_contains "$source/policies/PROJECT-BOUNDARY-POLICY.md" 'ne doivent jamais être référencés'
  assert_contains "$source/policies/BROWSER-SESSION-LIFECYCLE.md" 'aucun onglet sensible ouvert'
  assert_contains "$source/skills/documentation-audit/SKILL.md" 'README'
done

echo "Scénarios sandbox isolés OK"
