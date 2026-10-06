#!/usr/bin/env bash
set -euo pipefail
root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
config="$root/.claude"
version="$(sed -n 's/^kit_version = "\([^"]*\)"/\1/p' "$config/KIT.toml" 2>/dev/null || echo unknown)"
status="$(sed -n 's/^- execution_status: //p' "$config/RUNTIME-STATE.md" 2>/dev/null | head -1 || true)"
goal="$(sed -n 's/^- goal_status: //p' "$config/RUNTIME-STATE.md" 2>/dev/null | head -1 || true)"
printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"Contrat agentic %s. État runtime %s. Goal %s. Lire CLAUDE.md, l’état runtime et les politiques avant toute action. Créer ou reprendre le Goal natif et les agents requis avant toute modification."}}\n' "$version" "${status:-absent}" "${goal:-absent}"
