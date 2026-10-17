# Cahier des charges des kits agentiques

## 1. Objet

Ce document définit la cible fonctionnelle, technique, opérationnelle et documentaire des kits Codex et Claude. Il sert de référence pour rendre les kits réellement utilisables dans un projet local, dans une session longue, et dans un orchestrateur distant.

Le kit doit fournir une gouvernance portable. Il ne doit pas prétendre contrôler une interface de chat qu'il ne possède pas. Les règles déclaratives guident l'agent ; les hooks, scripts, permissions et contrôles CI doivent faire respecter les invariants vérifiables.

## 2. Périmètre

Les deux distributions doivent rester fonctionnellement paritaires :

- `starter-kit-codex/.codex/` pour Codex ;
- `starter-kit-claude/.claude/` pour Claude Code ;
- scripts de diagnostic, tests, documentation et versionnement au niveau racine ;
- installation native dans un projet et synchronisation externe sans écraser les données du projet.

Les intégrations distantes sont optionnelles. Le kit local doit fonctionner sans Agents API, sans Trello, sans webhook et sans serveur MCP, avec les valeurs `not-required`, `disabled` ou `not-applicable` explicites.

## 3. Sources normatives consultées

Les sources doivent être relues avant chaque évolution pouvant dépendre du produit ou de l'API :

- OpenAI Agents : https://developers.openai.com/api/docs/guides/agents
- Sessions et tours : https://developers.openai.com/api/docs/guides/agents-api/sessions
- Actions requises et événements : https://developers.openai.com/api/docs/guides/agents-api/sessions/events
- Webhooks : https://developers.openai.com/api/docs/guides/webhooks
- Cycle de vie d'environnement : https://developers.openai.com/api/docs/guides/agents-api/environments/lifecycle
- Sécurité sandbox : https://developers.openai.com/api/docs/guides/agents-api/environments/security
- Traces et observabilité : https://developers.openai.com/api/docs/guides/agents-api/tracing
- Fichiers et artefacts : https://developers.openai.com/api/docs/guides/agents-api/environments/files
- Goals Codex : https://developers.openai.com/cookbook/examples/codex/using_goals_in_codex
- Répertoire `.claude` : https://code.claude.com/docs/en/claude-directory
- Référence CLI Claude Code : https://docs.anthropic.com/en/docs/claude-code/cli-usage
- Permissions Claude Code : https://code.claude.com/docs/en/permissions
- Hooks Claude Code : https://code.claude.com/docs/en/hooks

Une décision influencée par une source externe doit conserver son URL, sa date de consultation et son impact dans le work item ou l'ADR.

## 4. Principes non négociables

1. Une instruction explicite autorise les étapes réversibles nécessaires dans son périmètre ; aucune confirmation redondante ne doit être demandée.
2. Un commit, une PR, une fusion, une CI verte ou une carte Trello synchronisée sont des checkpoints, jamais une Definition of Done.
3. Une réponse finale est interdite si l'état runtime n'est pas terminal et prouvé.
4. Une session `idle` ou un tour `completed` ne prouve pas que les outils ont réussi.
5. Une erreur corrigeable déclenche diagnostic, recherche officielle, correction, test et reprise.
6. Une action irréversible, un secret, une dépense, un accès externe, une décision métier ou un risque critique peut nécessiter l'utilisateur.
7. Les secrets ne sont jamais écrits dans le dépôt, les logs, les preuves, les prompts, les artefacts ou les commentaires de PR.
8. Les comportements obligatoires doivent être exécutables par hook, script, permission, CI ou test, pas seulement décrits dans `AGENTS.md` ou `CLAUDE.md`.

## 5. État runtime obligatoire

Chaque kit doit initialiser un `RUNTIME-STATE.md` valide et versionné comme modèle. Les projets consommateurs peuvent le personnaliser, mais ne doivent pas le supprimer.

### 5.1 État de travail

Champs obligatoires :

- `execution_status: running | waiting-ci | needs-review | blocked | complete` ;
- `current_action`, `next_action`, `open_checklist_items` ;
- `last_observable_evidence`, `ci_status`, `trello_sync_status` ;
- `attempt_count`, `max_attempts`, `redundant_confirmation_requested` ;
- branche, commit, fichiers modifiés, tests, erreurs et sources.

### 5.2 Objectif persistant

Pour une tâche multi-étapes :

- `goal_status: none | active | paused | complete | blocked | budget-exhausted` ;
- objectif mesurable, surface de vérification, contraintes, budget et condition de blocage ;
- identifiant de session si fourni par l'environnement.

Un budget atteint n'est jamais `complete`.

### 5.3 Session distribuée

Si une session distante est utilisée, renseigner :

- `required_action_type`, `required_action_id`, `required_action_status` ;
- `last_session_event_id`, `last_persisted_item_id`, `last_turn_id`, `trace_id` ;
- `pending_request_id`, `pending_turn_id` ;
- `reconnect_attempts`, `environment_status`, `environment_shutdown_status` ;
- `webhook_event_id`, `artifact_manifest`.

Une reprise doit récupérer l'état distant avant de renvoyer une requête. Une requête ou un tour en attente interdit le resubmit automatique.

## 6. Garde avant réponse

`guard-before-response.sh` doit refuser une conclusion si :

- `running`, `waiting-ci` ou une action autonome reste ouverte ;
- une obligation, une checklist ou une preuve est absente ;
- une action requise n'est pas résolue ;
- le budget est dépassé ou inconnu ;
- le dernier tour ou un outil a échoué sans traitement ;
- une requête est encore en attente ;
- l'environnement distant n'est pas reconnecté ou arrêté de façon sûre ;
- la relecture Trello exigée n'est pas prouvée ;
- une confirmation redondante a été demandée.

Les états `needs-review` et `blocked` exigent la preuve, la cause, les alternatives tentées et l'action humaine attendue. Ils ne déplacent jamais automatiquement une carte vers `Done`.

## 7. Continuité et reprise

Le kit doit documenter et tester les quatre niveaux suivants :

1. reprise locale depuis `RUNTIME-STATE.md` ;
2. reprise d'une conversation ou session par identifiant ;
3. récupération après coupure de flux à partir des éléments persistés ;
4. reconnexion d'un environnement déconnecté via l'action requise.

La continuation automatique n'est autorisée que si l'objectif est actif, la session est idle, aucune entrée n'est en attente et aucun travail n'est en cours. Le mode Plan ne déclenche pas une continuation d'implémentation.

## 8. Idempotence et événements

Tout opérateur externe doit :

- vérifier la signature du webhook ;
- répondre rapidement puis déléguer le traitement lourd à un worker ;
- dédupliquer par identifiant d'événement ;
- vérifier l'état courant avant de créer, pousser, fusionner, déplacer ou publier ;
- ne pas exécuter deux fois une opération dont le résultat est déjà prouvé ;
- conserver les identifiants de requête, tour, PR, commit, carte et artefact.

## 9. Sécurité et permissions

Le kit doit fournir une matrice de permissions par action : lecture, édition, commande, réseau, Git, GitHub, Trello, MCP et secrets. Les permissions de développement doivent être séparées des permissions de livraison.

Pour Claude Code, les modes `plan`, `default`, `acceptEdits`, `dontAsk` et `bypassPermissions` doivent être documentés avec leurs limites. `bypassPermissions` ne doit être utilisé que dans un environnement isolé et contrôlé. Les hooks `PreToolUse` doivent bloquer les opérations dangereuses, car une instruction textuelle seule n'est pas une garantie.

Pour Codex ou Agents API, l'environnement doit être isolé, le réseau limité aux domaines nécessaires et les clés séparées entre orchestrateur, executor et outils. Les secrets doivent être injectés par le mécanisme prévu par l'environnement, jamais copiés dans le workspace.

## 10. Outils, MCP et sous-agents

Chaque outil doit avoir : propriétaire, portée, permissions, timeout, retry, résultat attendu, preuve, politique d'erreur et condition d'arrêt. Les MCP non utilisés doivent être désactivés ou exclus.

Chaque sous-agent doit avoir : rôle, contexte minimal, fichiers autorisés, sortie attendue, limite de coût, responsable de la revue et stratégie de fusion. Le Coordinateur reste responsable de la décision finale et ne considère jamais une sortie de sous-agent comme une validation indépendante sans contrôle.

## 11. Observabilité, coûts et données

Le kit doit permettre de relier `session → turn → agent/subagent → tool → résultat → fichier/artefact → preuve`. Les échecs, retries, latences, tokens et coûts doivent être mesurables sans exposer les secrets.

Les règles de rétention doivent préciser : données conservées, durée, suppression, emplacement, accès et traitement des données sensibles. Les projets qui ne peuvent pas accepter la persistance distante doivent utiliser le mode local approprié et le déclarer dans le profil.

## 12. Git, CI et releases

Le flux obligatoire est : branche de travail depuis `dev` ou `develop`, PR vers la branche d'intégration, validation, puis PR finale vers `main`. Aucun push direct vers `main`.

Chaque changement du kit doit mettre à jour la version, les deux kits, les README, la carte de documentation et le changelog. Les tests de parité doivent vérifier inventaires, politiques, scripts, modèles runtime et comportements des garde-fous.

La CI doit exécuter au minimum : lint shell, audit de gouvernance, cohérence documentaire, cohérence de version, tests des portes, tests de reprise, tests d'idempotence et détection de secrets.

## 13. Tests d'acceptation

Le cahier des charges est accepté uniquement si les scénarios suivants passent pour Codex et Claude :

- un état `running` bloque la réponse ;
- une obligation ouverte bloque `complete` ;
- un outil échoué bloque `complete` ;
- une action requise bloque la reprise jusqu'à résolution ;
- une déconnexion restaure l'état sans doublon ;
- un webhook invalide est rejeté ;
- un webhook répété n'exécute l'action qu'une fois ;
- une requête en attente n'est pas renvoyée ;
- un budget épuisé produit `budget-exhausted`, jamais `complete` ;
- un environnement actif ne peut pas être arrêté prématurément ;
- un secret de test n'apparaît ni dans les logs ni dans les artefacts ;
- une PR ou une carte déjà créée n'est pas recréée après reprise ;
- une session sans intégration distante fonctionne avec `not-required` ;
- la parité Codex/Claude est vérifiée automatiquement ;
- une interruption de conversation permet de reprendre depuis l'état local.

## 14. Livrables attendus

- politiques et contrats mis à jour dans les deux kits ;
- `RUNTIME-STATE.md` complet et validé ;
- garde avant réponse et scripts de reprise ;
- tests automatisés des états normaux, bloqués, interrompus et dupliqués ;
- matrice permissions/outils/MCP ;
- guide installation, migration et dépannage ;
- documentation des limites entre kit local et orchestrateur distant ;
- rapport d'audit avec sources et preuves ;
- release versionnée et changelog ;
- PR d'intégration puis PR de promotion vers `main`.

## 15. Priorisation

### P0 - indispensable

État runtime, garde avant réponse, obligations, actions requises, idempotence, reprise locale, permissions dangereuses, tests de non-régression et secrets.

### P1 - nécessaire pour une utilisation distante

Webhooks signés, reconnexion, environnement, traces, artefacts, déduplication, worker asynchrone et rétention.

### P2 - amélioration continue

Tableau de métriques, budget par rôle, scoring d'autonomie, évaluation de qualité, optimisation du contexte et tableaux de bord.

## 16. Definition of Done globale

Les kits sont déclarés conformes uniquement lorsque tous les P0 sont implémentés et testés, les P1 sont soit implémentés soit explicitement déclarés non applicables, les deux distributions restent paritaires, les sources officielles sont à jour, aucune réponse finale prématurée n'est acceptée par les tests, et la livraison est prouvée par une release et les PR prévues.

## 17. État d'implémentation du dépôt

À la version 1.12.0, le dépôt fournit :

- l'état runtime étendu dans les deux kits ;
- le garde avant réponse avec contrôle des actions requises, du budget, de la session, du dernier tour, des outils et de l'environnement ;
- `validate-session-state.sh` dans les deux distributions ;
- les politiques de continuité, de secrets, d'idempotence, de traces et d'artefacts ;
- l'audit automatique de parité et les tests des portes exécutables ;
- le cahier des charges et les sources normatives ci-dessus.
- l'activation automatique du Goal pour les cartes Trello comportant au moins deux cases ouvertes.

Les éléments Agents API, webhooks et environnements distants restent des contrats documentés et des états `not-required` par défaut. Leur activation nécessite un adaptateur d'orchestrateur qui implémente les événements, la vérification des signatures, la reconnexion et le stockage persistant ; le kit ne simule pas cette intégration.
