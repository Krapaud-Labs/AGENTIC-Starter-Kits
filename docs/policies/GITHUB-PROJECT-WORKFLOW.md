# Convention GitHub Projects

Les projets GitHub utilisent une vue Kanban avec quatre colonnes, dans cet ordre

1. `Backlog` pour les cartes prévues mais non commencées.
2. `In progress` pour les cartes en cours d'exécution.
3. `Review` pour les cartes techniquement réalisées, mais dont les tests, les preuves, la documentation ou la relecture restent à valider.
4. `Done` pour les cartes entièrement vérifiées, documentées et livrées selon leur Definition of Done.

Une carte ne doit passer dans `Done` qu'après relecture de la checklist, vérification des preuves et confirmation de la livraison attendue.

Un blocage n'est pas une colonne de workflow. Il doit être signalé par l'étiquette `Blocked` ou par un champ dédié, avec la cause, les tentatives effectuées et la prochaine action documentées.

Les cartes doivent conserver leur numéro de suivi, une description structurée, les étiquettes pertinentes et une checklist cohérente avec leur état.

## Titres et contenu

Chaque carte possède un identifiant unique et lisible dans son titre. Une carte ne doit pas combiner plusieurs identifiants de suivi. Les titres historiques peuvent conserver leur formulation d'origine, mais reçoivent un identifiant unique ajouté en préfixe lorsqu'il manque.

Le contenu d'une carte doit être rédigé en français et suivre cet ordre lorsque les sections sont applicables : `Contexte`, `Objectif`, `Périmètre`, `Tâches`, `Dépendances`, `Critères d'acceptation`, `Preuves`, `Risques`, `Retour arrière` et `Définition de terminé`.

Les termes techniques ou noms de produits peuvent rester dans leur forme officielle. Les anciennes notes, preuves et décisions sont conservées sous une section historique au lieu d'être supprimées.

## Priorité

Le champ `Priority` complète le statut sans le remplacer. Il indique l'importance de la carte et doit utiliser quatre niveaux

- `P0` pour un blocage critique ou une correction indispensable à la livraison.
- `P1` pour une capacité nécessaire au MVP ou à la prochaine livraison.
- `P2` pour une évolution importante mais non bloquante.
- `P3` pour une amélioration, une optimisation ou un élément post-MVP.

Une carte doit avoir une priorité avant son passage dans `In progress`. Une priorité ne justifie jamais de contourner l'ordre des dépendances, les tests ou la Definition of Done.

Le statut décrit l'avancement. La priorité décrit l'importance. Les deux champs doivent rester renseignés séparément.

## Étiquettes

Les étiquettes restent simples, capitalisées et sans préfixe. Utiliser uniquement les labels pertinents parmi `Feature`, `Bug`, `Documentation`, `Governance`, `Frontend`, `Backend`, `Security`, `QA`, `DevOps`, `MVP`, `Post-MVP`, `P0`, `P1`, `P2` et `P3`.

Le statut reste un champ du GitHub Project. Il ne doit pas être dupliqué dans une étiquette. Une carte doit recevoir au moins une étiquette de type ou de domaine lorsque l'information est connue, sans inventer une classification absente de sa description.

## Contrôle obligatoire avant création et clôture

Le coordinateur doit auditer le Project avant de créer une carte, puis relire chaque carte après sa création ou sa modification. Une carte ne doit pas être considérée conforme si son titre, son contenu, son statut, ses labels ou sa priorité ne sont pas relus dans l'état distant réel.

Avant toute création de carte, vérifier

- l'identifiant unique et la séquence de suivi;
- la langue française et l'ordre des sections;
- le type, le domaine, la phase et la priorité explicitement déductibles;
- les labels existants du dépôt;
- la colonne cible et les dépendances;
- l'absence de doublon de titre ou d'identifiant.

Après toute création ou modification, vérifier

- le titre réellement enregistré;
- le contenu complet réellement enregistré;
- les labels réellement attachés;
- le statut réellement appliqué;
- la priorité réellement appliquée lorsqu'elle est connue;
- la présence de la carte dans la vue Kanban attendue.

Une carte historique peut conserver ses notes anciennes, mais doit recevoir un identifiant unique et les sections manquantes doivent être ajoutées sans effacer les preuves existantes. Les cartes sans preuve d'avancement sont placées dans `Backlog`; aucune carte ne doit être classée `In progress`, `Review` ou `Done` par déduction arbitraire.
