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
  local entries=("$hidden/" "$entry" ".context-manifest.tsv")
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
usage() { printf "%b\n" "Usage : ./install.sh [--kit codex|claude] [--mode shared] [--target CHEMIN] [--briefs-root CHEMIN] [--updates off|dispatch|pr] [--force]"; }
kit=""; mode="shared"; target=""; briefs_root=""; updates_mode=off; force=false
while [ "$#" -gt 0 ]; do
  case "$1" in
    --kit) [ "$#" -ge 2 ] || fail "Valeur manquante pour --kit."; kit="$2"; shift 2 ;;
    --mode) [ "$#" -ge 2 ] || fail "Valeur manquante pour --mode."; mode="$2"; shift 2 ;;
    --target) [ "$#" -ge 2 ] || fail "Valeur manquante pour --target."; target="$2"; shift 2 ;;
    --briefs-root) [ "$#" -ge 2 ] || fail "Valeur manquante pour --briefs-root."; briefs_root="$2"; shift 2 ;;
    --updates) [ "$#" -ge 2 ] || fail "Valeur manquante pour --updates."; updates_mode="$2"; shift 2 ;;
    --force) force=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) fail "Option inconnue : $1" ;;
  esac
done
case "$mode" in shared) ;; *) fail "Le seul mode d'installation autorisé est shared." ;; esac
case "$updates_mode" in off|dispatch|pr) ;; *) fail "Valeur --updates invalide : $updates_mode" ;; esac
title
if [ -z "$kit" ] && [ -t 0 ]; then
  printf "%b\n" "${bold}Quel orchestrateur souhaitez-vous installer ?${reset}"
  printf "\n  ${cyan}1${reset}) Codex\n  ${cyan}2${reset}) Claude\n\n  Votre choix [1] : "
  read -r choice
  case "${choice:-1}" in 1) kit=codex ;; 2) kit=claude ;; *) fail "Choix invalide." ;; esac
fi
if [ -t 0 ]; then
  info "Installation partagée obligatoire : le socle universel sera centralisé et réutilisé par les projets."
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
briefs_root="${briefs_root:-${AGENTIC_BRIEFS_HOME:-$HOME/Documents/Projets/Cahier-des-Charges}}"
if [ -t 0 ]; then
  printf "\n%b\n" "${bold}Dossier commun des cahiers des charges${reset}"
  printf "Tous les projets auront un sous-dossier dans ce dossier.\n"
  printf "  Chemin [%s] : " "$briefs_root"
  read -r requested_briefs_root
  briefs_root="${requested_briefs_root:-$briefs_root}"
fi
case "$briefs_root" in
  ""|/*) ;;
  *) fail "Le dossier commun des cahiers doit être un chemin absolu." ;;
esac
workflow_path="$target/.github/workflows/update-workspace-kit.yml"
profile_path="$target/$hidden/project-profile.toml"
[ -f "$profile_path" ] || profile_path="$repo_root/$source_dir/$hidden/templates/project-profile.toml"
hosted_updates_allowed="$(bash "$repo_root/$source_dir/$hidden/scripts/python.sh" - "$profile_path" <<'PY'
import pathlib, sys, tomllib
try:
    profile = tomllib.loads(pathlib.Path(sys.argv[1]).read_text())
except (OSError, tomllib.TOMLDecodeError):
    print("false")
    raise SystemExit(0)
delivery = profile.get("delivery", {})
visibility = str(delivery.get("github_repository_visibility", "unknown")).strip().lower()
approved = delivery.get("github_actions_private_billing_approved", False)
evidence = str(delivery.get("github_actions_usage_limit_evidence", "")).strip()
allowed = visibility == "public" or (
    visibility in {"private", "unknown"} and approved is True and evidence
    and evidence.lower() not in {"none", "unknown", "[[a_completer]]"}
)
print("true" if allowed else "false")
PY
)" || hosted_updates_allowed=false
if [ -e "$workflow_path" ] || [ -L "$workflow_path" ]; then
  if [ "$updates_mode" = "off" ]; then
    fail "--updates off ne désactive pas le workflow updater préexistant; il reste actif et doit être revu/désactivé manuellement : $workflow_path"
  fi
  if [ "$hosted_updates_allowed" != "true" ]; then
    fail "Le workflow updater préexistant reste actif, mais le profil ne passe pas le gate de visibilité/approbation; revue manuelle requise avant toute mutation : $workflow_path"
  fi
  existing_updater_kind="$(bash "$repo_root/$source_dir/$hidden/scripts/python.sh" - "$repo_root/distributions/shared/update-workspace-kit.yml" "$workflow_path" <<'PY'
import pathlib, sys
try:
    template = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
    existing = pathlib.Path(sys.argv[2]).read_text(encoding="utf-8")
except (OSError, UnicodeError):
    print("custom")
    raise SystemExit(0)
marker = "on:\n  workflow_dispatch:\n"
scheduled = template.replace(marker, "on:\n  schedule:\n    - cron: '17 8 * * 1'\n  workflow_dispatch:\n", 1) if template.count(marker) == 1 else ""
kind = "dispatch" if existing == template else "scheduled" if scheduled and existing == scheduled else "custom"
print(kind)
PY
)" || existing_updater_kind=custom
  case "$updates_mode:$existing_updater_kind" in
    dispatch:dispatch|pr:scheduled) ;;
    *) fail "Workflow updater préexistant conservé sans modification; il est personnalisé ou ne correspond pas à --updates $updates_mode. Revue manuelle requise avant toute mutation : $workflow_path" ;;
  esac
fi
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
shared_root="${AGENTIC_KIT_HOME:-${XDG_DATA_HOME:-$HOME/.local/share}/agentic-starter-kits/kits}"
kit_version="$(sed -n 's/^kit_version = "\(.*\)"/\1/p' "$repo_root/$source_dir/$hidden/KIT.toml")"
shared_dir="$shared_root/$kit/$kit_version"
mkdir -p "$shared_dir" "$shared_dir/$hidden" "$target/$hidden"
cp -R "$repo_root/$source_dir/$entry" "$shared_dir/$entry"
cp -R "$repo_root/$source_dir/$hidden/." "$shared_dir/$hidden/"
for item in "$repo_root/$source_dir/$hidden"/*; do
  name="$(basename "$item")"
  case "$name" in PROJECT-BRIEF.md|project-profile.toml|project-inventory.md|RUNTIME-STATE.md|decisions|work-items|reports|metrics|evaluations) continue ;; esac
  rm -rf "$target/$hidden/$name"
  ln -s "$shared_dir/$hidden/$name" "$target/$hidden/$name"
done
for local_dir in decisions work-items reports metrics evaluations; do mkdir -p "$target/$hidden/$local_dir"; done
rm -f "$target/$entry"
ln -s "$shared_dir/$entry" "$target/$entry"
if [ "$updates_mode" != "off" ]; then
  if [ "$hosted_updates_allowed" = "true" ]; then
    mkdir -p "$target/.github/workflows"
    if [ -e "$workflow_path" ] || [ -L "$workflow_path" ]; then
      info "Workflow updater préexistant reconnu et conservé sans modification (--updates $updates_mode)."
    else
      cp "$repo_root/distributions/shared/update-workspace-kit.yml" "$workflow_path"
      if [ "$updates_mode" = "pr" ]; then
        bash "$shared_dir/$hidden/scripts/python.sh" - "$workflow_path" <<'PY'
import os, pathlib, sys
workflow = pathlib.Path(sys.argv[1])
content = workflow.read_text(encoding="utf-8")
marker = "on:\n  workflow_dispatch:\n"
scheduled = "on:\n  schedule:\n    - cron: '17 8 * * 1'\n  workflow_dispatch:\n"
if content.count(marker) != 1:
    raise SystemExit("CI billing gate: modèle updater inattendu; schedule non activé")
mode = workflow.stat().st_mode & 0o777
temporary = workflow.with_name(workflow.name + f".tmp.{os.getpid()}")
temporary.write_text(content.replace(marker, scheduled, 1), encoding="utf-8")
os.chmod(temporary, mode)
temporary.replace(workflow)
PY
      fi
      verify_update_workflow "${workflow_path#$target/}"
      info "Workflow updater $updates_mode installé après validation de la politique d’usage hébergé."
    fi
  else
    warning "Aucun workflow updater installé : visibilité ou approbation avec preuve de limite d’usage requise."
  fi
fi
cat > "$target/.workspace.toml" <<EOF
orchestrator = "$kit"
kit_version = "$kit_version"
source = "https://github.com/Krapaud-Labs/AGENTIC-Starter-Kits"
kit_mode = "shared"
kit_home = "$shared_root"
briefs_home = "$briefs_root"
update_channel = "stable"
EOF
ensure_gitignore
brief_archive="$briefs_root/$project_name/cahier-des-charges.md"
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
success "Mises à jour  : $updates_mode"
printf "\n%b\n" "${cyan}Prochaine étape${reset}"
printf "%s\n" "Ouvrez le projet dans $label et envoyez votre cahier des charges complet."
if [ -f "$target/.github/workflows/update-workspace-kit.yml" ]; then
  printf "%s\n" "Les futures mises à jour suivront le mode $updates_mode (runner hébergé potentiellement facturable)."
fi
if [ -f "$target/.github/workflows/update-workspace-kit.yml" ] && git -C "$target" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  printf "\n%b\n" "${yellow}Avant le premier push${reset}"
  printf "%s\n" "Ajoutez le workflow au premier commit :"
  printf "  git add .github/workflows/update-workspace-kit.yml .workspace.toml .gitignore\n"
  printf "  git commit -m \"chore: install agentic starter kit\"\n"
  printf "  git push -u origin \"\$(git branch --show-current)\"\n"
  printf "\n%s\n" "Le workflow doit être visible dans git ls-files avant le push."
fi
