#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
kit_root="$(cd "$script_dir/.." && pwd)"
if project_root="$(git -C "${KIT_PROJECT_ROOT:-$PWD}" rev-parse --show-toplevel 2>/dev/null)" && [ -n "$project_root" ]; then
  :
else
  project_root="$(cd "$kit_root/.." && pwd)"
fi
manifest="$project_root/.workspace.toml"
lock_dir="$kit_root/.sync-workspace-kit.lock"
if ! mkdir "$lock_dir" 2>/dev/null; then
  echo "KIT_SYNC_BLOCKED: une synchronisation shared est déjà en cours." >&2
  exit 22
fi
trap 'rmdir "$lock_dir" 2>/dev/null || true' EXIT
if [ ! -f "$manifest" ]; then
  cat > "$manifest" <<EOF
orchestrator = "claude"
kit_version = "$(sed -n 's/^kit_version = "\([^"]*\)"/\1/p' "$kit_root/KIT.toml")"
source = "https://github.com/Krapaud-Labs/AGENTIC-Starter-Kits"
kit_mode = "shared"
kit_home = "${AGENTIC_KIT_HOME:-${XDG_DATA_HOME:-$HOME/.local/share}/agentic-starter-kits/kits}"
update_channel = "stable"
EOF
  echo "Manifest .workspace.toml initialisé dans $project_root" >&2
fi
source_url="$(sed -n 's/^source = "\(.*\)"/\1/p' "$manifest")"
[ -n "$source_url" ] || { echo "Source du kit absente du manifeste." >&2; exit 1; }
legacy_source="github.com/""krapaud/AGENTIC-Starter-Kits"
case "$source_url" in
  *"$legacy_source"*) source_url="https://github.com/Krapaud-Labs/AGENTIC-Starter-Kits" ;;
esac
raw_base="${source_url/github.com/raw.githubusercontent.com}"
latest=""
remote_channel=""
if latest_candidate="$(curl -fsSL --connect-timeout 5 --max-time 15 "$raw_base/main/VERSION" 2>/dev/null | tr -d '[:space:]')" && [ -n "$latest_candidate" ]; then
  latest="$latest_candidate"
  remote_channel="raw"
fi
if [ -z "$latest" ] && command -v gh >/dev/null 2>&1; then
  if latest_candidate="$(gh api 'repos/Krapaud-Labs/AGENTIC-Starter-Kits/contents/VERSION?ref=main' --jq .content 2>/dev/null | tr -d '\n' | base64 --decode 2>/dev/null | tr -d '[:space:]')" && [ -n "$latest_candidate" ]; then
    latest="$latest_candidate"
    remote_channel="github-api-via-gh"
  fi
fi
[ -n "$latest" ] || { echo "KIT_SYNC_BLOCKED: aucune voie de version GitHub vérifiable (raw DNS/API gh/connecteur)." >&2; echo "KIT_SYNC_ACTION: conserver le kit installé et réessayer automatiquement à la prochaine session." >&2; exit 20; }
installed="$(sed -n 's/^kit_version = "\(.*\)"/\1/p' "$manifest")"
[ "$installed" = "$latest" ] && { echo "Kit Claude déjà à jour : $installed (source: $remote_channel)"; exit 0; }
backup_root="$project_root/.claude/backups/kit-$installed-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_root"
printf 'prepared\n' > "$backup_root/operation.phase"
mkdir -p "$backup_root/claude-before-update"; rsync -a --exclude backups/ "$kit_root/" "$backup_root/claude-before-update/"
cp "$manifest" "$backup_root/workspace.toml.before-update"
tmp_dir="$(mktemp -d)"
rollback_dir="$backup_root/claude-before-update"
cleanup() {
  status="$?"
  if [ "$status" -ne 0 ] && [ -d "$rollback_dir" ]; then
    echo "Échec de la mise à jour. Restauration du kit Claude précédent." >&2
    rsync -a --delete --exclude backups/ "$rollback_dir/" "$kit_root/"
    cp "$backup_root/workspace.toml.before-update" "$manifest"
  fi
  rm -rf "$tmp_dir"
  exit "$status"
}
trap cleanup EXIT
archive="$tmp_dir/kit.tar.gz"
if ! curl -fsSL --connect-timeout 5 --max-time 30 -L "${source_url%/}/archive/refs/tags/v${latest}.tar.gz" -o "$archive"; then
  echo "KIT_SYNC_BLOCKED: version distante $latest détectée via $remote_channel, mais l'archive GitHub est inaccessible." >&2
  echo "KIT_SYNC_ACTION: réessayer avec le même canal de version dès que le téléchargement est disponible." >&2
  exit 21
fi
tar -xzf "$archive" -C "$tmp_dir"
source_kit="$(find "$tmp_dir" -mindepth 2 -maxdepth 2 -type d -name starter-kit-claude | head -n 1)"
[ -n "$source_kit" ] || { echo "Kit Claude absent de l'archive." >&2; exit 1; }
rsync -a --delete --exclude 'backups/' --exclude 'PROJECT-BRIEF.md' --exclude 'project-profile.toml' --exclude 'project-inventory.md' --exclude 'RUNTIME-STATE.md' --exclude 'decisions/' --exclude 'work-items/' --exclude 'reports/' --exclude 'metrics/' --exclude 'evaluations/' "$source_kit/.claude/" "$kit_root/.claude/"
printf 'applied\n' > "$backup_root/operation.phase"
cp "$source_kit/CLAUDE.md" "$kit_root/CLAUDE.md"
for local_file in PROJECT-BRIEF.md project-profile.toml RUNTIME-STATE.md; do
  if [ ! -f "$kit_root/$local_file" ]; then
    candidate="$source_kit/.claude/$local_file"
    [ -f "$candidate" ] || candidate="$source_kit/.claude/templates/$local_file"
    [ -f "$candidate" ] && cp "$candidate" "$kit_root/.claude/$local_file"
  fi
done
sed -i.bak "s/^kit_version = .*/kit_version = \"$latest\"/" "$manifest"
rm -f "$manifest.bak"
printf 'validated\n' > "$backup_root/operation.phase"
bash "$kit_root/scripts/deliver-workspace-update.sh" "$latest"
printf 'committed\n' > "$backup_root/operation.phase"
printf 'Kit Claude mis à jour : %s -> %s\nSauvegarde : %s\n' "$installed" "$latest" "$backup_root"
