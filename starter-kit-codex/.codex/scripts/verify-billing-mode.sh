#!/usr/bin/env bash
set -euo pipefail

if [ "${AGENTIC_EXTERNAL_BILLING_APPROVED:-0}" = "1" ]; then
  echo "Facturation externe explicitement autorisée pour cette session"
  exit 0
fi

for variable in OPENAI_API_KEY CODEX_API_KEY ANTHROPIC_API_KEY ANTHROPIC_AUTH_TOKEN; do
  if [ -n "${!variable:-}" ]; then
    echo "FACTURATION: $variable détectée. Utiliser l'authentification abonnement ou obtenir une autorisation explicite." >&2
    exit 1
  fi
done
echo "Mode abonnement/local vérifié : aucune clé API détectée"
