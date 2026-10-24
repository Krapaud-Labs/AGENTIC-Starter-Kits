#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
rg -q -- '--briefs-root CHEMIN' "$root/install.sh"
rg -q 'briefs_home = ' "$root/install.sh"
rg -q 'brief_archive="\$briefs_root/\$project_name' "$root/install.sh"
rg -q 'Dossier commun des cahiers des charges' "$root/install.sh"
echo "INSTALL-BRIEF-REGISTRY: OK"
