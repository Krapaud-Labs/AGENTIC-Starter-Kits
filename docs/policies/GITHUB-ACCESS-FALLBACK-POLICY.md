# Politique d'accès GitHub et de repli

## Principe

L'échec du binaire local `gh` ne signifie pas que GitHub est indisponible. Chaque capacité doit être testée séparément et l'exécution doit utiliser la première voie réellement disponible.

## Ordre des voies

1. Connecteur GitHub exposé par la session.
2. API GitHub authentifiée exposée par l'environnement de l'agent.
3. Chrome connecté de l'utilisateur, uniquement pour les opérations absentes de l'API ou lorsque l'utilisateur a explicitement demandé cette voie.
4. Binaire local `gh`, en dernier recours.

## Règles obligatoires

- `gh auth status` est un diagnostic du CLI, pas un diagnostic de GitHub.
- Un token `gh` invalide doit être enregistré comme `cli_unavailable`.
- Une API, un connecteur ou une session Chrome fonctionnelle doit permettre la poursuite sans demander à l'utilisateur de réauthentifier `gh`.
- Les opérations Project V2 doivent vérifier que la mutation demandée est réellement exposée avant de choisir un fallback.
- Après chaque mutation, relire la ressource par la même voie ou par une voie de lecture indépendante.
- Ne jamais annoncer GitHub indisponible sans avoir testé les voies exposées.
- Ne jamais ouvrir ou utiliser Chrome si une API capable de réaliser l'action est disponible.

## Classification des échecs

- `api_unavailable` signifie que l'API ou le connecteur requis n'est pas exposé ou ne répond pas.
- `cli_unavailable` signifie que seul le binaire `gh` échoue.
- `browser_unavailable` signifie que Chrome ne peut pas être utilisé lorsque son emploi est nécessaire.
- `permission_denied` signifie que la voie répond mais refuse l'opération.

Seul `api_unavailable` sans fallback admissible peut bloquer une opération GitHub. Un échec `cli_unavailable` ne doit jamais bloquer à lui seul.
