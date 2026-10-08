#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

for coordinator in \
  "$root/starter-kit-codex/AGENTS.md" \
  "$root/starter-kit-codex/.codex/ORCHESTRATION.md" \
  "$root/starter-kit-codex/.codex/policies/SESSION-CONTINUITY-POLICY.md" \
  "$root/starter-kit-claude/CLAUDE.md" \
  "$root/starter-kit-claude/.claude/ORCHESTRATION.md" \
  "$root/starter-kit-claude/.claude/policies/SESSION-CONTINUITY-POLICY.md"; do
  if ! grep -Eq "toute demande.*carte|Toute demande.*carte|quel que soit le nombre de cases" "$coordinator"; then
    echo "ECHEC TEST: la création automatique du Goal pour une reprise de carte est absente de $coordinator"
    exit 1
  fi
done

for closure in "$root/starter-kit-codex/.codex/policies/DELIVERY-CLOSURE-POLICY.md" "$root/starter-kit-claude/.claude/policies/DELIVERY-CLOSURE-POLICY.md"; do
  grep -q 'carte en `Review` déclenche d’abord l’agent `auditeur`' "$closure" || {
    echo "ECHEC TEST: Review ne route pas explicitement vers l auditeur"; exit 1;
  }
  grep -q 'ne demande une validation humaine que si' "$closure" || {
    echo "ECHEC TEST: conditions de validation humaine absentes"; exit 1;
  }
done

for flow in \
  "$root/starter-kit-codex/.codex/policies/GIT-FLOW.md" \
  "$root/starter-kit-claude/.claude/policies/GIT-FLOW.md"; do
  grep -q "Tant qu'un seul check" "$flow" || {
    echo "ECHEC TEST: la PR prématurée n'est pas interdite dans $flow"; exit 1;
  }
  grep -q "dernière checklist" "$flow" || {
    echo "ECHEC TEST: la condition de PR finale est absente de $flow"; exit 1;
  }
  grep -q "Garde exécutable de cadence" "$flow" || {
    echo "ECHEC TEST: le garde-fou de cadence PR est absent de $flow"; exit 1;
  }
done

for coordinator in \
  "$root/starter-kit-codex/.codex/ORCHESTRATION.md" \
  "$root/starter-kit-claude/.claude/ORCHESTRATION.md"; do
  grep -q "préparation de session obligatoire" "$coordinator" || {
    echo "ECHEC TEST: la préparation automatique de session est absente de $coordinator"; exit 1;
  }
  grep -q "doctor.sh" "$coordinator" || {
    echo "ECHEC TEST: l'inventaire automatique des outils est absent de $coordinator"; exit 1;
  }
  grep -q "TOOL-DISCOVERY-POLICY.md" "$coordinator" || {
    echo "ECHEC TEST: la règle de recherche multi-emplacements est absente de $coordinator"; exit 1;
  }
done

for parallel in \
  "$root/starter-kit-codex/.codex/skills/coordination/SKILL.md" \
  "$root/starter-kit-codex/.codex/skills/trello-planning/SKILL.md" \
  "$root/starter-kit-claude/.claude/skills/coordination/SKILL.md" \
  "$root/starter-kit-claude/.claude/skills/trello-planning/SKILL.md"; do
  grep -Eq "au moins deux lots indépendants|au moins deux cases indépendantes" "$parallel" || {
    echo "ECHEC TEST: seuil de parallélisation absent de $parallel"; exit 1;
  }
  grep -Eq "doit créer ou activer plusieurs agents" "$parallel" || {
    echo "ECHEC TEST: création obligatoire des agents parallèles absente de $parallel"; exit 1;
  }
done

for qa in \
  "$root/starter-kit-codex/.codex/skills/coordination/SKILL.md" \
  "$root/starter-kit-claude/.claude/skills/coordination/SKILL.md" \
  "$root/starter-kit-codex/.codex/policies/TASK-ROUTING-POLICY.md" \
  "$root/starter-kit-claude/.claude/policies/TASK-ROUTING-POLICY.md"; do
  grep -q "credentials" "$qa" || { echo "ECHEC TEST: fallback QA sans credentials absent de $qa"; exit 1; }
  grep -q "fixture" "$qa" || { echo "ECHEC TEST: fixture QA absente de $qa"; exit 1; }
done

for scope in \
  "$root/starter-kit-codex/.codex/skills/coordination/SKILL.md" \
  "$root/starter-kit-codex/.codex/skills/trello-planning/SKILL.md" \
  "$root/starter-kit-claude/.claude/skills/coordination/SKILL.md" \
  "$root/starter-kit-claude/.claude/skills/trello-planning/SKILL.md"; do
  grep -q "classer.*hors périmètre" "$scope" || {
    echo "ECHEC TEST: le contrôle de périmètre est absent de $scope"; exit 1;
  }
  grep -Eq "ne doit pas être ajouté|ne pas l'ajouter" "$scope" || {
    echo "ECHEC TEST: le refus des checks hors périmètre est absent de $scope"; exit 1;
  }
done

for autonomy in \
  "$root/starter-kit-codex/.codex/policies/AUTONOMY-AND-RECOVERY.md" \
  "$root/starter-kit-codex/.codex/skills/trello-planning/SKILL.md" \
  "$root/starter-kit-claude/.claude/policies/AUTONOMY-AND-RECOVERY.md" \
  "$root/starter-kit-claude/.claude/skills/trello-planning/SKILL.md"; do
  grep -q "Ne pas demander.*seconde confirmation\|Ne pas demander.*confirmation équivalente" "$autonomy" || {
    echo "ECHEC TEST: la règle d'autorisation explicite Trello est absente de $autonomy"; exit 1;
  }
done

for autonomy_policy in "$root/starter-kit-codex/.codex/policies/AUTONOMY-AND-RECOVERY.md" "$root/starter-kit-claude/.claude/policies/AUTONOMY-AND-RECOVERY.md"; do
  grep -q "jusqu'à la livraison sur.*dev.*sans demander une approbation intermédiaire" "$autonomy_policy" || {
    echo "ECHEC TEST: l'autonomie des gates internes jusqu'à dev est absente de $autonomy_policy"; exit 1;
  }
done

for ops in \
  "$root/starter-kit-codex/.codex/policies/TOOL-DISCOVERY-POLICY.md" \
  "$root/starter-kit-claude/.claude/policies/TOOL-DISCOVERY-POLICY.md" \
  "$root/starter-kit-codex/.codex/policies/CI-CD-POLICY.md" \
  "$root/starter-kit-claude/.claude/policies/CI-CD-POLICY.md"; do
  grep -q "production publique, la préproduction et l'administration opérateur" "$ops" || grep -q "endpoint public en HTTP 200" "$ops" || { echo "ECHEC TEST: distinction accès public et opérateur absente de $ops"; exit 1; }
  grep -q "DevOps" "$ops" || { echo "ECHEC TEST: activation DevOps absente de $ops"; exit 1; }
done

for sync in "$root/starter-kit-codex/.codex/scripts/sync-workspace-kit.sh" "$root/starter-kit-claude/.claude/scripts/sync-workspace-kit.sh"; do
  grep -q "gh api.*contents/VERSION" "$sync" || { echo "ECHEC TEST: synchronisation API GitHub absente de $sync"; exit 1; }
done

for recovery in \
  "$root/starter-kit-codex/.codex/policies/AUTONOMY-AND-RECOVERY.md" \
  "$root/starter-kit-codex/.codex/skills/coordination/SKILL.md" \
  "$root/starter-kit-claude/.claude/policies/AUTONOMY-AND-RECOVERY.md" \
  "$root/starter-kit-claude/.claude/skills/coordination/SKILL.md"; do
  grep -q "preuve négative" "$recovery" || {
    echo "ECHEC TEST: la reprise automatique après preuve négative est absente de $recovery"; exit 1;
  }
  grep -q "404" "$recovery" || {
    echo "ECHEC TEST: le cas 404 n'est pas couvert dans $recovery"; exit 1;
  }
done

for contract in \
  "$root/starter-kit-codex/.codex/policies/PERSISTENT-EXECUTION-CONTRACT.md" \
  "$root/starter-kit-claude/.claude/policies/PERSISTENT-EXECUTION-CONTRACT.md"; do
  grep -q "ne doit jamais être présenté comme une reprise automatique garantie" "$contract" || {
    echo "ECHEC TEST: promesse de reprise automatique non prouvée encore autorisée"; exit 1;
  }
  grep -q "nouvelle requête ou une réactivation native manuelle" "$contract" || {
    echo "ECHEC TEST: déclencheur manuel de reprise absent"; exit 1;
  }
done

for autonomy in \
  "$root/starter-kit-codex/.codex/policies/DELIVERY-CLOSURE-POLICY.md" \
  "$root/starter-kit-claude/.claude/policies/DELIVERY-CLOSURE-POLICY.md" \
  "$root/starter-kit-codex/.codex/policies/AUTONOMY-AND-RECOVERY.md" \
  "$root/starter-kit-claude/.claude/policies/AUTONOMY-AND-RECOVERY.md"; do
  grep -q "occupe-toi-en" "$autonomy" || { echo "ECHEC TEST: délégation des décisions réversibles absente de $autonomy"; exit 1; }
  grep -q "blocage global" "$autonomy" || { echo "ECHEC TEST: interdiction du blocage global absente de $autonomy"; exit 1; }
done

for continuity in \
  "$root/starter-kit-codex/.codex/policies/SESSION-CONTINUITY-POLICY.md" \
  "$root/starter-kit-codex/.codex/ORCHESTRATION.md" \
  "$root/starter-kit-claude/.claude/policies/SESSION-CONTINUITY-POLICY.md" \
  "$root/starter-kit-claude/.claude/ORCHESTRATION.md"; do
  grep -q "La clôture de l'onboarding ne clôture que l'onboarding\|dernier work item était un onboarding" "$continuity" || {
    echo "ECHEC TEST: la séparation onboarding et nouvelle demande est absente de $continuity"; exit 1;
  }
  grep -q "nouveau Goal" "$continuity" || {
    echo "ECHEC TEST: le nouveau Goal après onboarding est absent de $continuity"; exit 1;
  }
done

for kit in codex claude; do
  [ -x "$root/starter-kit-$kit/.$kit/scripts/ensure-tools.sh" ] || { echo "ECHEC TEST: ensure-tools.sh absent ou non executable pour $kit"; exit 1; }
  bash -n "$root/starter-kit-$kit/.$kit/scripts/ensure-tools.sh"
  [ -x "$root/starter-kit-$kit/.$kit/scripts/validate-agentic-contract.sh" ] || { echo "ECHEC TEST: validate-agentic-contract.sh absent pour $kit"; exit 1; }
  bash -n "$root/starter-kit-$kit/.$kit/scripts/validate-agentic-contract.sh"
  [ -x "$root/starter-kit-$kit/.$kit/scripts/validate-session-state.sh" ] || { echo "ECHEC TEST: validate-session-state.sh absent pour $kit"; exit 1; }
  bash -n "$root/starter-kit-$kit/.$kit/scripts/validate-session-state.sh"
  [ -x "$root/starter-kit-$kit/.$kit/scripts/ensure-native-goal.sh" ] || { echo "ECHEC TEST: ensure-native-goal.sh absent pour $kit"; exit 1; }
  bash -n "$root/starter-kit-$kit/.$kit/scripts/ensure-native-goal.sh"
  NATIVE_GOAL_STATUS=active NATIVE_GOAL_ID=test-goal bash "$root/starter-kit-$kit/.$kit/scripts/ensure-native-goal.sh" >/dev/null
  if NATIVE_GOAL_STATUS=blocked bash "$root/starter-kit-$kit/.$kit/scripts/ensure-native-goal.sh" >/dev/null 2>&1; then
    echo "ECHEC TEST: Goal bloqué accepté comme actif pour $kit"; exit 1
  fi
  session_fixture="$(mktemp -d)"
  mkdir -p "$session_fixture/.$kit/scripts"
  cp "$root/starter-kit-$kit/.$kit/RUNTIME-STATE.md" "$session_fixture/.$kit/RUNTIME-STATE.md"
  sed -i.bak \
    -e 's/\[\[A_COMPLETER\]\]/fixture/g' \
    -e 's/native_goal_status: required | active | unavailable/native_goal_status: blocked/' \
    -e 's/native_goal_id: none/native_goal_id: goal-fixture/' \
    -e 's/native_goal_evidence: fixture/native_goal_evidence: preuve-fixture/' \
    -e 's/native_goal_blocked_condition: none/native_goal_blocked_condition: décision humaine indispensable/' \
    "$session_fixture/.$kit/RUNTIME-STATE.md"
  cp "$root/starter-kit-$kit/.$kit/scripts/validate-session-state.sh" "$session_fixture/.$kit/scripts/validate-session-state.sh"
  (cd "$session_fixture" && bash ".${kit}/scripts/validate-session-state.sh") >/dev/null || { echo "ECHEC TEST: Goal natif blocked prouvé refusé pour $kit"; exit 1; }
  sed -i.bak 's/native_goal_status: blocked.*/native_goal_status: blocked (preuve)/' "$session_fixture/.$kit/RUNTIME-STATE.md"
  if (cd "$session_fixture" && bash ".${kit}/scripts/validate-session-state.sh") >/dev/null 2>&1; then
    echo "ECHEC TEST: statut natif mélangé accepté pour $kit"; exit 1
  fi
  rm -rf "$session_fixture"
  [ -x "$root/starter-kit-$kit/.$kit/scripts/verify-recovery-state.sh" ] || { echo "ECHEC TEST: verify-recovery-state.sh absent pour $kit"; exit 1; }
  bash -n "$root/starter-kit-$kit/.$kit/scripts/verify-recovery-state.sh"
  [ -x "$root/starter-kit-$kit/.$kit/scripts/verify-github-access.sh" ] || { echo "ECHEC TEST: verify-github-access.sh absent pour $kit"; exit 1; }
  bash -n "$root/starter-kit-$kit/.$kit/scripts/verify-github-access.sh"
  [ -x "$root/starter-kit-$kit/.$kit/scripts/prepare-qa-fixture.sh" ] || { echo "ECHEC TEST: prepare-qa-fixture.sh absent pour $kit"; exit 1; }
  bash -n "$root/starter-kit-$kit/.$kit/scripts/prepare-qa-fixture.sh"
  qa_fixture="$(mktemp -d)"
  (cd "$qa_fixture" && QA_FIXTURE_RESET_COMMAND='mkdir -p .qa && printf fixture > .qa/storage-state.json' QA_STORAGE_STATE=.qa/storage-state.json bash "$root/starter-kit-$kit/.$kit/scripts/prepare-qa-fixture.sh") >/dev/null || { echo "ECHEC TEST: fixture QA locale non régénérée pour $kit"; exit 1; }
  [ -s "$qa_fixture/.qa/storage-state.json" ] || { echo "ECHEC TEST: storage state QA absent pour $kit"; exit 1; }
  rm -rf "$qa_fixture"
  grep -q "approuv" "$root/starter-kit-$kit/.$kit/scripts/init-project.sh" || { echo "ECHEC TEST: demande d'approbation des hooks absente pour $kit"; exit 1; }
  [ -f "$root/starter-kit-$kit/.$kit/hooks.json" ] || { echo "ECHEC TEST: hooks.json absent pour $kit"; exit 1; }
  jq empty "$root/starter-kit-$kit/.$kit/hooks.json" || { echo "ECHEC TEST: hooks.json invalide pour $kit"; exit 1; }
  for hook in session-start.sh pre-tool-use.sh permission-request.sh post-tool-use.sh subagent-start.sh subagent-stop.sh stop.sh; do
    [ -x "$root/starter-kit-$kit/.$kit/hooks/$hook" ] || { echo "ECHEC TEST: hook $hook absent pour $kit"; exit 1; }
    bash -n "$root/starter-kit-$kit/.$kit/hooks/$hook"
  done
  [ -x "$root/starter-kit-$kit/.$kit/hooks/hook-runtime.sh" ] || { echo "ECHEC TEST: hook-runtime.sh absent pour $kit"; exit 1; }
  bash -n "$root/starter-kit-$kit/.$kit/hooks/hook-runtime.sh"
  grep -q 'project_root=' "$root/starter-kit-$kit/.$kit/hooks/hook-runtime.sh" || { echo "ECHEC TEST: project_root absent du runtime pour $kit"; exit 1; }
  ! grep -q '\$root/' "$root/starter-kit-$kit/.$kit/hooks/stop.sh" || { echo "ECHEC TEST: variable root non initialisée dans stop.sh pour $kit"; exit 1; }
  grep -q '\$project_root/' "$root/starter-kit-$kit/.$kit/hooks/stop.sh" || { echo "ECHEC TEST: stop.sh n'utilise pas project_root pour $kit"; exit 1; }
  grep -q 'max_log_bytes' "$root/starter-kit-$kit/.$kit/hooks/hook-runtime.sh"
  grep -q 'run_with_timeout' "$root/starter-kit-$kit/.$kit/hooks/stop.sh"
  grep -q 'report_path' "$root/starter-kit-$kit/.$kit/hooks/subagent-stop.sh"
  jq empty "$root/starter-kit-$kit/.$kit/hooks.json"
  grep -q 'Événement hook JSON invalide' "$root/starter-kit-$kit/.$kit/hooks/pre-tool-use.sh"
  grep -q 'le runtime et reprendre' "$root/starter-kit-$kit/.$kit/hooks/pre-tool-use.sh"
  grep -q 'tool_use_id' "$root/starter-kit-$kit/.$kit/hooks/post-tool-use.sh"
  grep -q 'gh.*pr.*create' "$root/starter-kit-$kit/.$kit/hooks/permission-request.sh"
done

for kit in codex claude; do
  update_script="$root/starter-kit-$kit/.$kit/scripts/check-kit-update.sh"
  [ -x "$update_script" ] || { echo "ECHEC TEST: check-kit-update.sh absent ou non executable pour $kit"; exit 1; }
  bash -n "$update_script"
done

for deploy in \
  "$root/starter-kit-codex/.codex/policies/GIT-FLOW.md" \
  "$root/starter-kit-codex/.codex/skills/coordination/SKILL.md" \
  "$root/starter-kit-claude/.claude/policies/GIT-FLOW.md" \
  "$root/starter-kit-claude/.claude/skills/coordination/SKILL.md"; do
  grep -q "Exception de déploiement explicite\|demande explicitement de déployer" "$deploy" || {
    echo "ECHEC TEST: l'exception de déploiement explicite est absente de $deploy"; exit 1;
  }
  grep -Eq "ne clôture ni la carte ni le Goal|PR de déploiement comme la PR finale" "$deploy" || {
    echo "ECHEC TEST: la non-clôture après PR de déploiement est absente de $deploy"; exit 1;
  }
done

for kit in codex claude; do
  hidden=".$kit"
  source_config="$root/starter-kit-$kit/$hidden"
  grep -q 'ne constitue jamais un MVP fonctionnel' "$source_config/policies/PRODUCT-READINESS-POLICY.md"
  grep -q 'baseline.*prototype.*MVP partiel.*MVP complet' "$source_config/policies/PRODUCT-READINESS-POLICY.md"
  grep -q 'création de fonctionnalités produit' "$source_config/policies/PRODUCT-READINESS-POLICY.md"
  grep -q 'identifiant réel du thread ou de l.agent' "$source_config/policies/TASK-ROUTING-POLICY.md"
  grep -q 'ne constitue pas la preuve d.exécution du Frontend' "$source_config/policies/TASK-ROUTING-POLICY.md"
  grep -q 'agent principal.*obligatoirement le Coordinateur' "$source_config/policies/PRIMARY-AGENT-POLICY.md"
  grep -q 'ne peut pas se comporter comme un agent frontend' "$source_config/policies/PRIMARY-AGENT-POLICY.md"
  root_entry="$root/starter-kit-$kit/$([ "$kit" = codex ] && echo AGENTS.md || echo CLAUDE.md)"
  grep -q 'Contrat obligatoire de chaque nouveau chat' "$root_entry"
  grep -q 'Pour une tâche visuelle, `frontend`, `qa` et `auditeur` sont obligatoires' "$root_entry"
  [ -x "$source_config/scripts/start-goal.sh" ] || {
    echo "ECHEC TEST: start-goal.sh absent ou non executable pour $kit"
    exit 1
  }
  [ -x "$source_config/scripts/verify-before-work.sh" ] || {
    echo "ECHEC TEST: verify-before-work.sh absent ou non executable pour $kit"
    exit 1
  }
  [ -x "$source_config/scripts/verify-specialist-plan.sh" ] || {
    echo "ECHEC TEST: verify-specialist-plan.sh absent pour $kit"
    exit 1
  }
  cadence="$source_config/scripts/verify-pr-cadence.sh"
  [ -x "$cadence" ] || { echo "ECHEC TEST: verify-pr-cadence.sh absent pour $kit"; exit 1; }
  bash -n "$cadence"
  bash "$cadence" complete 0 >/dev/null
  bash "$cadence" complete 1 >/dev/null
  if bash "$cadence" in-progress 0 >/dev/null 2>&1; then
    echo "ECHEC TEST: une PR de progression a été autorisée pour $kit"; exit 1
  fi
  bash "$cadence" in-progress 0 deployment-checkpoint >/dev/null
  if bash "$cadence" complete 2 >/dev/null 2>&1; then
    echo "ECHEC TEST: plusieurs PR ont été autorisées pour $kit"; exit 1
  fi
  runtime="$source_config/scripts/ensure-docker-ready.sh"
  [ -x "$runtime" ] || { echo "ECHEC TEST: ensure-docker-ready.sh absent pour $kit"; exit 1; }
  bash -n "$runtime"
  grep -q "ensure-docker-ready.sh" "$source_config/policies/TOOL-DISCOVERY-POLICY.md" || {
    echo "ECHEC TEST: tentative de démarrage du daemon absente pour $kit"; exit 1;
  }
  test_root="$(mktemp -d)"
  trap 'rm -rf "$test_root"' EXIT
  config="$test_root/$hidden"
  mkdir -p "$config/scripts" "$config/work-items/demo"
  cp "$source_config/scripts/guard-before-response.sh" "$config/scripts/"
  cp "$source_config/scripts/checkpoint.sh" "$config/scripts/"
  cp "$source_config/RUNTIME-STATE.md" "$config/"
  : > "$config/runtime-events.log"
  cp "$source_config/scripts/validate-obligations.sh" "$config/scripts/"
  cp "$source_config/templates/obligation-register.tsv" "$config/work-items/demo/obligations.tsv"
  cp "$source_config/templates/work-item.md" "$config/work-items/demo/brief.md"
  git init --quiet "$test_root/project"
  git -C "$test_root/project" config user.email sandbox@example.invalid
  git -C "$test_root/project" config user.name sandbox
  mkdir -p "$test_root/project/$hidden/scripts"
  cp "$source_config/scripts/verify-before-work.sh" "$test_root/project/$hidden/scripts/"
  if (cd "$test_root/project" && bash "$hidden/scripts/verify-before-work.sh") >/dev/null 2>&1; then
    echo "ECHEC TEST: branche par défaut protégée acceptée pour $kit"
    exit 1
  fi
  git -C "$test_root/project" switch --quiet -c feat/mvp-002-data-model
  (cd "$test_root/project" && bash "$hidden/scripts/verify-before-work.sh") >/dev/null
  touch "$test_root/project/.git/index.lock"
  if (cd "$test_root/project" && bash "$hidden/scripts/verify-before-work.sh") >/dev/null 2>&1; then
    echo "ECHEC TEST: index.lock accepté avant travail pour $kit"
    exit 1
  fi
  rm -f "$test_root/project/.git/index.lock"
  perl -0pi -e 's/\| Statut \| proposed \|/| Statut | in-progress |/' "$config/work-items/demo/brief.md"

  if bash "$config/scripts/validate-obligations.sh" --if-present >/dev/null 2>&1; then
    echo "ECHEC TEST: le registre pending aurait dû bloquer $kit"
    exit 1
  fi

  if bash "$config/scripts/guard-before-response.sh" >/dev/null 2>"$test_root/guard.err"; then
    echo "ECHEC TEST: l'état running aurait dû bloquer la réponse $kit"
    exit 1
  fi
  grep -q "état non terminal" "$test_root/guard.err"

  bash "$config/scripts/checkpoint.sh" validation waiting "attente récupérable" >/dev/null
  grep -q '^- execution_status: waiting-ci$' "$config/RUNTIME-STATE.md"
  if grep -q '^- execution_status: blocked$' "$config/RUNTIME-STATE.md"; then
    echo "ECHEC TEST: une attente récupérable ne doit pas bloquer le Goal $kit"
    exit 1
  fi

  perl -0pi -e 's/execution_status: .*/execution_status: complete/; s/next_action: .*/next_action: none/; s/open_checklist_items: .*/open_checklist_items: 0/; s/last_observable_evidence: .*/last_observable_evidence: test-evidence/; s/ci_status: .*/ci_status: success/; s/trello_sync_status: .*/trello_sync_status: disabled/; s/goal_agents_created: .*/goal_agents_created: agent-test/; s/goal_agent_evidence: .*/goal_agent_evidence: test-agent-evidence/' "$config/RUNTIME-STATE.md"
  if bash "$config/scripts/guard-before-response.sh" >/dev/null 2>&1; then
    echo "ECHEC TEST: une obligation pending aurait dû bloquer complete $kit"
    exit 1
  fi

  perl -0pi -e 's/\tpending\tnot-collected\t/\tverified\ttest-evidence\t/g' "$config/work-items/demo/obligations.tsv"
  bash "$config/scripts/validate-obligations.sh" --require-active >/dev/null
  bash "$config/scripts/guard-before-response.sh" >/dev/null


  perl -0pi -e 's/goal_status: .*/goal_status: active/; s/goal_delivery_status: .*/goal_delivery_status: pending/; s/integration_branch: .*/integration_branch: dev/; s/pushed_integration_commit: .*/pushed_integration_commit: none/; s/pull_request_status: .*/pull_request_status: not-required/' "$config/RUNTIME-STATE.md"
  if bash "$config/scripts/guard-before-response.sh" >/dev/null 2>&1; then
    echo "ECHEC TEST: un goal sans livraison vers dev aurait dû bloquer complete $kit"
    exit 1
  fi

  perl -0pi -e 's/goal_status: .*/goal_status: complete/; s/goal_delivery_status: .*/goal_delivery_status: verified/; s/pushed_integration_commit: .*/pushed_integration_commit: abc123/; s/integration_remote_evidence: .*/integration_remote_evidence: none/; s/pull_request_status: .*/pull_request_status: open/' "$config/RUNTIME-STATE.md"
  if bash "$config/scripts/guard-before-response.sh" >/dev/null 2>&1; then
    echo "ECHEC TEST: une PR ouverte aurait dû bloquer complete $kit"
    exit 1
  fi
  perl -0pi -e 's/integration_remote_evidence: .*/integration_remote_evidence: origin\/dev contient abc123/; s/pull_request_status: .*/pull_request_status: verified/' "$config/RUNTIME-STATE.md"
  bash "$config/scripts/guard-before-response.sh" >/dev/null

  perl -0pi -e 's/\tverified\ttest-evidence\t/\tverified\tnot-collected\t/' "$config/work-items/demo/obligations.tsv"
  if bash "$config/scripts/validate-obligations.sh" --require-active >/dev/null 2>&1; then
    echo "ECHEC TEST: une preuve absente aurait dû bloquer $kit"
    exit 1
  fi

  rm -rf "$test_root"
  trap - EXIT
done

for kit in codex claude; do
  hidden=".$kit"
  source_config="$root/starter-kit-$kit/$hidden"
  goal_root="$(mktemp -d)"
  mkdir -p "$goal_root/$hidden/scripts"
  cp "$source_config/RUNTIME-STATE.md" "$goal_root/$hidden/"
  cp "$source_config/scripts/start-goal.sh" "$goal_root/$hidden/scripts/"
  : > "$goal_root/$hidden/runtime-events.log"
  (cd "$goal_root" && NATIVE_GOAL_STATUS=unavailable NATIVE_GOAL_EVIDENCE='sandbox API native non exposée' GOAL_AGENT_EVIDENCE='sandbox agents déclarés par scénario isolé' bash "$hidden/scripts/start-goal.sh" \
    "Livrer la carte de test" "preuve CI et PR" "branche dev et outils gratuits" \
    "decision humaine ou blocage externe prouve" "P01" "dev" "qa,frontend" \
    "agent-qa,agent-frontend" "qa->tests,frontend->ui") >/dev/null
  grep -q '^- execution_status: running$' "$goal_root/$hidden/RUNTIME-STATE.md"
  grep -q '^- goal_status: active$' "$goal_root/$hidden/RUNTIME-STATE.md"
  grep -q '^- active_card: P01$' "$goal_root/$hidden/RUNTIME-STATE.md"
  grep -q 'delegation=qa,frontend' "$goal_root/$hidden/runtime-events.log"
  grep -q '^- goal_agents_created: agent-qa,agent-frontend$' "$goal_root/$hidden/RUNTIME-STATE.md"
  grep -q '^- goal_agent_assignments: qa->tests,frontend->ui$' "$goal_root/$hidden/RUNTIME-STATE.md"
  if (cd "$goal_root" && bash "$hidden/scripts/start-goal.sh" "bad" "proof" "constraints" "block" "P02" "dev" "qa,frontend") >/dev/null 2>&1; then
    echo "ECHEC TEST: une délégation sans agents ni affectations aurait dû être bloquée"
    exit 1
  fi
  if (cd "$goal_root" && bash "$hidden/scripts/start-goal.sh" "bad" "proof" "constraints" "block" "none" "dev") >/dev/null 2>&1; then
    echo "ECHEC TEST: un travail sans analyse de délégation aurait dû être bloqué"
    exit 1
  fi
  rm -rf "$goal_root"
done

boundary_root="$(mktemp -d)"
trap 'rm -rf "$boundary_root"' EXIT
git -C "$boundary_root" init --quiet
git -C "$boundary_root" config user.email test@example.invalid
git -C "$boundary_root" config user.name test
git -C "$boundary_root" config commit.gpgsign false
git -C "$boundary_root" checkout --quiet -b main
mkdir -p "$boundary_root/.codex/scripts"
cp "$root/starter-kit-codex/.codex/scripts/verify-project-boundary.sh" "$boundary_root/.codex/scripts/verify-project-boundary.sh"
printf '%s\n' 'Documentation produit neutre' > "$boundary_root/README.md"
git -C "$boundary_root" add README.md .codex/scripts/verify-project-boundary.sh
git -C "$boundary_root" commit --quiet -m baseline
git -C "$boundary_root" checkout --quiet -b feature/test-boundary
printf '%s\n' 'Piloté par Agentic Starter Kits' > "$boundary_root/README.md"
git -C "$boundary_root" add README.md
git -C "$boundary_root" commit --quiet -m leak
if (cd "$boundary_root" && BOUNDARY_BASE_REF=main bash .codex/scripts/verify-project-boundary.sh >/dev/null 2>&1); then
  echo "ECHEC TEST: une référence au kit aurait dû être bloquée"
  exit 1
fi
printf '%s\n' 'Documentation produit neutre' > "$boundary_root/README.md"
git -C "$boundary_root" add README.md
git -C "$boundary_root" commit --quiet -m neutralize
(cd "$boundary_root" && BOUNDARY_BASE_REF=main bash .codex/scripts/verify-project-boundary.sh >/dev/null)

recovery_root="$(mktemp -d)"
trap 'rm -rf "$recovery_root"' EXIT
for kit in codex claude; do
  kit_root="$root/starter-kit-$kit/.${kit}"
  mkdir -p "$recovery_root/$kit/.${kit}/scripts" "$recovery_root/$kit/.${kit}/work-items/demo"
  cp "$kit_root/scripts/verify-recovery-state.sh" "$recovery_root/$kit/.${kit}/scripts/verify-recovery-state.sh"
  printf '%s\n' '# Runtime' '- execution_status: blocked' '- goal_blocked_condition: audit interne' '- next_action: relancer auditeur' > "$recovery_root/$kit/.${kit}/RUNTIME-STATE.md"
  printf '%s\n' '| Statut | in-progress |' > "$recovery_root/$kit/.${kit}/work-items/demo/brief.md"
  printf '%s\n' $'gate\towner\ttrigger\tstatus\tevidence\tnext_check' $'audit-gate\tauditeur\tgate\tneeds-review\tnone\trelecture' $'delivery-gate\tcoordinateur\tgate\tpending\tnone\tpublication' > "$recovery_root/$kit/.${kit}/work-items/demo/obligations.tsv"
  if (cd "$recovery_root/$kit" && bash .${kit}/scripts/verify-recovery-state.sh) >/dev/null 2>&1; then
    echo "ECHEC TEST: blocked récupérable accepté pour $kit"; exit 1
  fi
  sed -i.bak 's/execution_status: blocked/execution_status: needs-review/' "$recovery_root/$kit/.${kit}/RUNTIME-STATE.md"
  (cd "$recovery_root/$kit" && bash .${kit}/scripts/verify-recovery-state.sh) >/dev/null || { echo "ECHEC TEST: needs-review récupérable refusé pour $kit"; exit 1; }
done
echo "Test reprise récupérable OK"

echo "Tests des portes exécutables OK"
