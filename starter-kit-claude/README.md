# Kit d'orchestration Claude Code portable

![Version du kit](https://img.shields.io/badge/version-1.6.3-blue.svg)

Ce kit installe une gouvernance projet native pour Claude Code. Il ne construit rien tant que le cahier des charges n'a pas été fourni et formalisé.

## Prérequis

- Claude Code est installé.
- Le projet possède une racine dédiée. Un dépôt Git est recommandé, mais l'initialisation fonctionne avant `git init`.
- Le cahier des charges est prêt ou peut être envoyé dans le chat au premier échange.

## Installation pas à pas

1. Ouvrir un terminal dans le nouveau projet.

2. Définir le chemin du kit source :

```bash
KIT_SOURCE="/chemin/vers/agentic-starter-kits/starter-kit-claude"
```

3. Copier le point d'entrée obligatoire et toute la configuration :

```bash
cp "$KIT_SOURCE/CLAUDE.md" ./CLAUDE.md
cp -R "$KIT_SOURCE/.claude" ./.claude
```

4. Lancer l'initialisation non destructive :

```bash
bash .claude/scripts/init-project.sh
```

Cette commande crée `project-profile.toml` s'il est absent et génère un inventaire des fichiers détectés. Elle ne modifie pas le code du produit.

5. Démarrer une nouvelle session Claude Code à la racine du projet :

```bash
claude
```

Une nouvelle session est importante car les sous-agents de `.claude/agents/` sont chargés à son démarrage.

6. Envoyer une demande projet normale, par exemple :

```text
Je veux construire une application de réservation pour des associations locales.
```

7. Claude doit répondre uniquement par une demande de cahier des charges. Envoyer alors le cahier dans le chat. Il peut être rédigé naturellement, mais doit préciser le besoin, les utilisateurs, le périmètre, les contraintes, les critères de réussite et le hors périmètre.

8. Après acceptation, Claude remplit `.claude/PROJECT-BRIEF.md`, applique le Skill `project-onboarding` et complète `.claude/project-profile.toml` avec les technologies réellement présentes ou validées.

9. Vérifier que le projet est prêt :

```bash
bash .claude/scripts/preflight.sh
```

`Preflight OK` confirme que le cahier est accepté, que le profil est complet et que les contrôles structurels du kit passent.

## Utilisation quotidienne

Après l'onboarding, décrire une tâche avec son résultat attendu et ses critères d'acceptation. Le Coordinateur attribue ensuite les rôles, demande des preuves et impose l'audit avant clôture.

Pour ne pas déclencher la porte projet dans une conversation générale, commencer le message par :

```text
Mode général : explique-moi la différence entre REST et GraphQL.
```

Pour entretenir le kit sans démarrer le produit :

```text
Mode maintenance : vérifie les Skills du kit.
```

## Arborescence importée

```text
CLAUDE.md                         Instructions permanentes chargées par Claude Code
.claude/agents/                   Sous-agents Markdown avec frontmatter YAML
.claude/skills/                   Skills natifs, un dossier par SKILL.md
.claude/project-profile.toml      Technologies et commandes du projet
.claude/PROJECT-BRIEF.md          Cahier des charges formalisé après réception
.claude/policies/                 Qualité, Gitflow, incidents et validation
.claude/scripts/                  Initialisation et contrôles internes
.claude/work-items/               Tâches suivies et archives
.claude/decisions/                Décisions traçables
.claude/metrics/                  Mesures coût et qualité
.claude/reports/                  Rapports d'audit et de livraison
```

Les dossiers initialement vides contiennent un `.gitkeep`, afin qu'ils restent présents dans Git après import ou clonage.

## À ne pas faire

- Ne pas importer le kit Codex dans le même projet.
- Ne pas modifier `PROJECT-BRIEF.md` pour simuler son acceptation sans cahier réel.
- Ne pas lancer le preflight avant l'onboarding en attendant un succès : son blocage est intentionnel.
- Ne pas copier une CI générique sans adapter les commandes à `project-profile.toml`.

## Validation avant GitHub

`init-project.sh` installe un hook Git pre-push lorsque le projet est un dépôt. Avant chaque push, le rôle responsable exécute :

```bash
bash .claude/scripts/verify-before-push.sh
```

Le contrôle lance le preflight, le socle cybersécurité et les commandes configurées dans `project-profile.toml`. Pour un projet frontend ou backend, les commandes `lint` et `test` sont obligatoires. Un échec bloque le push. Ne jamais utiliser `--no-verify`.

Après l’onboarding, générer si nécessaire le workflow GitHub Actions du projet :

```bash
bash .claude/scripts/generate-github-ci.sh
```

Le générateur refuse de remplacer un workflow existant. Relire le fichier produit, définir les secrets dans GitHub et garder tout déploiement soumis aux validations décrites dans les politiques.

## Compatibilité machine

macOS et Linux : utiliser Bash avec Git, ripgrep et Python 3.11 ou plus récent.

Windows : installer Git for Windows et Python 3.11 ou plus récent. Utiliser Git Bash, ou PowerShell avec le wrapper suivant :

```powershell
.\.claude\scripts\run.ps1 preflight
```

Les commandes disponibles dans le wrapper sont `init-project`, `preflight`, `verify-before-push`, `run-project-checks`, `generate-github-ci`, `show-project-context` et `doctor`.

## Conception obligatoire

Après le cahier accepté et avant toute implémentation, le Coordinateur exécute :

```bash
bash .claude/scripts/initialize-project-design.sh
```

Le Concepteur complète ensuite `docs/` avec vision, user stories, parcours, architecture, diagrammes, données, contrats, sécurité, roadmap et décisions. Tout document non applicable contient une justification. Chaque work item met à jour les documents touchés et l’Auditeur bloque une livraison si le code diverge de la conception.

## Gitflow obligatoire

Chaque feature, correctif ou tâche documentaire se fait sur une branche dédiée. Les agents ne committent ni ne poussent directement vers `main`, `master` ou la branche d’intégration. Les commits sont atomiques, limités par défaut à 75 fichiers et 1200 lignes, et ne mélangent jamais plusieurs features. `verify-before-push.sh` bloque les écarts.

## Dossier de conception de niveau CDA

Le générateur de conception produit des documents structurés, mais aucun marqueur `[[A_COMPLETER]]` ne peut rester avant le preflight. Après le cahier accepté, le Concepteur transforme chaque modèle en dossier complet : contexte, objectifs mesurables, acteurs, user stories et critères, règles métier, scénarios d’erreur, parcours, diagrammes Mermaid, architecture, données, contrats, sécurité, roadmap, stratégie de validation, rollback et décisions. Un simple squelette ne valide pas le projet.


Le journal qualité partagé est `docs/quality/quality-journal.md`. Il est alimenté par tous les audits et toutes les corrections. Une anomalie possède un identifiant stable, une preuve, un propriétaire, une correction et une vérification indépendante.

## Choix Trello obligatoire

Après acceptation du cahier des charges, l’agent demande une réponse explicite : `Veux-tu que je prépare un Trello complet avec toutes les tâches détaillées du projet ? Réponds oui ou non.` Le choix est enregistré dans `project-profile.toml`.

Avec `oui`, le Coordinateur et le Skill `trello-planning` construisent toujours `docs/project-management/trello-board.md` avec toutes les petites features, les cartes détaillées, les dépendances, les membres, les responsables, les checklists Definition of Done, les critères, les preuves, les tâches de sécurité, les tests, la documentation, l’audit et la livraison. Le fichier est ensuite synchronisé avec Trello si l’intégration est autorisée. Avec `non`, le projet continue sans tableau Trello.

## Documentation d’installation

Le tutoriel unique et complet se trouve dans [INSTALLATION.md](../INSTALLATION.md). Il décrit toute la procédure, depuis la copie du kit jusqu’à la première livraison.

## Agents Claude Code

Le kit Claude Code comprend 16 agents : six agents du noyau et dix spécialistes optionnels activables selon le profil, le risque et les besoins du projet.

| Fichier | Rôle | Responsabilité |
| --- | --- | --- |
| `.claude/agents/coordinateur.md` | Coordinateur | plan, dépendances, budget, orchestration et clôture |
| `.claude/agents/concepteur.md` | Concepteur | conception CDA, contrats, architecture et décisions |
| `.claude/agents/frontend.md` | Frontend | interface, accessibilité, tests client et preuves visuelles |
| `.claude/agents/backend.md` | Backend | API, données, logique métier, tests et observabilité |
| `.claude/agents/cybersecurite.md` | Cybersécurité | menaces, vulnérabilités, contrôles et blocage critique |
| `.claude/agents/auditeur.md` | Auditeur | vérification indépendante, preuves, régressions et décision |

Les spécialistes optionnels sont activés dans `[agents]` de `.claude/project-profile.toml` : `produit`, `qa`, `devops`, `performance`, `ux_research`, `accessibilite`, `data`, `documentation`, `release` et `conformite`. Le Coordinateur les active selon les besoins détectés, le risque et le budget.

| Identifiant | Fichier | Livrable principal |
| --- | --- | --- |
| `produit` | `.claude/agents/produit.md` | Priorités, valeur métier et critères fonctionnels. |
| `qa` | `.claude/agents/qa.md` | Stratégie de tests, couverture et régression. |
| `devops` | `.claude/agents/devops.md` | CI/CD, environnements, observabilité et rollback. |
| `performance` | `.claude/agents/performance.md` | Baseline, mesures et budget de performance. |
| `ux_research` | `.claude/agents/ux_research.md` | Hypothèses utilisateur, parcours et validation. |
| `accessibilite` | `.claude/agents/accessibilite.md` | Contrôles WCAG, clavier et lecteurs d’écran. |
| `data` | `.claude/agents/data.md` | Modèle, qualité des données et migrations. |
| `documentation` | `.claude/agents/documentation.md` | Documentation utilisateur, API et exploitation. |
| `release` | `.claude/agents/release.md` | Version, changelog, migration et notes de livraison. |
| `conformite` | `.claude/agents/conformite.md` | Exigences RGPD, licences et preuves de conformité. |

Le Coordinateur ne les appelle pas tous systématiquement. Il lit `.claude/SPECIALIST-AGENTS.md`, vérifie la condition d’activation, inscrit la justification dans le work item et exige le livrable correspondant.

Une CI en cours ne clôture jamais le work item. Le Coordinateur attend les résultats, traite les erreurs, corrige les lints et les dettes historiques du périmètre par lots, puis relance les contrôles jusqu’à la Definition of Done.

Le kit est actuellement en version `1.6.3`. Toute modification du kit doit mettre à jour ce README, le changelog et la version selon `VERSIONING.md`.

## Gouvernance complète disponible

Le fichier `.claude/SPECIALIST-AGENTS.md` définit les conditions d’activation, les livrables et l’ordre de contrôle des dix spécialistes. Le Coordinateur lit ce fichier avant toute délégation, consulte `[agents]` dans le profil et justifie chaque activation dans le work item.

Le kit comprend aussi `RUNTIME-STATE.md` et `scripts/checkpoint.sh` pour reprendre une session, `scripts/cost-tracker.sh` pour aider le Coordinateur à réduire les coûts, et le mode Trello `time-gated` pour suspendre uniquement une carte dépendante d’une échéance. Les flux indépendants continuent.

Toute évolution doit mettre à jour ce README, `CHANGELOG.md`, la version SemVer, le titre et la description de la Pull Request. Une livraison sans documentation correspondante est refusée.

## Skills Claude Code

Les Skills natifs se trouvent dans `.claude/skills/<nom>/SKILL.md`. Ils couvrent l’intake, l’onboarding, la conception, la coordination, la planification Trello, l’implémentation, l’audit qualité, l’audit sécurité, le journal qualité, la livraison et l’optimisation coût. Les agents utilisent ces procédures avec un contexte limité et traçable.

Claude Code reste l’orchestrateur de la session. Les sous-agents ne travaillent que sur des flux autorisés et indépendants.

## Optimisation pilotée par le Coordinateur

Le script `.claude/scripts/cost-tracker.sh` conserve les appels dans `.claude/metrics/usage.jsonl` et produit un résumé exploitable :

```bash
bash .claude/scripts/cost-tracker.sh report
```

Le Coordinateur utilise ces données pour réduire le contexte, supprimer les relances, regrouper les tâches et router chaque demande vers Luna, Terra ou Sol selon le risque. Les prix sont optionnels dans le profil et aucune estimation monétaire n’est inventée.

Après une instruction « fais tout », le Coordinateur poursuit jusqu’à la Definition of Done sans demander « Continue ». Il corrige les erreurs récupérables, vérifie les résultats et ne sollicite l’utilisateur que pour une décision sensible ou irréversible.

## Synchronisation automatique

L’initialisation installe un workflow GitHub Actions hebdomadaire qui ouvre une Pull Request pour chaque évolution du kit officiel. Le script `.claude/scripts/update-starter-kit.sh` permet aussi une mise à jour manuelle avec un remote, une référence et une branche.

## Qualité documentaire premium

Utilisez `documentation-authoring` pour rédiger et `documentation-audit` pour relire. Le contrôle `bash .claude/scripts/validate-documentation.sh` vérifie les métadonnées, les dates et les marqueurs incomplets avant la livraison.
La version du kit évolue uniquement lorsqu’un changement consommé par un projet importateur le justifie.
L’installateur vérifie que le workflow de mise à jour est suivi par Git avant la première publication.
Le Coordinateur applique une politique universelle de routage pour toute demande nouvelle, corrective ou hors cahier des charges.

La validation navigateur est obligatoire pour les changements frontend et doit être documentée dans le work item.

La synchronisation Trello est obligatoire immédiatement après chaque étape livrée, avec relecture de la carte et de sa checklist.

Le Coordinateur distingue désormais les tâches terminées, les sous-tâches en attente d’autorisation et les blocages réels.

Une carte ne passe dans `Terminé` qu’après validation complète, y compris juridique ou externe si elle est requise.

Les descriptions Trello utilisent de vrais retours à la ligne et sont relues après synchronisation.

Une fusion de Pull Request est un checkpoint et non une fin de carte. Le Coordinateur reprend automatiquement la prochaine étape ouverte.

Le workflow récupère le script officiel à l’exécution et ne dépend plus d’un script ignoré dans `.claude/`.

L’installateur propose désormais les distributions native et external, avec conservation du socle local et du contexte projet selon le mode choisi.

Dans une conversation existante, utiliser `Mode initialisation :` pour relancer de façon fiable la porte obligatoire du cahier des charges.

Envoyer cette commande seule depuis la racine du projet. Claude recharge alors les instructions et l'état du kit, vérifie le cahier des charges et n'autorise aucune analyse technique, aucun work item ni aucune modification produit avant sa réception et son acceptation. La procédure détaillée est documentée dans le guide d'installation du dépôt principal.

## Diagnostic

Le diagnostic local vérifie la version, le manifeste, le cahier des charges, l état runtime, le workflow external, le point d entrée et les fichiers qui ne doivent pas être suivis par Git :

```bash
bash .claude/scripts/doctor.sh
```
