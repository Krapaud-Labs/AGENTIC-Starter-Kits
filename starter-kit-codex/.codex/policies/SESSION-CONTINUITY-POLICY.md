# Politique de continuité de session

## Principe

Une demande ponctuelle et un objectif persistant ne sont pas équivalents. Pour un travail multi-étapes, le Coordinateur doit utiliser le mécanisme d'objectif persistant de l'environnement lorsqu'il est disponible, par exemple `/goal`, avec une fin mesurable, les preuves attendues, les contraintes, le budget et la condition de blocage.

Cette politique ne prétend pas transformer une conversation ordinaire en boucle autonome. Si l'environnement ne fournit pas d'objectif ou de session persistante, l'agent conserve l'état local et indique clairement que la reprise nécessite un nouveau tour utilisateur.

## Contrat d'un objectif persistant

Avant activation, enregistrer dans `RUNTIME-STATE.md` :

- `goal_status: active | waiting | paused | complete | blocked | none` ;
- `goal_objective` : résultat attendu, formulé de façon vérifiable ;
- `goal_verification` : tests, fichiers, logs ou artefacts qui prouvent le résultat ;
- `goal_constraints` : limites à préserver ;
- `goal_budget` : limite de tours, temps ou tentatives ;
- `goal_blocked_condition` : décision ou accès qui justifie un arrêt ;
- `goal_session_id` si l'environnement en fournit un.

Un objectif actif n'autorise pas une clôture fondée sur une impression. La clôture exige les preuves du work item, l'état terminal local et la vérification du dernier tour. `idle` ou `turn completed` ne signifie pas que les outils ont tous réussi.

## Reprise et limites

L'agent peut reprendre automatiquement seulement si l'objectif est actif, que la session est idle, qu'aucune entrée utilisateur n'attend et qu'aucun travail n'est en cours. Un objectif en mode Plan ne doit pas déclencher de continuation d'implémentation. Une interruption volontaire, une limite de budget ou une décision humaine requise met l'objectif en pause ou en blocage et doit être journalisée. Une CI en cours, une intégration temporairement indisponible, une commande réessayable ou une reconnexion attendue sont des états `waiting`, jamais `blocked` et jamais une pause native du Goal. Le Coordinateur conserve `next_action`, enregistre un checkpoint `waiting` et reprend dès que la condition est résolue.

À chaque reprise : relire `RUNTIME-STATE.md`, le work item, les preuves et le dernier résultat de tour, puis exécuter `next_action`. Si l'environnement a malgré tout marqué le Goal natif `blocked` pour une attente récupérable, le Coordinateur doit d'abord réconcilier l'état local `waiting`, demander la reprise native uniquement si l'interface l'exige, puis exécuter `next_action` immédiatement. Ne jamais annoncer « je poursuis » sans lancer une action observable dans le même tour lorsque l'environnement le permet.

Un même blocage ne peut pas être répété plus de deux tours de Goal. Au deuxième tour, le Coordinateur doit changer d'approche et exécuter une action de déblocage concrète, par exemple installer provisoirement un outil gratuit, déléguer une analyse indépendante, utiliser une alternative locale, réduire le périmètre ou demander une décision humaine consolidée avec toutes les alternatives tentées. Il est interdit de produire un troisième tour identique ou de rendre la main avec le même `next_action` sans preuve de changement.

## Commandes d'environnement

Quand elles existent, utiliser les commandes natives de l'environnement : `/goal`, `/goal pause`, `/goal resume`, `/goal clear`. Ne pas inventer une commande équivalente et ne pas traiter un mode Agent ou Work locally comme une garantie de persistance.

## Activation automatique depuis Trello

Lorsqu’une demande contient « enchaîner les cartes », « poursuivre les cartes », « traiter la suite » ou une formulation équivalente, le Goal porte sur toute la séquence autorisée et non sur la première carte. Le Coordinateur doit inscrire la file ordonnée des cartes, leurs dépendances et la condition finale de livraison dans `RUNTIME-STATE.md` avant la première action.

Le passage d’une carte en `Review` ne termine jamais ce Goal de séquence. Le Coordinateur relit la carte, exécute la revue prévue, puis démarre la prochaine carte éligible dans le même Goal. `Goal achieved`, `complete` ou une réponse finale sont interdits tant qu’une carte autonome de la file reste ouverte ou qu’une décision humaine explicitement requise n’est pas le seul prochain événement.

Lorsqu'une demande explicite porte sur la finalisation d'une carte Trello, le Coordinateur doit créer un objectif persistant dès le début, quel que soit le nombre de cases ouvertes, y compris une seule case. L'objectif doit reprendre le titre de la carte, inclure toutes les cases ouvertes, la Definition of Done, les preuves attendues, les contraintes de branche/PR et la condition de blocage. Une carte à une seule case n'active pas la parallélisation, mais elle active bien le Goal.

Si la checklist contient au moins deux tâches ouvertes indépendantes, ou plusieurs lots clairement parallélisables, le Goal doit aussi inclure avant sa première action un plan de délégation accélérée : agents à créer ou activer, rôle de chacun, partition exacte des tâches, fichiers autorisés, preuves attendues, dépendances et agent intégrateur. Le Coordinateur lance les agents parallèles dans le même cycle d'autorisation lorsque les partitions sont sûres, puis conserve une seule branche et une seule PR finale pour la carte. Il ne crée pas d'agent supplémentaire si les tâches partagent un fichier, un contrat, une migration ou une dépendance séquentielle.

Cette vérification est une porte obligatoire de création du Goal. Avant toute commande, délégation ou premier check, le Coordinateur crée ou active réellement les agents requis, inscrit leurs identifiants et affectations vérifiées dans `RUNTIME-STATE.md`, puis seulement démarre le Goal. `pending-assessment` est interdit pour une délégation annoncée. Il compte les checks ouverts et les lots indépendants, compare leurs fichiers et contrats, puis crée ou active immédiatement les agents nécessaires lorsque le parallélisme est sûr. Si le parallélisme n'est pas sûr, il inscrit explicitement `séquentiel justifié`, avec la cause vérifiée.

Tout Goal qui implique une modification, un audit, un test, une livraison ou une action externe doit contenir cette décision de délégation avant de démarrer, même sans carte Trello. La valeur `none` est interdite pour un travail ; seul `séquentiel justifié` ou un registre d’agents réellement créés et affectés permet de poursuivre.

À la création du Goal et à chaque relecture du Goal, le Coordinateur réévalue la checklist restante et le registre des agents. Pour chaque check autonome non attribué, il attribue immédiatement le check à un agent disponible ; si aucun agent compétent n'est disponible et que le check est parallélisable, il crée ou active l'agent requis avant de poursuivre. Il ne laisse pas un agent disponible inactif lorsqu'un check compatible est ouvert. Toute attribution est enregistrée avec le check, le périmètre, la preuve attendue et l'heure de début.

Le Coordinateur renseigne `goal_status: active`, `goal_objective`, `goal_verification`, `goal_constraints`, `goal_budget`, `goal_blocked_condition` et `goal_session_id` dans `RUNTIME-STATE.md`, puis active `/goal` ou l'API native lorsqu'elle est disponible. Toute demande ciblant une carte à reprendre ou à livrer active automatiquement le Goal, y compris une carte à une seule case ou une reprise ponctuelle. Une simple demande d'information sans travail sur une carte reste hors de ce mécanisme.

## Source de référence

## Matrice obligatoire de déclenchement

Le Coordinateur crée ou reprend un Goal avant toute action observable dès qu'une demande implique une exécution, une correction ou une livraison. Le déclenchement est obligatoire pour les formulations directes ou équivalentes suivantes : reprendre ou continuer une carte, traiter un check ou une anomalie, corriger un échec CI ou de test, effectuer un audit, appliquer une amélioration, mettre à jour la documentation, synchroniser ou publier une branche, préparer ou mettre à jour une Pull Request, installer ou configurer un outil pour valider, ou exécuter une demande aléatoire qui modifie le dépôt.

La clôture de l'onboarding ne clôture que l'onboarding. Toute demande ultérieure d'audit du code, de correction, de lint, de test, d'installation d'outil, de déploiement ou de livraison déclenche un nouveau Goal, un nouveau work item et une nouvelle branche ou reprise explicitement reliée à la demande. Le Coordinateur ne réutilise pas silencieusement le Goal d'onboarding et ne considère pas les preuves historiques comme des preuves actuelles sans revalidation.

Le nombre de cases, le nombre de fichiers, le nombre de tours prévus, le caractère ponctuel de la demande et l'absence de carte Trello visible ne désactivent jamais ce déclenchement. Dans ce dernier cas, le Coordinateur crée d'abord le work item local et la carte requise selon les règles Trello, puis rattache le Goal à cet identifiant. Une simple question d'information sans exécution, modification, diagnostic actif ou engagement de livraison ne déclenche pas de Goal.

Avant la première commande, lecture de log, délégation, modification, commentaire externe ou test, le Coordinateur doit renseigner `goal_status: active`, `goal_objective`, `goal_verification`, `goal_constraints`, `goal_blocked_condition` et `goal_session_id`, puis vérifier que le Goal natif est bien actif ou consigner la preuve de son indisponibilité. L'absence de cette preuve interdit de démarrer le travail et interdit toute conclusion de tour.

Le comportement attendu est aligné sur la documentation officielle OpenAI sur les Goals et les sessions. Les URLs et la date de consultation doivent être conservées dans le work item ou l'ADR lorsque cette politique influence une décision.

## Runtime distribué

Si une session distante ou l'Agents API est utilisée, renseigner aussi les identifiants d'événements, d'éléments persistés, de tour, de trace et d'artefact dans `RUNTIME-STATE.md`. Après une coupure, récupérer la session et les éléments sauvegardés avant de reprendre. Ne jamais renvoyer une requête dont le `pending_request_id` ou le `pending_turn_id` est encore actif.

Traiter `required_action_type` avant toute reprise. Les valeurs attendues sont `none`, `function_call` ou `environment_connection`, avec un `required_action_status` résolu avant `complete`. Les événements webhook doivent être vérifiés cryptographiquement et dédupliqués par `webhook_event_id`.

Une clôture exige `budget_status` non épuisé, `environment_shutdown_status` sûr ou non requis, et un manifeste d'artefacts associant chaque livrable à son tour et à son empreinte. Les secrets, clés d'environnement, signatures webhook et données sensibles ne doivent jamais apparaître dans les logs, preuves, commits ou prompts.
