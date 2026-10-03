#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
root="$(git -C "$config/.." rev-parse --show-toplevel 2>/dev/null || { echo "Git requis pour valider un push"; exit 1; })"

bash "$script_dir/verify-consumer-index.sh"

if [ -f "$root/.workspace.toml" ]; then
  echo "Mode external détecté: validation du kit et des fichiers publiables uniquement"
  if git -C "$root" ls-files --error-unmatch .codex AGENTS.md >/dev/null 2>&1; then
    echo "ECHEC EXTERNAL: .codex ou AGENTS.md est suivi par Git"
    exit 1
  fi
  if rg -n --hidden --glob '!.git/**' --glob '!.codex/**' --glob '!.claude/**' --glob '!node_modules/**' -- '-----BEGIN (RSA|OPENSSH|EC|PRIVATE) KEY-----|AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{20,}|sk-[A-Za-z0-9]{20,}' "$root"; then
    echo "ECHEC EXTERNAL: secret potentiel détecté"
    exit 1
  fi
  git -C "$root" diff --check
  workflow="$root/.github/workflows/update-workspace-kit.yml"
  [ -f "$workflow" ] || { echo "ECHEC EXTERNAL: workflow de mise à jour absent"; exit 1; }
  grep -q 'Update workspace kit' "$workflow" || { echo "ECHEC EXTERNAL: workflow invalide"; exit 1; }
  bash "$script_dir/validate-obligations.sh" --if-present
  echo "Validation external avant push OK"
  exit 0
fi

"$script_dir/python.sh" - "$config/project-profile.toml" <<'PY'
import pathlib, sys, tomllib
profile = tomllib.loads(pathlib.Path(sys.argv[1]).read_text())
capabilities = profile.get('capabilities', {})
commands = profile.get('commands', {})
if capabilities.get('frontend') or capabilities.get('backend'):
    missing = [name for name in ('lint', 'test') if not str(commands.get(name, '')).strip()]
    if missing:
        print(f'ECHEC: commandes obligatoires pour projet applicatif: {", ".join(missing)}')
        raise SystemExit(1)
PY

read -r integration_branch require_feature_branch max_files max_lines < <(
  "$script_dir/python.sh" - "$config/project-profile.toml" <<'PY'
import pathlib, sys, tomllib
profile = tomllib.loads(pathlib.Path(sys.argv[1]).read_text())
delivery = profile.get('delivery', {})
print(
    profile.get('integration_branch', 'develop'),
    str(delivery.get('require_feature_branch', True)).lower(),
    delivery.get('max_files_per_commit', 75),
    delivery.get('max_changed_lines_per_commit', 1200),
)
PY
)

branch="$(git -C "$root" branch --show-current)"
protected_branch=false
case "$branch" in
  dev|develop|main|master) protected_branch=true ;;
esac
if [ "$protected_branch" = "true" ] || { [ "$require_feature_branch" = "true" ] && [ -z "$branch" ]; }; then
  echo "ECHEC GITFLOW: créer une branche de travail avant le push, aucun push direct vers dev, develop, main ou master"
  exit 1
fi
if [ "$require_feature_branch" = "true" ]; then
  case "$branch" in feature/*|fix/*|hotfix/*|chore/*|docs/*|refactor/*|test/*) ;; *)
    echo "ECHEC GITFLOW: branche invalide $branch. Utiliser feature/, fix/, hotfix/, chore/, docs/, refactor/ ou test/"
    exit 1 ;;
  esac
fi

base="$(git -C "$root" merge-base HEAD "$integration_branch" 2>/dev/null || true)"
if [ -n "$base" ]; then
  while IFS= read -r commit; do
    files="$(git -C "$root" diff-tree --no-commit-id --name-only -r "$commit" | wc -l | tr -d ' ')"
    lines="$(git -C "$root" diff-tree --no-commit-id --numstat -r "$commit" | awk '{add += ($1 == "-" ? 0 : $1); del += ($2 == "-" ? 0 : $2)} END {print add + del}')"
    changed_paths="$(git -C "$root" diff-tree --no-commit-id --name-only -r "$commit")"
    only_generated=true
    while IFS= read -r path; do
      case "$path" in
        *-lock.yaml|*-lock.yml|package-lock.json|npm-shrinkwrap.json|yarn.lock|Cargo.lock|composer.lock|Gemfile.lock|poetry.lock) ;;
        *) only_generated=false ;;
      esac
    done <<< "$changed_paths"
    if [ "$files" -gt "$max_files" ] || [ "$lines" -gt "$max_lines" ]; then
      if [ "$only_generated" = "true" ]; then
        echo "AVERTISSEMENT GITFLOW: commit $commit contient un artefact généré incompressible ($files fichiers, $lines lignes). Il est accepté uniquement isolé et sans code métier."
      else
        echo "ECHEC GITFLOW: commit $commit touche $files fichiers et $lines lignes. Limites: $max_files fichiers, $max_lines lignes. Découper la feature en commits atomiques."
        exit 1
      fi
    fi
  done < <(git -C "$root" rev-list "$base"..HEAD)
fi

git -C "$root" diff --check
bash "$script_dir/validate-obligations.sh" --if-present
bash "$script_dir/preflight.sh"
bash "$script_dir/verify-project-boundary.sh"
bash "$script_dir/run-project-checks.sh" --execute
echo "Validation avant push OK"
