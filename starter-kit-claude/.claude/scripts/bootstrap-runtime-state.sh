#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
state="$config/RUNTIME-STATE.md"
template="$config/templates/RUNTIME-STATE.md"
[ -s "$state" ] && { echo "RUNTIME: état déjà présent"; exit 0; }
[ -s "$template" ] || { echo "RUNTIME: modèle absent" >&2; exit 1; }
project="$(basename "$(git rev-parse --show-toplevel 2>/dev/null || cd "$config/.." && pwd)")"
now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
tmp="$state.bootstrap.$$"
sed -e "s/\[\[A_COMPLETER\]\]/non-défini/g" -e "s/^- Projet: non-défini$/- Projet: $project/" -e "s/^- Dernière mise à jour: non-défini$/- Dernière mise à jour: $now/" -e "s/^- execution_session: non-défini$/- execution_session: bootstrap-$now/" -e "s/^- goal_budget: non-défini$/- goal_budget: 100000/" "$template" > "$tmp"
mv "$tmp" "$state"
echo "RUNTIME: état initial créé automatiquement"
