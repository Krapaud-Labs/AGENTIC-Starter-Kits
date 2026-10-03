# Orchestration Claude portable

## Objectif

Ce répertoire s'importe dans tout nouveau projet. Il adapte les contrôles à partir de `project-profile.toml` sans imposer de langage, framework, outil de suivi ou fournisseur de déploiement. Lire aussi `CONVERSATION-MODES.md`, `PROJECT-CONTEXT.md`, `PROJECT-DATA-BOUNDARY.md`, `FILE-MANIFEST.md`, `models.toml`, `MODEL-POLICY.md`, `GOVERNANCE.md`, `RISK-MATRIX.md`, `COST-AND-EVALUATION.md` et `ADAPTERS.md`.

## Recherche actualisée

Lire et appliquer obligatoirement `policies/WEB-RESEARCH-POLICY.md`, `policies/SESSION-CONTINUITY-POLICY.md`, `policies/EXCEPTIONAL-REQUESTS.md`, `policies/TRELLO-VISUAL-SYSTEM.md`, `policies/TRELLO-START-STATE.md` et `policies/DOCUMENTATION-LANGUAGE-POLICY.md`. Le Coordinateur déclenche une recherche externe dès qu'une information peut avoir changé ou engage une décision technique, légale, de sécurité, de coût ou de compatibilité. Les agents concernés consignent les sources et la date de consultation dans les preuves.
Lire également `policies/CONTINUOUS-IMPROVEMENT-POLICY.md` et consulter les incidents connus avant toute action comparable.

## Cycle obligatoire

### Porte de démarrage d'initialisation

Lorsqu'une session lance ou reprend une initialisation de projet, le Coordinateur charge intégralement les instructions applicables avant toute création de fichier, tableau Trello, carte, délégation ou modification produit. Il relit `AGENTS.md`, `ORCHESTRATION.md`, `START-HERE.md`, `CONVERSATION-MODES.md`, `GOVERNANCE.md`, `FILE-MANIFEST.md`, `PROJECT-DATA-BOUNDARY.md`, `SPECIALIST-AGENTS.md`, `models.toml`, `MODEL-POLICY.md`, `RISK-MATRIX.md`, `COST-AND-EVALUATION.md`, `ADAPTERS.md`, les policies référencées et les Skills `project-intake`, `project-onboarding`, `trello-planning` et `coordination`. Il consigne la liste et la version des documents relus dans le work item ou l'état runtime. Tant que cette relecture n'est pas prouvée, aucune action d'initialisation n'est autorisée.

Après cette relecture, il crée immédiatement le Goal persistant couvrant toute l'initialisation jusqu'à sa livraison vérifiée. Le Goal est obligatoire même si aucun code n'est présent et même si Trello sert d'abord de checkpoint ; il ne devient `complete` qu'après les documents, le tableau, les cartes, les étiquettes, les checklists, le push prévu et la relecture finale.

1. Recevoir et accepter le cahier des charges.
2. Poser une seule série de questions de complétude avec choix recommandés.
3. Mettre à jour `RUNTIME-STATE.md` à chaque transition et après chaque erreur.
4. Recevoir le choix Trello et initialiser le profil du projet.
5. Créer un work item.
6. Classer toute demande exceptionnelle et créer une carte Trello dès que le seuil S3 ou S4 est atteint.
7. Choisir rôle et Skill.
8. Implémenter dans le périmètre déclaré.
9. Auditer, vérifier et enregistrer les preuves.
10. Livrer, évaluer et archiver.

Avant l'étape 1, le Coordinateur exécute une préparation de session obligatoire. Il charge le cahier des charges, le profil projet, le contrat central, les politiques applicables, le work item ou la carte active, l'état runtime, les décisions et les outils déjà installés. Il exécute `scripts/doctor.sh`, vérifie les commandes déclarées et disponibles avec leur chemin absolu et leur version, puis enregistre l'inventaire dans les preuves. Une nouvelle conversation ne dispense jamais de cette préparation et l'utilisateur n'a pas à rappeler ces règles. Une commande absente du `PATH` ne peut pas être déclarée indisponible avant la recherche multi-emplacements définie par `TOOL-DISCOVERY-POLICY.md`.

La préparation de session exécute aussi `scripts/ensure-tools.sh` avec les outils réellement requis par le profil et les validations. Le script réutilise l'installation partagée, installe les outils gratuits connus si nécessaire, vérifie leurs versions et journalise le résultat pour les projets suivants.

## Règles

- Claude est l'unique orchestrateur.
- Le profil du projet est la source de vérité des technologies, commandes et conventions locales.
- Une tâche active par flux, sauf tâches indépendantes sans fichiers communs.
- Le niveau de risque commande la profondeur de revue.
- Les intégrations GitHub, Trello, Docker et autres sont facultatives.
- Les fichiers de produit restent hors de `.claude/`.
- Lire `SPECIALIST-AGENTS.md` avant toute délégation. Le Coordinateur compare le besoin aux conditions d’activation, met à jour `[agents]`, justifie chaque activation dans le work item et exige les livrables annoncés.
- Un spécialiste désactivé ne doit pas être appelé. Les agents de QA, Cybersécurité, Accessibilité et Auditeur contrôlent la livraison lorsqu’ils sont requis par le risque ou la nature du produit.

## Autorisation continue

Lorsque l’utilisateur demande de tout faire ou de poursuivre jusqu’à la livraison, exécuter la chaîne complète du work item sans interruption volontaire. Produire des checkpoints et rapports intermédiaires sans demander d’approbation. Arrêter uniquement pour un blocage sensible défini par la politique d’autonomie.

Lorsqu'une demande cible une carte Trello à terminer, reprendre, corriger ou livrer, activer ou reprendre le Goal persistant décrit dans `policies/SESSION-CONTINUITY-POLICY.md` avant toute analyse et avant la première case, quel que soit le nombre de cases ouvertes, puis rattacher toutes les preuves au même objectif.

Le Coordinateur initialise ce Goal avec `scripts/start-goal.sh` avant toute commande, délégation ou commentaire externe. Il fournit l'objectif, les preuves attendues, les contraintes, la condition de blocage, la carte, la branche d'intégration et le plan de délégation. Si l'API native du Goal est disponible, il l'active immédiatement après cette écriture et vérifie son état. Sinon, l'état local reste la source de reprise et la limite est consignée.

## Reprise automatique

À chaque nouvelle session, lire `RUNTIME-STATE.md`, le dernier work item, le dernier commit et les rapports avant de demander quoi que ce soit. Reprendre directement l’action autorisée.

Au démarrage de chaque session manuelle, exécuter d'abord `scripts/check-kit-update.sh`. Si une version distante est plus récente, appliquer la mise à jour du kit et relire les politiques, scripts et manifestes modifiés avant toute action projet. Si la vérification est indisponible, enregistrer ce résultat et ne jamais présenter le kit comme à jour.

Si le dernier work item était un onboarding terminé et que la nouvelle demande concerne le code, l'audit, le lint, les tests, TypeScript, la sécurité ou la livraison, créer immédiatement un nouveau Goal et un nouveau work item. L'agent doit inventorier les outils, exécuter les contrôles disponibles, corriger les écarts et conserver la PR fermée jusqu'à la preuve complète.

## Rapport exigé

```text
Statut: complete | blocked | needs-review
Perimetre: fichiers et limites
Travail: résumé factuel
Preuves: commandes et résultats
Risques: inconnues restantes
Suite: action recommandée
Sources: URLs consultées et décisions influencées
```

Lire et appliquer obligatoirement `.codex/policies/TASK-ROUTING-POLICY.md` ou `.claude/policies/TASK-ROUTING-POLICY.md` avant toute délégation, y compris pour une demande hors cahier des charges initial.

## Synchronisation après chaque livraison

Après chaque étape validée, fusion, correction ou changement de statut, relire la carte Trello concernée et sa checklist. Une livraison sans mise à jour et preuve de relecture Trello est incomplète.

Lire et appliquer obligatoirement la politique DELIVERY-CLOSURE-POLICY.md avant de suspendre, clôturer ou déclarer bloqué un work item.
