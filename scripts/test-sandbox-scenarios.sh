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
  test -f "$source/SPECIALIST-CONTRACTS.toml"
  test -x "$source/scripts/reconcile-runtime.sh"
  test -x "$source/hooks/pre-tool-use.sh"
  contract_count="$(grep -c '^\[[^]]\+\]$' "$source/SPECIALIST-CONTRACTS.toml")"
  agent_count="$(find "$source/agents" -maxdepth 1 -type f | wc -l | tr -d ' ')"
  [ "$contract_count" -eq "$agent_count" ] || { echo "ECHEC SANDBOX: contrats spécialistes incomplets pour $kit" >&2; exit 1; }
  for field in domain activation deliverable reviewer; do
    count="$(grep -c "^$field = " "$source/SPECIALIST-CONTRACTS.toml")"
    [ "$count" -eq "$contract_count" ] || { echo "ECHEC SANDBOX: champ $field incomplet pour $kit" >&2; exit 1; }
  done
  assert_contains "$source/scripts/verify-specialist-plan.sh" 'identifiant réel au format role@id'
  assert_contains "$source/scripts/start-goal.sh" 'GOAL_REQUIRED_ROLES'
  assert_contains "$source/scripts/start-goal.sh" 'GOAL_SPECIALIST_AVAILABILITY'
  # Un point d'entrée périmé doit être rejeté sans que le validateur ne le réécrive.
  entry_fixture="$tmp/entrypoint-$kit"
  mkdir -p "$entry_fixture/$hidden/scripts"
  cp "$source/scripts/validate-entrypoint.sh" "$entry_fixture/$hidden/scripts/"
  cp "$source/KIT.toml" "$entry_fixture/$hidden/"
  entry_name="$([ "$kit" = codex ] && echo AGENTS.md || echo CLAUDE.md)"
  entry_file="$entry_fixture/$entry_name"
  printf '%s\n' '<!-- ENTRYPOINT-CONTRACT: stale -->' > "$entry_file"
  entry_before="$(shasum -a 256 "$entry_file" | cut -d' ' -f1)"
  if (cd "$entry_fixture" && bash "$hidden/scripts/validate-entrypoint.sh") >/dev/null 2>&1; then
    echo "ECHEC SANDBOX: version périmée acceptée par le validateur $kit" >&2
    exit 1
  fi
  entry_after="$(shasum -a 256 "$entry_file" | cut -d' ' -f1)"
  [ "$entry_before" = "$entry_after" ] || {
    echo "ECHEC SANDBOX: le validateur $kit a modifié $entry_name" >&2
    exit 1
  }
  assert_contains "$source/scripts/validate-documentation.sh" 'non applicable dans le kit'
  assert_contains "$source/scripts/validate-session-state.sh" 'git rev-parse --show-toplevel'
  assert_contains "$source/scripts/guard-before-response.sh" 'git rev-parse --show-toplevel'
  assert_contains "$source/scripts/validate-entrypoint.sh" 'git rev-parse --show-toplevel'
assert_contains "$source/scripts/resolve-user-input.sh" 'process-user-response'
assert_contains "$source/hooks/pre-tool-use.sh" 'resolve-user-input\\.sh'
assert_contains "$source/scripts/guard-before-response.sh" 'demande utilisateur encore en attente'
  assert_contains "$source/scripts/session-start-gate.sh" 'ENTRYPOINT-CONTRACT:'
  assert_contains "$source/hooks/session-start.sh" 'check-kit-reports.sh'
  test -x "$source/scripts/check-kit-reports.sh"
  test -x "$source/scripts/flush-kit-report-outbox.sh"
  assert_contains "$root/scripts/check-kit-reports.sh" 'kit-report-history.jsonl'
  assert_contains "$root/scripts/record-kit-report.sh" 'duplicate'
  assert_contains "$source/scripts/guard-before-response.sh" 'report-kit-blocker.sh'
  assert_contains "$source/scripts/init-project.sh" '.kit-reports/'
  assert_contains "$source/scripts/sync-workspace-kit.sh" 'Manifest .workspace.toml initialisé'
  assert_contains "$source/ORCHESTRATION.md" 'CONTEXT-EFFICIENCY-POLICY.md'
  assert_contains "$source/ORCHESTRATION.md" 'GOAL-RETRY-AGENT-METRICS.md'
  assert_contains "$source/scripts/session-start-gate.sh" 'verification_mode'
  assert_contains "$source/scripts/session-start-gate.sh" 'manifest_sha256'
  assert_contains "$source/scripts/session-start-gate.sh" 'kit_sha256'
  test -x "$source/scripts/validate-goal-budget.sh"
  "$source/scripts/validate-goal-budget.sh" >/dev/null
  if GOAL_MAX_STEPS=41 "$source/scripts/validate-goal-budget.sh" >/dev/null 2>&1; then
    echo "ECHEC SANDBOX: budget Goal hors limite accepté pour $kit" >&2
    exit 1
  fi
  test -x "$source/scripts/guard-agent-loop.sh"
  "$source/scripts/guard-agent-loop.sh" real-agent 2 repeated-blocker >/dev/null
  if "$source/scripts/guard-agent-loop.sh" real-agent 3 repeated-blocker >/dev/null 2>&1; then
    echo "ECHEC SANDBOX: boucle d agent non arrêtée pour $kit" >&2
    exit 1
  fi
  test -x "$source/scripts/prepare-context-manifest.sh"
  if [ "$kit" = codex ]; then
    assert_contains "$root/starter-kit-codex/AGENTS.md" 'Ne jamais utiliser de tiret cadratin.'
  else
    assert_contains "$root/starter-kit-claude/CLAUDE.md" 'Ne jamais utiliser de tiret cadratin.'
  fi
  test -x "$source/scripts/report-kit-blocker.sh"
  assert_contains "$source/scripts/report-kit-blocker.sh" 'if root='
  report_project="$tmp/report-$kit"
  mkdir -p "$report_project/$hidden"
  cp -R "$source/." "$report_project/$hidden/"
  (cd "$report_project" && KIT_REPORT_DRY_RUN=1 bash "$hidden/scripts/report-kit-blocker.sh" --severity bloquant --summary 'test report' --details '/Users/test token=secret') >/dev/null
  report_file="$(find "$report_project/.kit-reports/outbox" -type f -name '*.md' -print -quit)"
  test -n "$report_file"
  ! grep -Eq '/Users/test|token=secret' "$report_file"
  assert_contains "$source/hooks/pre-tool-use.sh" 'reconcile-runtime.sh'
  assert_contains "$source/scripts/verify-before-push.sh" 'diff --cached --name-only'
  assert_contains "$source/scripts/verify-before-push.sh" 'créer immédiatement une branche dédiée'
  assert_contains "$source/scripts/verify-before-push.sh" 'ouvrir la PR vers dev ou develop'
  assert_contains "$source/scripts/verify-before-push.sh" 'Dépôt source du kit détecté'
  assert_contains "$source/scripts/verify-before-push.sh" 'Validation avant push du dépôt source du kit OK'
  assert_contains "$source/policies/TASK-ROUTING-POLICY.md" 'frontend@id,qa@id,auditeur@id'
  delegation="$tmp/delegation-$kit"
  mkdir -p "$delegation/$hidden/reports/agents"
  for role in frontend qa auditeur; do printf 'thread=real-%s\nscope=sandbox-%s\ndeliverable=%s-report\nevidence=%s-proof\n' "$role" "$role" "$role" "$role" > "$delegation/$role.assignment"; done
  if bash "$source/scripts/verify-specialist-plan.sh" visual 'frontend,qa,auditeur' "$delegation" >/dev/null 2>&1; then
    echo "ECHEC SANDBOX: délégation sans identifiants acceptée pour $kit" >&2
    exit 1
  fi
  bash "$source/scripts/verify-specialist-plan.sh" visual 'frontend@real-f,qa@real-q,auditeur@real-a' "$delegation" >/dev/null
  printf 'thread=real-q\nscope=sandbox-frontend\ndeliverable=qa-report\nevidence=qa-proof\n' > "$delegation/qa.assignment"
  if bash "$source/scripts/verify-specialist-plan.sh" visual 'frontend@real-f,qa@real-q,auditeur@real-a' "$delegation" >/dev/null 2>&1; then
    echo "ECHEC SANDBOX: chevauchement d agents accepté pour $kit" >&2
    exit 1
  fi
  printf 'thread=real-q\nscope=sandbox-qa\ndeliverable=qa-report\nevidence=qa-proof\n' > "$delegation/qa.assignment"
  printf 'agent_role: frontend\nagent_id: real-f\nstatus: accepted\nscope: sandbox-frontend\nevidence: frontend-proof\nnext_action: integrate\n' > "$delegation/frontend.report"
  (cd "$delegation" && bash "$source/scripts/verify-agent-report.sh" frontend real-f "$delegation/frontend.report") >/dev/null
  if (cd "$delegation" && sed 's/^evidence:.*/evidence:/' "$delegation/frontend.report" | bash "$source/scripts/verify-agent-report.sh" frontend real-f /dev/stdin) >/dev/null 2>&1; then
    echo "ECHEC SANDBOX: rapport incomplet accepté pour $kit" >&2
    exit 1
  fi
  # Un événement générique ou une référence de Goal orpheline ne doit pas
  # être traité comme un spécialiste sans rapport et boucler indéfiniment.
  hook_sandbox="$tmp/hook-$kit"
  mkdir -p "$hook_sandbox/$hidden/hooks" "$hook_sandbox/$hidden/reports/agents"
  git init -q "$hook_sandbox"
  cp "$source/hooks/hook-runtime.sh" "$hook_sandbox/$hidden/hooks/"
  cp "$source/hooks/subagent-stop.sh" "$hook_sandbox/$hidden/hooks/"
  : > "$hook_sandbox/$hidden/runtime-events.log"
  generic_event="$(printf '{\"agent_id\":\"orphan-goal-id\"}' | (cd "$hook_sandbox" && bash "$hidden/hooks/subagent-stop.sh"))"
  printf '%s' "$generic_event" | grep -q 'Aucun rapport spécialiste attendu' || {
    echo "ECHEC SANDBOX: événement générique bloqué pour $kit" >&2
    exit 1
  }
  specialist_event="$(printf '{\"agent_id\":\"real-f\",\"agent_role\":\"frontend\"}' | (cd "$hook_sandbox" && bash "$hidden/hooks/subagent-stop.sh"))"
  printf '%s' "$specialist_event" | grep -q 'arrêté' || {
    echo "ECHEC SANDBOX: arrêt spécialiste sans rapport non récupérable pour $kit" >&2
    exit 1
  }
  printf '%s' "$specialist_event" | grep -q 'relance automatique' || {
    echo "ECHEC SANDBOX: absence de garde anti-relance pour $kit" >&2
    exit 1
  }
  assert_contains "$source/scripts/sync-workspace-kit.sh" 'local_file in PROJECT-BRIEF.md project-profile.toml RUNTIME-STATE.md'
  assert_contains "$source/scripts/init-project.sh" 'local_file in PROJECT-BRIEF.md project-profile.toml'
  assert_contains "$source/scripts/init-project.sh" 'update-workspace-kit.yml'
  test -f "$source/templates/github/workflows/update-workspace-kit.yml"
  assert_contains "$source/scripts/start-goal.sh" 'lots parallèles détectés sans au moins deux agents'
  assert_contains "$source/ORCHESTRATION.md" 'crée ou active d.abord le Goal natif'
  assert_contains "$source/ORCHESTRATION.md" 'start-goal.sh.*n.est jamais une création de Goal natif'
  assert_contains "$source/policies/SESSION-CONTINUITY-POLICY.md" 'Garde native-first'
  assert_contains "$source/policies/SESSION-CONTINUITY-POLICY.md" 'avant la première lecture'
  assert_contains "$source/policies/SESSION-CONTINUITY-POLICY.md" 'native_goal_status=unavailable'
  if rg -n 'github\.com/krapaud/AGENTIC-Starter-Kits|raw\.githubusercontent\.com/krapaud/AGENTIC-Starter-Kits' "$source" "$root/distributions" >/dev/null; then
    echo "ECHEC SANDBOX: ancienne URL du kit détectée pour $kit" >&2
    exit 1
  fi
  scenario="$tmp/$kit"
  mkdir -p "$scenario/$hidden/scripts" "$scenario/agent-evidence"
  cp "$source/RUNTIME-STATE.md" "$scenario/$hidden/"
  cp "$source/scripts/start-goal.sh" "$scenario/$hidden/scripts/"
  cp "$source/scripts/verify-specialist-plan.sh" "$scenario/$hidden/scripts/"
  printf 'scope=lot-ui\ndeliverable=frontend report\nevidence=ui evidence\n' > "$scenario/agent-evidence/frontend.assignment"
  printf 'scope=lot-tests\ndeliverable=qa report\nevidence=test evidence\n' > "$scenario/agent-evidence/qa.assignment"
  : > "$scenario/$hidden/runtime-events.log"

  # Scenario 1: démarrer une carte multi-lots crée le Goal et son plan d'agents.
  (cd "$scenario" && NATIVE_GOAL_STATUS=unavailable NATIVE_GOAL_EVIDENCE='sandbox API native non exposée' GOAL_AGENT_EVIDENCE="$scenario/agent-evidence" GOAL_REQUIRED_ROLES='frontend,qa' bash "$hidden/scripts/start-goal.sh" \
    "Livrer une carte multi-lots" "preuves de tests et livraison" \
    "branche dev, aucune dépense" "accès externe manquant" \
    "P23" "dev" "création de 2 agents; agent intégrateur; lots indépendants" \
    "frontend@agent-frontend,qa@agent-qa" "frontend->lot-ui,qa->lot-tests") >/dev/null
  assert_contains "$scenario/$hidden/RUNTIME-STATE.md" '^- goal_status: active$'
  assert_contains "$scenario/$hidden/RUNTIME-STATE.md" 'goal_delegation_plan: création de 2 agents'
  assert_contains "$scenario/$hidden/RUNTIME-STATE.md" 'goal_agents_created: frontend@agent-frontend,qa@agent-qa'
  assert_contains "$scenario/$hidden/runtime-events.log" 'delegation=création de 2 agents'

  # Scenario 2: le Coordinateur active les agents et répartit les lots sans recouvrement.
  assert_contains "$scenario/$hidden/RUNTIME-STATE.md" 'goal_agents_created: frontend@agent-frontend,qa@agent-qa'
  assert_contains "$scenario/$hidden/RUNTIME-STATE.md" 'goal_agent_assignments: frontend->lot-ui,qa->lot-tests'

  # Scenario 3: une réponse ne peut pas être émise pendant l'exécution.
  cp "$source/scripts/guard-before-response.sh" "$scenario/$hidden/scripts/"
  cp "$source/scripts/guard-repeated-blocker.sh" "$scenario/$hidden/scripts/"
  if (cd "$scenario" && bash "$scenario/$hidden/scripts/guard-before-response.sh") >/dev/null 2>&1; then
    echo "ECHEC SANDBOX: l'état running a autorisé une réponse pour $kit" >&2
    exit 1
  fi

  # Scenario 4: le parcours Trello prépare les labels avant création de carte.
  assert_contains "$source/skills/trello-planning/SKILL.md" 'Avant toute création de carte.*étiquettes obligatoires'
  assert_contains "$source/skills/trello-planning/SKILL.md" 'Ne jamais demander.*confirmation'
  assert_contains "$source/skills/trello-planning/SKILL.md" 'lecture dédiée.*checklist'

  # Scenario 5: le parcours de sélection respecte l'ordre et ferme le navigateur.
  assert_contains "$source/skills/coordination/SKILL.md" 'refuse de démarrer.*03.*02'
  assert_contains "$source/policies/BROWSER-SESSION-LIFECYCLE.md" 'fermeture.*session|fermer.*session'

  # Scenario 6: fin nominale d'un Goal avec livraison et session navigateur fermée.
  perl -0pi -e 's/execution_status: running/execution_status: complete/; s/goal_status: active/goal_status: complete/; s/goal_delivery_status: pending/goal_delivery_status: verified/; s/next_action: .*/next_action: none/; s/open_checklist_items: .*/open_checklist_items: 0/; s/last_observable_evidence: .*/last_observable_evidence: sandbox-delivery/; s/ci_status: .*/ci_status: not-applicable/; s/trello_sync_status: .*/trello_sync_status: disabled/; s/integration_branch: .*/integration_branch: dev/; s/pushed_integration_commit: .*/pushed_integration_commit: sandbox123/; s/integration_remote_evidence: .*/integration_remote_evidence: origin\/dev contains sandbox123/; s/pull_request_status: .*/pull_request_status: verified/; s/- session_status: .*/- session_status: completed/' "$scenario/$hidden/RUNTIME-STATE.md"
  (cd "$scenario" && bash "$scenario/$hidden/scripts/guard-before-response.sh") >/dev/null
done

integration_output="$(bash "$root/scripts/test-integration-preflight.sh")"
grep -q '^git_worktrees=passed$' <<< "$integration_output"
grep -q '^git_index_lock_detection=passed$' <<< "$integration_output"
grep -q '^trello=not-executed$' <<< "$integration_output"
grep -q '^agents=not-executed$' <<< "$integration_output"
grep -q '^browser=not-executed$' <<< "$integration_output"
grep -q '^status=completed-with-explicit-external-limits$' <<< "$integration_output"
if bash "$root/scripts/test-integration-preflight.sh" --require-real >/dev/null 2>&1; then
  echo "ECHEC SANDBOX: --require-real a accepté des parcours externes absents" >&2
  exit 1
fi

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
  if [ "$kit" = codex ]; then cp "$root/starter-kit-codex/AGENTS.md" "$project/$hidden/templates/AGENTS.md"; else cp "$root/starter-kit-claude/CLAUDE.md" "$project/CLAUDE.md"; fi
  if python3 -c 'import tomllib' >/dev/null 2>&1; then
    bash "$project/$hidden/scripts/lint-kit.sh"
  else
    # Python 3.9 ne possède pas tomllib ; la CI fournit Python 3.11.
    assert_contains "$root/.github/workflows/validate-starter-kits.yml" 'python-version: "3.11"'
    echo "SCENARIO SANDBOX: lint dynamique reporté à la CI Python 3.11 pour $kit"
  fi
  bash "$project/$hidden/scripts/init-project.sh"
  updater="$project/.github/workflows/update-workspace-kit.yml"
  test ! -e "$updater" || { echo "ECHEC SANDBOX: updater hébergé installé avec visibilité unknown pour $kit"; exit 1; }
  if [ "$kit" = codex ]; then test -f "$project/AGENTS.md"; else test -f "$project/CLAUDE.md"; fi
  if bash "$project/$hidden/scripts/preflight.sh" >/dev/null 2>&1; then
    echo "ECHEC SANDBOX: preflight accepté sans cahier pour $kit" >&2
    exit 1
  fi
  cp "$project/$hidden/templates/project-brief.md" "$project/$hidden/PROJECT-BRIEF.md"
  cp "$project/$hidden/templates/project-profile.toml" "$project/$hidden/project-profile.toml"
  perl -0pi -e 's/\bpending\b/accepted/ if /## Statut/' "$project/$hidden/PROJECT-BRIEF.md"
  KIT_NAME="$kit" perl -0pi -e 's/project_name = "à compléter"/project_name = "sandbox-$ENV{KIT_NAME}"/; s/github_projects_choice = "pending"/github_projects_choice = "disabled"/' "$project/$hidden/project-profile.toml"
  if python3 -c 'import tomllib' >/dev/null 2>&1; then
    bash "$project/$hidden/scripts/initialize-project-design.sh" >/dev/null
    test -f "$project/docs/design/design-readiness.md"
  else
    assert_contains "$source/ORCHESTRATION.md" 'ensure-tools.sh'
  fi

  schedule_project="$tmp/init-schedule-$kit"
  mkdir -p "$schedule_project/$hidden"
  git init --quiet "$schedule_project"
  git -C "$schedule_project" config user.email sandbox@example.invalid
  git -C "$schedule_project" config user.name sandbox
  cp -R "$source/." "$schedule_project/$hidden/"
  cp "$source/templates/project-profile.toml" "$schedule_project/$hidden/project-profile.toml"
  perl -0pi -e 's/github_repository_visibility = "unknown"/github_repository_visibility = "public"/' "$schedule_project/$hidden/project-profile.toml"
  if [ "$kit" = codex ]; then cp "$root/starter-kit-codex/AGENTS.md" "$schedule_project/$hidden/templates/AGENTS.md"; else cp "$root/starter-kit-claude/CLAUDE.md" "$schedule_project/CLAUDE.md"; fi
  bash "$schedule_project/$hidden/scripts/init-project.sh" --updates pr >/dev/null
  scheduled_updater="$schedule_project/.github/workflows/update-workspace-kit.yml"
  grep -q '^  schedule:$' "$scheduled_updater" || { echo "ECHEC SANDBOX: visibilité publique explicite n'a pas activé le schedule pour $kit"; exit 1; }

  public_dispatch_project="$tmp/init-public-dispatch-$kit"
  mkdir -p "$public_dispatch_project/$hidden"
  git init --quiet "$public_dispatch_project"
  git -C "$public_dispatch_project" config user.email sandbox@example.invalid
  git -C "$public_dispatch_project" config user.name sandbox
  cp -R "$source/." "$public_dispatch_project/$hidden/"
  cp "$source/templates/project-profile.toml" "$public_dispatch_project/$hidden/project-profile.toml"
  perl -0pi -e 's/github_repository_visibility = "unknown"/github_repository_visibility = "public"/' "$public_dispatch_project/$hidden/project-profile.toml"
  if [ "$kit" = codex ]; then cp "$root/starter-kit-codex/AGENTS.md" "$public_dispatch_project/$hidden/templates/AGENTS.md"; else cp "$root/starter-kit-claude/CLAUDE.md" "$public_dispatch_project/CLAUDE.md"; fi
  bash "$public_dispatch_project/$hidden/scripts/init-project.sh" --updates dispatch >/dev/null
  public_dispatch_updater="$public_dispatch_project/.github/workflows/update-workspace-kit.yml"
  test -f "$public_dispatch_updater" || { echo "ECHEC SANDBOX: updater public manuel absent pour $kit"; exit 1; }
  grep -q '^  workflow_dispatch:$' "$public_dispatch_updater" || { echo "ECHEC SANDBOX: dispatch public absent pour $kit"; exit 1; }
  if grep -q '^  schedule:' "$public_dispatch_updater"; then echo "ECHEC SANDBOX: dispatch public a activé le schedule pour $kit"; exit 1; fi

  private_project="$tmp/init-private-$kit"
  mkdir -p "$private_project/$hidden"
  git init --quiet "$private_project"
  git -C "$private_project" config user.email sandbox@example.invalid
  git -C "$private_project" config user.name sandbox
  cp -R "$source/." "$private_project/$hidden/"
  cp "$source/templates/project-profile.toml" "$private_project/$hidden/project-profile.toml"
  perl -0pi -e 's/github_repository_visibility = "unknown"/github_repository_visibility = "private"/' "$private_project/$hidden/project-profile.toml"
  if [ "$kit" = codex ]; then cp "$root/starter-kit-codex/AGENTS.md" "$private_project/$hidden/templates/AGENTS.md"; else cp "$root/starter-kit-claude/CLAUDE.md" "$private_project/CLAUDE.md"; fi
  bash "$private_project/$hidden/scripts/init-project.sh" --updates dispatch >/dev/null
  test ! -e "$private_project/.github/workflows/update-workspace-kit.yml" || { echo "ECHEC SANDBOX: updater installé en privé sans approbation pour $kit"; exit 1; }

  approved_project="$tmp/init-approved-$kit"
  mkdir -p "$approved_project/$hidden"
  git init --quiet "$approved_project"
  git -C "$approved_project" config user.email sandbox@example.invalid
  git -C "$approved_project" config user.name sandbox
  cp -R "$source/." "$approved_project/$hidden/"
  cp "$source/templates/project-profile.toml" "$approved_project/$hidden/project-profile.toml"
  perl -0pi -e 's/github_repository_visibility = "unknown"/github_repository_visibility = "private"/; s/github_actions_private_billing_approved = false/github_actions_private_billing_approved = true/; s/github_actions_usage_limit_evidence = ""/github_actions_usage_limit_evidence = "owner-approved sandbox cap"/' "$approved_project/$hidden/project-profile.toml"
  if [ "$kit" = codex ]; then cp "$root/starter-kit-codex/AGENTS.md" "$approved_project/$hidden/templates/AGENTS.md"; else cp "$root/starter-kit-claude/CLAUDE.md" "$approved_project/CLAUDE.md"; fi
  bash "$approved_project/$hidden/scripts/init-project.sh" --updates dispatch >/dev/null
  approved_updater="$approved_project/.github/workflows/update-workspace-kit.yml"
  test -f "$approved_updater" || { echo "ECHEC SANDBOX: updater privé approuvé absent pour $kit"; exit 1; }
  grep -q '^  workflow_dispatch:$' "$approved_updater" || { echo "ECHEC SANDBOX: dispatch absent après approbation pour $kit"; exit 1; }
  if grep -q '^  schedule:' "$approved_updater"; then echo "ECHEC SANDBOX: dispatch a activé le schedule pour $kit"; exit 1; fi

  for existing_case in scheduled-public scheduled-mismatch scheduled-unknown scheduled-off custom-public; do
    existing_project="$tmp/existing-updater-$kit-$existing_case"
    mkdir -p "$existing_project/$hidden" "$existing_project/.github/workflows"
    git init --quiet "$existing_project"
    git -C "$existing_project" config user.email sandbox@example.invalid
    git -C "$existing_project" config user.name sandbox
    cp -R "$source/." "$existing_project/$hidden/"
    cp "$source/templates/project-profile.toml" "$existing_project/$hidden/project-profile.toml"
    if [ "$kit" = codex ]; then cp "$root/starter-kit-codex/AGENTS.md" "$existing_project/$hidden/templates/AGENTS.md"; else cp "$root/starter-kit-claude/CLAUDE.md" "$existing_project/CLAUDE.md"; fi
    if [ "$existing_case" = scheduled-public ] || [ "$existing_case" = scheduled-mismatch ] || [ "$existing_case" = scheduled-off ] || [ "$existing_case" = custom-public ]; then
      perl -0pi -e 's/github_repository_visibility = "unknown"/github_repository_visibility = "public"/' "$existing_project/$hidden/project-profile.toml"
    fi
    existing_workflow="$existing_project/.github/workflows/update-workspace-kit.yml"
    if [ "$existing_case" = custom-public ]; then
      printf 'name: custom updater\non:\n  workflow_dispatch:\njobs:\n  custom:\n    runs-on: ubuntu-latest\n    steps:\n      - run: echo custom\n' > "$existing_workflow"
    else
      perl -0pe "s/on:\n  workflow_dispatch:\n/on:\n  schedule:\n    - cron: '17 8 * * 1'\n  workflow_dispatch:\n/" "$source/templates/github/workflows/update-workspace-kit.yml" > "$existing_workflow"
    fi
    workflow_before="$(shasum -a 256 "$existing_workflow" | cut -d' ' -f1)"
    case "$existing_case" in
      scheduled-public)
        bash "$existing_project/$hidden/scripts/init-project.sh" --updates pr >/dev/null
        ;;
      scheduled-mismatch)
        if bash "$existing_project/$hidden/scripts/init-project.sh" --updates dispatch >"$tmp/$kit-$existing_case.log" 2>&1; then
          echo "ECHEC SANDBOX: schedule existant accepté pour le mode dispatch pour $kit"; exit 1
        fi
        grep -q 'ne correspond pas à --updates dispatch' "$tmp/$kit-$existing_case.log" || { echo "ECHEC SANDBOX: incompatibilité de mode non signalée pour $kit"; exit 1; }
        test ! -e "$existing_project/.gitignore" || { echo "ECHEC SANDBOX: le refus de mode a créé .gitignore pour $kit"; exit 1; }
        ;;
      scheduled-unknown)
        if bash "$existing_project/$hidden/scripts/init-project.sh" --updates pr >"$tmp/$kit-$existing_case.log" 2>&1; then
          echo "ECHEC SANDBOX: updater planifié préexistant accepté sans gate pour $kit"; exit 1
        fi
        grep -q 'reste actif.*gate' "$tmp/$kit-$existing_case.log" || { echo "ECHEC SANDBOX: erreur de gate explicite absente pour $kit"; exit 1; }
        test ! -e "$existing_project/.gitignore" || { echo "ECHEC SANDBOX: le refus pré-mutation a créé .gitignore pour $kit"; exit 1; }
        ;;
      scheduled-off)
        if bash "$existing_project/$hidden/scripts/init-project.sh" --updates off >"$tmp/$kit-$existing_case.log" 2>&1; then
          echo "ECHEC SANDBOX: --updates off a ignoré l'updater préexistant pour $kit"; exit 1
        fi
        grep -q 'ne désactive pas.*reste actif' "$tmp/$kit-$existing_case.log" || { echo "ECHEC SANDBOX: explication de --updates off absente pour $kit"; exit 1; }
        test ! -e "$existing_project/.gitignore" || { echo "ECHEC SANDBOX: le refus --updates off a créé .gitignore pour $kit"; exit 1; }
        ;;
      custom-public)
        if bash "$existing_project/$hidden/scripts/init-project.sh" --updates dispatch >"$tmp/$kit-$existing_case.log" 2>&1; then
          echo "ECHEC SANDBOX: workflow custom accepté par init-project pour $kit"; exit 1
        fi
        grep -q 'conservé sans modification.*personnalisé' "$tmp/$kit-$existing_case.log" || { echo "ECHEC SANDBOX: workflow custom non signalé pour $kit"; exit 1; }
        test ! -e "$existing_project/.gitignore" || { echo "ECHEC SANDBOX: le refus custom a créé .gitignore pour $kit"; exit 1; }
        ;;
    esac
    workflow_after="$(shasum -a 256 "$existing_workflow" | cut -d' ' -f1)"
    [ "$workflow_before" = "$workflow_after" ] || { echo "ECHEC SANDBOX: updater préexistant modifié pour $kit/$existing_case"; exit 1; }
  done
done

# Vérifier séparément le chemin d'installation partagé, qui copie le workflow commun.
for visibility_case in unknown public private-approved; do
  install_target="$tmp/install-$visibility_case"
  mkdir -p "$install_target/.codex"
  git init --quiet "$install_target"
  git -C "$install_target" config user.email sandbox@example.invalid
  git -C "$install_target" config user.name sandbox
  cp "$root/starter-kit-codex/.codex/templates/project-profile.toml" "$install_target/.codex/project-profile.toml"
  case "$visibility_case" in
    public) perl -0pi -e 's/github_repository_visibility = "unknown"/github_repository_visibility = "public"/' "$install_target/.codex/project-profile.toml" ;;
    private-approved) perl -0pi -e 's/github_repository_visibility = "unknown"/github_repository_visibility = "private"/; s/github_actions_private_billing_approved = false/github_actions_private_billing_approved = true/; s/github_actions_usage_limit_evidence = ""/github_actions_usage_limit_evidence = "owner-approved sandbox cap"/' "$install_target/.codex/project-profile.toml" ;;
  esac
  AGENTIC_KIT_HOME="$tmp/install-kit-home" AGENTIC_BRIEFS_HOME="$tmp/install-briefs" \
    bash "$root/install.sh" --kit codex --target "$install_target" --briefs-root "$tmp/install-briefs" --force --updates pr >/dev/null
  install_updater="$install_target/.github/workflows/update-workspace-kit.yml"
  if [ "$visibility_case" = unknown ]; then
    test ! -e "$install_updater" || { echo "ECHEC SANDBOX: install.sh a posé un updater en visibilité unknown"; exit 1; }
  else
    grep -q '^  schedule:$' "$install_updater" || { echo "ECHEC SANDBOX: install.sh n'a pas activé le schedule après gate ($visibility_case)"; exit 1; }
  fi
done

# L'installateur doit refuser les workflows préexistants non autorisés avant
# de créer le kit partagé, les liens du kit ou le manifeste.
for install_kit in codex claude; do
for existing_case in scheduled-public scheduled-mismatch scheduled-unknown scheduled-off custom-public; do
  install_hidden=".$install_kit"
  install_target="$tmp/install-existing-$install_kit-$existing_case"
  mkdir -p "$install_target/$install_hidden" "$install_target/.github/workflows"
  git init --quiet "$install_target"
  git -C "$install_target" config user.email sandbox@example.invalid
  git -C "$install_target" config user.name sandbox
  cp "$root/starter-kit-$install_kit/$install_hidden/templates/project-profile.toml" "$install_target/$install_hidden/project-profile.toml"
  if [ "$existing_case" = scheduled-public ] || [ "$existing_case" = scheduled-mismatch ] || [ "$existing_case" = scheduled-off ] || [ "$existing_case" = custom-public ]; then
    perl -0pi -e 's/github_repository_visibility = "unknown"/github_repository_visibility = "public"/' "$install_target/$install_hidden/project-profile.toml"
  fi
  install_existing_workflow="$install_target/.github/workflows/update-workspace-kit.yml"
  if [ "$existing_case" = custom-public ]; then
    printf 'name: custom updater\non:\n  workflow_dispatch:\njobs:\n  custom:\n    runs-on: ubuntu-latest\n    steps:\n      - run: echo custom\n' > "$install_existing_workflow"
  else
    perl -0pe "s/on:\n  workflow_dispatch:\n/on:\n  schedule:\n    - cron: '17 8 * * 1'\n  workflow_dispatch:\n/" "$root/distributions/shared/update-workspace-kit.yml" > "$install_existing_workflow"
  fi
  install_workflow_before="$(shasum -a 256 "$install_existing_workflow" | cut -d' ' -f1)"
  case "$existing_case" in
    scheduled-public)
      install_output="$(AGENTIC_KIT_HOME="$tmp/existing-install-home-$install_kit" AGENTIC_BRIEFS_HOME="$tmp/install-briefs" bash "$root/install.sh" --kit "$install_kit" --target "$install_target" --briefs-root "$tmp/install-briefs" --force --updates pr 2>&1)"
      printf '%s\n' "$install_output" | grep -q 'reconnu et conservé sans modification' || { echo "ECHEC SANDBOX: updater partagé préexistant présenté comme nouvellement installé ($install_kit)"; exit 1; }
      ;;
    scheduled-mismatch|scheduled-unknown|scheduled-off|custom-public)
      updates_arg=pr
      [ "$existing_case" != scheduled-off ] || updates_arg=off
      [ "$existing_case" != scheduled-mismatch ] || updates_arg=dispatch
      if AGENTIC_KIT_HOME="$tmp/existing-install-home-$install_kit-$existing_case" AGENTIC_BRIEFS_HOME="$tmp/install-briefs" bash "$root/install.sh" --kit "$install_kit" --target "$install_target" --briefs-root "$tmp/install-briefs" --force --updates "$updates_arg" >"$tmp/install-$install_kit-$existing_case.log" 2>&1; then
        echo "ECHEC SANDBOX: install.sh a accepté workflow préexistant unsafe ($install_kit/$existing_case)"; exit 1
      fi
      if [ "$existing_case" = scheduled-off ]; then
        grep -q 'ne désactive pas.*reste actif' "$tmp/install-$install_kit-$existing_case.log" || { echo "ECHEC SANDBOX: refus --updates off absent dans install.sh ($install_kit)"; exit 1; }
      else
        grep -Eq 'workflow updater préexistant|Workflow updater préexistant' "$tmp/install-$install_kit-$existing_case.log" || { echo "ECHEC SANDBOX: refus pré-mutation absent dans install.sh ($install_kit)"; exit 1; }
      fi
      test ! -e "$install_target/.workspace.toml" || { echo "ECHEC SANDBOX: install.sh a écrit le manifeste avant son refus ($install_kit/$existing_case)"; exit 1; }
      test ! -e "$install_target/AGENTS.md" && test ! -e "$install_target/CLAUDE.md" || { echo "ECHEC SANDBOX: install.sh a écrit l'entrée avant son refus ($install_kit/$existing_case)"; exit 1; }
      test ! -e "$tmp/existing-install-home-$install_kit-$existing_case" || { echo "ECHEC SANDBOX: install.sh a modifié le kit partagé avant son refus ($install_kit/$existing_case)"; exit 1; }
      ;;
  esac
  install_workflow_after="$(shasum -a 256 "$install_existing_workflow" | cut -d' ' -f1)"
  [ "$install_workflow_before" = "$install_workflow_after" ] || { echo "ECHEC SANDBOX: install.sh a modifié le workflow préexistant ($install_kit/$existing_case)"; exit 1; }
done
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
  assert_contains "$source/skills/project-onboarding/SKILL.md" 'parcours accéléré de reprise'
  assert_contains "$source/skills/project-onboarding/SKILL.md" '20 minutes actives, 30 actions maximum'
  assert_contains "$source/policies/INITIALIZATION-CLOSURE-POLICY.md" '15 minutes.*20 actions'
  assert_contains "$source/policies/INITIALIZATION-CLOSURE-POLICY.md" 'audits techniques.*cartes distinctes'
  assert_contains "$source/skills/coordination/SKILL.md" 'audit-gate.*delivery-gate.*stories P0 non relues'
  assert_contains "$source/policies/INITIALIZATION-CLOSURE-POLICY.md" 'ne lance pas la réalisation'
done

# Contrats statiques des domaines qui nécessitent une intégration externe réelle.
for kit in codex claude; do
  hidden=".$kit"
  source="$root/starter-kit-$kit/$hidden"
  assert_contains "$source/policies/TOOL-DISCOVERY-POLICY.md" 'PATH'
  assert_contains "$source/policies/GIT-FLOW.md" 'une seule Pull Request finale'
  assert_contains "$source/policies/GIT-FLOW.md" 'Le kit minimise le nombre d.objets Git'
  assert_contains "$source/policies/GIT-FLOW.md" 'ne crée jamais une branche ou une PR par agent'
  assert_contains "$source/policies/GIT-FLOW.md" 'Garde exécutable de cadence'
  assert_contains "$source/skills/trello-planning/SKILL.md" "Une PR n'est pas un journal de progression"
  assert_contains "$source/policies/TOOL-DISCOVERY-POLICY.md" 'exécute le garde-fou de démarrage'
  assert_contains "$source/policies/TOOL-DISCOVERY-POLICY.md" 'ensure-docker-ready.sh'
  assert_contains "$source/hooks/pre-tool-use.sh" 'Événement hook JSON invalide'
  assert_contains "$source/hooks/pre-tool-use.sh" 'le runtime et reprendre'
  assert_contains "$source/hooks/post-tool-use.sh" 'Événement déjà journalisé'
  assert_contains "$source/hooks/permission-request.sh" 'gh.*pr.*create'
  assert_contains "$source/hooks/hook-runtime.sh" 'max_log_bytes'
  assert_contains "$source/hooks/subagent-stop.sh" 'report_path'
assert_contains "$source/hooks/subagent-stop.sh" 'non-specialist-event'
assert_contains "$source/policies/CONTINUOUS-IMPROVEMENT-POLICY.md" 'test de non-régression'
assert_contains "$source/policies/PERSISTENT-EXECUTION-CONTRACT.md" 'Récupération universelle avant arrêt'
  assert_contains "$source/policies/PERSISTENT-EXECUTION-CONTRACT.md" 'Un même symptôme ne peut pas être répété deux fois'
  assert_contains "$source/policies/PERSISTENT-EXECUTION-CONTRACT.md" 'Blocage récupérable interdit de fin de tour'
  assert_contains "$source/policies/PERSISTENT-EXECUTION-CONTRACT.md" 'ne doit jamais interrompre le chat'
  assert_contains "$source/policies/AUTONOMY-AND-RECOVERY.md" 'Tout blocage que le Coordinateur ou un agent peut résoudre'
  assert_contains "$source/skills/quality-audit/SKILL.md" 'Retourner `rework` et produire ou déléguer'
  assert_contains "$source/skills/quality-audit/SKILL.md" 'Transformer un écart corrigeable en `rework`'
  assert_contains "$source/skills/delivery/SKILL.md" 'diagnostiquer, corriger ou déléguer la correction'
  assert_contains "$source/skills/documentation-audit/SKILL.md" 'Si une preuve manque, la produire ou la déléguer'
  assert_contains "$source/skills/documentation-authoring/SKILL.md" 'Si une preuve manque, la produire ou la déléguer'
  assert_contains "$source/scripts/init-project.sh" 'Initialiser les fichiers locaux obligatoires avant de valider le contrat'
assert_contains "$source/policies/AGENT-DELIVERY-CONTRACTS.md" 'Il refuse immédiatement toute tâche hors domaine'
assert_contains "$source/policies/AGENT-DELIVERY-CONTRACTS.md" 'agent qui a réellement produit le livrable'
assert_contains "$source/skills/coordination/SKILL.md" 'tâche → agent concerné → identifiant réel'
assert_contains "$source/skills/coordination/SKILL.md" 'Le Coordinateur assemble et vérifie, mais ne remplace pas ces agents'
  assert_contains "$source/skills/coordination/SKILL.md" 'design-gate.*rework.*jamais un blocage'
  assert_contains "$source/skills/coordination/SKILL.md" 'rapport d.audit indépendant.*REWORK.*relance l.auditeur'
if [ "$kit" = "codex" ]; then
  assert_contains "$source/agents/coordinateur.toml" 'exécuter soi-même une tâche relevant d un agent spécialisé disponible'
else
  assert_contains "$source/agents/coordinateur.md" 'ne réalise pas lui-même les tâches spécialisées'
fi
assert_contains "$source/policies/PROJECT-BOUNDARY-POLICY.md" 'ne doivent jamais être référencés'
assert_contains "$source/policies/DESIGN-FIRST-GATE.md" 'Transition de phase atomique'
assert_contains "$source/policies/DESIGN-FIRST-GATE.md" 'Mode refonte par phases'
assert_contains "$source/policies/SESSION-CONTINUITY-POLICY.md" 'Pool d.agents et limite de threads'
assert_contains "$source/policies/GIT-FLOW.md" 'Verrouillage et agents parallèles'
assert_contains "$source/policies/GIT-FLOW.md" 'ne supprimer un verrou que s.il est prouvé comme orphelin'
assert_contains "$source/policies/DESIGN-FIRST-GATE.md" 'ne peut annoncer simultanément'
  assert_contains "$source/policies/BROWSER-SESSION-LIFECYCLE.md" 'aucun onglet sensible ouvert'
  assert_contains "$source/skills/documentation-audit/SKILL.md" 'README'
  assert_contains "$source/policies/INITIALIZATION-CLOSURE-POLICY.md" 'Un fichier local décrivant Trello ne constitue pas une preuve Trello'
assert_contains "$source/policies/INITIALIZATION-CLOSURE-POLICY.md" 'PR vers `dev`'
assert_contains "$source/policies/INITIALIZATION-CLOSURE-POLICY.md" 'cahier.*conception.*carte locale.*carte distante'
  assert_contains "$source/policies/INITIALIZATION-CLOSURE-POLICY.md" 'needs-review.*action autonome'
  assert_contains "$source/policies/INITIALIZATION-CLOSURE-POLICY.md" 'doit créer immédiatement la PR'
  assert_contains "$source/policies/INITIALIZATION-CLOSURE-POLICY.md" 'sans demander.*confirmation.*PR'
  assert_contains "$source/policies/AUTONOMY-AND-RECOVERY.md" 'branche publiée.*déclenche automatiquement la création de la PR'
  assert_contains "$source/policies/INITIALIZATION-TRANSPARENCY.md" '## Approbation des hooks'
  kit_version="$(sed -n 's/^kit_version = "\(.*\)"/\1/p' "$source/KIT.toml")"
  assert_contains "$source/../$( [ "$kit" = codex ] && echo AGENTS.md || echo CLAUDE.md )" "ENTRYPOINT-CONTRACT: $kit_version"
  assert_contains "$source/policies/SESSION-CONTINUITY-POLICY.md" 'enchaîner les cartes'
  assert_contains "$source/policies/SESSION-CONTINUITY-POLICY.md" 'Review.*ne termine jamais'
done

echo "Scénarios sandbox isolés OK"
