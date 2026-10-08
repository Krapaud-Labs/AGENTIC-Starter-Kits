# Historique des versions

## Objet

Ce document constitue la vue chronologique du projet Agentic Starter Kits. Il complète `CHANGELOG.md`, qui contient le détail opérationnel de chaque entrée. Les versions correspondent aux évolutions consommables du kit Codex ou Claude, et non à chaque commit interne.

## Origine du projet

Le dépôt a été initialisé le 21 septembre 2026. Les premiers commits ont établi la documentation du dépôt, les deux variantes Codex et Claude, les rôles spécialisés, les Skills, les scripts de cycle de vie, la sécurité, la validation avant push, le support multiplateforme et les standards de contribution.

## Historique chronologique

| 1.16.8 | 2026-10-08 | Démarrage automatique et vérification du daemon Docker local avant tout blocage, avec garde-fou et tests par variante. |

| 1.16.7 | 2026-10-07 | Garde exécutable contre les PR intermédiaires et doublons, avec tests de cadence et exception de déploiement explicite. |

| 1.16.6 | 2026-10-07 | Relecture directe obligatoire des checklists Trello après écriture, validée par un test réel du connecteur. |

| 1.16.5 | 2026-10-07 | Parité des hooks d'initialisation Codex et Claude renforcée par un contrôle de gouvernance commun. |

| 1.16.4 | 2026-10-07 | Séparation stricte entre scénarios externes simulés et preuves réelles, avec préflight obligatoire en mode `--require-real`. |

| 1.16.3 | 2026-10-07 | Correction de la cohérence de version lors de l'initialisation et validation dynamique des points d'entrée. |

| 1.16.2 | 2026-10-07 | Ouverture autonome de la PR d'onboarding lorsque la branche et les contrôles sont prêts, sans confirmation redondante, avec suivi obligatoire dans le même Goal. |

| 1.16.1 | 2026-10-06 | Revue obligatoire des hooks à l'installation et après mise à jour. |

| 1.16.0 | 2026-10-06 | Ajout des hooks PermissionRequest et PostToolUse pour bloquer les actions sensibles et journaliser les preuves. |

| 1.15.1 | 2026-10-06 | Correction du hook SessionStart pour les projets avant création du runtime. |

| 1.15.0 | 2026-10-06 | Hooks de cycle de vie pour automatiser le chargement de session, le contrôle avant outil, le suivi des sous-agents et la clôture. |

| 1.14.13 | 2026-10-06 | Garde-fou d'authentification et de facturation pour rester sur l'abonnement utilisateur par défaut. |

| 1.14.12 | 2026-10-05 | Synchronisation sûre excluant les sauvegardes locales des projets. |

| 1.14.11 | 2026-10-05 | Ajout du validateur global du contrat agentic, exécuté à l'initialisation et vérifiant les politiques, l'état runtime, les garde-fous et la preuve de délégation. |

| 1.14.10 | 2026-10-05 | Validation du point d'entrée racine pendant l'initialisation et blocage des fichiers AGENTS/CLAUDE incomplets. |

| 1.14.9 | 2026-10-05 | Contrat de démarrage autonome dans AGENTS.md et CLAUDE.md pour les chats VS Code, avec Goal et agents spécialisés obligatoires dès le premier tour. |

| 1.14.8 | 2026-10-05 | Porte spécialisée visuelle avec frontend, QA et auditeur obligatoires avant modification. |

| 1.14.7 | 2026-10-04 | Contrat explicite de l'agent principal comme Coordinateur et blocage des substitutions silencieuses de rôles spécialisés. |

| 1.14.6 | 2026-10-04 | Preuve d'exécution réelle des agents spécialisés et interdiction de substituer le Coordinateur au Frontend, QA ou Auditeur. |

| 1.14.5 | 2026-10-04 | Porte de readiness produit, distinction baseline/MVP, audit des parcours visibles et interdiction d'implémenter lors d'une simple demande d'aperçu. |

| 1.14.4 | 2026-10-04 | Porte Git Flow avant modification, couverture des branches feat/feature et blocage précoce de index.lock. |

| 1.14.3 | 2026-10-04 | Sélection multi-version de Python 3.11+ pour rendre les outils TOML réellement réutilisables. |

| 1.14.2 | 2026-10-04 | Preuve observable obligatoire de délégation et validation exécutable des champs native Goal dans l'état de session. |

| 1.14.1 | 2026-10-04 | Enforcement exécutable de l'état du Goal natif dans le runtime et dans start-goal.sh, avec tests de refus et fallback prouvé. |

| 1.14.0 | 2026-10-04 | Contrat native-first des Goals, refus d'exécution sans Goal natif actif lorsque l'API est disponible, et test de non-régression associé. |

| 1.13.9 | 2026-10-04 | Installation réelle de AGENTS.md et test de non-régression de l'initialisation Codex. |

| 1.13.8 | 2026-10-04 | Preflight réel worktrees/verrou Git et distinction stricte des intégrations externes non exécutées. |

| 1.13.7 | 2026-10-04 | Contrôle complet de couverture et de synchronisation Trello avant clôture d'initialisation. |

| 1.13.6 | 2026-10-04 | Isolation Git des agents parallèles et traitement sûr de `.git/index.lock`. |

| 1.13.5 | 2026-10-04 | Pool d'agents persistant, réutilisation des threads et fermeture différée jusqu'à la livraison. |

| 1.13.4 | 2026-10-04 | Refonte multi-écrans organisée en phases design, implémentation et audit final. |

| 1.13.3 | 2026-10-03 | Validation artistique comparative et refus des refontes visuellement négligeables. |

| 1.13.2 | 2026-10-03 | Vérification technique de la création et de l'affectation des agents parallèles. |

| 1.13.1 | 2026-10-03 | Transition atomique des phases et blocage de l'implémentation avant conception approuvée. |

| 1.13.0 | 2026-10-03 | Contrat universel de récupération et interdiction des arrêts prématurés pour toute action. |

| 1.12.99 | 2026-10-03 | Design-gate incomplet traité en rework avec délégation obligatoire avant tout blocage. |

| 1.12.98 | 2026-10-03 | Réparation de l'initialisation, de la synchronisation des fichiers obligatoires et des URLs du dépôt canonique. |

| 1.12.97 | 2026-10-03 | Blocage des tâches hors rôle et preuve d’exécution attribuée à l’agent réel. |

| 1.12.96 | 2026-10-03 | Délégation obligatoire de chaque tâche à l’agent spécialisé concerné. |

| 1.12.95 | 2026-10-03 | Clôture de Goal conditionnée à la fusion et à la relecture de la branche d’intégration. |

| 1.12.94 | 2026-10-03 | Renforcement du blocage des push directs et vérification du hook GitFlow. |

| 1.12.93 | 2026-10-03 | Identité explicite du bot pour créer les tags automatiquement sur le runner GitHub. |

| 1.12.92 | 2026-10-03 | Publication automatique des Releases depuis main et création idempotente des tags SemVer. |

| 1.12.91 | 2026-10-03 | Décision de délégation obligatoire pour tout Goal de travail. |

| 1.12.90 | 2026-10-03 | Routage obligatoire des cartes Review vers l’auditeur. |

| 1.12.89 | 2026-10-03 | Audit des seuils de délégation et suppression d’une contradiction inter-agents. |

| 1.12.88 | 2026-10-03 | Audit de cohérence versionnée et blocage des versions périmées ou dupliquées. |

| 1.12.87 | 2026-10-03 | Création et affectation des agents obligatoires avant tout Goal délégué. |

| 1.12.86 | 2026-10-03 | Goal séquentiel maintenu jusqu’à la fin de toutes les cartes autorisées. |

| 1.12.85 | 2026-10-03 | Porte stricte de clôture et de reprise de l’initialisation. |

| 1.12.84 | 2026-10-03 | Scénario dynamique complet d’initialisation d’un projet existant. |

| 1.12.83 | 2026-10-03 | Contrats spécialisés et preuves obligatoires pour tous les agents. |

| 1.12.82 | 2026-10-02 | Contrôle visuel item par item des menus et preuves de correction frontend. |

| 1.12.81 | 2026-10-02 | Garde d’index consommateur empêchant le suivi accidentel des dossiers locaux du kit. |

| 1.12.80 | 2026-10-02 | Adaptateurs externes simulés dans la CI sandbox. |

| 1.12.79 | 2026-10-02 | Initialisation et hooks testés dans des dépôts Git temporaires isolés. |

| 1.12.78 | 2026-10-02 | Correction du lint Markdown détectée par la CI sandbox. |

| 1.12.77 | 2026-10-02 | CI déclenchée et vérifiée sur les PR vers dev. |

| 1.12.76 | 2026-10-02 | Matrice complète de scénarios et contrôle de couverture CI. |

| 1.12.75 | 2026-10-02 | Scénarios sandbox isolés exécutés dans la CI avant livraison. |

| 1.12.74 | 2026-10-02 | Labels obligatoires préparés avant toute création de carte. |

| 1.12.73 | 2026-10-02 | Suppression des confirmations redondantes lors de la création d'une carte demandée. |

| 1.12.72 | 2026-10-01 | Porte obligatoire de délégation des agents dans chaque Goal multi-lots. |

| 1.12.71 | 2026-10-01 | Vérification stricte de l'ordre des cartes avant lancement. |

| 1.12.70 | 2026-10-01 | Gestion et fermeture vérifiée des sessions navigateur après les lots terminés. |

| 1.12.69 | 2026-09-30 | Fusion autonome des PR vers la branche d'intégration dans un flux autorisé. |

| 1.12.68 | 2026-09-30 | PR vers dev obligatoire avant clôture de l'onboarding. |

| 1.12.67 | 2026-09-30 | Audit final complet de chaque carte avant clôture de l'initialisation Trello. |

| 1.12.66 | 2026-09-30 | Connecteur Trello lecture-écriture prioritaire, navigateur en complément contrôlé. |

| 1.12.65 | 2026-09-30 | Stratégie hybride connecteur Trello puis navigateur. |

| 1.12.64 | 2026-09-30 | Relecture obligatoire après chaque création de carte. |

| 1.12.63 | 2026-09-30 | Décomposition détaillée obligatoire au-delà des cartes macro. |

| 1.12.62 | 2026-09-30 | Navigateur généraliste partagé pour Trello, GitHub, VPS et Dokploy. |

| 1.12.61 | 2026-09-30 | Priorité au navigateur existant et à sa session Trello authentifiée. |

| 1.12.60 | 2026-09-30 | Création obligatoire des étiquettes Trello et contrôle de rattachement. |

| 1.12.59 | 2026-09-30 | Fallback Trello, initialisation du contexte et détection Python renforcée. |

| 1.12.58 | 2026-09-30 | Protection Git immédiate avant installation du kit. |

| 1.12.57 | 2026-09-30 | Porte de démarrage complète et Goal obligatoire pour l'initialisation. |

| 1.12.57 | 2026-09-29 | Repli API GitHub contre les réponses Raw obsolètes. |

| 1.12.55 | 2026-09-29 | Neutralisation du cache CDN lors de la vérification distante. |

| 1.12.54 | 2026-09-29 | Fallback officiel pour les projets sans manifeste de source du kit. |

| Version | Date | Évolution principale |
| --- | --- | --- |
| 1.0.1 | 2026-09-21 | Première correction documentaire et stabilisation initiale. |
| 1.0.2 | 2026-09-21 | Correction de gouvernance Claude. |
| 1.0.3 | 2026-09-21 | Synchronisation des versions et profils Claude. |
| 1.0.4 | 2026-09-21 | Inventaire fonctionnel, spécialistes, coûts et Trello. |
| 1.0.5 | 2026-09-21 | Correction de l’inventaire des agents. |
| 1.0.6 | 2026-09-21 | Contrôles CI des README et de la cohérence des versions. |
| 1.0.7 | 2026-09-21 | Lint Markdown bloquant. |
| 1.1.2 | 2026-09-21 | Autonomie continue, reprises CI et traitement des dettes. |
| 1.1.3 à 1.1.9 | 2026-09-23 | Distributions native/external, synchronisation, installateur, onboarding et contrôles external. |
| 1.2.0 | 2026-09-23 | Carte documentaire et diagnostics locaux. |
| 1.2.1 | 2026-09-23 | Sécurité des workflows, timeouts, concurrence et actions épinglées. |
| 1.2.2 | 2026-09-23 | Restauration automatique après synchronisation échouée. |
| 1.4.0 | 2026-09-24 | Classification des demandes exceptionnelles S1 à S4. |
| 1.5.0 | 2026-09-24 | Contrat documentaire et synchronisation documentaire. |
| 1.6.0 | 2026-09-24 | Système visuel Trello. |
| 1.6.1 | 2026-09-24 | Démarrage obligatoire des cartes Trello. |
| 1.6.2 | 2026-09-24 | Synchronisation séquentielle des checklists Trello. |
| 1.6.3 | 2026-09-25 | Autonomie après cadrage et intégrité des branches. |
| 1.7.0 | 2026-09-25 | Contrat central, huit portes et gouvernance Trello exécutable. |
| 1.8.0 | 2026-09-25 | Registres d’obligations et portes de qualité exécutables. |
| 1.8.2 | 2026-09-26 | Actions réversibles sans confirmation redondante et garde avant réponse. |
| 1.9.0 | 2026-09-26 | Continuité de session fondée sur les objectifs persistants. |
| 1.10.0 | 2026-09-26 | Runtime distribué, idempotence, budgets et reprises. |
| 1.11.0 | 2026-09-26 | Application complète du cahier des charges agentique. |
| 1.12.0 | 2026-09-26 | Goal automatique pour les cartes Trello multi-étapes. |
| 1.12.1 à 1.12.40 | 2026-09-26 à 2026-09-28 | Renforcements successifs de Trello, CI, versionnement, synchronisation, onboarding, coûts, GitFlow et autonomie. Voir le changelog pour chaque entrée. |
| 1.12.41 | 2026-09-28 | Initialisation exécutable des Goals avec `start-goal.sh`. |
| 1.12.42 | 2026-09-28 | Préparation automatique des sessions et inventaire des outils installés. |
| 1.12.43 | 2026-09-28 | PR interdite avant la fin complète d’une carte. |
| 1.12.44 | 2026-09-28 | Choix de cadence CI `pull-request-only` ou `every-push`. |
| 1.12.45 | 2026-09-28 | Refus des checks et blocages hors périmètre projet. |
| 1.12.46 | 2026-09-28 | Suppression des confirmations Trello redondantes. |
| 1.12.47 | 2026-09-28 | Reprise automatique après preuve négative, échec ou déploiement absent. |
| 1.12.48 | 2026-09-28 | PR de checkpoint vers `dev` autorisée sur demande explicite pour déployer et revalider. |
| 1.12.49 | 2026-09-29 | Historique versionné complet et contrôle de cohérence associé. |
| 1.12.50 | 2026-09-29 | Vérification et installation gratuite réutilisable des outils de test. |
| 1.12.51 | 2026-09-29 | Boucle d'amélioration continue et apprentissage documenté après incident. |
| 1.12.52 | 2026-09-29 | Nouveau Goal et work item obligatoires après un onboarding terminé. |
| 1.12.53 | 2026-09-29 | Vérification du kit distant à chaque démarrage de session. |

## Intégrité de publication

La version courante est lue exclusivement depuis `VERSION` et doit être identique au badge README, aux manifestes `KIT.toml`, au changelog et à l’historique. Les contrôles de publication refusent toute version périmée ou dupliquée.

## Sources de vérité

- `VERSION` contient la version courante.
- `CHANGELOG.md` contient le détail de chaque changement.
- `VERSIONING.md` définit le processus de publication.
- Les tags annotés `vX.Y.Z` identifient les versions publiées.
