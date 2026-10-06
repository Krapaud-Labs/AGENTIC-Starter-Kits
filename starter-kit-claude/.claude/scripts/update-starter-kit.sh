#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: update-starter-kit.sh [--remote NAME] [--ref REF] [--branch NAME]

Synchronise les fichiers universels du kit depuis le dépôt officiel.
Les fichiers spécifiques au projet sont sauvegardés puis restaurés.
EOF
}

remote="upstream"
ref="main"
branch=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --remote) remote="$2"; shift 2 ;;
    --ref) ref="$2"; shift 2 ;;
    --branch) branch="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Option inconnue: $1" >&2; usage >&2; exit 2 ;;
  esac
done

kit_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
project_root="$(git -C "$kit_root/.." rev-parse --show-toplevel 2>/dev/null || (cd "$kit_root/.." && pwd))"
if ! git -C "$project_root" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Le projet doit être un dépôt Git." >&2
  exit 1
fi
if ! git -C "$project_root" remote get-url "$remote" >/dev/null 2>&1; then
  echo "Remote absent: $remote. Ajoutez-le avec git remote add $remote URL." >&2
  exit 1
fi

git -C "$project_root" fetch --quiet "$remote" "$ref"
source_tree="$(mktemp -d)"
backup_tree="$(mktemp -d)"
trap 'rm -rf "$source_tree" "$backup_tree"' EXIT
git -C "$project_root" archive --format=tar "$remote/$ref" | tar -xf - -C "$source_tree"
source_kit="$source_tree/starter-kit-claude/.claude"
[ -d "$source_kit" ] || { echo "Kit Claude absent dans $remote/$ref." >&2; exit 1; }

if [ -n "$branch" ]; then
  git -C "$project_root" switch -c "$branch" 2>/dev/null || git -C "$project_root" switch "$branch"
fi

preserve=(project-profile.toml RUNTIME-STATE.md project-inventory.md trello.md)
for item in "${preserve[@]}"; do
  [ -e "$kit_root/$item" ] && cp -R "$kit_root/$item" "$backup_tree/$item"
done
for item in decisions evaluations metrics reports work-items; do
  [ -d "$kit_root/$item" ] && cp -R "$kit_root/$item" "$backup_tree/$item"
done

cp -R "$source_kit/." "$kit_root/"
for item in "${preserve[@]}"; do
  [ -e "$backup_tree/$item" ] && { rm -rf "$kit_root/$item"; cp -R "$backup_tree/$item" "$kit_root/$item"; }
done
for item in decisions evaluations metrics reports work-items; do
  [ -d "$backup_tree/$item" ] && { rm -rf "$kit_root/$item"; cp -R "$backup_tree/$item" "$kit_root/$item"; }
done

echo "Kit Claude synchronisé depuis $remote/$ref."
echo "Les hooks peuvent avoir changé. Relisez et réapprouvez les hooks dans l'interface Claude Code avant toute action."
echo "Vérifiez les changements, lancez verify-before-push.sh, puis ouvrez une PR."
