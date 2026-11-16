#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
root="$(git -C "$config/.." rev-parse --show-toplevel 2>/dev/null || (cd "$config/.." && pwd))"
target="$root/.github/workflows/claude-orchestration.yml"

if [ -e "$target" ]; then echo "Workflow existant, aucune écriture: $target"; exit 1; fi
gate_config="$(bash "$script_dir/python.sh" - "$config/project-profile.toml" <<'PY'
import pathlib, sys, tomllib
try:
    profile = tomllib.loads(pathlib.Path(sys.argv[1]).read_text())
except (OSError, tomllib.TOMLDecodeError) as exc:
    raise SystemExit(f"CI billing gate: project-profile.toml absent ou invalide: {exc}")
delivery = profile.get("delivery", {})
visibility = str(delivery.get("github_repository_visibility", "unknown")).strip().lower()
approved = delivery.get("github_actions_private_billing_approved", False)
evidence = str(delivery.get("github_actions_usage_limit_evidence", "")).strip()
timeout = delivery.get("github_actions_max_minutes_per_run", 30)
if visibility not in {"public", "private", "unknown"}:
    raise SystemExit("CI billing gate: github_repository_visibility doit valoir public, private ou unknown")
if not isinstance(approved, bool):
    raise SystemExit("CI billing gate: github_actions_private_billing_approved doit être un booléen")
if not isinstance(timeout, int) or isinstance(timeout, bool) or not 1 <= timeout <= 360:
    raise SystemExit("CI billing gate: github_actions_max_minutes_per_run doit être compris entre 1 et 360")
if visibility != "public":
    if not approved:
        raise SystemExit("CI billing gate: dépôt privé ou visibilité inconnue; approbation explicite requise avant runner hébergé")
    if not evidence or evidence.lower() in {"none", "unknown", "[[a_completer]]"}:
        raise SystemExit("CI billing gate: preuve documentée d’une limite d’usage GitHub requise pour un runner hébergé privé")
print(visibility, timeout)
PY
)" || exit 1
read -r visibility timeout_minutes <<< "$gate_config"
mkdir -p "$root/.github/workflows"
trigger=$'  pull_request:\n    branches: [main, dev, develop]\n  workflow_dispatch:'
mode="$(sed -n 's/^ci_trigger_mode = "\(.*\)"/\1/p' "$config/project-profile.toml" 2>/dev/null || true)"
if [ "$mode" = "every-push" ]; then
  trigger=$'  pull_request:\n    branches: [main, dev, develop]\n  push:\n    branches: [main, dev, develop]\n  workflow_dispatch:'
fi
printf '%s\n' \
  'name: Claude orchestration gates' '' 'on:' "$trigger" '' \
  'permissions:' '  contents: read' '' \
  'concurrency:' '  group: claude-orchestration-${{ github.workflow }}-${{ github.ref }}' '  cancel-in-progress: true' '' \
  'jobs:' '  quality:' '    runs-on: ubuntu-latest' "    timeout-minutes: $timeout_minutes" '    steps:' '      - uses: actions/checkout@v4' \
  '      - uses: actions/setup-python@v5' '        with:' '          python-version: "3.11"' \
  '      - name: Install ripgrep' '        run: sudo apt-get update && sudo apt-get install -y ripgrep' \
  '      - name: Preflight' '        run: bash .claude/scripts/preflight.sh' \
  '      - name: Project checks' '        run: bash .claude/scripts/run-project-checks.sh --execute' > "$target"
echo "Workflow créé: $target"
