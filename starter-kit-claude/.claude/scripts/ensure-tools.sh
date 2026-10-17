#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/tool-env.sh"
mkdir -p "$AGENTIC_TOOLS_HOME/bin" "$AGENTIC_NPM_PREFIX" "$AGENTIC_TOOLS_HOME/cache"
registry="$AGENTIC_TOOLS_HOME/registry.tsv"
[ -f "$registry" ] || printf 'tool\tcommand\tversion\tsource\tlast_checked\n' > "$registry"
record() { local name="$1" command_name="$2" version="$3" source="$4"; awk -F '\t' -v name="$name" 'NR == 1 || $1 != name' "$registry" > "$registry.tmp"; printf '%s\t%s\t%s\t%s\t%s\n' "$name" "$command_name" "$version" "$source" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$registry.tmp"; mv "$registry.tmp" "$registry"; }
version_of() { "$1" --version 2>/dev/null | head -n 1 || "$1" -v 2>/dev/null | head -n 1 || echo unknown; }
check_command() { local command_name="$1"; if command -v "$command_name" >/dev/null 2>&1; then record "$command_name" "$command_name" "$(version_of "$command_name")" existing-or-central; printf 'Disponible %-16s %s\n' "$command_name" "$(command -v "$command_name")"; else printf 'Absent     %-16s installer avec --install ou une commande projet\n' "$command_name"; fi; }
install_npm() { local package="$1"; command -v npm >/dev/null 2>&1 || { echo "npm est requis pour installer $package" >&2; exit 1; }; npm install --global --prefix "$AGENTIC_NPM_PREFIX" "$package"; local executable="${package%@*}"; executable="${executable##*/}"; record "$package" "$executable" "$(version_of "$executable")" npm-central; }
install_python() { local package="$1"; if command -v uv >/dev/null 2>&1; then uv tool install --force "$package"; elif command -v pipx >/dev/null 2>&1; then pipx install --force "$package"; else echo "Installez uv ou pipx pour centraliser l'outil Python $package" >&2; exit 1; fi; record "$package" "$package" "$(version_of "$package")" python-central; }
install_mode=false
while [ "$#" -gt 0 ]; do case "$1" in --install) install_mode=true; shift ;; --npm) [ "$#" -ge 2 ] || { echo '--npm exige un paquet' >&2; exit 2; }; install_npm "$2"; shift 2 ;; --python) [ "$#" -ge 2 ] || { echo '--python exige un paquet' >&2; exit 2; }; install_python "$2"; shift 2 ;; --list) awk -F '\t' 'NR > 1 { print $1 "\t" $2 "\t" $3 "\t" $4 }' "$registry"; exit 0 ;; -h|--help) echo 'Usage: ensure-tools.sh [--install] [--npm paquet] [--python paquet] [--list] [commande ...]'; exit 0 ;; *) check_command "$1"; shift ;; esac; done
if [ "$install_mode" = true ]; then for command_name in git rg jq gh node npm; do check_command "$command_name"; done; fi
printf 'Registre central : %s\nPrefix npm central : %s\n' "$registry" "$AGENTIC_NPM_PREFIX"
