# Trello Visual System

## Purpose

Every project board must be immediately understandable without reading every card. The Coordinateur creates or reuses a consistent visual system before creating cards.

## Langue obligatoire

Tout contenu rédigé dans Trello doit être exclusivement en français : noms de tableaux, listes, cartes, descriptions, checklists, commentaires, preuves, décisions, étiquettes nommées et messages de synchronisation. Les noms techniques incompressibles, commandes, identifiants, URLs, noms de branches et extraits de logs peuvent rester dans leur forme originale, mais toute explication autour doit être en français. Le Coordinateur traduit le contenu avant publication et relit le texte réellement affiché après chaque enregistrement. Une carte partiellement rédigée en anglais n'est pas conforme et ne peut pas être déclarée terminée.

## Standard lists

Create missing lists in this order:

1. `À trier`
2. `Prêt à concevoir`
3. `Conception en cours`
4. `Prêt à développer`
5. `En développement`
6. `En revue`
7. `En validation`
8. `Bloqué`
9. `Terminé`
10. `Archivé`

Après chaque création ou reprise, relire les positions réelles et réordonner explicitement les listes. Si Trello place les nouvelles listes en tête, créer dans l'ordre inverse ou utiliser le réordonnancement. La synchronisation reste non vérifiée tant que cette séquence n'est pas confirmée.

Use `Inbox` only for captured requests. Move a card to `Ready` after its scope, owner, dependencies and Definition of Done are complete. A card remains in `In Progress` while work is active. Use `Blocked` only with a documented blocker and next action. Use `Review` only when implementation is complete and a real review remains. Use `Done` only after every checklist item is proven. The final checklist item before opening the card branch PR must always update and reread applicable README files, documentation, changelog and release notes. The PR is forbidden until this item is proven; after the PR, reread it again before `Done`.

### Dimensionnement selon l'équipe

Les listes de gouvernance restent stables (`Inbox`, `Ready`, `Blocked`, `Review`, `Done`, `Archived`). Les colonnes de travail remplacent `In Progress` selon le nombre de personnes réellement affectées au projet, après déduplication des membres et confirmation de leur rôle :

`work_columns = min(4, max(1, ceil(active_members / 2)))`

- 1 ou 2 personnes : une colonne `In Progress`.
- 3 ou 4 personnes : `In Progress 1` et `In Progress 2`.
- 5 à 8 personnes : trois colonnes de travail.
- 9 personnes ou plus : quatre colonnes maximum.

Chaque colonne de travail doit avoir un responsable ou un groupe clairement documenté. Ne pas créer une colonne par personne lorsque cela produit un tableau vide ou artificiellement fragmenté. Si les membres ne sont pas confirmés, conserver une seule colonne `In Progress` et demander la clarification avant d'en créer d'autres. Le Coordinateur réévalue ce dimensionnement lorsque l'équipe change de taille.

## Standard labels

Create or reuse these labels with the same names and colors:

| Label | Color | Meaning |
| --- | --- | --- |
| `Fonctionnalité` | Green | Nouvelle capacité produit. |
| `Anomalie` | Red | Défaut ou régression. |
| `Sécurité` | Orange | Risque de sécurité, confidentialité ou conformité. |
| `Architecture` | Purple | Architecture or design decision. |
| `Frontend` | Blue | User interface or client work. |
| `Backend` | Blue | API, service or server work. |
| `Données` | Yellow | Base, migration ou contrat de données. |
| `DevOps` | Black | CI, deployment or infrastructure. |
| `Documentation` | Sky | Documentation or knowledge transfer. |
| `Qualité` | Lime | Tests et validation. |
| `Bloqué` | Red | Blocage actif. |
| `Priorité haute` | Orange | À traiter avant le travail normal. |
| `Validation externe` | Pink | Preuve humaine, juridique, client ou externe requise. |

Use at least one type label and one domain label. Add risk, priority and validation labels only when relevant. Never create near-duplicate labels such as `frontend`, `Front end` and `UI`.

## Numérotation, ordre et périmètre

Chaque carte reçoit un numéro d'exécution stable, calculé après le tri des dépendances et avant la création Trello. Utiliser le format `[MVP-001]` pour le périmètre MVP et `[POST-MVP-001]` pour une fonctionnalité explicitement hors MVP. Le numéro suit l'ordre topologique des dépendances : une carte dépendante reçoit un numéro supérieur à toutes ses dépendances ; des cartes au même niveau peuvent partager le même groupe de parallélisation. Ne jamais renuméroter une carte déjà synchronisée ; utiliser le prochain numéro disponible et documenter tout déplacement de périmètre.

Chaque description contient aussi `Execution order`, `Phase`, `Dependencies`, `Parallel group` et `Scope decision`. Si le tableau contient réellement les deux périmètres, créer des listes de travail lisibles comme `MVP - À développer` et `Post-MVP - À développer`, avec leurs variantes `In Progress` si nécessaires. Ne pas créer une colonne Post-MVP vide : une phase absente reste identifiée par le champ `Phase` et l'étiquette correspondante.

## Card naming

Use the format `[MVP-001] Verb + precise outcome` or `[POST-MVP-001] Verb + precise outcome`. Keep titles short, unique and action-oriented. Preserve the stable work-item ID in the description. Do not encode transient status, dates or unchecked progress in the title. Status belongs to the list and labels belong to the visual taxonomy.

## Card layout

The first lines of every description must contain:

```text
Owner: <name>
Type: <Feature|Bug|Architecture|...>
Priority: <Low|Medium|High|Critical>
Dependencies: <IDs or None>
Execution order: <MVP-001 or POST-MVP-001>
Phase: <MVP|Post-MVP>
Parallel group: <P0|P1|None>
Scope decision: <Included in MVP|Post-MVP with reason>
Definition of Done: <short statement>
```

Then use the headings `Context`, `Scope`, `Implementation plan`, `Acceptance criteria`, `Evidence`, `Risks`, `Rollback` and `Definition of Done`. Use real line breaks, short paragraphs and Markdown checklists. Never encode newlines as literal `\\n`.

## Synchronization rules

Before creating cards, inspect existing lists and labels and reuse matching objects by stable ID or exact name. Create only missing objects. After synchronization, reread the board, lists, labels, card descriptions, members, due dates and checklists. Record all IDs and URLs in the local board document.

After every status change, assignment, checklist update, delivery, correction or merge, synchronize the card immediately. If the visual state and the local work item disagree, correct both before continuing.

## Accessibility and clarity

Labels must not be the only way to understand a card. The title, list, first description block and checklist must remain meaningful without color. Do not overload cards with more than five labels unless the extra labels carry a real decision or risk signal.
