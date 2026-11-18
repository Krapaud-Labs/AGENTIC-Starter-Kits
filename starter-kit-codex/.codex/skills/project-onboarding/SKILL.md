# Skill project-onboarding

## Précondition obligatoire

Le Coordinateur applique d'abord la porte de démarrage d'initialisation de `ORCHESTRATION.md`, consigne les instructions relues, puis crée ou reprend le Goal persistant de l'initialisation. Ce Goal couvre tout le flux jusqu'à la livraison vérifiée ; il est obligatoire même sans code et même si Trello sert d'abord de checkpoint.

## Objectif

Adapter le kit à un nouveau projet avant toute modification du produit.

## Quand l'utiliser

Après acceptation du cahier des charges, après un changement majeur de stack ou si le profil est incomplet.

## Entrées

`.codex/PROJECT-BRIEF.md` accepté, `.codex/project-inventory.md`, `.codex/RISK-MATRIX.md`, état Git, manifests, documentation, scripts, CI existante et demande utilisateur.

## Procédure

1. Lire l'inventaire et les fichiers de projet pertinents.
3. Identifier langage, framework, gestionnaire de paquets, tests, build, CI, données, authentification, déploiement et conventions Git.
4. Si un choix technique n’est pas détectable, proposer une baseline cohérente avec le cahier, la documenter comme décision réversible et poursuivre sans demander une confirmation pour chaque outil. Demander uniquement les décisions métier, irréversibles, réglementaires, financières ou bloquantes.
6. Compléter `[stack]` dans `project-profile.toml` avec uniquement les technologies réellement détectées.
6. Compléter le reste du profil avec les commandes et conventions vérifiées.
7. Définir les commandes de validation réellement disponibles.
8. Proposer la cadence CI `pull-request-only` ou `every-push` et enregistrer le choix dans `[delivery].ci_trigger_mode`. Renseigner `[delivery].github_repository_visibility` (`public`, `private` ou `unknown`; garder `unknown` si la visibilité n’est pas confirmée par le propriétaire). Une visibilité `public` explicitement confirmée autorise le runner hébergé standard. Pour `private` ou `unknown`, ne générer aucun workflow hébergé sans `github_actions_private_billing_approved = true` et une référence différente des valeurs de placeholder reconnues `none`, `unknown` et `[[A_COMPLETER]]` dans `github_actions_usage_limit_evidence`, attestant une limite ou un budget vérifié par une personne autorisée. Fixer `github_actions_max_minutes_per_run` à un entier entre 1 et 360 (défaut 30); préciser que `timeout-minutes` borne chaque job, pas le cumul mensuel. Générer le workflow hébergé seulement après validation de cette garde. Si elle n’est pas satisfaite, ne créer aucun workflow hébergé; conserver la validation locale ou utiliser uniquement un workflow séparé avec runner auto-hébergé déjà configuré et documenté. Recommander `pull-request-only` et ne sélectionner `every-push` qu’après décision explicite.
9. Conserver les conventions existantes, y compris la branche d'intégration.
9. Créer une décision locale si une convention est absente ou contradictoire.
10. Appliquer le Skill de planification qui correspond à `tracking.mode` : `github` déclenche `github-projects-planning` et complète `docs/project-management/github-project.md` avec les Issues et leur appartenance au Project; `trello` déclenche `trello-planning` et complète `docs/project-management/trello-board.md`; `local` conserve les work items et le plan dans le dépôt sans créer de ressource distante. Si le gestionnaire distant sélectionné est indisponible, enregistrer `pending_activation`, continuer les tâches indépendantes et ne pas annoncer de synchronisation vérifiée.
11. Si le projet contient déjà du code, des fonctionnalités ou un historique de livraison, utiliser le parcours accéléré de reprise. En une passe bornée, inventorier les écarts visibles dans la conception, le périmètre, l’architecture, les données, la sécurité, le code, les tests, l’accessibilité, l’UX, la documentation, la CI, l’exploitation et les risques. Ne pas refaire l’audit approfondi de chaque domaine. Créer les work items de couverture dans le gestionnaire sélectionné ou localement, avec une synthèse, une priorité, une source et une prochaine action. Budget de reprise : 20 minutes actives, 30 actions maximum et une seule passe de relecture distante lorsque le suivi distant est activé.
12. Si le gestionnaire sélectionné existe déjà à distance, inspecter ses capacités et sa structure avant reprise. Pour GitHub Projects, relire le résumé, les vues, les champs et un échantillon représentatif des Issues; pour Trello, relire le tableau, ses listes, labels et checklists. Préserver les champs et valeurs natifs disponibles. Les colonnes de travail restent `Todo`, `In Progress` et `Done`; les états de blocage ou de revue sont des labels ou métadonnées. Le suivi local n’exige aucune relecture distante.
13. Une fois toutes les réponses d'initialisation recueillies, terminer automatiquement l'onboarding avant toute question sur le développement. Compléter les profils et documents, mettre à jour `.gitignore` sans ignorer les livrables requis, créer une branche d'onboarding, committer uniquement ses artefacts, pousser la branche, ouvrir la PR vers `dev`, attendre et vérifier ses contrôles, puis fusionner ou documenter précisément le blocage. Un simple push sur `dev`, une branche créée ou une PR préparée ne constitue pas une livraison. Ne demander s'il faut lancer le développement qu'après la preuve de la PR vers `dev` et sa relecture. Si la PR est impossible, conserver l'onboarding ouvert et ne pas le déclarer terminé.
11. Exécuter `bash .codex/scripts/initialize-project-design.sh`, puis appliquer le Skill `conception` pour compléter `docs/` avant toute implémentation.

## Sortie

Profil complété, résumé des faits confirmés, inconnues restantes et recommandations de Skills actifs.

## Contrôles

Chaque valeur renseignée doit être reliée à un fichier, une commande ou un résultat observable. Les champs inconnus restent inconnus, sans inférence.

## Mesures

Nombre de conventions détectées, inconnues restantes, temps d'initialisation et corrections ultérieures du profil.

## Arrêt

Ne pas deviner une commande, un environnement de production, une branche ou une politique de sécurité. Demander une décision si l'information ne peut pas être établie.
