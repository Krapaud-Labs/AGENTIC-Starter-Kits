# Skill coordination

## Objectif

Transformer une demande en livraison vérifiable, avec un seul responsable du plan et des dépendances explicites.

## Quand l'utiliser

Pour toute demande qui modifie le produit, ses documents, sa configuration ou sa livraison. Ne pas l'utiliser pour une question purement explicative sans changement attendu.

## Entrées requises

Demande, critères d'acceptation, `.codex/project-profile.toml`, état Git si disponible, fichiers concernés et contraintes déclarées.

## Récupération et recherche

Ne pas transmettre une erreur corrigeable à l’utilisateur comme conclusion. Déclencher le diagnostic, la recherche documentaire ou internet, la correction et la validation. Continuer jusqu’à réussite, limite documentée ou blocage réel. Ne pas attendre un message « Continue », « approuve » ou une validation intermédiaire lorsque la prochaine étape est déjà autorisée. Poursuivre les tâches indépendantes malgré une limite locale, en la documentant.

Une preuve négative ne clôt jamais le tour. Pour chaque `404`, échec de test, déploiement non visible ou revalidation externe négative, le Coordinateur enchaîne cause, correction, déploiement ou alternative, puis revalidation. Il ne transmet pas seulement le constat et ne demande pas à l'utilisateur de relancer une action déjà autorisée.

Si l'utilisateur demande explicitement de déployer la branche de travail sur `dev` ou `develop`, le Coordinateur ouvre la PR d'intégration nécessaire même si la carte n'est pas terminée, attend CI et déploiement, revalide l'environnement, puis revient à la branche de travail et reprend le Goal. Il ne classe pas cette situation en `blocked` et ne considère pas la PR de déploiement comme la PR finale de la carte.
Un check Trello ouvert est une obligation active, pas une suggestion. Tant que le check courant n'est pas validé par une preuve relue, le Coordinateur ne passe pas à une autre carte, ne présente pas la carte comme livrée et ne transforme pas un échec en simple information. Il doit enchaîner diagnostic, correction, test ciblé, alternative sûre et relecture Trello jusqu'à preuve, décision humaine réellement nécessaire ou blocage externe démontré.

Avant de traiter un check, un blocage ou une suggestion découverte pendant l'audit, le Coordinateur vérifie sa traçabilité dans le cahier des charges accepté, le périmètre du work item, les critères d'acceptation, la conception validée ou une décision projet. Un besoin absent de ces sources ne doit pas être ajouté à la checklist, au Goal ou au périmètre de développement. Le classer `hors périmètre`, retirer le blocage non applicable de la file active, conserver une note locale si elle est utile et poursuivre immédiatement avec la prochaine action applicable. Seule une obligation légale, de sécurité critique ou explicitement demandée peut devenir une décision `needs-review`, jamais une exigence silencieuse.

## Procédure

1. Créer un work item avec résultat, hors périmètre, critères et budget.
2. En mode `autonomous-after-brief` et lorsque `execution_authorization = "continuous-until-done"`, une instruction comme « fais tout » autorise l’exécution de toutes les sous-tâches du work item jusqu’à la Definition of Done. Regrouper les choix non bloquants en décisions réversibles dans un ADR et continuer sans interrompre l’utilisateur. Ne poser qu’une demande consolidée pour les blocages réels.
3. Évaluer le risque avec `.codex/RISK-MATRIX.md`.
4. Décomposer le résultat en tâches atomiques qui indiquent rôle, Skill, dépendances, fichiers autorisés et preuves.
5. Ne paralléliser que les tâches sans contrat ni fichier commun.
6. Transmettre le contexte minimal utile, jamais le dépôt entier par défaut.
7. Collecter les rapports, preuves et risques résiduels.
8. Demander l'audit requis, puis clôturer ou faire reprendre le travail.

## Délégation parallèle d'une même carte

Lorsque la checklist ou le périmètre contient au moins deux lots indépendants et que leur exécution parallèle réduit réellement le délai, le Coordinateur doit créer ou activer plusieurs agents dans le même cycle d'autorisation. Il construit avant le démarrage une matrice `agent → sous-tâche → fichiers autorisés → dépendances → preuve`, vérifie l'absence de contrat ou de fichier commun, attribue chaque lot à un agent habilité et lance les actions. Les agents utilisent des espaces de travail isolés lorsque leurs commits peuvent se chevaucher. Si la parallélisation est techniquement sûre mais n'apporte aucun gain réel, le Coordinateur documente cette décision dans le Goal avant de rester séquentiel.

Lors de la création d'un Goal pour une carte comportant au moins trois tâches ouvertes indépendantes, cette matrice de délégation devient une partie obligatoire du Goal avant le premier travail. Le Goal doit demander explicitement la création ou l'activation des agents nécessaires pour traiter les lots en parallèle, préciser l'agent intégrateur et prévoir l'assemblage, les tests et l'audit. Cette décision est réévaluée si le coût de coordination dépasse le gain attendu.

À chaque relecture du Goal, le Coordinateur parcourt les checks encore ouverts dans l'ordre des dépendances, attribue tout check autonome à un agent disponible et active un nouvel agent si aucun agent compétent n'est libre. L'état `available` d'un agent ne vaut pas preuve de travail : il doit être suivi d'une attribution observable ou d'une justification documentée lorsqu'aucun check ne lui correspond.
Pour chaque check bloqué, le Goal conserve un journal de tentatives avec le symptôme, la cause supposée, l'action exécutée, le résultat observable et l'alternative suivante. Après deux tours sans résolution, il est obligatoire de changer concrètement d'approche, d'activer un agent ou un outil disponible, d'installer provisoirement un outil gratuit si nécessaire, ou d'utiliser une voie de validation de secours. Le Coordinateur ne peut déclarer `blocked` qu'après ces alternatives et une preuve du blocage. Une carte comportant un check ouvert reste prioritaire sur toute carte suivante, sauf instruction explicite contraire de l'utilisateur.

Le Coordinateur ne parallélise jamais une tâche dépendante, une migration partagée, une décision d'architecture, une modification du même fichier ou une validation qui exige le résultat d'un autre agent. Après chaque lot, il relit la preuve, Trello et le work item, résout les conflits, intègre les résultats sur la branche unique de la carte, puis lance l'audit et les contrôles finaux. La carte reste ouverte tant que tous les lots, la revue et la Definition of Done ne sont pas prouvés.

Plusieurs agents du même rôle peuvent être activés pour accélérer une famille de tâches homogènes, à condition de partitionner explicitement le travail : cartes différentes, fichiers différents, parcours différents, lignes de données distinctes ou lots de checklist non recouvrants. Un agent intégrateur unique est désigné avant le démarrage ; il vérifie l'absence de doublons, assemble les résultats, résout les conflits et porte la preuve finale. Deux agents ne doivent jamais implémenter le même périmètre sans partition, ni écraser le résultat de l'autre.

## Sélection de la prochaine carte

Pour une autorisation `continuous-until-done` portant sur un lot Trello, le Coordinateur ne s'arrête pas après la clôture d'une carte. Avant chaque démarrage, il relit le tableau et extrait le numéro stable de chaque carte candidate, en séparant `MVP` et `POST-MVP`. Il trie les numéros numériquement, vérifie les dépendances et refuse de démarrer `03` si `02` est encore éligible. Il vérifie aussi qu'aucun numéro attendu n'est manquant, dupliqué ou incohérent avec la source locale. Il filtre ensuite les cartes `Ready` ou reprenables sans dépendance ouverte, échéance bloquante ou blocage documenté, puis démarre la première carte dans l'ordre vérifié. Il enregistre les cartes examinées, la carte choisie et les raisons des cartes ignorées dans le work item et l'état runtime. Une demande explicitement limitée à une carte reste limitée à cette carte, mais ses dépendances et son ordre doivent tout de même être vérifiés.

## Boucle d.optimisation du Coordinateur

Avant chaque délégation, lire les métriques disponibles et les évaluations comparables. Le registre est interne et ne doit jamais interrompre un work item autorisé. Réduire le contexte, réutiliser les résultats validés, regrouper les tâches indépendantes, puis router Luna pour les tâches répétitives à faible risque, Terra pour l.implementation et les audits courants, et Sol pour les décisions complexes ou critiques. Après chaque work item, comparer qualité, défauts, durée, contexte, relances et coût estimé. En cas de dérive, modifier un seul paramètre et vérifier la non-régression.

## Contrôles

Chaque tâche doit avoir un propriétaire, un risque, un périmètre, une règle d'arrêt et une preuve attendue. Toute dérive de budget, de portée ou de sécurité impose une escalade.

## Sortie

Plan de travail, état des dépendances, décision de clôture et évaluation enregistrée.

## Mesures

Tours, contexte transmis, relances, durée, défauts après audit et tâches reprises.

## Arrêt

Arrêter si le besoin devient ambigu, si une décision métier ou irréversible est nécessaire, si le budget est dépassé ou si une dépendance externe manque.
