#!/usr/bin/env bash
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
cat > "$tmp/report.md" <<'EOF'
## Rapport automatique du kit

Résumé
Garde agentique normal waiting-for-user

KIT_REPORT_FINGERPRINT:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa

Preuve anonymisée
execution_status=waiting-for-user
EOF
out="$(bash "$root/scripts/auto-correct-kit-report.sh" --report "$tmp/report.md")"
grep -q 'playbook=stale-user-input-deadlock' <<<"$out"
echo "Correcteur automatique: test de détection OK"
