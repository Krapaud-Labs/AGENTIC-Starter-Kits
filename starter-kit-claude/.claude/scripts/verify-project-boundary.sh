#!/usr/bin/env bash
set -euo pipefail

root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
forbidden='agentic|agentic starter kits|starter kit|\.codex|\.claude'
violations=()
base_ref="${BOUNDARY_BASE_REF:-develop}"
base="$(git -C "$root" merge-base HEAD "$base_ref" 2>/dev/null || true)"
if [ -z "$base" ]; then
  echo "Frontière projet: branche de référence absente, contrôle différé à la première PR d'intégration."
  exit 0
fi
while IFS= read -r file; do
  case "$file" in
    .codex/*|.claude/*|AGENTS.md|CLAUDE.md|.workspace.toml|.github/workflows/update-agentic-starter-kit.yml) continue ;;
  esac
  if rg -n -i --hidden --glob '!node_modules/**' --glob '!.git/**' "$forbidden" "$root/$file" >/dev/null 2>&1; then
    violations+=("$file")
  fi
done < <(git -C "$root" diff --name-only "$base" HEAD)

if [ "${#violations[@]}" -gt 0 ]; then
  printf '%s\n' "FRONTIÈRE PROJET: références interdites détectées dans :" "${violations[@]}"
  exit 1
fi
echo "Frontière projet OK: aucun détail interne exposé dans les livrables suivis."
