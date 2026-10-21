#!/usr/bin/env bash
set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/hook-runtime.sh"
config="$project_root/.codex"
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
  report=""
fi
if [ -z "$report" ]; then
  archive="$config/reports/agents/$id.md"
  if [ -s "$archive" ]; then report="$archive"; else
    pending="$config/reports/agents/pending.tsv"
    mkdir -p "$(dirname "$pending")"
    if ! awk -F '\t' -v id="$id" '$1 == id { found=1 } END { exit found ? 0 : 1 }' "$pending" 2>/dev/null; then
      printf '%s\t%s\t%s\n' "$id" "${role:-unknown}" "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" >> "$pending"
    fi
    log_event "$(date -u '+%Y-%m-%dT%H:%M:%SZ') | subagent_stop | report-pending | id=$id | role=${role:-unknown}"
    printf '{"decision":"allow","systemMessage":"Sous-agent %s arrêté. Rapport enregistré comme pending; le prochain contrôle le récupérera sans relance automatique."}\n' "$id"
    exit 0
  fi
fi
if [ -z "$report" ]; then
  printf '{"decision":"allow","systemMessage":"Sous-agent %s arrêté sans rapport attaché. Marquer le livrable manquant et ne pas relancer automatiquement."}\n' "$id"
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
