# Politique CI et CD

## CI par défaut

Les jobs GitHub Actions générés pour les contrôles du projet utilisent un runner auto-hébergé avec un label déclaré dans le profil du projet, lorsque celui-ci est disponible. Avant de lancer la CI, vérifier que le runner est enregistré, en ligne, autorisé pour le dépôt et équipé des outils requis. Si aucun runner auto-hébergé n'est disponible, exécuter les validations localement ou documenter le blocage ; ne pas basculer silencieusement vers un runner facturable.

## Sobriété des exécutions

Pendant l'onboarding, le Coordinateur doit proposer `pull-request-only` ou `every-push` et enregistrer le choix dans `[delivery].ci_trigger_mode`. Le mode recommandé est `pull-request-only` : aucune CI complète sur les pushes de branches de travail, validations locales gratuites avant chaque push, CI complète sur les Pull Requests vers `dev` ou `develop` et sur `main`, avec `workflow_dispatch` pour un contrôle ponctuel. Le mode `every-push` exige une décision explicite de l'utilisateur.

Le projet ne doit pas lancer deux fois la même validation pour le même commit. Choisir un déclencheur principal par étape, généralement `pull_request` vers `develop` pour la validation de branche et `push` vers `main` uniquement pour la livraison, puis supprimer les doublons entre `push` et `pull_request`. Une promotion de `develop` vers `main` réutilise les preuves de la PR lorsque le commit est identique et ne relance que les contrôles strictement nécessaires.

Chaque workflow doit déclarer une concurrence par branche et annuler les exécutions obsolètes. Le Coordinateur doit exécuter d'abord les contrôles locaux gratuits, regrouper les corrections dans une seule branche et une seule PR par work item, éviter les pushes intermédiaires sans valeur de validation et ne relancer la CI qu'après une modification réelle ou une correction de configuration. Les matrices doivent rester limitées aux plateformes et versions justifiées par le profil du projet.

La CI est générée après onboarding seulement. Elle exécute le preflight, le socle cybersécurité et les commandes déclarées dans `project-profile.toml`. Le workflow reçoit uniquement `contents: read`, limite les exécutions concurrentes et ne contient aucun secret.

## Commandes pilotées par le projet

`commands.install`, `commands.lint`, `commands.test`, `commands.build` et `commands.security` sont complétées avec les commandes réellement vérifiées pour le projet. Une commande vide est signalée comme non configurée, elle n'est jamais inventée.

## CD bloqué par défaut

Aucun déploiement n'est généré automatiquement. Avant toute automatisation CD, le projet doit définir l'environnement cible, les secrets hors dépôt, les approbations, la stratégie de migration, les vérifications après déploiement et une procédure de retour testable.

## Promotion

Une promotion exige CI verte observable, audit requis par la matrice de risque, rapport de livraison et approbation humaine lorsque le déploiement, des données sensibles ou une action irréversible sont concernés.
