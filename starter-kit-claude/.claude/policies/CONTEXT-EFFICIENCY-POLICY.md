# Politique d'efficacité du contexte

Cette politique réduit les tokens et les appels sans réduire les contrôles.

## Chargement par niveaux

Au démarrage, charger seulement le contrat d'entrée, l'index d'orchestration, le profil, l'état runtime et le work item actif. Charger une policy, un Skill ou un document complet uniquement lorsqu'une règle de son domaine est déclenchée. Les documents déjà relus dans la session sont réutilisés tant que leur empreinte n'a pas changé.

Le script `scripts/prepare-context-manifest.sh` crée le manifeste de session local avec le chemin, l'empreinte, la taille, la version et l'heure de lecture des documents. Une empreinte identique autorise la réutilisation du résumé précédent. Une empreinte différente impose une nouvelle lecture complète avant toute action concernée.

## Contexte à ne pas charger intégralement

Ne jamais charger intégralement `CHANGELOG.md`, `VERSION-HISTORY.md`, un README, un historique d'audit ou un répertoire de logs pour une action courante. Rechercher uniquement le sujet, le work item, la version ou l'incident concerné, puis lire le contexte local nécessaire.

Les rapports d'agents sont résumés par le Coordinateur avec le statut, la preuve, les fichiers touchés et la prochaine action. Le rapport complet reste un artefact consultable, pas un préfixe obligatoire de chaque appel.

## Délégation économique

Avant de créer ou réactiver un agent, estimer le périmètre, les fichiers communs et le livrable. Ne lancer un agent que s'il possède un livrable indépendant et mesurable. Les agents parallèles partagent un résumé court et les chemins autorisés, jamais l'intégralité du dépôt ou de l'historique conversationnel.

Le Coordinateur regroupe les contrôles compatibles dans une commande ou un appel d'outil lorsque cela ne réduit pas la traçabilité. Il ne répète pas une commande identique sans changement d'état ou nouvelle preuve.

## Limites de reprise

Un échec réessayable utilise un nombre limité de tentatives et une alternative différente. Les messages de statut ne recopient pas l'historique. Ils indiquent seulement le changement observé, la preuve et l'action suivante.

Cette politique ne permet jamais d'omettre une instruction de sécurité, une obligation applicable, une preuve requise ou une relecture d'un fichier modifié.
