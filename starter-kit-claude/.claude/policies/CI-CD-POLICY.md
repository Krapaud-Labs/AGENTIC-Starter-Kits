# Politique CI et CD

## CI par défaut

Le profil déclare la visibilité du dépôt dans `[delivery].github_repository_visibility`; la valeur initiale est `unknown`. Si les champs sont absents d’un profil de projet existant, le générateur applique aussi ses défauts sécurisés : visibilité `unknown`, approbation `false`, preuve vide et durée de 30 minutes. Le générateur n’effectue pas de vérification en direct de la visibilité ou de la facturation. Une visibilité `public` explicitement confirmée par le propriétaire autorise les runners hébergés standards tels que `ubuntu-latest`, sous réserve des quotas applicables. Pour `private` ou `unknown`, le générateur refuse de créer un workflow hébergé avant d’avoir les deux attestations suivantes : `github_actions_private_billing_approved = true` (défaut `false`) et `github_actions_usage_limit_evidence` non vide et différente des valeurs de placeholder reconnues `none`, `unknown` et `[[A_COMPLETER]]` (défaut vide). Cette référence doit décrire une limite ou un budget GitHub vérifié manuellement par une personne autorisée; elle ne contient aucun secret.

Le profil borne chaque job par `github_actions_max_minutes_per_run`, converti en `timeout-minutes`. La valeur doit être un entier entre 1 et 360; le défaut est 30. Ce délai limite une exécution individuelle, pas le cumul mensuel. Pour les dépôts privés ou de visibilité inconnue, l’approbation et la référence de limite restent nécessaires avant génération. Un runner auto-hébergé n’est utilisable que s’il est explicitement configuré, disponible et autorisé pour le dépôt; documenter ses responsables, ses coûts éventuels, sa maintenance, ses mises à jour, sa disponibilité et sa sécurité.

## Sobriété des exécutions

Pendant l'onboarding, le Coordinateur doit proposer `pull-request-only` ou `every-push` et enregistrer le choix dans `[delivery].ci_trigger_mode`. Le mode recommandé est `pull-request-only` : aucune CI complète sur les pushes de branches de travail, validations locales gratuites avant chaque push, CI complète sur les Pull Requests vers `dev` ou `develop` et sur `main`, avec `workflow_dispatch` pour un contrôle ponctuel. Le mode `every-push` exige une décision explicite de l'utilisateur. Pendant cette étape, relever la visibilité confirmée du dépôt, le consentement et la référence de limite requis par la politique zéro dépense; ne jamais traiter un champ d’attestation comme une vérification en direct.

Le projet ne doit pas lancer deux fois la même validation pour le même commit. Choisir un déclencheur principal par étape, généralement `pull_request` vers `develop` pour la validation de branche et `push` vers `main` uniquement pour la livraison, puis supprimer les doublons entre `push` et `pull_request`. Une promotion de `develop` vers `main` réutilise les preuves de la PR lorsque le commit est identique et ne relance que les contrôles strictement nécessaires.

Chaque workflow doit déclarer une concurrence par branche et annuler les exécutions obsolètes. Le Coordinateur doit exécuter d'abord les contrôles locaux gratuits, regrouper les corrections dans une seule branche et une seule PR par work item, éviter les pushes intermédiaires sans valeur de validation et ne relancer la CI qu'après une modification réelle ou une correction de configuration. Les matrices doivent rester limitées aux plateformes et versions justifiées par le profil du projet.

La CI est générée après onboarding seulement. Elle exécute le preflight, le socle cybersécurité et les commandes déclarées dans `project-profile.toml`. Le workflow de CI généré reçoit uniquement `permissions: contents: read` et déclare une concurrence par workflow et référence (`github.workflow`/`github.ref`) avec `cancel-in-progress: true` afin d’annuler les exécutions obsolètes. Il ne contient aucun secret. Le workflow updater est distinct et soumis à la garde de runners hébergés; ses permissions d’écriture ne sont pas héritées par la CI.

## Commandes pilotées par le projet

`commands.install`, `commands.lint`, `commands.test`, `commands.build` et `commands.security` sont complétées avec les commandes réellement vérifiées pour le projet. Une commande vide est signalée comme non configurée, elle n'est jamais inventée.

## CD bloqué par défaut

Aucun déploiement n'est généré automatiquement. Avant toute automatisation CD, le projet doit définir l'environnement cible, les secrets hors dépôt, les approbations, la stratégie de migration, les vérifications après déploiement et une procédure de retour testable.

## Promotion

Une promotion exige CI verte observable, audit requis par la matrice de risque, rapport de livraison et approbation humaine lorsque le déploiement, des données sensibles ou une action irréversible sont concernés.

La production publique, la préproduction et l'administration opérateur sont trois preuves distinctes. Une production saine ne remplace jamais une préproduction, mais l'absence de cible préproduction ou de rollback opérateur ne bloque pas les tests locaux, la conception, l'audit de code ou la livraison vers `dev`. Le Coordinateur active DevOps pour inventorier les accès et prépare une cible locale ou documente uniquement la porte opérateur dépendante en `needs-review`, sans marquer le Goal global `blocked` lorsque les autres portes sont livrables.
