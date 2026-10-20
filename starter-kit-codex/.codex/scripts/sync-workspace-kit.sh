#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
kit_root="$(cd "$script_dir/.." && pwd)"
project_root="$(git -C "${KIT_PROJECT_ROOT:-$PWD}" rev-parse --show-toplevel 2>/dev/null || cd "$kit_root/.." && pwd)"
manifest="$project_root/.workspace.toml"
if [ ! -f "$manifest" ]; then
  cat > "$manifest" <<EOF
orchestrator = "codex"
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
latest="$(curl -fsSL "$raw_base/main/VERSION")"
if command -v gh >/dev/null 2>&1; then
  gh_latest="$(gh api 'repos/Krapaud-Labs/AGENTIC-Starter-Kits/contents/VERSION?ref=main' --jq .content 2>/dev/null | tr -d '\n' | base64 --decode | tr -d '[:space:]' || true)"
  [ -n "$gh_latest" ] && latest="$gh_latest"
fi
installed="$(sed -n 's/^kit_version = "\(.*\)"/\1/p' "$manifest")"
[ -n "$installed" ] || { echo "Version installée absente du manifeste." >&2; exit 1; }
[ "$installed" = "$latest" ] && { echo "Kit Codex déjà à jour : $installed"; exit 0; }
backup_root="$project_root/.codex/backups/kit-$installed-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_root"
mkdir -p "$backup_root/codex-before-update"; rsync -a --exclude backups/ "$kit_root/" "$backup_root/codex-before-update/"
tmp_dir="$(mktemp -d)"
rollback_dir="$backup_root/codex-before-update"
cleanup() {
  status="$?"
  if [ "$status" -ne 0 ] && [ -d "$rollback_dir" ]; then
    echo "Échec de la mise à jour. Restauration du kit Codex précédent." >&2
    cp -R "$rollback_dir"/. "$kit_root/"
  fi
  rm -rf "$tmp_dir"
  exit "$status"
}
trap cleanup EXIT
archive="$tmp_dir/kit.tar.gz"
curl -fsSL -L "${source_url%/}/archive/refs/heads/main.tar.gz" -o "$archive"
tar -xzf "$archive" -C "$tmp_dir"
source_kit="$(find "$tmp_dir" -mindepth 2 -maxdepth 2 -type d -name starter-kit-codex | head -n 1)"
[ -n "$source_kit" ] || { echo "Kit Codex absent de l'archive." >&2; exit 1; }
rsync -a --delete --exclude 'backups/' --exclude 'PROJECT-BRIEF.md' --exclude 'project-profile.toml' --exclude 'project-inventory.md' --exclude 'RUNTIME-STATE.md' --exclude 'decisions/' --exclude 'work-items/' --exclude 'reports/' --exclude 'metrics/' --exclude 'evaluations/' "$source_kit/.codex/" "$kit_root/"
cp "$source_kit/AGENTS.md" "$project_root/AGENTS.md"
[ -x "$kit_root/scripts/validate-entrypoint.sh" ] || chmod +x "$kit_root/scripts/validate-entrypoint.sh"
for required_file in KIT.toml hooks.json scripts/validate-entrypoint.sh scripts/validate-agentic-contract.sh scripts/verify-billing-mode.sh scripts/validate-documentation.sh; do
  [ -e "$kit_root/$required_file" ] || { echo "Fichier obligatoire absent après synchronisation: .codex/$required_file" >&2; exit 1; }
done
sed -i.bak "s/^kit_version = .*/kit_version = \"$latest\"/" "$kit_root/KIT.toml"
rm -f "$kit_root/KIT.toml.bak"
for local_file in PROJECT-BRIEF.md project-profile.toml RUNTIME-STATE.md; do
  if [ ! -f "$kit_root/$local_file" ]; then
    candidate="$source_kit/.codex/$local_file"
    [ -f "$candidate" ] || candidate="$source_kit/.codex/templates/$local_file"
    [ -f "$candidate" ] && cp "$candidate" "$kit_root/$local_file"
  fi
done
sed -i.bak "s/^kit_version = .*/kit_version = \"$latest\"/" "$manifest"
rm -f "$manifest.bak"
installed_manifest="$(sed -n 's/^kit_version = \"\(.*\)\"/\1/p' "$manifest")"
installed_kit="$(sed -n 's/^kit_version = \"\(.*\)\"/\1/p' "$kit_root/KIT.toml")"
[ "$installed_manifest" = "$latest" ] && [ "$installed_kit" = "$latest" ] || {
  echo "Échec de cohérence de version après synchronisation." >&2
  exit 1
}
bash "$kit_root/scripts/deliver-workspace-update.sh" "$latest"
printf 'Kit Codex mis à jour : %s -> %s\nSauvegarde : %s\n' "$installed" "$latest" "$backup_root"
