# Skill github-projects-planning

## Objectif

Utiliser GitHub Projects comme système de suivi principal du projet, relié aux Issues, aux Pull Requests et au Git Flow.

## Entrées

Cahier des charges accepté, conception validée, profil projet, work items et accès GitHub disponibles.

## Règle de démarrage

Après acceptation du cahier des charges, créer ou reprendre un Project GitHub au niveau de l’organisation ou du dépôt. Ne jamais créer un doublon sans rechercher d’abord un Project portant le même nom. Si l’intégration GitHub n’est pas disponible, produire le manifeste local et enregistrer `pending_activation` sans annoncer une synchronisation distante.

## Modèle obligatoire

Chaque carte Trello devient une Issue GitHub numérotée et traçable, ajoutée au Project. Utiliser les labels nommés, le champ `Status`, `Priority`, `Assignees`, `Iteration`, les dates et les dépendances quand ils sont disponibles. Les checklists sont des tâches Markdown dans l’Issue, avec une dernière tâche obligatoire avant PR : `Mettre à jour et relire les README, la documentation, le changelog et les notes de release applicables avant la PR`.

## Procédure

1. Lire le cahier, la conception, le profil, les work items et les décisions.
2. Auditer la couverture MVP et Post-MVP et créer toutes les Issues détaillées nécessaires.
3. Attribuer un identifiant stable et séquentiel à chaque Issue, par exemple `[MVP-001]` ou `[POST-MVP-001]`.
4. Ajouter labels, description détaillée, dépendances, critères d’acceptation, preuves attendues et Definition of Done.
5. Ajouter chaque Issue au Project et régler son statut dans l’ordre `Backlog`, `Ready`, `In Progress`, `Review`, `Done`.
6. Relire via GitHub l’Issue, les labels, le Project, le statut, les tâches et les relations après chaque création ou modification.
7. Pour une carte multi-lots, créer le Goal et les agents spécialistes avant le démarrage, puis inscrire la partition dans l’Issue et le Goal.
8. Une Issue correspond à une branche et une seule PR finale. Les commits restent sur la branche jusqu’à la Definition of Done.
9. La PR n’est créée qu’après fermeture de toutes les tâches, y compris la documentation et les notes de release. La fusion vers `dev` doit être vérifiée avant de marquer l’Issue `Done`.

## Contrôles bloquants

Une Issue sans numéro, label, description détaillée, critères, checklist, preuve ou statut correct est invalide. Une Issue ne passe pas à `Review` ou `Done` tant que toutes ses tâches et preuves ne sont pas relues. Toute demande hors cahier est classée hors périmètre et ne devient pas une Issue sans décision tracée.

## Synchronisation

Synchroniser et relire le Project après chaque changement significatif : création, assignation, changement de statut, tâche cochée, commit, push, PR, CI, correction, blocage, déblocage et fusion. Conserver dans `docs/project-management/github-project.md` l’URL, l’identifiant du Project, les vues, les champs, les labels et la matrice de couverture.

## Sortie

Project GitHub réellement créé ou repris, Issues détaillées et relues, labels et champs vérifiés, couverture du cahier complète, et statut local `verified` uniquement avec preuve distante.

## Mesures

Mesurer la couverture des exigences, le nombre d’Issues relues, les tâches ouvertes, les labels manquants et les preuves distantes confirmées.

## Arrêt

Arrêter et signaler précisément l’écart si l’accès GitHub, le cahier accepté, la conception ou une preuve distante manque. Ne jamais déclarer `verified` sans relecture réelle.
