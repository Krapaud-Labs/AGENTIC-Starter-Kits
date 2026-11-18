---
name: github-projects-planning
description: Planifie et synchronise les Issues et Projects GitHub lorsque ce gestionnaire est sélectionné dans le profil.
---

# Skill github-projects-planning

## Objectif

Utiliser GitHub Issues et GitHub Projects comme système de suivi uniquement lorsque `tracking.mode = "github"` et `github_projects_choice = "enabled"`.

## Quand l’utiliser

Ce Skill s’applique uniquement si GitHub Projects est le gestionnaire sélectionné dans `project-profile.toml`. Pour `tracking.mode = "local"`, conserver les work items dans le dépôt et ne créer aucune ressource distante. Pour `tracking.mode = "trello"`, utiliser `trello-planning`.

## Entrées

Cahier des charges accepté, conception validée, profil projet, work items et accès GitHub disponibles.

## Règle de démarrage

Avant toute création, rechercher un Project au niveau de l’organisation ou du dépôt portant le même nom et le reprendre s’il existe. Si l’intégration GitHub n’est pas disponible, conserver le plan et les work items localement, enregistrer `pending_activation`, poursuivre le travail indépendant et ne jamais annoncer une synchronisation distante réussie.

## Capacités et modèle de suivi

Une Issue GitHub est l’élément de travail détaillé. Lorsqu’un Project est activé, ajouter l’Issue au Project et relier les deux dans le document local. Les tâches sont une checklist Markdown dans le corps de l’Issue. Utiliser les labels et les champs natifs disponibles, par exemple `Status`, `Priority`, `Assignees`, `Iteration`, dates et relations de dépendance, sans prétendre qu’un champ ou une checklist native existe s’il n’est pas exposé.

Les trois statuts de travail canoniques sont `Todo`, `In Progress` et `Done`. Les refléter dans le champ `Status` lorsqu’ils sont disponibles. Préserver les autres champs et options natifs; si les libellés natifs diffèrent, documenter leur correspondance avec ces trois statuts sans renommer ni remplacer les options. Le blocage, la revue, la priorité et les échéances restent des labels ou métadonnées, pas des colonnes de travail.

## Procédure

1. Confirmer que GitHub Projects est le gestionnaire choisi dans le profil, puis lire le cahier, la conception, les work items et les décisions.
2. Auditer la couverture MVP et Post-MVP et créer les Issues détaillées nécessaires.
3. Attribuer à chaque Issue un identifiant stable et séquentiel, par exemple `[MVP-001]` ou `[POST-MVP-001]`.
4. Ajouter les labels disponibles, une description détaillée, les dépendances, les critères d’acceptation, les preuves attendues et la Definition of Done.
5. Ajouter chaque Issue au Project sélectionné si cette capacité est disponible. Régler `Status` selon `Todo`, `In Progress` ou `Done`; ne pas créer les colonnes `Ready` ou `Review`.
6. Relire via GitHub l’Issue, les labels, le Project, les champs utilisés, les tâches et les relations après chaque écriture distante.
7. Pour une Issue multi-lots, créer ou reprendre le Goal et les agents spécialistes avant le démarrage, puis inscrire la partition dans l’Issue et le Goal.
8. Une Issue correspond à une branche et une seule PR finale. Les commits restent sur la branche jusqu’à la Definition of Done.
9. Créer la PR après les tâches requises, y compris documentation et notes de version. Vérifier la fusion vers `dev` avant de marquer le travail `Done`.

## Contrôles bloquants

Une Issue sans identifiant, périmètre, critères, tâches, preuve attendue ou statut conforme est incomplète. `Review` ne termine pas une Issue et ne devient pas une colonne; seule une Definition of Done prouvée autorise `Done`. Toute demande hors cahier est classée hors périmètre et ne devient pas une Issue sans décision tracée.

## Synchronisation

Relire l’état distant après chaque écriture et aux checkpoints importants : fin de lot, blocage ou reprise, livraison, PR, CI et fusion. Conserver dans `docs/project-management/github-project.md` l’URL et l’identifiant du Project, les vues et champs réellement disponibles, les labels utilisés et la matrice de couverture. Sans Project distant disponible, conserver le suivi local et l’état `pending_activation`.

## Sortie

Issues détaillées et relues, éléments du Project reliés lorsque cette capacité est activée, labels et champs réellement disponibles vérifiés, couverture du cahier complète et statut local `verified` uniquement avec une preuve distante complète.

## Mesures

Mesurer la couverture des exigences, les Issues et éléments Project effectivement relus, les tâches ouvertes, les labels manquants et les preuves distantes confirmées.

## Arrêt

Arrêter la synchronisation distante et signaler précisément l’écart si l’accès GitHub, le cahier accepté, la conception ou une preuve distante manque. Le travail indépendant peut continuer localement. Ne jamais déclarer `verified` sans relecture réelle.
