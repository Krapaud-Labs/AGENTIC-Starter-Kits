# Gouvernance des demandes exceptionnelles

Toute demande hors cahier des charges ou à impact durable doit être classée avant exécution.

## Classification

- `S1` : correction locale sans impact durable. Aucun tableau n'est requis.
- `S2` : modification limitée. Un work item local et une validation ciblée sont requis.
- `S3` : évolution multi-fichiers, multi-agents ou hors cahier des charges. Un work item est obligatoire dans le gestionnaire configuré, ou localement si aucun gestionnaire n’est activé.
- `S4` : sécurité, données, production, architecture ou coût significatif. Un work item dans le gestionnaire configuré (ou localement), un plan de retour arrière et des validations renforcées sont obligatoires.

En cas de doute, la classe supérieure est retenue sans demander une confirmation inutile.

La classification d'une demande ne constitue pas une demande d'autorisation supplémentaire. Lorsque l'utilisateur demande lui-même une évolution nécessitant une carte, l'agent crée immédiatement la carte et le work item, puis poursuit les étapes réversibles prévues. Il ne demande pas à l'utilisateur de confirmer la création de la carte déjà demandée.

## Déclenchement

Un work item est obligatoire dans le gestionnaire configuré si la demande ajoute une fonctionnalité, modifie le périmètre, touche plusieurs domaines, implique plusieurs commits ou tests, modifie l'architecture, la sécurité, les données, les coûts ou la production, ou doit être reprise dans une autre conversation. Si aucun gestionnaire n’est activé, conserver le suivi local.

## Contenu obligatoire

La carte et le work item local sont créés avant toute modification structurante. Ils contiennent le contexte, l'objectif, les périmètres inclus et exclus, les agents, les dépendances, les décisions d'architecture, les risques, le retour arrière, les sous-tâches, les tests, les documents attendus et une Definition of Done vérifiable.

## Exécution

1. Classer la demande et créer le work item.
2. Créer ou mettre à jour l’élément dans le gestionnaire configuré et utiliser le statut `In Progress`.
3. Exécuter toutes les tâches autonomes sans interruption inutile.
4. Synchroniser le journal, le work item et le gestionnaire configuré aux checkpoints importants. Relire après chaque écriture distante et à la fin d’un lot, en cas de blocage ou reprise, à la livraison, à la PR, à la CI et à la fusion. Regrouper les mises à jour liées au même checkpoint.
5. Mettre à jour le code, les tests, la sécurité et la documentation.
6. Regrouper la livraison sur une seule branche et une seule PR finale.
7. Attendre tous les contrôles CI et validations prévus.
8. Utiliser une étiquette ou métadonnée de revue uniquement lorsqu’une validation humaine reste réellement nécessaire.
9. Utiliser `Done` uniquement lorsque toute la Definition of Done est prouvée.

Une réponse de simple statut sans action observable, preuve ou prochaine action persistée est invalide.

## Gestionnaire indisponible

Si le gestionnaire configuré est indisponible, créer ou conserver l’équivalent local dans `work-items/`, journaliser l’absence de synchronisation et ne jamais prétendre qu’un élément distant existe. Reprendre les écritures et relire l’état distant lorsque l’intégration revient.
