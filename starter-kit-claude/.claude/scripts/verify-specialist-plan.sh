#!/usr/bin/env bash
set -euo pipefail
domain="${1:-}"; agents="${2:-}"; evidence="${3:-}"
[ -n "$domain" ] && [ -n "$agents" ] && [ -n "$evidence" ] || { echo "AGENTS: domaine, agents et preuve requis" >&2; exit 1; }
case "$domain" in
  visual|frontend|responsive)
    for role in frontend qa auditeur; do
      case ",$agents," in *,"$role",*) ;; *) echo "AGENTS: $role requis pour une tâche visuelle" >&2; exit 1 ;; esac
    done
    ;;
esac
echo "Plan spécialisé vérifié: domaine=$domain agents=$agents"
