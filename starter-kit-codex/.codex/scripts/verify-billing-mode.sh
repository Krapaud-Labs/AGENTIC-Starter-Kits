#!/usr/bin/env bash
set -euo pipefail

if [ "${AGENTIC_EXTERNAL_BILLING_APPROVED:-0}" = "1" ]; then
  echo "Autorisation explicite de facturation externe détectée; le contrôle des credentials est désactivé pour cette exécution"
  exit 0
fi

while IFS= read -r variable; do
  case "$variable" in
    *_API_KEY|*_API_TOKEN|*_AUTH_TOKEN|*_ACCESS_TOKEN|*_CLIENT_SECRET|*_SECRET_KEY|AWS_ACCESS_KEY_ID|AWS_SECRET_ACCESS_KEY|AWS_SESSION_TOKEN|AWS_PROFILE|GOOGLE_APPLICATION_CREDENTIALS|AZURE_CONFIG_DIR)
      # La présence du nom exporté suffit; ne déréférencer aucune valeur.
      echo "FACTURATION: credential externe détecté via le nom de variable $variable. Utiliser l'authentification abonnement ou obtenir une autorisation explicite." >&2
      exit 1
      ;;
  esac
done < <(compgen -e)

echo "Mode abonnement/local vérifié : aucun credential externe connu détecté par son nom de variable"
