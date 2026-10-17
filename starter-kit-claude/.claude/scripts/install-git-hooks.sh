#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
root="$(git -C "$config/.." rev-parse --show-toplevel 2>/dev/null || { echo "Git indisponible, hook non installé"; exit 0; })"

git -C "$root" config core.hooksPath "$config/hooks"
configured="$(git -C "$root" config --get core.hooksPath || true)"
[ "$configured" = "$config/hooks" ] || { echo "ÉCHEC GITFLOW: hook pre-push non configuré" >&2; exit 1; }
echo "Hook pre-push installé: $config/hooks/pre-push"
