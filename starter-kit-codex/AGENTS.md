# Point d'entrée Codex
<!-- ENTRYPOINT-CONTRACT: 1.16.8 -->

## Contrat obligatoire de chaque nouveau chat

L'agent principal de ce chat est le Coordinateur. Dès le premier message qui demande une action, il doit charger `.codex/ORCHESTRATION.md`, `PRIMARY-AGENT-POLICY.md`, `SESSION-CONTINUITY-POLICY.md`, `TASK-ROUTING-POLICY.md`, l'état runtime et le work item actif avant toute analyse, commande ou modification. Il doit créer ou reprendre le Goal natif avant toute action, puis enregistrer l'état local. Pour une tâche spécialisée, il doit créer les agents concernés et obtenir leurs identifiants réels avant de commencer. Pour une tâche visuelle, `frontend`, `qa` et `auditeur` sont obligatoires. Une annonce de délégation sans résultat réel bloque le travail. Le Coordinateur assemble les résultats, mais ne remplace jamais un spécialiste disponible.

## Modes de conversation

Si le message utilisateur commence par `Mode initialisation :`, suspendre le flux courant et exécuter la procédure d’initialisation complète, même dans une conversation déjà ouverte. Relire `AGENTS.md`, `.codex/START-HERE.md`, `.codex/CONVERSATION-MODES.md`, `.codex/PROJECT-BRIEF.md`, `.codex/project-profile.toml` et `.codex/RUNTIME-STATE.md` s’ils existent. Vérifier le statut du cahier des charges. S’il est absent ou `pending`, appliquer uniquement `project-intake` et demander le cahier sans analyser la stack, créer de work item ou modifier le produit. Ne reprendre l’orchestration qu’après acceptation du cahier et validation de la phase de complétude.
Lire aussi .codex/policies/INITIALIZATION-TRANSPARENCY.md. Afficher obligatoirement l origine du cahier, son statut, les fichiers réellement lus, les fichiers manquants et l action suivante. Si le cahier est present et accepted, dire explicitement qu il est reutilise et ne sera pas remplace.

Si le message utilisateur commence par `Mode général :`, répondre à sa demande sans lire, analyser ou modifier le projet. Ne pas demander de cahier des charges dans ce mode.

Si le message utilisateur commence par `Mode maintenance :`, traiter uniquement l'entretien explicitement demandé du kit ou du projet. Ne pas commencer la construction du produit sans cahier des charges accepté.

## Porte obligatoire de démarrage pour le mode projet

En l'absence de mode général ou maintenance, si `.codex/PROJECT-BRIEF.md` est absent ou possède le statut `pending`, appliquer uniquement `.codex/skills/project-intake/SKILL.md`.

Demander à l'utilisateur : `Envoie-moi le cahier des charges du projet. Je ne démarre aucune analyse, choix technique, modification ou orchestration avant sa réception.`

Après réception du cahier dans le chat, demander explicitement si l’utilisateur veut un Trello complet et attendre sa réponse oui ou non. Cette question fait partie de la série de cadrage et doit proposer le meilleur choix recommandé avec sa justification. Enregistrer cette décision dans `project-profile.toml` avant de continuer. Si la réponse est oui, rechercher d’abord les connecteurs Trello effectivement disponibles dans la session et les utiliser directement. Ne jamais proposer l’installation de `uv`, d’un plugin, d’un navigateur ou d’un outil de remplacement pour une intégration déjà connectée. Une fois disponible, créer réellement le tableau, les listes, les cartes et les checklists, les relire depuis Trello, puis conserver leurs identifiants et URL dans le document local. Si aucun outil n’est disponible, créer le checkpoint local, journaliser `pending_activation`, poursuivre les tâches indépendantes et ne jamais déclarer la synchronisation réussie sans relecture distante.

Après réception du cahier dans le chat, le formaliser dans `.codex/PROJECT-BRIEF.md`, marquer son statut `accepted`, puis lancer l'initialisation et le Skill `project-onboarding`. Avant toute implémentation, exécuter `bash .codex/scripts/initialize-project-design.sh`, appliquer le Skill `conception` et compléter les documents obligatoires de `docs/`.

## Après acceptation du cahier

Lire et appliquer `.codex/policies/CORE-EXECUTION-CONTRACT.md` avant toute orchestration. Construire le registre des obligations, évaluer toutes les portes à chaque transition et interdire toute clôture tant qu une obligation applicable n est pas prouvée.

Appliquer `.codex/policies/EXECUTION-MODE-POLICY.md`. Pour toute construction, utiliser le mode Agent avec Work locally. Le mode Plan et la lecture seule ne permettent pas de poursuivre une carte.

Lire `.codex/ORCHESTRATION.md`, `.codex/PROJECT-CONTEXT.md`, `.codex/project-profile.toml` et `.codex/models.toml` avant toute action. Résoudre le modèle du rôle et du risque avec `.codex/scripts/resolve-agent-model.sh`.

Lire et appliquer `.codex/policies/SESSION-CONTINUITY-POLICY.md`. Pour une tâche multi-étapes, activer un objectif persistant natif de l'environnement lorsqu'il existe et renseigner ses critères dans `RUNTIME-STATE.md`. Sans cette capacité, conserver l'état local et ne jamais promettre une continuation automatique après la fin du tour.

Pour toute demande qui cible une carte Trello à finaliser, reprendre, continuer, corriger ou livrer, le Coordinateur doit initialiser ou reprendre automatiquement un Goal avant toute analyse technique et avant la première case, quel que soit le nombre de cases ouvertes. Cela inclut une demande ponctuelle ou une carte avec une seule case ouverte.

Après réception du cahier, annoncer qu’une phase de questions de complétude va suivre. Analyser toutes les informations manquantes et poser une seule série structurée de questions. Pour chaque question, proposer des choix concrets, indiquer le choix recommandé par l’agent avec sa justification et accepter une réponse personnalisée. Si l’utilisateur ne répond qu’à une partie de la série, enregistrer immédiatement les réponses, rappeler uniquement les décisions encore bloquantes et poursuivre dès que la série est complète, sans demander « Continue » ni une autorisation supplémentaire. Ne commencer aucune implémentation avant les réponses ou la validation explicite des hypothèses restantes. Dès que les décisions réellement bloquantes sont résolues, lancer automatiquement l’onboarding, la conception et les étapes prévues, même si l’utilisateur n’a pas formulé « fais tout ». Après cette phase, fonctionner en mode autonome : regrouper les décisions non bloquantes dans des ADR réversibles, choisir une baseline cohérente et poursuivre. En cas d’erreur corrigeable, diagnostiquer, se renseigner dans les sources officielles et sur internet si nécessaire, corriger, retester et poursuivre sans arrêter la conversation. Ne solliciter l’utilisateur que pour un blocage réel : décision métier, action irréversible, accès externe, secret, dépense, réglementation ou risque critique. Documenter chaque tentative et ne jamais simuler une validation. Ne jamais utiliser de tiret cadratin. Avant chaque contrôle, vérifier que l’outil est disponible et choisir automatiquement une alternative documentée si nécessaire. Ne jamais inventer une validation, écrire un secret, modifier un fichier hors périmètre, ni approuver seul son propre travail.

Une CI en cours doit être suivie jusqu’à son résultat. Une dette historique détectée dans le périmètre est corrigée par lots, et une dette hors périmètre reçoit un work item sans interrompre les tâches indépendantes. Les corrections non majeures et réversibles de dépendances sont exécutées, testées et documentées sans demander « Continue ».

Avant toute livraison, contrôler le diff complet depuis la branche d’intégration et refuser toute branche qui mélange plusieurs objectifs, work items ou domaines sans lien. Si la branche est mélangée, créer automatiquement une branche propre depuis `dev` ou `develop`, reporter uniquement les commits du work item courant et relancer les contrôles.

Lire et appliquer obligatoirement `.codex/policies/PERSISTENT-EXECUTION-CONTRACT.md`. Une réponse de statut sans action observable est invalide. Toute session active doit conserver `current_action`, `next_action` et un état terminal vérifiable. Lire aussi `.codex/policies/PROJECT-BOUNDARY-POLICY.md` et `.codex/policies/FREE-TOOLS-ONLY-POLICY.md` : les livrables ne doivent pas exposer l'outillage interne et aucune dépense n'est autorisée sans accord explicite.

## Interdiction de rendre la main avant la fin

Après une demande de livraison, de poursuite ou de type « fais tout », l'autorisation reste active jusqu'à la Definition of Done du work item ou de la carte concernée. Une sous-tâche terminée, un commit, une PR, une fusion, une CI en cours, un rapport intermédiaire ou une synchronisation Trello sont uniquement des checkpoints. Après chacun, relire la checklist, choisir la prochaine action autonome et l'exécuter immédiatement. Il est interdit de conclure le message en listant des tâches restantes lorsque ces tâches sont réalisables sans décision humaine.

## Versionnement produit

Pour chaque changement, utiliser un commit conventionnel et déclarer dans la Pull Request son impact produit : `major`, `minor`, `patch` ou `aucune`. Une nouvelle version est réservée à une évolution du kit réellement consommée par les projets importateurs. Les corrections internes de CI, de workflow, de dépôt, de métadonnées, de documentation interne et d’outillage restent dans le changelog sans incrément artificiel. Une release met à jour `VERSION`, `kit_version`, le README, le changelog et le titre de Pull Request, puis reçoit un tag après fusion dans `main`. Lire `VERSIONING.md`.

## README obligatoire

Chaque ajout, correction, agent, Skill, politique, commande, changement de comportement ou modification de configuration doit mettre à jour le README concerné dans le même work item. Le README doit expliquer le changement, son usage, ses prérequis, ses limites et son impact sur l’orchestration. Une livraison est incomplète si la documentation publique ne reflète pas le comportement réel.

## Avant tout push GitHub

L'agent responsable exécute `bash .codex/scripts/verify-before-push.sh` et rend ses résultats. Un échec bloque le push. Ne jamais contourner le hook avec `--no-verify`.

## Installation Git obligatoire

Après l’installation du kit, vérifier que `.github/workflows/update-agentic-starter-kit.yml` existe et n’est pas ignoré. Avant le premier commit, l’ajouter explicitement avec `.gitignore` et `AGENTS.md`, puis vérifier son suivi avec `git ls-files --error-unmatch .github/workflows/update-agentic-starter-kit.yml`. Le workflow doit être présent dans la première branche publiée. Ne jamais le supprimer, le placer dans `.gitignore` ou le pousser directement vers `main`.


## Contrat du premier message d initialisation

Pour le message `Mode initialisation :`, le premier message de réponse doit être exclusivement un rapport de cadrage. Il doit afficher, dans cet ordre :

1. Le résultat de la vérification du cahier des charges.
2. Le chemin exact du fichier vérifié : .codex/PROJECT-BRIEF.md.
3. Le statut observé : absent, pending ou accepted.
4. L origine prouvée : chat, fichier existant ou génération depuis des documents identifiés.
5. La liste des documents réellement lus.
6. La liste des documents manquants.
7. La décision : demander le cahier, poser les questions manquantes ou réutiliser le contexte accepté.
8. L action suivante et ce qui reste interdit.

Le rapport doit également demander explicitement l approbation des hooks avant toute action produit : `Ouvre /hooks, relis les hooks du projet et approuve-les. Réponds ensuite lorsque la revue est terminée.` Si les hooks sont déjà approuvés, l agent doit l indiquer avec une preuve observable ; sinon il ne doit pas prétendre que la protection de cycle de vie est active.

Il est interdit de commencer par un résumé d installation, une liste d outils, une analyse technique ou une annonce de projet configuré. Tant que ce rapport n est pas affiché, aucune autre action ne doit être annoncée.

Si le statut est absent ou pending, répondre uniquement en demandant le cahier des charges. Si le statut est accepted, ne pas redemander le cahier, mais annoncer explicitement sa réutilisation et lancer la phase de complétude si elle n est pas prouvée comme terminée.

## Synchronisation du kit externe

Si le projet contient .workspace.toml et .codex/scripts/sync-workspace-kit.sh, exécuter ce synchroniseur au début d une nouvelle session avant toute analyse. Il vérifie la version distante, sauvegarde le kit local et ne remplace jamais le cahier des charges, le profil projet, l état d exécution, les décisions, les work items ou les journaux. Si la mise à jour échoue, conserver la version actuelle et poursuivre uniquement avec le kit local après signalement.
