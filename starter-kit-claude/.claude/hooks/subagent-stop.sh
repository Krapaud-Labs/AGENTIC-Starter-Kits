#!/usr/bin/env bash
set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/hook-runtime.sh"
event="$(cat)"
id="$(printf '%s' "$event" | jq -r '.agent_id // "unknown"' 2>/dev/null || echo unknown)"
report="$(printf '%s' "$event" | jq -r '.report_path // .tool_response.report_path // empty' 2>/dev/null || true)"
role="$(printf '%s' "$event" | jq -r '.agent_role // .role // empty' 2>/dev/null || true)"
# Les événements de cycle de vie du Goal peuvent passer par ce hook sans être
# des spécialistes et sans livrable. Ils ne doivent pas être confondus avec
# un spécialiste requis, sinon une référence de Goal orpheline boucle.
if [ -z "$role" ] && [ -z "$report" ]; then
  log_event "$(date -u '+%Y-%m-%dT%H:%M:%SZ') | subagent_stop | non-specialist-event | id=$id"
  printf '{"systemMessage":"Événement de cycle de vie reçu pour %s. Aucun rapport spécialiste attendu."}\n' "$id"
  exit 0
fi
if [ -n "$report" ] && [ ! -f "$report" ]; then
  printf '{"decision":"block","reason":"Rapport du sous-agent absent : %s"}\n' "$id"
  exit 0
fi
if [ -z "$report" ]; then
  printf '{"decision":"block","reason":"Rapport spécialiste absent pour %s"}\n' "$id"
  exit 0
fi
if [ -n "$role" ] && [ -x "$config/scripts/verify-agent-report.sh" ]; then
  if ! bash "$config/scripts/verify-agent-report.sh" "$role" "$id" "$report" >/dev/null 2>&1; then
    printf '{"decision":"block","reason":"Rapport spécialiste incomplet ou incohérent pour %s"}\n' "$id"
    exit 0
  fi
fi
log_event "$(date -u '+%Y-%m-%dT%H:%M:%SZ') | subagent_stop | id=$id | report=${report:-absent}"
printf '{"systemMessage":"Sous-agent %s terminé. Vérifier son livrable, les fichiers touchés et la preuve indépendante avant de cocher sa tâche."}\n' "$id"
