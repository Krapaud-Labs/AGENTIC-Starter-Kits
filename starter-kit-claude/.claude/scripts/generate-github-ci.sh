#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
root="$(git -C "$config/.." rev-parse --show-toplevel 2>/dev/null || (cd "$config/.." && pwd))"
target="$root/.github/workflows/claude-orchestration.yml"

if [ -e "$target" ]; then echo "Workflow existant, aucune écriture: $target"; exit 1; fi
mkdir -p "$root/.github/workflows"
trigger=$'  pull_request:\n    branches: [main, develop]\n  workflow_dispatch:'
mode="$(sed -n 's/^ci_trigger_mode = "\(.*\)"/\1/p' "$config/project-profile.toml" 2>/dev/null || true)"
if [ "$mode" = "every-push" ]; then
  trigger=$'  pull_request:\n    branches: [main, develop]\n  push:\n    branches: [main, develop]\n  workflow_dispatch:'
fi
printf '%s\n' \
  'name: Claude orchestration gates' '' 'on:' "$trigger" '' \
  'jobs:' '  quality:' '    runs-on: ubuntu-latest' '    steps:' '      - uses: actions/checkout@v4' \
  '      - uses: actions/setup-python@v5' '        with:' '          python-version: "3.11"' \
  '      - name: Install ripgrep' '        run: sudo apt-get update && sudo apt-get install -y ripgrep' \
  '      - name: Preflight' '        run: bash .claude/scripts/preflight.sh' \
  '      - name: Project checks' '        run: bash .claude/scripts/run-project-checks.sh --execute' > "$target"
echo "Workflow créé: $target"
