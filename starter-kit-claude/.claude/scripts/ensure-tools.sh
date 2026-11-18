#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
source "$script_dir/tool-env.sh"
if ! mkdir -p "$AGENTIC_TOOLS_HOME/bin" "$AGENTIC_NPM_PREFIX" "$AGENTIC_TOOLS_HOME/cache" 2>/dev/null || ! touch "$AGENTIC_TOOLS_HOME/.write-test" 2>/dev/null; then
  fallback_root="${TMPDIR:-/tmp}/agentic-starter-kits"
  mkdir -p "$fallback_root/bin" "$fallback_root/cache" "$fallback_root/npm"
  AGENTIC_TOOLS_HOME="$fallback_root"
  AGENTIC_NPM_PREFIX="$fallback_root/npm"
else
  rm -f "$AGENTIC_TOOLS_HOME/.write-test"
fi
registry="$AGENTIC_TOOLS_HOME/registry.tsv"
registry_lock="$registry.lock"
[ -f "$registry" ] || printf 'tool\tcommand\tversion\tsource\tlast_checked\n' > "$registry"
record() {
  local name="$1" command_name="$2" version="$3" source="$4"
  local attempt tmp
  for attempt in $(seq 1 100); do
    if mkdir "$registry_lock" 2>/dev/null; then
      tmp="$registry.$$.$attempt.tmp"
      if awk -F '\t' -v name="$name" 'NR == 1 || $1 != name' "$registry" > "$tmp" \
        && printf '%s\t%s\t%s\t%s\t%s\n' "$name" "$command_name" "$version" "$source" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$tmp" \
        && mv "$tmp" "$registry"; then
        rmdir "$registry_lock"
        return 0
      fi
      rm -f "$tmp"
      rmdir "$registry_lock"
      return 1
    fi
    sleep 0.05
  done
  echo "REGISTRE OUTILS: écriture concurrente différée" >&2
  return 0
}
version_of() { "$1" --version 2>/dev/null | head -n 1 || "$1" -v 2>/dev/null | head -n 1 || echo unknown; }
check_command() {
  local command_name="$1"
  if command -v "$command_name" >/dev/null 2>&1; then
    record "$command_name" "$command_name" "$(version_of "$command_name")" existing-or-central
    printf 'Disponible %-16s %s\n' "$command_name" "$(command -v "$command_name")"
  else
    printf 'Absent     %-16s installer avec --install ou une commande projet\n' "$command_name"
  fi
}
install_system_tool() {
  local command_name="$1"
  case "$command_name" in
    rg|jq|gh|shellcheck|uv)
      if command -v brew >/dev/null 2>&1; then brew install "$command_name"; return 0; fi
      if command -v apt-get >/dev/null 2>&1; then sudo apt-get update && sudo apt-get install -y "$command_name"; return 0; fi
      ;;
  esac
  return 1
}
bootstrap_command() {
  local command_name="$1"
  if command -v "$command_name" >/dev/null 2>&1; then check_command "$command_name"; return 0; fi
  install_system_tool "$command_name" >/dev/null 2>&1 || true
  check_command "$command_name"
  command -v "$command_name" >/dev/null 2>&1
}
install_npm() {
  local package="$1"
  command -v npm >/dev/null 2>&1 || { echo "npm est requis pour installer $package" >&2; exit 1; }
  npm install --global --prefix "$AGENTIC_NPM_PREFIX" "$package"
  local executable="${package%@*}"; executable="${executable##*/}"
  record "$package" "$executable" "$(version_of "$executable")" npm-central
}
install_python() {
  local package="$1"
  if command -v uv >/dev/null 2>&1; then
    uv tool install --force "$package"
  elif command -v pipx >/dev/null 2>&1; then
    pipx install --force "$package"
  else
    echo "Installez uv ou pipx pour centraliser l'outil Python $package" >&2
    exit 1
  fi
  record "$package" "$package" "$(version_of "$package")" python-central
}
bootstrap_manifest() {
  local manifest="$1" category package command_name
  [ -f "$manifest" ] || return 0
  while IFS=$'\t' read -r category package command_name _; do
    [ "$category" = "category" ] && continue
    [ -n "${command_name:-}" ] || continue
    if command -v "$command_name" >/dev/null 2>&1; then
      check_command "$command_name"
      continue
    fi
    case "$category" in
      cli|runtime) bootstrap_command "$command_name" || missing_manifest=1 ;;
      npm) install_npm "$package" >/dev/null 2>&1 || missing_manifest=1 ;;
      python) install_python "$package" >/dev/null 2>&1 || missing_manifest=1 ;;
    esac
  done < "$manifest"
}
install_mode=false
while [ "$#" -gt 0 ]; do
  case "$1" in
    --install|--bootstrap) install_mode=true; shift ;;
    --npm) [ "$#" -ge 2 ] || { echo '--npm exige un paquet' >&2; exit 2; }; install_npm "$2"; shift 2 ;;
    --python) [ "$#" -ge 2 ] || { echo '--python exige un paquet' >&2; exit 2; }; install_python "$2"; shift 2 ;;
    --list) awk -F '\t' 'NR > 1 { print $1 "\t" $2 "\t" $3 "\t" $4 }' "$registry"; exit 0 ;;
    -h|--help) echo 'Usage: ensure-tools.sh [--install|--bootstrap] [--npm paquet] [--python paquet] [--list] [commande ...]'; exit 0 ;;
    *) check_command "$1"; shift ;;
  esac
done
if [ "$install_mode" = true ]; then
  missing=0
  for command_name in git rg jq gh node npm; do bootstrap_command "$command_name" || missing=1; done
  missing_manifest=0
  bootstrap_manifest "${AGENTIC_TOOL_MANIFEST:-$config/tool-manifest.tsv}"
  [ "$missing_manifest" -eq 0 ] || missing=1
  if [ "$missing" -ne 0 ]; then
    echo 'OUTILS CENTRAUX INDISPONIBLES: installation automatique tentee, aucune tache ne doit commencer.' >&2
    exit 1
  fi
fi
printf 'Registre central : %s\nPrefix npm central : %s\n' "$registry" "$AGENTIC_NPM_PREFIX"
