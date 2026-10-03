#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
codex="$root/starter-kit-codex/.codex"
claude="$root/starter-kit-claude/.claude"
failures=0

fail() {
  printf 'ECHEC GOUVERNANCE: %s\n' "$*" >&2
  failures=$((failures + 1))
}

require_text() {
  local file="$1"
  local text="$2"
  grep -Fq "$text" "$file" || fail "$file ne contient pas: $text"
}

codex_inventory="$(mktemp)"
claude_inventory="$(mktemp)"
trap 'rm -f "$codex_inventory" "$claude_inventory"' EXIT

find "$codex/policies" "$codex/skills" -type f | sed "s#$codex/##" | sort > "$codex_inventory"
find "$claude/policies" "$claude/skills" -type f | sed "s#$claude/##" | sort > "$claude_inventory"
cmp -s "$codex_inventory" "$claude_inventory" || fail "inventaires Codex et Claude différents"

cmp -s "$codex/policies/CORE-EXECUTION-CONTRACT.md" "$claude/policies/CORE-EXECUTION-CONTRACT.md" || fail "contrats centraux Codex et Claude différents"
cmp -s "$codex/policies/GIT-FLOW.md" "$claude/policies/GIT-FLOW.md" || fail "politiques GitFlow Codex et Claude différentes"
cmp -s "$codex/templates/obligation-register.tsv" "$claude/templates/obligation-register.tsv" || fail "registres d obligations Codex et Claude différents"
cmp -s "$codex/scripts/validate-obligations.sh" "$claude/scripts/validate-obligations.sh" || fail "validateurs d obligations Codex et Claude différents"

for entry in "$root/starter-kit-codex/AGENTS.md" "$root/starter-kit-claude/CLAUDE.md"; do
  require_text "$entry" "CORE-EXECUTION-CONTRACT.md"
  require_text "$entry" "registre des obligations"
  require_text "$entry" "interdire toute clôture"
done

for runtime in "$codex/RUNTIME-STATE.md" "$claude/RUNTIME-STATE.md"; do
  require_text "$runtime" "Obligations ouvertes"
  require_text "$runtime" "Portes non vérifiées"
  require_text "$runtime" "État des intégrations"
done

for contract in "$codex/policies/CORE-EXECUTION-CONTRACT.md" "$claude/policies/CORE-EXECUTION-CONTRACT.md"; do
  for gate in intake-gate design-gate scope-gate validation-gate documentation-gate integration-gate audit-gate delivery-gate; do
    require_text "$contract" "$gate"
  done
done

for skill in "$codex/skills/trello-planning/SKILL.md" "$claude/skills/trello-planning/SKILL.md"; do
  require_text "$skill" "connecteurs Trello déjà disponibles"
  require_text "$skill" "checkpoint local"
  if grep -Fq "demander à l’utilisateur d’activer le plugin" "$skill"; then
    fail "$skill contient encore une activation Trello inconditionnelle"
  fi
done

for intake in "$codex/skills/project-intake/SKILL.md" "$claude/skills/project-intake/SKILL.md"; do
  require_text "$intake" "demander uniquement les réponses encore manquantes"
  require_text "$intake" "ne constitue pas un motif d’arrêt"
done

for delegation in "$codex/skills/coordination/SKILL.md" "$claude/skills/coordination/SKILL.md" "$codex/skills/trello-planning/SKILL.md" "$claude/skills/trello-planning/SKILL.md" "$codex/policies/SESSION-CONTINUITY-POLICY.md" "$claude/policies/SESSION-CONTINUITY-POLICY.md"; do
  require_text "$delegation" "au moins deux"
  if grep -Eq "au moins trois (tâches|cases) .*indépendantes" "$delegation"; then
    fail "$delegation conserve un seuil de délégation contradictoire"
  fi
done

for push_policy in "$codex/policies/PUSH-VALIDATION.md" "$claude/policies/PUSH-VALIDATION.md"; do
  require_text "$push_policy" "Toute modification non rattachée au work item bloque le push"
  require_text "$push_policy" "créer une branche propre"
done

for autonomy_policy in "$codex/policies/AUTONOMY-AND-RECOVERY.md" "$claude/policies/AUTONOMY-AND-RECOVERY.md"; do
  require_text "$autonomy_policy" "Une demande explicite d'action vaut autorisation"
  require_text "$autonomy_policy" "Ne jamais demander ensuite"
done
for improvement in "$codex/policies/CONTINUOUS-IMPROVEMENT-POLICY.md" "$claude/policies/CONTINUOUS-IMPROVEMENT-POLICY.md"; do
  require_text "$improvement" "test de non-régression"
  require_text "$improvement" "incidents"
done

for kit_root in "$codex" "$claude"; do
  require_text "$kit_root/RUNTIME-STATE.md" "goal_status: none"
  require_text "$kit_root/RUNTIME-STATE.md" "goal_objective:"
  require_text "$kit_root/policies/SESSION-CONTINUITY-POLICY.md" "objectif persistant"
  require_text "$kit_root/RUNTIME-STATE.md" "required_action_type: none"
  require_text "$kit_root/RUNTIME-STATE.md" "pending_request_id: none"
  require_text "$kit_root/RUNTIME-STATE.md" "budget_status: not-applicable"
done

for exceptional_policy in "$codex/policies/EXCEPTIONAL-REQUESTS.md" "$claude/policies/EXCEPTIONAL-REQUESTS.md"; do
  require_text "$exceptional_policy" "ne constitue pas une demande d'autorisation supplémentaire"
  require_text "$exceptional_policy" "Il ne demande pas à l'utilisateur de confirmer la création"
done

if [ "$failures" -gt 0 ]; then
  exit 1
fi

printf 'Audit de gouvernance OK: inventaires, contrat central, portes et reprise alignés.\n'
