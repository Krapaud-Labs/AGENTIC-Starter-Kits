#!/usr/bin/env bash
set -euo pipefail
root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
config="$root/.codex"
tools_script="$config/scripts/ensure-tools.sh"
gate_script="$config/scripts/session-start-gate.sh"
if [ -x "$gate_script" ]; then bash "$gate_script"; fi
tool_context=""
report_context=""
if [ -x "$tools_script" ]; then
  if ! tool_output="$($tools_script --bootstrap 2>&1)"; then
    printf '%s\n' "$tool_output" >&2
    exit 1
  fi
  tool_context=" Outils centraux verifies et PATH partage initialise depuis AGENTIC_TOOLS_HOME."
fi
remote_url="$(git config --get remote.origin.url 2>/dev/null || true)"
if printf '%s' "$remote_url" | grep -qi 'AGENTIC-Starter-Kits'; then
  report_script="$root/scripts/check-kit-reports.sh"
  if [ -x "$report_script" ]; then
    report_output="$(KIT_REPORT_FAIL_ON_BLOCKING=1 KIT_REPORT_REPOSITORY=Krapaud-Labs/AGENTIC-Starter-Kits bash "$report_script" 2>&1 || true)"
    report_context=" Rapports kit priorises au demarrage: $(printf '%s' "$report_output" | tr '\n' ' ' | cut -c1-900)."
  fi
fi
if [ ! -f "$config/RUNTIME-STATE.md" ] && [ -f "$config/templates/RUNTIME-STATE.md" ]; then
  cp "$config/templates/RUNTIME-STATE.md" "$config/RUNTIME-STATE.md"
fi
version="$(sed -n 's/^kit_version = "\([^"]*\)"/\1/p' "$config/KIT.toml" 2>/dev/null || echo unknown)"
status="$(sed -n 's/^- execution_status: //p' "$config/RUNTIME-STATE.md" 2>/dev/null | head -1 || true)"
goal="$(sed -n 's/^- goal_status: //p' "$config/RUNTIME-STATE.md" 2>/dev/null | head -1 || true)"
printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"Contrat agentic %s. État runtime %s. Goal %s.%s%s Lire AGENTS.md, l’état runtime et les politiques avant toute action. Créer ou reprendre le Goal natif et les agents requis avant toute modification."}}\n' "$version" "${status:-absent}" "${goal:-absent}" "$tool_context" "$report_context"
