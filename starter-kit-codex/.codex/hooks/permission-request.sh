#!/usr/bin/env bash
set -euo pipefail
event="$(cat)"
command="$(printf '%s' "$event" | jq -r '.tool_input.command // empty' 2>/dev/null || true)"
tool="$(printf '%s' "$event" | jq -r '.tool_name // empty' 2>/dev/null || true)"
if printf '%s' "$command" | grep -Eiq '(curl|wget|http(ie)?)[[:space:]].*api[.](openai|anthropic)[.]com|git[[:space:]]+push([[:space:]]+--force)? .* (main|master|dev|develop)|rm[[:space:]]+[-][r][f]|chmod[[:space:]]+[7][7][7]|g[h][[:space:]]+[p]r[[:space:]]+[c]reate'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"deny","message":"Action refusée par le kit : API payante, branche protégée ou commande destructive détectée."}}}\n'
else
  printf '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"allow"},"additionalContext":"Permission évaluée pour l’outil %s. Les contrôles de périmètre et de Goal restent obligatoires."}}\n' "$tool"
fi
