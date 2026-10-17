# Skill documentation-audit

## Objectif

Ce Skill rend la documentation complète, vérifiable et exploitable.

## Mission

Auditer la qualité et la cohérence de la documentation avant livraison.

## Contrôles

- Présence des documents obligatoires.
- Métadonnées et statut cohérents.
- Absence de `[[A_COMPLETER]]`.
- Liens internes et chemins existants.
- Cohérence entre profil, code, API, diagrammes, tests et README.
- Exemples reproductibles ou limites documentées.
- Risques, décisions et alternatives tracés.
- Synchronisation du code avec les README, la conception, les work items, le journal qualité, le changelog, les preuves et Trello si activé.

## Décision

Retourner `accepted`, `rework` ou `blocked` avec une preuve par anomalie.

## Entrées

Cahier des charges accepté, profil projet, décisions, work items et fichiers impactés.

## Procédure

Lire les sources, rédiger ou auditer, puis exécuter le validateur documentaire.

## Sortie

Document complet ou rapport d’audit avec preuves, inconnues et risques résiduels.

## Mesures

Nombre de documents contrôlés, anomalies trouvées, corrections et limites restantes.

## Arrêt

Si une preuve manque, la produire ou la déléguer et poursuivre les tâches indépendantes. Si une décision métier est nécessaire, préparer les options et conserver une `next_action` explicite. Si le document reste incohérent avec le code, corriger la documentation dans le même work item puis relancer l'audit. N'arrêter que lorsqu'une décision humaine indispensable ou une dépendance externe inaccessible est le seul obstacle restant.
