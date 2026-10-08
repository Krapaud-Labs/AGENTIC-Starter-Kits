#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
fail() { echo "CONTRAT AGENTIC: $*" >&2; exit 1; }

[ -f "$root/CLAUDE.md" ] || fail "CLAUDE.md absent"
[ -f "$root/.claude/ORCHESTRATION.md" ] || fail "ORCHESTRATION.md absent"
[ -f "$root/.claude/RUNTIME-STATE.md" ] || fail "RUNTIME-STATE.md absent"
for policy in PRIMARY-AGENT-POLICY.md TASK-ROUTING-POLICY.md AGENT-DELIVERY-CONTRACTS.md CORE-EXECUTION-CONTRACT.md DELIVERY-CLOSURE-POLICY.md SESSION-CONTINUITY-POLICY.md; do
  [ -f "$root/.claude/policies/$policy" ] || fail "politique absente: $policy"
done
for script in guard-before-response.sh validate-session-state.sh verify-before-work.sh verify-before-push.sh verify-specialist-plan.sh verify-pr-cadence.sh ensure-tools.sh; do
  [ -x "$root/.claude/scripts/$script" ] || fail "garde-fou absent ou non exécutable: $script"
done
[ -x "$root/.claude/scripts/verify-billing-mode.sh" ] || fail "garde-facturation absent ou non exécutable"
[ -x "$root/.claude/scripts/ensure-docker-ready.sh" ] || fail "garde de démarrage Docker absent ou non exécutable"
grep -q 'agent principal de ce chat est le Coordinateur' "$root/CLAUDE.md" || fail "rôle du Coordinateur absent"
grep -q 'créer ou reprendre le Goal natif' "$root/CLAUDE.md" || fail "création du Goal natif absente"
grep -q 'identifiant réel' "$root/.claude/policies/TASK-ROUTING-POLICY.md" || fail "preuve d'identifiant agent absente"
grep -q 'agent qui a réellement produit le livrable' "$root/.claude/policies/AGENT-DELIVERY-CONTRACTS.md" || fail "preuve de producteur absente"
bash "$root/.claude/scripts/validate-entrypoint.sh" >/dev/null
echo "Contrat agentic vérifié"
