# Installation complète des Agentic Starter Kits

Ce guide explique comment importer un kit dans un nouveau projet et démarrer une construction agentique contrôlée. Il faut choisir Codex ou Claude Code. Ne jamais importer les deux kits dans le même projet.

## 1. Préparer la machine

Installer :

- Git.
- Bash sur macOS ou Linux.
- Git for Windows avec Git Bash sur Windows.
- Python 3.11 ou plus récent.
- Ripgrep.
- Codex ou Claude Code selon le kit choisi.

Vérifier les outils :

```bash
git --version
bash --version
python3 --version
rg --version
```

Sous Windows, ouvrir Git Bash depuis la racine du projet. PowerShell peut être utilisé avec les wrappers `run.ps1` après installation de Git for Windows.

## 2. Créer ou ouvrir le projet

Créer un dossier dédié au projet, puis l’ouvrir dans un terminal :

```bash
mkdir mon-projet
cd mon-projet
git init
git switch --create develop
```

Si le projet existe déjà, ne pas supprimer ses fichiers. Importer le kit de manière non destructive et conserver les conventions existantes.

## 3. Choisir et copier un kit

Le seul mode disponible est `shared`. Il installe une seule copie du kit dans le registre partagé de la machine et place dans chaque projet les liens symboliques, le contexte local et le manifeste de version. Aucun workflow updater n’est installé par défaut (`--updates off`). L’option `--updates dispatch` demande un workflow manuel et `--updates pr` demande un workflow planifié, tous deux soumis à la garde de visibilité/facturation ci-dessous.

Pour Codex :

```bash
./install.sh --kit codex --mode shared --target /chemin/absolu/vers/mon-projet
```

Pour Claude :

```bash
./install.sh --kit claude --mode shared --target /chemin/absolu/vers/mon-projet
```

Le mode partagé conserve les fichiers universels dans `AGENTIC_KIT_HOME` et les projets ne conservent que leur état local. Les mises à jour sont donc reçues par tous les projets depuis une source unique après activation de l’updater. L’installation de base le laisse désactivé; après avoir renseigné et confirmé les champs de visibilité et d’approbation du profil, lancez `bash .codex/scripts/init-project.sh --updates dispatch` ou remplacez `.codex` par `.claude` pour un déclencheur manuel. Pour le calendrier, utilisez `--updates pr`. Sans profil admissible, le gate refuse la création.

Définir le chemin local du dépôt source. Adapter ce chemin à votre machine.

Pour Codex :

```bash
KIT_SOURCE="/chemin/vers/agentic-starter-kits/starter-kit-codex"
cp "$KIT_SOURCE/AGENTS.md".
cp -R "$KIT_SOURCE/.codex".
```

Pour Claude Code :

```bash
KIT_SOURCE="/chemin/vers/agentic-starter-kits/starter-kit-claude"
cp "$KIT_SOURCE/CLAUDE.md".
cp -R "$KIT_SOURCE/.claude".
```

Ne pas copier `starter-kit-codex` ou `starter-kit-claude` en tant que dossier dans le projet. Copier leur point d’entrée et leur dossier caché à la racine du projet.

## 4. Initialiser le kit

Codex :

```bash
bash .codex/scripts/init-project.sh
```

Claude Code :

```bash
bash .claude/scripts/init-project.sh
```

L’initialisation crée le profil s’il est absent, génère l’inventaire du projet et installe le hook Git pre-push. Elle ne modifie pas le code produit.

## 5. Démarrer la première conversation

Ouvrir l’outil choisi à la racine du projet.

Codex :

```bash
codex
```

Claude Code :

```bash
claude
```

Envoyer une demande projet simple, par exemple :

```text
Je veux construire une application de réservation pour des associations locales.
```

## Reprendre une conversation déjà ouverte

Une nouvelle conversation n'est pas obligatoire. Si une conversation existe déjà, envoyer exactement le message suivant :

```text
Mode initialisation :
```

Ce mode est prioritaire sur le sujet de la conversation. L'agent recharge les instructions du kit, vérifie l'état local du projet et recherche le cahier des charges ainsi que le profil technique. Tant que le cahier des charges n'est pas reçu et accepté, il ne doit pas coder, créer de work item, modifier un gestionnaire distant ou choisir une architecture.

Après réception du cahier des charges, l'agent pose les questions manquantes avec une recommandation explicite. Il crée ensuite les documents de conception, le profil technique, le registre des décisions et le premier plan de livraison. Cette commande est donc la méthode fiable pour reprendre l'initialisation sans perdre la conversation existante.

Si l'agent répond à côté, renvoyer la commande depuis la racine du projet, puis vérifier que la réponse commence par la demande du cahier des charges. Ne pas démarrer le développement avant cette confirmation.

Tant que le cahier des charges n’est pas reçu et accepté, l’agent ne doit pas analyser la stack, écrire du code, créer une tâche ou lancer une orchestration.

## 6. Fournir le cahier des charges

Le cahier doit préciser au minimum :

- Le problème et la vision.
- Les utilisateurs et parties prenantes.
- Les objectifs mesurables.
- Les fonctionnalités attendues.
- Le périmètre et le hors périmètre.
- Les contraintes de délai, budget, plateformes, conformité et sécurité.
- Les critères de réussite.
- Les intégrations et données concernées.
- Les inconnues nécessitant une décision humaine.

L’agent formalise ensuite le document propre au projet :

```text
.codex/PROJECT-BRIEF.md   pour Codex
.claude/PROJECT-BRIEF.md  pour Claude Code
```

Le statut doit devenir `accepted` uniquement lorsque les informations essentielles sont présentes.

## 7. Choisir le gestionnaire de suivi

Après réception du cahier des charges, l’agent demande quel gestionnaire utiliser, avec trois choix :

- `local` (recommandé par défaut) : work items conservés dans `.codex/work-items/` ou `.claude/work-items/`, sans service distant.
- `github` : GitHub Issues et, si sélectionné et accessible, un GitHub Project pour organiser les Issues.
- `trello` : un tableau Trello, ses cartes et checklists, si l’utilisateur le choisit explicitement.

Enregistrer le choix dans `[tracking].mode` de `project-profile.toml`. Activer uniquement le gestionnaire choisi : `github_projects_choice = "enabled"` pour `github`, `trello_choice = "enabled"` pour `trello`; mettre à `"disabled"` le choix de l’autre service distant. Pour `local`, désactiver les deux intégrations distantes. Si un service choisi n’est pas accessible, conserver le suivi local et inscrire `pending_activation`; ne jamais prétendre qu’une synchronisation distante a réussi.

Pour GitHub, les Issues portent les descriptions et tâches en Markdown; un Project relie les Issues et utilise les champs natifs réellement disponibles. Pour Trello, les cartes et checklists sont gérées dans le tableau. Le suivi local conserve les work items et n’exige aucun accès externe. Lorsque les colonnes de travail s’appliquent, utiliser les statuts canoniques `Todo`, `In Progress` et `Done`; les états de blocage ou de revue restent des labels ou métadonnées.

## 8. Laisser l’agent détecter la stack

L’agent lit l’inventaire, les manifests et les fichiers de configuration. Il complète uniquement les faits vérifiables dans :

```text
.codex/project-profile.toml
.claude/project-profile.toml
```

Ce fichier contient notamment :

- Langages.
- Frameworks frontend et backend.
- Base de données et ORM.
- Runtime et gestionnaire de paquets.
- Commandes install, lint, test, build et sécurité.
- CI, déploiement, authentification et capacités.
- Gestionnaire de suivi choisi : local, GitHub Projects ou Trello.
- Limites Gitflow et règles de livraison.

Ne pas remplir ce fichier avec une technologie supposée.

## 9. Générer et compléter la conception

Après acceptation du cahier des charges et enregistrement du gestionnaire choisi, l’agent exécute le générateur de conception.

Codex :

```bash
bash .codex/scripts/initialize-project-design.sh
```

Claude Code :

```bash
bash .claude/scripts/initialize-project-design.sh
```

Le Concepteur remplace tous les marqueurs de modèle dans `docs/` et produit une conception exploitable de niveau CDA : vision, acteurs, objectifs, user stories, règles métier, critères, erreurs, parcours, diagrammes Mermaid, architecture, données, contrats, sécurité, roadmap, rollback et décisions.

Aucun document ne doit rester générique. Un document non applicable doit contenir une justification précise. Le preflight bloque tant qu’un marqueur `[[A_COMPLETER]]` reste présent.

## 10. Vérifier l’onboarding

Codex :

```bash
bash .codex/scripts/preflight.sh
```

Claude Code :

```bash
bash .claude/scripts/preflight.sh
```

Le résultat attendu est `Preflight OK`. Un échec est intentionnel lorsqu’il manque le cahier, le choix du gestionnaire, le profil, la conception ou une preuve obligatoire.

## 11. Créer un premier work item

Demander à l’agent de créer une tâche atomique avec :

- Objectif.
- Hors périmètre.
- Critères d’acceptation.
- Rôle responsable.
- Fichiers’autorisés.
- Dépendances.
- Niveau de risque.
- Budget et règle d’arrêt.
- Preuve attendue.
- Documents de conception à mettre à jour.

Chaque feature doit avoir une branche dédiée :

```bash
git switch --create feature/US-001-reservation
```

## 12. Autoriser l’exécution complète

Une fois le cahier accepté, écrire par exemple :

```text
Fais tout pour ce work item jusqu’à sa Definition of Done.
```

Le Coordinateur enchaîne les étapes autorisées, corrige les erreurs récupérables, relance les contrôles et documente les décisions. Il ne demande pas une validation intermédiaire pour chaque commande. Une question n’est posée que lorsqu’une décision métier, un secret, une permission externe ou une action irréversible est réellement nécessaire.

## 13. Suivre et optimiser le coût

Le suivi est destiné au Coordinateur. Après une délégation, enregistrer les volumes si l’intégration ne les fournit pas automatiquement :

```bash
bash .codex/scripts/cost-tracker.sh record --agent backend --model gpt-5.6-terra --input 12000 --output 3000 --work-item US-001 --feature reservation
bash .codex/scripts/cost-tracker.sh report
```

Avec Claude, remplacer `.codex` par `.claude`. Le registre JSONL permet de comparer les agents, modèles, fonctionnalités, relances et volumes. Le profil peut définir un budget de tokens et des tarifs optionnels. Aucun montant ne doit être déduit si les tarifs ne sont pas configurés.

## 14. Finaliser une livraison

Avant le commit, le rôle responsable lance les validations du projet. Avant le push, le hook et `verify-before-push.sh` vérifient le preflight, la sécurité, le lint, les tests, le build, les documents et les limites du diff. L’Auditeur rend une décision indépendante. La Pull Request doit expliquer le résultat, les preuves, les risques résiduels et les migrations éventuelles.

Les commits doivent rester atomiques. Ne jamais créer un commit de centaines ou milliers de fichiers pour plusieurs fonctionnalités.

## 15. Utiliser le journal qualité

Le journal est créé ici :

```text
docs/quality/quality-journal.md
```

Tous les agents d’audit ou de correction l’utilisent. Chaque anomalie doit avoir un identifiant, une source, une catégorie, une gravité, un impact, une preuve, un responsable, une correction et un statut. Une correction passe par `fixed`, puis `verified` après une vérification indépendante.

## 16. Valider avant chaque push

Codex :

```bash
bash .codex/scripts/verify-before-push.sh
```

Claude Code :

```bash
bash .claude/scripts/verify-before-push.sh
```

La commande vérifie la branche, les commits atomiques, le preflight, la sécurité, le lint, les tests, le build et les commandes configurées. Ne jamais utiliser `git push --no-verify`.

## 17. Générer la CI du projet

Après l’onboarding, si le projet ne possède pas déjà une CI :

```bash
### Codex
bash .codex/scripts/generate-github-ci.sh

### Claude Code
bash .claude/scripts/generate-github-ci.sh
```

Le générateur refuse d’écraser un workflow existant. Avant de l’exécuter, renseigner dans `[delivery]` la visibilité du dépôt (`github_repository_visibility`, défaut `unknown`) et la durée maximale par job (`github_actions_max_minutes_per_run`, entier de 1 à 360, défaut 30). Les clés absentes d’un profil existant prennent ces mêmes valeurs par défaut, et la visibilité reste `unknown`. Le générateur ne vérifie pas ces données en direct : la visibilité doit être confirmée par le propriétaire. Une valeur `public` confirmée autorise le runner hébergé standard. Pour `private` ou `unknown`, les champs `github_actions_private_billing_approved = true` (défaut `false`) et `github_actions_usage_limit_evidence` non vide et différente des valeurs de placeholder reconnues `none`, `unknown` et `[[A_COMPLETER]]` (défaut vide) sont requis avant toute création de workflow hébergé. La référence d’attestation doit désigner une limite ou un budget de compte vérifié manuellement et ne doit contenir aucun secret. Le délai maximal borne une exécution, pas la dépense mensuelle. Si ces conditions manquent, le générateur refuse avant toute création du dossier ou du workflow. Utiliser les contrôles locaux gratuits; un runner auto-hébergé ne peut être utilisé que par un workflow séparé déjà configuré et documenté, car le générateur du kit n’en configure pas. Relire le workflow généré et faire vérifier le déploiement par Cybersécurité.

## 18. GitFlow de livraison

Le flux est :

```text
feature ou fix -> Pull Request -> develop -> Pull Request de release -> main -> tag vX.Y.Z
```

Avant promotion, exiger les preuves du Coordinateur, de l’agent responsable, de Cybersécurité lorsque nécessaire et de l’Auditeur. Le changement visible est inscrit dans `CHANGELOG.md`.

## 19. Modes qui évitent le faux démarrage

Pour une question générale :

```text
Mode général : explique-moi la différence entre REST et GraphQL.
```

Pour entretenir le kit sans construire le produit :

```text
Mode maintenance : vérifie les Skills et les contrôles du kit.
```

Sans préfixe, la conversation est considérée comme une demande projet et la porte cahier des charges s’applique.

## 20. Diagnostic

Codex :

```bash
bash .codex/scripts/doctor.sh
.\.codex\scripts\run.ps1 doctor
```

Claude Code :

```bash
bash .claude/scripts/doctor.sh
.\.claude\scripts\run.ps1 doctor
```

Sous Windows, utiliser PowerShell pour les wrappers `run.ps1`. Sous macOS et Linux, utiliser Bash. En cas de désaccord entre documentation, code et profil, l’agent arrête l’action et documente l’inconnue.

## Installation débutant

1. Ouvrez un terminal dans le dépôt du starter kit.
2. Exécutez `./install.sh --kit codex --target /chemin/du/projet` ou remplacez `codex` par `claude`.
3. Ouvrez le projet dans Codex ou Claude.
4. Complétez le profil projet demandé par l’agent.
5. Aucun updater n’est installé par défaut. Pour l’activer, demandez `--updates dispatch` pour un déclenchement manuel ou `--updates pr` pour un calendrier hebdomadaire, après avoir renseigné les attestations requises dans le profil. Sans garde satisfaite, aucun nouveau workflow updater n’est créé.

Pour remplacer un kit existant, utilisez `--force` uniquement après avoir sauvegardé vos personnalisations.

## Parcours recommandé pour un débutant

Cette procédure installe le kit. L’updater reste désactivé par défaut et doit être activé explicitement après configuration du profil et validation de la garde de facturation.

### Étape 1. Installer les prérequis

Installez Git et créez le projet à construire. Le projet peut être vide ou déjà versionné.

- macOS : installez Git avec Xcode Command Line Tools.
- Windows : installez Git Bash ou utilisez PowerShell avec Git.
- Linux : installez Git avec le gestionnaire de paquets de votre distribution.

### Étape 2. Télécharger le dépôt du kit

Dans un terminal, exécutez :

```bash
git clone https://github.com/krapaud/AGENTIC-Starter-Kits.git
cd AGENTIC-Starter-Kits
```

### Étape 3. Installer une seule variante

Pour un projet Codex :

```bash
./install.sh --kit codex --target /chemin/absolu/vers/mon-projet
```

Pour un projet Claude :

```bash
./install.sh --kit claude --target /chemin/absolu/vers/mon-projet
```

Remplacez le chemin par celui de votre projet. L’installateur copie directement les fichiers à la racine du projet. Il ne faut pas déplacer `starter-kit-codex` ou `starter-kit-claude` manuellement.

### Étape 4. Vérifier l’installation

Dans le projet, vérifiez la présence de l’une des structures suivantes :

```text
Codex : AGENTS.md, .codex/ (workflow updater seulement si demandé et autorisé par la garde; un updater préexistant peut rester actif).
Claude : CLAUDE.md, .claude/ (workflow updater seulement si demandé et autorisé par la garde; un updater préexistant peut rester actif).
```

N’installez jamais Codex et Claude ensemble dans le même projet.

### Étape 5. Activer les mises à jour

Par défaut, `./install.sh` n’installe aucun updater (`--updates off`). Pour demander un workflow manuel, utilisez `--updates dispatch`; pour demander également un calendrier hebdomadaire, utilisez `--updates pr`. Les mêmes options sont disponibles à l’initialisation avec `init-project.sh`; `ask` interactif propose le calendrier et `ask` sans terminal choisit le déclenchement manuel.

La garde s’applique à toute exécution hébergée, même manuelle, car elle peut consommer du quota facturable. Une visibilité `public` déclarée et confirmée par le propriétaire suffit; pour `private` ou `unknown`, le profil doit contenir `github_actions_private_billing_approved = true` et `github_actions_usage_limit_evidence` non vide et non placeholder. Ces attestations ne sont pas relues par API. Sans garde satisfaite, aucun nouveau workflow updater n’est installé. Une fois la garde satisfaite, `dispatch` se lance depuis `Actions` avec `Run workflow`; `pr` ajoute l’exécution chaque lundi. Le workflow compare le projet à la branche `main` du dépôt officiel, lance la mise à jour et ouvre une Pull Request vers la branche d’intégration. Il ne modifie jamais directement `main`.

Si un workflow updater existe déjà, l’installateur ne le supprime ni ne le réécrit jamais automatiquement. Une demande `off` échoue avant toute mutation et signale que le workflow existant reste actif, à examiner manuellement. Les modes `dispatch` et `pr` acceptent uniquement le workflow correspondant exactement au modèle attendu; un workflow personnalisé ou un mode différent bloque l’opération avant mutation. La garde échouée bloque aussi lorsqu’un updater préexistant est trouvé.

### Étape 6. Accepter une mise à jour

1. Ouvrez la Pull Request automatique.
2. Lisez la liste des fichiers modifiés.
3. Vérifiez que votre profil projet et vos documents métier sont conservés.
4. Attendez que la CI soit entièrement verte.
5. Fusionnez la Pull Request selon le GitFlow de votre projet.

Le kit conserve automatiquement les personnalisations suivantes : `project-profile.toml`, `RUNTIME-STATE.md`, les décisions, les travaux, les rapports, les métriques et les journaux.

### Mise à jour manuelle de secours

Si les Actions GitHub sont désactivées, lancez le synchroniseur depuis la racine du projet :

```bash
git remote add upstream https://github.com/krapaud/AGENTIC-Starter-Kits.git
bash .codex/scripts/update-starter-kit.sh --remote upstream --ref main --branch chore/update-agentic-kit
```

Avec Claude, remplacez `.codex` par `.claude`. Cette procédure crée une branche et ne remplace pas les données propres au projet.

## Choix des mises à jour à l’initialisation

Lors de l’exécution de `init-project.sh`, le kit demande si les mises à jour automatiques doivent être activées.

- Répondez `O` pour demander le workflow planifié qui ouvre une Pull Request; la garde de facturation doit réussir avant toute installation.
- Répondez `N` pour ne pas installer ce workflow.
- Utilisez `--updates dispatch` pour demander le workflow manuel, ou `--updates pr` pour demander son calendrier; les deux modes exigent la garde.
- Utilisez `--updates off` (défaut de `install.sh`) pour ne pas installer de nouvel updater. Si un workflow existe déjà, il est conservé et l’opération échoue avec consigne de revue manuelle; `off` ne désactive pas un workflow préexistant.

Le choix recommandé est `O`. Pour le mode CLI `init-project.sh`, l’absence de terminal choisit `dispatch` après réussite de la garde; dans `install.sh`, le défaut est `off`. L’agent peut alors détecter une nouvelle version, créer la branche de mise à jour, synchroniser les fichiers universels, préserver les données du projet, lancer les contrôles et ouvrir la Pull Request. Il ne modifie jamais directement `main`.

## Branche des Pull Requests automatiques

Le workflow cible `develop` par défaut. Si votre projet utilise `dev`, définissez la variable de dépôt GitHub `AGENTIC_INTEGRATION_BRANCH` avec la valeur `dev`. Toute autre valeur, notamment `main`, est refusée automatiquement. Le Coordinateur peut ensuite promouvoir automatiquement vers `main` dans une demande de livraison active, après contrôles verts.

### Installateur guidé

Lancez simplement `./install.sh` dans un terminal interactif. L’assistant propose Codex ou Claude, demande le dossier cible, affiche un résumé et demande confirmation avant toute copie. Dans une automatisation, utilisez `./install.sh --kit codex --target /chemin/du/projet`.

### Choisir le dossier avec les flèches

Lancez `./install.sh` sans `--target`. Le sélecteur intégré fonctionne sans dépendance obligatoire et affiche le dossier courant ainsi que ses sous-dossiers visibles. Le mode `--target` reste disponible pour les automatisations.

### Navigation dans le sélecteur

Dans le sélecteur intégré, les flèches haut et bas parcourent les sous-dossiers, la flèche droite ou la touche Entrée entre dans le dossier sélectionné, et la flèche gauche ou la touche Backspace revient au parent. La touche `s` sélectionne explicitement le dossier courant comme projet. La touche `q` annule. Entrer dans un dossier ne sélectionne jamais automatiquement ce dossier.

### Gestion automatique du `.gitignore`

L’installation crée `.gitignore` s’il est absent et ajoute uniquement les entrées nécessaires au kit choisi. Codex ajoute `.codex/` et `AGENTS.md`. Claude ajoute `.claude/` et `CLAUDE.md`. Les doublons ne sont pas ajoutés. Si l’updater est explicitement demandé et que la garde réussit, `.github/workflows/update-workspace-kit.yml` reste suivi par Git.

Le workflow détecte automatiquement `develop`, puis `dev`. Il refuse `main` et ne demande aucune variable GitHub Actions supplémentaire. Le workflow est manuel sauf demande explicite du mode `pr`; l’installateur `install.sh` reste en `off` par défaut. La garde s’applique à tout updater hébergé, même manuel, car une exécution peut consommer du quota facturable : une visibilité `public` déclarée et confirmée par le propriétaire suffit; pour `private` ou `unknown`, il faut aussi `github_actions_private_billing_approved = true` et une référence non vide, non placeholder dans `github_actions_usage_limit_evidence`. Le kit ne vérifie pas ces attestations via API. Si la garde manque, aucun nouveau workflow updater n’est installé. Après validation de la garde, `--updates dispatch` installe un lancement manuel et seul `--updates pr` ajoute le calendrier. `--updates off` laisse les workflows existants en place et échoue avec consigne de revue manuelle. Aucun workflow préexistant n’est modifié : il doit correspondre au modèle exact du mode demandé, sinon l’opération bloque.

## Publication Release et About

La promotion vers `main` est effectuée automatiquement par le Coordinateur dans le même GitFlow lorsque la demande de livraison est active. Après cette promotion, le kit crée et pousse le tag annoté prévu par le versionnement :

```bash
git tag -a vX.Y.Z -m "Release vX.Y.Z"
git push origin vX.Y.Z
```

Le workflow GitHub crée alors la Release, vérifie la cohérence avec `VERSION`, et actualise automatiquement la description et les topics visibles dans la section About. Le dépôt doit autoriser les GitHub Actions à écrire le contenu et les métadonnées du dépôt.

### Secret nécessaire pour la section About

Pour autoriser l’actualisation automatique de la description et des topics, créez dans GitHub un secret de dépôt nommé `REPO_SETTINGS_TOKEN`. Utilisez un token appartenant à une personne autorisée à administrer le dépôt, avec les droits de dépôt nécessaires à la modification de ses métadonnées. La Release reste fonctionnelle sans ce secret, mais la section About devra alors être mise à jour manuellement.

Le workflow de publication est idempotent : si une Release portant le tag existe déjà, il la conserve et poursuit la mise à jour About.
Si l’updater a été explicitement installé et que la garde a réussi, le workflow de mise à jour doit être ajouté au premier commit du projet. L’installateur affiche les commandes nécessaires et vérifie qu’il n’est pas ignoré. Un workflow préexistant est conservé; si la demande est `off`, si la garde échoue, ou si le fichier ne correspond pas exactement au modèle attendu, l’opération échoue avant mutation et demande une revue manuelle.

La distribution unique `shared` est documentée dans le dossier `distributions/`.
