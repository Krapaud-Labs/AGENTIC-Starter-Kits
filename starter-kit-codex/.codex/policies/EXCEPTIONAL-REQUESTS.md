# Gouvernance des demandes exceptionnelles

Toute demande hors cahier des charges ou à impact durable doit être classée avant exécution.

## Classification

- `S1` : correction locale sans impact durable. Aucun tableau n'est requis.
- `S2` : modification limitée. Un work item local et une validation ciblée sont requis.
- `S3` : évolution multi-fichiers, multi-agents ou hors cahier des charges. Une carte Trello est obligatoire.
- `S4` : sécurité, données, production, architecture ou coût significatif. Une carte Trello, un plan de retour arrière et des validations renforcées sont obligatoires.

En cas de doute, la classe supérieure est retenue sans demander une confirmation inutile.

La classification d'une demande ne constitue pas une demande d'autorisation supplémentaire. Lorsque l'utilisateur demande lui-même une évolution nécessitant une carte, l'agent crée immédiatement la carte et le work item, puis poursuit les étapes réversibles prévues. Il ne demande pas à l'utilisateur de confirmer la création de la carte déjà demandée.

## Déclenchement

Une carte Trello est obligatoire si la demande ajoute une fonctionnalité, modifie le périmètre, touche plusieurs domaines, implique plusieurs commits ou tests, modifie l'architecture, la sécurité, les données, les coûts ou la production, ou doit être reprise dans une autre conversation.

## Contenu obligatoire

La carte et le work item local sont créés avant toute modification structurante. Ils contiennent le contexte, l'objectif, les périmètres inclus et exclus, les agents, les dépendances, les décisions d'architecture, les risques, le retour arrière, les sous-tâches, les tests, les documents attendus et une Definition of Done vérifiable.

## Exécution

1. Classer la demande et créer le work item.
2. Créer ou synchroniser Trello et passer la carte en `En cours`.
3. Exécuter toutes les tâches autonomes sans interruption inutile.
4. Synchroniser le journal, le work item et Trello après chaque étape significative.
5. Mettre à jour le code, les tests, la sécurité et la documentation.
6. Regrouper la livraison sur une seule branche et une seule PR finale.
7. Attendre tous les contrôles CI et validations prévus.
8. Utiliser `Revue` uniquement lorsqu'une validation humaine reste réellement nécessaire.
9. Utiliser `Terminé` uniquement lorsque toute la Definition of Done est prouvée.

Une réponse de simple statut sans action observable, preuve ou prochaine action persistée est invalide.

## Trello indisponible

Si Trello est indisponible, créer immédiatement l'équivalent local dans le dossier `work-items/`, journaliser l'absence de synchronisation et ne jamais prétendre qu'une carte distante existe. Synchroniser dès que le plugin redevient disponible.
