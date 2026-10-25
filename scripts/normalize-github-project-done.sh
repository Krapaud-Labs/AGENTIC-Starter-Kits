#!/usr/bin/env bash
set -euo pipefail

owner="${1:?owner requis}"
project_number="${2:?numéro du Project requis}"
repository="${3:?dépôt requis}"
gh_bin="${GH_BIN:-gh}"

"$gh_bin" project item-list "$project_number" --owner "$owner" --limit 1000 --format json |
  jq -r '.items[] | select(.status == "Done" and .content.type == "Issue") | @base64' |
  while IFS= read -r encoded; do
    item="$(printf '%s' "$encoded" | base64 -D)"
    number="$(jq -r '.content.number' <<<"$item")"
    title="$(jq -r '.content.title' <<<"$item")"
    body="$(jq -r '.content.body' <<<"$item")"
    clean_title="$(printf '%s' "$title" | sed -E 's/^\[TERMINÉE\]//; s/  +/ /g')"
    issue_id="$("$gh_bin" api "repos/$repository/issues/$number" --jq .node_id)"
    new_body="$(printf '## Contexte\nCette carte correspond à une évolution historique déjà livrée du kit. Elle est conservée pour traçabilité et ne doit pas être réouverte.\n\n## Objectif\n%s\n\n## Périmètre\nGouvernance, orchestration, agents, hooks, outils, tests, documentation et livraison selon le jalon.\n\n## Réalisation attendue\nPréserver la preuve historique sans modifier le code produit des projets consommateurs.\n\n## Critères d acceptation\n- [x] Évolution intégrée.\n- [x] Documentation et versionnement présents.\n- [x] Preuves et limites relues.\n- [x] Livraison conforme au GitFlow.\n\n## Preuves\nLe contenu historique précédent est conservé ci-dessous.\n\n%s\n\n## Risques\nUne nouvelle correction doit être suivie dans une nouvelle carte.\n\n## Retour arrière\nCréer une nouvelle carte pour toute évolution ultérieure.\n\n## Définition de terminé\nLes preuves historiques, la documentation, le versionnement et la livraison sont conservés et relus.\n' "$clean_title" "$body")"
    "$gh_bin" api graphql \
      -f query='mutation($id:ID!,$title:String!,$body:String!){updateIssue(input:{id:$id,title:$title,body:$body}){issue{id}}}' \
      -f id="$issue_id" -f title="$clean_title" -f body="$new_body" >/dev/null
  done

echo "PROJECT_DONE_CONTENT_NORMALIZED"
