#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
policy="$root/docs/policies/EXECUTION-EFFICIENCY-POLICY.md"

for required in \
  'plan consolidé' \
  'une seule branche' \
  'une seule PR finale' \
  "passe d'inventaire" \
  'revalidation finale' \
  'Une seule relance par agent' \
  'sans changement de code, preuve, configuration ou état externe'; do
  grep -Fiq "$required" "$policy" || {
    printf 'ECHEC: règle d efficacité absente: %s\n' "$required" >&2
    exit 1
  }
done

for kit in codex claude; do
  config="$root/starter-kit-$kit/.${kit}/policies/EXECUTION-EFFICIENCY-POLICY.md"
  test -s "$config" || {
    printf 'ECHEC: politique absente pour %s\n' "$kit" >&2
    exit 1
  }
done

printf 'OK: politique d efficacité présente dans les deux kits\n'
