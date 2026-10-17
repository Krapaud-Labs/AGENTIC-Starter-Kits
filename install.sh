#!/usr/bin/env bash
set -euo pipefail

if [ -t 1 ] && [ "${NO_COLOR:-}" = "" ]; then
  cyan="\033[36m"; blue="\033[34m"; green="\033[32m"; yellow="\033[33m"; red="\033[31m"; bold="\033[1m"; reset="\033[0m"
else
  cyan=""; blue=""; green=""; yellow=""; red=""; bold=""; reset=""
fi
info() { printf "%b\n" "${cyan}ℹ${reset} $*"; }
success() { printf "%b\n" "${green}✔${reset} $*"; }
warning() { printf "%b\n" "${yellow}!${reset} $*"; }
fail() { printf "%b\n" "${red}✖${reset} $*" >&2; exit 1; }
title() {
  clear 2>/dev/null || true
  printf "%b\n" "${blue}${bold}"
  printf "%b\n" "  ╔══════════════════════════════════════════════════════════╗"
  printf "%b\n" "  ║              AGENTIC STARTER KITS                       ║"
  printf "%b\n" "  ║              Installation guidée                       ║"
  printf "%b\n" "  ╚══════════════════════════════════════════════════════════╝${reset}"
  printf "\n"
}
ensure_gitignore() {
  local gitignore="$target/.gitignore"
  touch "$gitignore"
  local entries=("$hidden/" "$entry")
  for ignored_path in "${entries[@]}"; do
    if ! grep -Fqx "$ignored_path" "$gitignore"; then
      printf "%s\n" "$ignored_path" >> "$gitignore"
    fi
  done
}
sync_kit_directory() {
  local source_hidden="$1"
  local target_hidden="$2"
  mkdir -p "$target_hidden"
  for item in "$source_hidden"/*; do
    [ -e "$item" ] || continue
    case "$(basename "$item")" in
      PROJECT-BRIEF.md|project-profile.toml|project-inventory.md|RUNTIME-STATE.md|decisions|work-items|reports|metrics|evaluations)
        continue
        ;;
    esac
    cp -R "$item" "$target_hidden/"
  done
}
verify_update_workflow() {
  local workflow="$target/$1"
  [ -f "$workflow" ] || fail "Le workflow de mise à jour est absent : $workflow"
  if git -C "$target" check-ignore -q "$workflow" 2>/dev/null; then
    fail "Le workflow de mise à jour est ignoré par Git. Retirez cette règle avant de continuer."
  fi
}
usage() { printf "%b\n" "Usage : ./install.sh [--kit codex|claude] [--mode native|external|shared] [--target CHEMIN] [--force]"; }
kit=""; mode="native"; target=""; force=false
while [ "$#" -gt 0 ]; do
  case "$1" in
    --kit) [ "$#" -ge 2 ] || fail "Valeur manquante pour --kit."; kit="$2"; shift 2 ;;
    --mode) [ "$#" -ge 2 ] || fail "Valeur manquante pour --mode."; mode="$2"; shift 2 ;;
    --target) [ "$#" -ge 2 ] || fail "Valeur manquante pour --target."; target="$2"; shift 2 ;;
    --force) force=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) fail "Option inconnue : $1" ;;
  esac
done
case "$mode" in native|external|shared) ;; *) fail "Le mode doit être native, external ou shared." ;; esac
title
if [ -z "$kit" ] && [ -t 0 ]; then
  printf "%b\n" "${bold}Quel orchestrateur souhaitez-vous installer ?${reset}"
  printf "\n  ${cyan}1${reset}) Codex\n  ${cyan}2${reset}) Claude\n\n  Votre choix [1] : "
  read -r choice
  case "${choice:-1}" in 1) kit=codex ;; 2) kit=claude ;; *) fail "Choix invalide." ;; esac
fi
if [ -t 0 ] && [ "$mode" = "native" ] && [ -z "${AGENTIC_MODE_SELECTED:-}" ]; then
  printf "\n%b\n" "${bold}Comment souhaitez-vous installer le kit ?${reset}"
  printf "  ${cyan}1${reset}) Mode natif : fichiers du kit disponibles directement dans le projet\n"
  printf "  ${cyan}2${reset}) Mode externe : fichiers du kit ignorés par Git, manifeste discret uniquement\n"
  printf "  ${cyan}3${reset}) Mode partagé : kit global unique et liens symboliques dans le projet\n\n"
  printf "Votre choix [1] : "
  read -r mode_choice
  case "${mode_choice:-1}" in
    1) mode=native ;;
    2) mode=external ;;
    3) mode=shared ;;
    *) fail "Choix de distribution invalide." ;;
  esac
fi
case "$kit" in
  codex) source_dir=starter-kit-codex; entry=AGENTS.md; hidden=.codex; label="Codex" ;;
  claude) source_dir=starter-kit-claude; entry=CLAUDE.md; hidden=.claude; label="Claude" ;;
  *) fail "Choisissez Codex ou Claude avec --kit codex|claude." ;;
esac
if [ -z "$target" ] && [ -t 0 ]; then
  current="$PWD"
  selected_index=0
  while true; do
    mapfile -t directories < <(find "$current" -mindepth 1 -maxdepth 1 -type d ! -name '.*' -print 2>/dev/null | sort)
    item_count=${#directories[@]}
    [ "$selected_index" -lt "$item_count" ] || selected_index=0
    clear 2>/dev/null || true
    title
    printf "%b\n" "${bold}Choisissez le dossier du projet${reset}"
    printf "\n  Dossier actuel : %s\n\n" "$current"
    printf "  ${green}s${reset} Sélectionner ce dossier comme projet\n"
    printf "  ${cyan}↑ ↓${reset} Parcourir les sous-dossiers\n"
    printf "  ${cyan}→${reset} ou Entrée Entrer dans le dossier sélectionné\n"
    printf "  ${cyan}←${reset} ou Backspace Revenir au dossier parent\n"
    printf "  ${red}q${reset} Annuler\n\n"
    if [ "$item_count" -eq 0 ]; then
      printf "  ${yellow}Aucun sous-dossier visible.${reset}\n"
    else
      for index in "${!directories[@]}"; do
        marker="  "
        [ "$index" -eq "$selected_index" ] && marker="${cyan}▸${reset} "
        printf "  %b%s/\n" "$marker" "$(basename "${directories[$index]}")"
      done
    fi
    printf "\n  Action : "
    IFS= read -r -s -n 1 key
    case "$key" in
      $'\x1b')
        IFS= read -r -s -n 2 key
        case "$key" in
          '[A') [ "$item_count" -gt 0 ] && selected_index=$(( (selected_index - 1 + item_count) % item_count )) ;;
          '[B') [ "$item_count" -gt 0 ] && selected_index=$(( (selected_index + 1) % item_count )) ;;
          '[C') [ "$item_count" -gt 0 ] && current="${directories[$selected_index]}" && selected_index=0 ;;
          '[D') parent="$(dirname "$current")"; [ "$parent" != "$current" ] && current="$parent" && selected_index=0 ;;
        esac
        ;;
      '')
        if [ "$item_count" -gt 0 ]; then
          current="${directories[$selected_index]}"
          selected_index=0
        fi
        ;;
      $'\x7f'|$'\x08')
        parent="$(dirname "$current")"
        [ "$parent" != "$current" ] && current="$parent" && selected_index=0
        ;;
      s|S) target="$current"; break ;;
      q|Q) fail "Installation annulée." ;;
    esac
  done
fi

target="${target:-.}"
[ -d "$target" ] || fail "Le dossier cible n’existe pas : $target"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target="$(cd "$target" && pwd)"
project_name="$(basename "$target")"
if [ -t 0 ]; then
  printf "\n%b\n" "${bold}Nom du projet pour l’archive des cahiers des charges${reset}"
  printf "  Nom [%s] : " "$project_name"
  read -r requested_project_name
  project_name="${requested_project_name:-$project_name}"
fi
case "$project_name" in
  ""|.|..|*/*) fail "Le nom du projet doit être un nom de dossier simple, sans slash." ;;
esac
if [ "$force" != true ] && { [ -e "$target/$entry" ] || [ -e "$target/$hidden" ]; }; then
  fail "Un kit existe déjà dans $target. Utilisez --force après vérification."
fi
printf "\n%b\n" "${bold}Résumé de l’installation${reset}"
printf "  Orchestrateur : %s\n  Distribution  : %s\n  Projet cible  : %s\n\n" "$label" "$mode" "$target"
if [ -t 0 ]; then
  printf "Continuer l’installation ? [O/n] : "
  read -r confirm
  case "${confirm:-o}" in n|N|non|Non) info "Installation annulée."; exit 0 ;; esac
fi
info "Installation de la configuration $label..."
if [ "$mode" = "shared" ]; then
  shared_root="${AGENTIC_KIT_HOME:-${XDG_DATA_HOME:-$HOME/.local/share}/agentic-starter-kits/kits}"
  kit_version="$(sed -n 's/^kit_version = "\(.*\)"/\1/p' "$repo_root/$source_dir/$hidden/KIT.toml")"
  shared_dir="$shared_root/$kit/$kit_version"
  mkdir -p "$shared_dir"
  cp -R "$repo_root/$source_dir/$entry" "$shared_dir/$entry"
  mkdir -p "$shared_dir/$hidden"
  cp -R "$repo_root/$source_dir/$hidden/." "$shared_dir/$hidden/"
  mkdir -p "$target/$hidden"
  for item in "$repo_root/$source_dir/$hidden"/*; do
    name="$(basename "$item")"
    case "$name" in PROJECT-BRIEF.md|project-profile.toml|project-inventory.md|RUNTIME-STATE.md|decisions|work-items|reports|metrics|evaluations) continue ;; esac
    rm -rf "$target/$hidden/$name"
    ln -s "$shared_dir/$hidden/$name" "$target/$hidden/$name"
  done
  for local_dir in decisions work-items reports metrics evaluations; do mkdir -p "$target/$hidden/$local_dir"; done
  rm -f "$target/$entry"
  ln -s "$shared_dir/$entry" "$target/$entry"
else
  cp -R "$repo_root/$source_dir/$entry" "$target/$entry"
  sync_kit_directory "$repo_root/$source_dir/$hidden" "$target/$hidden"
fi
mkdir -p "$target/.github/workflows"
if [ "$mode" = "shared" ]; then
  workflow_path="$target/.github/workflows/update-workspace-kit.yml"
  cp "$repo_root/distributions/external/update-workspace-kit.yml" "$workflow_path"
  cat > "$target/.workspace.toml" <<EOF
orchestrator = "$kit"
kit_version = "$kit_version"
source = "https://github.com/Krapaud-Labs/AGENTIC-Starter-Kits"
kit_mode = "shared"
kit_home = "$shared_root"
update_channel = "stable"
EOF
elif [ "$mode" = "external" ]; then
  workflow_path="$target/.github/workflows/update-workspace-kit.yml"
  cp "$repo_root/distributions/external/update-workspace-kit.yml" "$workflow_path"
  kit_version="$(sed -n 's/^kit_version = "\(.*\)"/\1/p' "$target/$hidden/KIT.toml")"
  cat > "$target/.workspace.toml" <<EOF
orchestrator = "$kit"
kit_version = "$kit_version"
source = "https://github.com/Krapaud-Labs/AGENTIC-Starter-Kits"
update_channel = "stable"
EOF
else
  workflow_path="$target/.github/workflows/update-agentic-starter-kit.yml"
  cp "$repo_root/$source_dir/$hidden/templates/github/workflows/update-agentic-starter-kit.yml" "$workflow_path"
fi
ensure_gitignore
verify_update_workflow "${workflow_path#$target/}"
projects_root="$target"
while [ "$projects_root" != "/" ] && [ "$(basename "$projects_root")" != "Projets" ]; do
  projects_root="$(dirname "$projects_root")"
done
if [ "$(basename "$projects_root")" != "Projets" ]; then
  projects_root="$(dirname "$target")"
fi
brief_archive="$projects_root/Cahier-des-Charges/$project_name/cahier-des-charges.md"
mkdir -p "$(dirname "$brief_archive")"
if [ ! -e "$brief_archive" ]; then
  cat > "$brief_archive" <<EOF
# Cahier des charges - $project_name

## Statut

À compléter

## Objectif

Décrire ici le besoin, le périmètre et les critères de réussite du projet.

## Périmètre

À compléter lors de l'initialisation.
EOF
  success "Archive du cahier des charges créée : $brief_archive"
else
  info "Archive du cahier des charges conservée : $brief_archive"
fi
info "Gitignore mis à jour pour le kit $label."
printf "\n"
success "Kit $label installé avec succès."
success "Fichier racine : $target/$entry"
success "Configuration : $target/$hidden"
success "Mises à jour  : $workflow_path"
printf "\n%b\n" "${cyan}Prochaine étape${reset}"
printf "%s\n" "Ouvrez le projet dans $label et envoyez votre cahier des charges complet."
printf "%s\n" "Les futures mises à jour arriveront par Pull Request vers dev ou develop."
if git -C "$target" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  printf "\n%b\n" "${yellow}Avant le premier push${reset}"
  printf "%s\n" "Ajoutez le workflow au premier commit :"
  if [ "$mode" = "external" ] || [ "$mode" = "shared" ]; then
    printf "  git add .github/workflows/update-workspace-kit.yml .workspace.toml .gitignore\n"
  else
    printf "  git add .github/workflows/update-agentic-starter-kit.yml .gitignore %s\n" "$entry"
  fi
  printf "  git commit -m \"chore: install agentic starter kit\"\n"
  printf "  git push -u origin \"\$(git branch --show-current)\"\n"
  printf "\n%s\n" "Le workflow doit être visible dans git ls-files avant le push."
fi
