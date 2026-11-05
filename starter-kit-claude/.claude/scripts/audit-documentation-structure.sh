#!/usr/bin/env bash
set -euo pipefail
root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
docs_root="${DOCS_ROOT:-$root/docs}"
strict=0
[ "${1:-}" = "--strict" ] && strict=1
[ -d "$docs_root" ] || { echo "DOCUMENTATION: docs absent, aucune génération automatique"; exit 0; }
warnings=0
echo "DOCUMENTATION: audit canonique de $docs_root"
if find "$docs_root" -name '.DS_Store' -print -quit | grep -q .; then echo "DOCUMENTATION_WARNING: artefacts .DS_Store présents"; warnings=$((warnings + 1)); fi
number_collisions="$(find "$docs_root" -type f -name '*.md' -exec basename {} \; | sed -n 's/^\([0-9][0-9]*\)-.*/\1/p' | sort | uniq -d | tr '\n' ' ' || true)"
if [ -n "$number_collisions" ]; then echo "DOCUMENTATION_WARNING: collisions de numérotation: $number_collisions"; warnings=$((warnings + 1)); fi
report_count="$(find "$docs_root" -type f \( -path '*/audits/*' -o -path '*/quality/evidence/*' -o -path '*/project-management/*history*' \) | wc -l | tr -d ' ')"
echo "DOCUMENTATION: preuves et historiques recensés: $report_count"
echo "DOCUMENTATION: aucun nouveau document ne doit être créé si un document canonique couvre déjà le sujet"
if [ "$strict" -eq 1 ] && [ "$warnings" -gt 0 ]; then echo "DOCUMENTATION: audit strict échoué avec $warnings avertissement(s)" >&2; exit 2; fi
echo "DOCUMENTATION: audit terminé"
