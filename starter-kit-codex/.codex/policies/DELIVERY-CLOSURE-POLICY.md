# Politique de clôture et de blocage des livraisons

## Principe

Une carte ne doit jamais rester globalement `En cours` uniquement parce qu’une sous-tâche exige une décision humaine. Le Coordinateur distingue l’avancement réel, les limites techniques et les autorisations manquantes.

## États obligatoires

- `complete` : toutes les actions prévues et autorisées sont terminées avec preuves.
- `needs-review` : le travail est prêt, mais une décision humaine est requise avant une action sensible.
- `blocked` : une dépendance externe ou technique empêche réellement de poursuivre.
- `in-progress` : au moins une action autonome reste à exécuter.

Une carte est découpée en sous-tâches indépendantes lorsque certaines sont terminées et qu’une autre est sensible, risquée ou dépend d’une autorisation.

## Actions sensibles

Un rollback de production, une migration destructive, une rotation de secret, une suppression de données, une modification de permissions ou une dépense peuvent nécessiter une décision humaine. L’agent doit cependant préparer la procédure, vérifier les prérequis, tester une simulation ou un environnement non productif et documenter le plan de retour.

L’agent ne doit jamais exécuter une action irréversible ou susceptible d’interrompre la production sans autorisation explicite. Cette restriction ne justifie pas l’arrêt des tâches autonomes et réversibles.

## Definition of Done partielle

Avant de clôturer ou de suspendre une carte, le Coordinateur doit :

1. Lister les sous-tâches terminées, restantes et bloquées.
2. Relier chaque élément à une preuve réelle.
3. Décrire la limite exacte et l’autorisation manquante.
4. Poursuivre les actions autonomes restantes.
5. Mettre à jour le work item, le journal qualité, la roadmap et Trello.
6. Relire la carte et sa checklist directement depuis Trello.
7. Exécuter la revue de cycle de vie navigateur et fermer les sessions devenues inutiles.
8. Utiliser `needs-review` pour une décision humaine et `blocked` uniquement pour une impossibilité réelle.

Une carte ne peut être annoncée comme terminée si une action nécessaire reste non préparée. Elle peut être livrée avec une sous-tâche en attente uniquement si cette sous-tâche exige explicitement une décision humaine ou une action irréversible.

## Boucle de continuation d'une carte

Après chaque incrément, commit, Pull Request, fusion, résultat de CI ou synchronisation Trello, le Coordinateur doit exécuter cette boucle avant de terminer son intervention :

1. Relire la carte directement depuis Trello.
2. Comparer chaque case de la checklist à une preuve réelle.
3. Identifier la première case ouverte qui peut être réalisée sans décision humaine.
4. Créer ou reprendre le work item correspondant, puis poursuivre immédiatement.
5. Mettre à jour Trello avec l'avancement réel avant de passer à la case suivante.
6. Recommencer jusqu'à ce que toutes les cases soient prouvées ou qu'un blocage réel soit documenté.

Une sous-fonctionnalité terminée, une PR créée, une PR fusionnée, une CI en cours ou un rapport intermédiaire ne constitue jamais une fin de carte. Un message d'état ne doit pas être le dernier message lorsque la prochaine action est autonome. Le Coordinateur indique alors l'action en cours et continue son exécution.

## Validations externes et juridiques

Une validation juridique, métier, réglementaire, client ou externe prévue dans les critères d’acceptation est une condition de fin. Tant qu’elle n’est pas obtenue et prouvée, la carte ne doit jamais être déplacée dans `Terminé`. Utiliser `needs-review`, conserver la carte dans `En cours` ou créer une liste dédiée selon le workflow du projet, puis indiquer clairement la validation manquante.

Une publication technique réussie ne vaut pas validation juridique. L’agent doit distinguer `livré techniquement`, `en attente de validation` et `terminé`.

## Dépendances explicites

Lorsqu’un utilisateur ordonne de terminer une carte avant d’en commencer une autre, créer une dépendance dans le work item et Trello. Ne pas déplacer la carte suivante dans `En cours` avant la preuve de clôture de la première. Si la première carte est techniquement livrée mais attend une validation externe, la seconde reste bloquée par dépendance, sauf autorisation explicite contraire.
