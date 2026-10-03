# Cycle de vie des sessions navigateur

## Principe

Une session navigateur est une ressource de travail temporaire. Le Coordinateur l'ouvre seulement pour une action identifiée, réutilise la session générale déjà disponible lorsque c'est sûr, puis la ferme dès que le lot externe est terminé.

## Ouverture et réutilisation

- Enregistrer dans le work item l'objectif, le domaine, l'identifiant de session et l'état de connexion.
- Réutiliser une session existante pour Trello, GitHub, VPS, Dokploy ou une validation frontend si elle est saine et autorisée.
- Ne pas ouvrir de navigateur dédié par service sans besoin technique démontré.
- Ne jamais fermer une session si une autre action autonome du Goal en dépend.

## Fermeture obligatoire

Après chaque feature, carte, validation externe ou lot navigateur terminé, le Coordinateur doit relire la preuve, synchroniser l'outil concerné, fermer les onglets sensibles et demander la fermeture de la session si aucune action suivante n'en dépend.

Avant de déclarer la session fermée, vérifier que les téléchargements sont terminés, qu'aucun formulaire non envoyé ne contient de donnée sensible, qu'aucune fenêtre d'authentification ou de paiement n'est laissée ouverte et que le statut est enregistré dans l'état runtime.

Si la session ne peut pas être fermée proprement, enregistrer la cause, l'URL concernée, l'action restante et le risque. La carte ne peut pas être déclarée `complete` tant qu'une action navigateur nécessaire reste ouverte ou non vérifiée.

## Fin de Goal

Avant `complete`, `needs-review` ou `blocked`, exécuter une revue de sessions : `browser_session_status = closed` ou `not-required`, aucun onglet sensible ouvert, aucune action externe en attente et preuve de fermeture enregistrée. Une session laissée ouverte par commodité est une non-conformité.
