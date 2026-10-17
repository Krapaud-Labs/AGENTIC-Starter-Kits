# Contrat central d exécution

## Priorité

Ce contrat est obligatoire pour tout agent, Skill, work item et mode projet. En cas de duplication ou de contradiction, l ordre de priorité est : sécurité et instruction utilisateur explicite, présent contrat, politiques spécialisées, Skill actif, convention locale. Une règle moins prioritaire ne peut jamais supprimer une porte obligatoire.

## Registre d obligations

Avant toute action, le Coordinateur construit la liste des obligations applicables à partir du cahier, du profil, du work item, des politiques, du Skill actif, de la carte et de la Definition of Done. Chaque obligation possède : un identifiant, un responsable, un déclencheur, une action, une preuve, un état et une prochaine vérification.

Le registre exécutable est conservé dans `work-items/<identifiant>/obligations.tsv`. Il est créé avec le work item et validé par `scripts/validate-obligations.sh` avant push et livraison.

États autorisés : `pending`, `running`, `verified`, `needs-review`, `blocked` et `not-applicable`. `not-applicable` exige une justification. Une obligation sans preuve reste `pending`.

## Boucle non interruptible

Pour chaque obligation applicable :

1. Relire l état persistant et les preuves existantes.
2. Exécuter la première action autonome non vérifiée.
3. Enregistrer immédiatement la preuve et l état.
4. Synchroniser les consommateurs concernés : code, tests, documentation, journal, Git, CI et Trello si activé.
5. Calculer et exécuter la prochaine action.

Un message, un commit, une PR, une fusion, une CI, un audit partiel ou une synchronisation sont des checkpoints, jamais une clôture automatique. L agent ne demande pas « Continue » pour une action réversible déjà couverte par le work item.

## Portes obligatoires

Les portes suivantes sont évaluées à chaque transition :

- `intake-gate` : cahier accepté et décisions réellement bloquantes résolues.
- `design-gate` : conception et contrats concernés à jour.
- `scope-gate` : branche, commits, fichiers autorisés et work item cohérents.
- `validation-gate` : lint, tests, build, sécurité, accessibilité et preuves proportionnés au risque.
- Chaque fichier ouvert pour une modification doit recevoir un contrôle lint adapté avant de poursuivre ; une erreur doit être corrigée et recontrôlée, ou l'absence d'outil doit être explicitement prouvée comme `not-applicable`.
- `documentation-gate` : documentation, décisions, journal et changelog cohérents.
- `integration-gate` : intégrations activées synchronisées et relues, ou checkpoint local prouvé.
- `audit-gate` : revue indépendante sans auto-approbation.
- `delivery-gate` : diff propre, CI observée, PR correcte, rollback et Definition of Done prouvés.

Une porte non vérifiée interdit `complete` et `Done`. Elle ne bloque pas les tâches indépendantes.

## Capacités et alternatives

L agent inventorie d abord les outils et connecteurs réellement exposés. Il utilise une capacité connectée avant toute solution de remplacement. Il n installe pas un outil, un plugin, un navigateur ou un runtime sans demande explicite lorsque cette installation dépasse le périmètre ou qu une capacité équivalente existe déjà.

Si une capacité manque, l agent consigne la preuve, prépare le résultat local synchronisable, poursuit les tâches indépendantes et conserve une action de reprise. Il ne transforme jamais une absence d outil en validation réussie.

## Reprise et mémoire

Après chaque checkpoint, `RUNTIME-STATE.md` conserve au minimum : session, work item, carte, branche, étape, obligations ouvertes, action courante, prochaine action, dernière preuve, état CI, état des intégrations et raison exacte d un blocage. Une nouvelle conversation reprend cette prochaine action avant tout nouveau résumé.

## Clôture

Avant toute conclusion, le Coordinateur relit le registre complet. La clôture est autorisée uniquement si toutes les obligations sont `verified`, `not-applicable` avec justification, ou `needs-review` avec une décision humaine explicitement attendue. `blocked` exige la preuve du blocage, les alternatives tentées et les tâches indépendantes terminées.
