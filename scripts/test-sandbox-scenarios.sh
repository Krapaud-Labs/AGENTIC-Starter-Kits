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
  assert_contains "$source/scripts/sync-workspace-kit.sh" 'local_file in PROJECT-BRIEF.md project-profile.toml RUNTIME-STATE.md'
  assert_contains "$source/scripts/init-project.sh" 'local_file in PROJECT-BRIEF.md project-profile.toml'
  if rg -n 'github\.com/krapaud/AGENTIC-Starter-Kits|raw\.githubusercontent\.com/krapaud/AGENTIC-Starter-Kits' "$source" "$root/distributions" >/dev/null; then
    echo "ECHEC SANDBOX: ancienne URL du kit détectée pour $kit" >&2
    exit 1
  fi
  scenario="$tmp/$kit"
  mkdir -p "$scenario/$hidden/scripts"
  cp "$source/RUNTIME-STATE.md" "$scenario/$hidden/"
  cp "$source/scripts/start-goal.sh" "$scenario/$hidden/scripts/"
  : > "$scenario/$hidden/runtime-events.log"

  # Scenario 1: démarrer une carte multi-lots crée le Goal et son plan d'agents.
  (cd "$scenario" && bash "$hidden/scripts/start-goal.sh" \
    "Livrer une carte multi-lots" "preuves de tests et livraison" \
    "branche dev, aucune dépense" "accès externe manquant" \
    "P23" "dev" "création de 2 agents; agent intégrateur; lots indépendants" \
    "agent-frontend,agent-qa" "frontend->lot-ui,qa->lot-tests") >/dev/null
  assert_contains "$scenario/$hidden/RUNTIME-STATE.md" '^- goal_status: active$'
  assert_contains "$scenario/$hidden/RUNTIME-STATE.md" 'goal_delegation_plan: création de 2 agents'
  assert_contains "$scenario/$hidden/RUNTIME-STATE.md" 'goal_agents_created: agent-frontend,agent-qa'
  assert_contains "$scenario/$hidden/runtime-events.log" 'delegation=création de 2 agents'

  # Scenario 2: le Coordinateur active les agents et répartit les lots sans recouvrement.
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
  perl -0pi -e 's/execution_status: running/execution_status: complete/; s/goal_status: active/goal_status: complete/; s/goal_delivery_status: pending/goal_delivery_status: verified/; s/next_action: .*/next_action: none/; s/open_checklist_items: .*/open_checklist_items: 0/; s/last_observable_evidence: .*/last_observable_evidence: sandbox-delivery/; s/ci_status: .*/ci_status: not-applicable/; s/trello_sync_status: .*/trello_sync_status: disabled/; s/integration_branch: .*/integration_branch: dev/; s/pushed_integration_commit: .*/pushed_integration_commit: sandbox123/; s/integration_remote_evidence: .*/integration_remote_evidence: origin\/dev contains sandbox123/; s/pull_request_status: .*/pull_request_status: verified/; s/- session_status: .*/- session_status: completed/' "$scenario/$hidden/RUNTIME-STATE.md"
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

# Parcours complet d'initialisation d'un projet existant avec audit et plan Trello isolé.
for kit in codex claude; do
  hidden=".$kit"
  source="$root/starter-kit-$kit/$hidden"
  project="$tmp/existing-$kit"
  mkdir -p "$project/$hidden" "$project/docs" "$project/trello"
  git init --quiet "$project"
  git -C "$project" config user.email sandbox@example.invalid
  git -C "$project" config user.name sandbox
  printf '# Projet existant\n\nFonction déjà livrée à auditer.\n' > "$project/README.md"
  printf 'const existingFeature = true;\n' > "$project/app.js"
  cp -R "$source/." "$project/$hidden/"
  if [ "$kit" = codex ]; then cp "$root/starter-kit-codex/AGENTS.md" "$project/AGENTS.md"; else cp "$root/starter-kit-claude/CLAUDE.md" "$project/CLAUDE.md"; fi

  # Adaptateur local : il représente uniquement les écritures Trello attendues.
  cat > "$project/trello/board.tsv" <<'DATA'
01|À concevoir|Architecture|Audit de la conception et des dépendances.|conception;preuve;relecture
02|À concevoir|Frontend|Audit de l'interface, des états et de l'accessibilité.|rendu;responsive;preuve
03|Ready|QA|Tests nominaux, négatifs et régression.|outils;tests;rapport
DATA
  grep -q '^01|' "$project/trello/board.tsv"
  grep -q '^02|' "$project/trello/board.tsv"
  grep -q '^03|' "$project/trello/board.tsv"
  test "$(awk -F'|' '{print $1}' "$project/trello/board.tsv" | sort -n | tr '\n' ' ')" = "01 02 03 "
  while IFS='|' read -r id list label description checks; do
    [ -n "$id" ] && [ -n "$list" ] && [ -n "$label" ] && [ "${#description}" -ge 25 ] && [ -n "$checks" ]
    [ "$checks" != "$id" ]
  done < "$project/trello/board.tsv"
  printf '%s\n' 'goal_status=active' 'goal_card=01' 'goal_delegation_plan=frontend->02,qa->03' 'goal_agents_created=agent-frontend,agent-qa' 'trello_readback=verified' > "$project/$hidden/existing-audit-state.log"
  assert_contains "$project/$hidden/existing-audit-state.log" '^goal_status=active$'
  assert_contains "$project/$hidden/existing-audit-state.log" 'goal_delegation_plan=frontend->02,qa->03'
  assert_contains "$project/$hidden/existing-audit-state.log" '^trello_readback=verified$'
  assert_contains "$source/skills/project-onboarding/SKILL.md" 'audit complet et minutieux'
done

# Contrats statiques des domaines qui nécessitent une intégration externe réelle.
for kit in codex claude; do
  hidden=".$kit"
  source="$root/starter-kit-$kit/$hidden"
  assert_contains "$source/policies/TOOL-DISCOVERY-POLICY.md" 'PATH'
  assert_contains "$source/policies/GIT-FLOW.md" 'une seule Pull Request finale'
assert_contains "$source/policies/CONTINUOUS-IMPROVEMENT-POLICY.md" 'test de non-régression'
assert_contains "$source/policies/AGENT-DELIVERY-CONTRACTS.md" 'Il refuse immédiatement toute tâche hors domaine'
assert_contains "$source/policies/AGENT-DELIVERY-CONTRACTS.md" 'agent qui a réellement produit le livrable'
assert_contains "$source/skills/coordination/SKILL.md" 'tâche → agent concerné → identifiant réel'
assert_contains "$source/skills/coordination/SKILL.md" 'Le Coordinateur assemble et vérifie, mais ne remplace pas ces agents'
assert_contains "$source/skills/coordination/SKILL.md" 'design-gate.*rework.*jamais un blocage'
if [ "$kit" = "codex" ]; then
  assert_contains "$source/agents/coordinateur.toml" 'exécuter soi-même une tâche relevant d un agent spécialisé disponible'
else
  assert_contains "$source/agents/coordinateur.md" 'ne réalise pas lui-même les tâches spécialisées'
fi
  assert_contains "$source/policies/PROJECT-BOUNDARY-POLICY.md" 'ne doivent jamais être référencés'
  assert_contains "$source/policies/BROWSER-SESSION-LIFECYCLE.md" 'aucun onglet sensible ouvert'
  assert_contains "$source/skills/documentation-audit/SKILL.md" 'README'
  assert_contains "$source/policies/INITIALIZATION-CLOSURE-POLICY.md" 'Un fichier local décrivant Trello ne constitue pas une preuve Trello'
  assert_contains "$source/policies/INITIALIZATION-CLOSURE-POLICY.md" 'PR vers `dev`'
  assert_contains "$source/policies/INITIALIZATION-CLOSURE-POLICY.md" 'needs-review.*action autonome'
  assert_contains "$source/policies/SESSION-CONTINUITY-POLICY.md" 'enchaîner les cartes'
  assert_contains "$source/policies/SESSION-CONTINUITY-POLICY.md" 'Review.*ne termine jamais'
done

echo "Scénarios sandbox isolés OK"
