# Historique des versions

## Objet

Ce document constitue la vue chronologique du projet Agentic Starter Kits. Il complète `CHANGELOG.md`, qui contient le détail opérationnel de chaque entrée. Les versions correspondent aux évolutions consommables du kit Codex ou Claude, et non à chaque commit interne.

| Version | Date | Évolution |
|---|---|---|
| 1.16.85 | 2026-10-21 | Délégation spécialiste vérifiable au démarrage avec affectations par rôle et refus des chevauchements. |
| 1.16.84 | 2026-10-21 | Reprise du Goal natif avec fallback local lorsqu’une action autonome reste disponible, sans masquer les blocages externes. |
| 1.16.83 | 2026-10-21 | Élimine le deadlock des hooks en autorisant uniquement les commandes de récupération sûres, avec scénarios Codex/Claude. |
| 1.16.82 | 2026-10-21 | Canonisation automatique et idempotente de `RUNTIME-STATE.md` au démarrage, avec test Codex/Claude. |
| 1.16.81 | 2026-10-21 | Auto-correction locale des problèmes connus et rapport anonymisé de correction. |
| 1.16.80 | 2026-10-21 | Correcteur automatique contrôlé des rapports avec playbooks, tests et historique de correction. |
| 1.16.79 | 2026-10-21 | Corrige la boucle de reprise lorsque l'état utilisateur est résiduel sans demande en attente. |
| 1.16.74 | 2026-10-20 | Fiabilisation des erreurs distantes, de la déduplication et de l'historique des rapports. |
| 1.16.73 | 2026-10-20 | Correction du chemin outbox et test réel de génération et déduplication des rapports. |
| 1.16.72 | 2026-10-20 | Lecture des rapports depuis tous les projets et rejeu automatique de l'outbox locale. |
| 1.16.71 | 2026-10-20 | Preuve de session renforcée avec mode de vérification et empreintes du manifeste et du kit. |
| 1.16.70 | 2026-10-20 | Garde anti-boucle par agent, contexte neuf après échec et arrêt des relances identiques. |
| 1.16.69 | 2026-10-20 | Audit des volumes de contexte et budgets exécutables des Goals, avec tests et politique de métriques. |
| 1.16.68 | 2026-10-20 | Manifeste d'empreintes du contexte généré automatiquement au démarrage et ignoré par Git. |
| 1.16.67 | 2026-10-20 | Optimisation du contexte agentique par chargement ciblé, cache d'empreintes et audit automatisé. |

## Origine du projet

Le dépôt a été initialisé le 21 septembre 2026. Les premiers commits ont établi la documentation du dépôt, les deux variantes Codex et Claude, les rôles spécialisés, les Skills, les scripts de cycle de vie, la sécurité, la validation avant push, le support multiplateforme et les standards de contribution.

## Historique chronologique

| 1.16.66 | 2026-10-19 | Réconciliation contrôlée du Goal et du runtime avant reprise, avec voie blanche anti-deadlock et preuve d’état. |

| 1.16.65 | 2026-10-19 | Preuve d’exécution obligatoire des agents, détection des chevauchements et refus des rapports incomplets. |

| 1.16.64 | 2026-10-19 | Contrats spécialisés exécutables, routage par domaine, relecteurs obligatoires et tests de parité Codex/Claude. |

| 1.16.63 | 2026-10-19 | Recherche prioritaire dans le registre partagé, questionnaire unique avant installation interactive et arrêt anti-boucle des hooks en attente de réponse. |

| 1.16.62 | 2026-10-19 | Ajoute l état waiting-for-user avec questionnaire unique et reprise après réponse. |

| 1.16.61 | 2026-10-18 | Livraison automatique de `.workspace.toml` par worktree isolé, branche dédiée et PR vers `dev`. |

| 1.16.60 | 2026-10-18 | API gh facultative, fallback curl public et mises à jour accessibles aux utilisateurs sans privilège créateur. |

| 1.16.59 | 2026-10-18 | Réseau distant indisponible traité comme limite récupérable lorsque le kit local est cohérent. |

| 1.16.58 | 2026-10-18 | Synchronisation partagée autorisée par une exception de hook strictement exacte et reprise automatique après mise à jour détectée. |

| 1.16.57 | 2026-10-18 | Fallback automatique vers un registre temporaire lorsque le registre partagé est inaccessible en écriture. |

| 1.16.56 | 2026-10-18 | Bootstrap des outils rendu autonome et testé sans variable `config` héritée de la session. |

| 1.16.55 | 2026-10-18 | Réamorçage automatique de la porte SessionStart depuis PreToolUse, avec refus explicite uniquement si le bootstrap échoue réellement. |

| 1.16.54 | 2026-10-18 | Mode `shared` rendu unique dans l’installateur, les distributions et toute la documentation active. |

| 1.16.53 | 2026-10-18 | Suspension obligatoire lors d'une mise à jour détectée, sauvegarde runtime, livraison vers `dev`, vérification distante et reprise de `next_action`. |

| 1.16.52 | 2026-10-18 | Mode `shared` rendu obligatoire comme unique installation supportée, avec registre central et mises à jour unifiées. |

| 1.16.51 | 2026-10-18 | Installation automatique et idempotente des outils manquants dans le registre partagé, avec revalidation avant blocage. |

| 1.16.50 | 2026-10-18 | Bootstrap obligatoire de branche dédiée, refus des branches mélangées et branche/PR unique par feature ou carte GitHub Project. |

| 1.16.49 | 2026-10-17 | Garde universelle des délégations avec identifiants réels et preuves d'affectation. |

| 1.16.49 | 2026-10-17 | Cahiers des charges centralisés hors des dépôts dans le dossier Projets. |

| 1.16.49 | 2026-10-17 | Archive automatique des cahiers des charges par projet lors de l'installation. |

| 1.16.49 | 2026-10-17 | Agent image-generation, routage obligatoire, réalisme, cohérence de thème, provenance, accessibilité et contrôle des artefacts. |

| 1.16.49 | 2026-10-17 | Mode shared avec kit global unique et contexte local par projet. |

| 1.16.44 | 2026-10-17 | Registre central des outils CLI, npm et Python, installation idempotente et environnement partagé. |

| 1.16.43 | 2026-10-17 | Contrôle lint obligatoire par fichier ouvert ou modifié. |

| 1.16.42 | 2026-10-17 | GitHub Projects devient le système de suivi principal. |

| 1.16.41 | 2026-10-15 | Modèle runtime initial valide et statut Goal natif explicite. |

| 1.16.40 | 2026-10-15 | Normalisation de la source officielle du kit. |

| 1.16.39 | 2026-10-15 | Synchronisation robuste des fichiers protégés et marqueurs alignés. |

| 1.16.38 | 2026-10-15 | Bootstrap automatique de RUNTIME-STATE et test de projet vierge. |

| 1.16.37 | 2026-10-14 | Routage spécialisé obligatoire avant toute feature, correction ou livraison. |

| 1.16.36 | 2026-10-11 | Validation stricte des cartes Trello avant et après création. |

| 1.16.35 | 2026-10-11 | Consolidation des audits et revalidation finale unique. |

| 1.16.34 | 2026-10-10 | Structure standardisée et vérifiée des commentaires Trello. |

| 1.16.33 | 2026-10-10 | Réconciliation sûre entre Goal natif actif et runtime bloqué. |

| 1.16.32 | 2026-10-10 | Refus des blocages globaux pour les actions encore réalisables. |

| 1.16.31 | 2026-10-09 | Garde anti-boucle exécutable après deux blocages identiques. |

| 1.16.30 | 2026-10-08 | Activation réelle des agents spécialisés à chaque Goal et chaque reprise. |

| 1.16.29 | 2026-10-08 | Exécution autonome des gates internes jusqu'à la PR vers dev. |

| 1.16.28 | 2026-10-08 | Garde de reprise native des Goals et refus des fausses reprises locales. |

| 1.16.27 | 2026-10-08 | Stabilisation des hooks de cycle de vie, résolution de racine fiable et test de régression. |

| 1.16.26 | 2026-10-08 | Synchronisation basée sur l’API GitHub authentifiée pour éviter les versions distantes périmées. |

| 1.16.25 | 2026-10-08 | Distinction des preuves publique, préproduction et opérateur, avec routage DevOps obligatoire. |

| 1.16.24 | 2026-10-08 | Limitation des blocages humains aux décisions réellement irréversibles ou critiques. |

| 1.16.23 | 2026-10-08 | Réduction des blocages humains abusifs et poursuite des portes indépendantes après délégation explicite. |

| 1.16.22 | 2026-10-08 | Régénération autonome des fixtures QA locales et du storage state après recréation de base. |

| 1.16.21 | 2026-10-08 | Routage QA renforcé avec alternatives locales et fixtures lorsqu’aucune cible authentifiée n’est disponible. |

| 1.16.20 | 2026-10-08 | Correction de la détection des limitations sandbox dans le diagnostic GitHub. |

| 1.16.19 | 2026-10-08 | Diagnostic GitHub renforcé avec distinction sandbox, accès renforcé et indisponibilité externe réelle. |

| 1.16.18 | 2026-10-08 | Correction des promesses de reprise automatique sans mécanisme de surveillance prouvé. |

| 1.16.17 | 2026-10-08 | Normalisation et validation stricte du statut natif `blocked`, avec preuve et cause séparées. |

| 1.16.16 | 2026-10-08 | Refus des faux blocages lorsque les portes audit ou livraison sont récupérables, avec exécution obligatoire de la prochaine action. |

| 1.16.15 | 2026-10-08 | Le mode external ne bloque plus une synchronisation du kit avec des gates produit historiques. |

| 1.16.14 | 2026-10-08 | Synchronisation basée sur l’archive de la branche main lorsque les tags de release ne sont pas disponibles. |

| 1.16.13 | 2026-10-08 | Correction du deadlock des hooks : les actions de récupération restent autorisées en état `blocked` ou `needs-review`. |

| 1.16.12 | 2026-10-08 | Correction du synchroniseur Codex, des chemins `.codex` et de l’installation de `AGENTS.md` à la racine du projet. |

| 1.16.11 | 2026-10-08 | Finalisation du durcissement des hooks avec journaux bornés, verrous, timeout de clôture, rapports agents et tests de parité. |

| 1.16.10 | 2026-10-08 | Renforcement complet des hooks et des clôtures, avec validation runtime, preuves agents, déduplication et contrôles sensibles. |

| 1.16.9 | 2026-10-08 | Audit et renforcement des hooks, validation runtime avant outil, déduplication des événements et détection sensible étendue. |

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

## Référentiel complet des instructions et consignes

Cette section complète la chronologie des versions avec les règles opérationnelles qui ont été ajoutées au kit. Elle permet de comprendre ce que chaque version change dans le comportement attendu des agents.

### Démarrage et initialisation

- Le fichier d’entrée du kit doit être lu avant toute analyse, commande, modification ou réponse opérationnelle.
- Le Coordinateur doit charger les politiques d’orchestration, de continuité, de routage, de sécurité, de limites de projet et l’état runtime.
- Toute initialisation commence par la vérification du cahier des charges, de son statut, de son origine et de son emplacement central hors dépôt.
- Le `.gitignore` est vérifié et complété immédiatement afin que les états locaux du kit, les secrets, caches, rapports temporaires et fichiers machine ne soient jamais suivis.
- Un projet déjà commencé fait l’objet d’un audit complet avant création des cartes : code, documentation, conception, tests, sécurité, déploiement, Git, dépendances et fonctionnalités manquantes.
- L’initialisation crée ou vérifie les documents de conception, le profil projet, le runtime, le work item et le plan de livraison avant toute implémentation.
- L’approbation des hooks est demandée lors de la première installation et après toute modification nécessitant une nouvelle revue.
- Une synchronisation partielle ou un plan local ne vaut pas initialisation terminée.

### Goal, continuité et autonomie

- Toute demande d’exécution, de correction, de livraison, de carte GitHub Project ou de fonctionnalité démarre ou reprend un Goal natif.
- Le Goal reste actif jusqu’à la Definition of Done réelle : contrôles terminés, documentation mise à jour, carte clôturée, branche publiée, PR intégrée et branche d’intégration relue.
- Un commit, une CI verte, une PR ouverte, une fusion ou une synchronisation de suivi sont des checkpoints, jamais une clôture.
- `current_action`, `next_action`, les obligations ouvertes, les preuves observables et l’état terminal doivent rester synchronisés dans le runtime.
- Une action autonome encore possible interdit toute réponse finale.
- Un blocage n’est autorisé que lorsqu’il est réel, prouvé, externe ou nécessite une décision irréversible. Toute action réparable localement doit être exécutée immédiatement.
- Après deux occurrences identiques d’un blocage, le Coordinateur doit changer d’approche, appeler le spécialiste adapté, installer l’outil manquant ou proposer une alternative vérifiable.
- Une reprise relit l’état existant et poursuit l’action suivante sans réinitialiser le projet ni demander une confirmation déjà accordée.

### Rôles et délégation agentique

- L’agent principal est toujours le Coordinateur. Il orchestre, répartit, relit et intègre ; il ne remplace pas un spécialiste disponible.
- Chaque tâche est affectée à l’agent correspondant à son domaine et chaque affectation doit produire une preuve réelle avec identifiant d’agent, périmètre, fichiers autorisés et rapport.
- Une simple annonce de délégation ou un nom d’agent sans identifiant réel ne constitue pas une délégation.
- Pour une tâche visuelle, les agents `frontend`, `qa` et `auditeur` sont obligatoires avant modification.
- Pour les tâches concernées, les agents Backend, Cybersécurité, DevOps, Conformité, Performance, Documentation, Release et `image-generation` sont activés selon le routage réel.
- Une carte comportant plusieurs lots indépendants peut utiliser plusieurs agents en parallèle, avec worktrees isolés et affectations non chevauchantes.
- Les agents secondaires restent actifs jusqu’à la production et l’intégration de leur preuve ; ils ne sont pas considérés comme utilisés si le Coordinateur réalise leur travail.
- Aucun agent ne modifie les fichiers, branches ou responsabilités d’un autre rôle sans transfert explicite et traçable.

### GitFlow et cadence de livraison

- Une feature ou une carte GitHub Project correspond à une branche dédiée unique.
- Les agents travaillent sur cette branche ou dans des worktrees isolés intégrés par le Coordinateur.
- Les commits sont regroupés par intention cohérente ; aucun commit n’est créé pour chaque micro-étape, agent, fichier, test ou commentaire.
- Une seule PR est créée lorsque toute la feature ou toute la carte est terminée et vérifiée.
- Les PR intermédiaires sont interdites sauf besoin explicite de déploiement ou blocage critique documenté.
- La PR finale va vers `dev` ou `develop`, selon la branche d’intégration réellement configurée ; aucune PR n’est ouverte directement vers `main` pour le travail courant.
- Après intégration et relecture de `dev`, une PR de promotion séparée est créée vers `main` selon le flux du projet.
- Le Goal ne se termine pas à la création de la PR, mais après fusion, relecture distante et vérification que la branche d’intégration contient effectivement le travail.
- Les verrous Git, notamment `.git/index.lock`, sont diagnostiqués avant toute conclusion d’indisponibilité ; les agents parallèles utilisent des worktrees et ne manipulent pas le checkout partagé simultanément.

### GitHub Projects et suivi du travail

- GitHub Projects est le suivi principal lorsque le projet l’utilise ; Trello reste une compatibilité optionnelle explicitement choisie.
- Les cartes sont numérotées, ordonnées par dépendances et créées après l’audit complet du MVP et du post-MVP.
- Chaque carte contient un objectif, un périmètre, les dépendances, les critères d’acceptation, les tests, la documentation attendue, les preuves et le dernier check de mise à jour documentaire avant PR.
- Une carte n’est clôturée que lorsque tous ses checks sont prouvés et que l’élément « indiquer comme achevé » est effectivement marqué.
- Toute carte hors périmètre du cahier des charges est écartée ou classée post-MVP ; elle ne doit pas devenir un faux blocage.

### Conception, code et qualité

- La conception complète précède le code : vision, périmètre, architecture, modèle de données, sécurité, UX, flux, erreurs, observabilité, sauvegarde, restauration et critères de validation doivent être cohérents.
- L’ouverture ou la modification d’un fichier déclenche la vérification du lint approprié et la correction des erreurs relevant du périmètre.
- Les outils manquants sont recherchés dans le registre central puis installés de manière gratuite, idempotente et réutilisable avant de déclarer un contrôle impossible.
- Les runtimes Node, npm, Python, linters, typecheckers, tests, Docker et outils GitHub utilisent l’environnement centralisé du kit lorsque disponible.
- Les tests couvrent les scénarios d’initialisation, reprise, délégation, GitFlow, hooks, GitHub Projects, cartes, outils, erreurs, navigateur, responsive, sécurité, déploiement et clôture.
- Une CI verte ne remplace ni les tests locaux, ni la preuve navigateur, ni la relecture de l’environnement déployé lorsque celle-ci est requise.

### Hooks et garde-fous

- `SessionStart` initialise ou vérifie le contexte, le kit, les outils et le runtime.
- `PreToolUse` refuse les actions incompatibles avec l’état, le rôle, le périmètre ou le GitFlow.
- `PermissionRequest` protège les actions sensibles, les secrets, les services payants et les opérations externes.
- `PostToolUse` enregistre les preuves et met à jour l’état observable.
- `SubagentStart` et `SubagentStop` vérifient l’affectation, le rapport et la clôture réelle des agents.
- `Stop` refuse la clôture si une action autonome, une obligation, une preuve ou une livraison reste ouverte.
- Les hooks doivent rester réparables : un hook ne doit jamais interdire sa propre récupération, la création du runtime ou l’exécution d’une action de déblocage autorisée.

### Coûts, sécurité et services externes

- Aucun service payant, abonnement, runner facturé, API premium ou activation de facturation ne doit être utilisé sans accord explicite.
- Les outils gratuits locaux, le registre central et les runners auto-hébergés sont privilégiés lorsque le projet le demande.
- Les secrets ne sont jamais écrits dans le dépôt, les commentaires, les logs, les cartes ou les rapports.
- Les preuves distinguent clairement validation locale, préproduction, production publique et preuve opérateur.
- Une intégration externe indisponible est vérifiée par toutes les voies disponibles avant d’être déclarée inaccessible ; l’agent distingue une limitation de sandbox, un outil absent et une panne réelle.

### Documentation, versionnement et historique

- Toute évolution d’instruction, d’agent, de Skill, de hook, de script, de workflow ou de comportement met à jour le README, le changelog et l’historique dans le même lot.
- Le cahier des charges est archivé dans `Documents/Projets/Cahier-des-Charges/<nom-du-projet>/cahier-des-charges.md`, jamais dans le dépôt du projet sauf demande explicite.
- `VERSION`, les manifestes, les badges, `CHANGELOG.md`, `VERSION-HISTORY.md` et les Releases doivent rester cohérents.
- Une version publiée décrit les fonctionnalités réellement présentes, les migrations, les limitations, les tests et les changements de comportement.
- L’historique de versions est chronologique ; les entrées ne doivent pas réutiliser une version pour des fonctionnalités différentes ni contenir de lignes de tableau isolées ou ambiguës.

## Limites explicites

Le kit automatise les contrôles, le routage et la continuité, mais ne peut pas inventer une décision métier, un secret, une approbation réglementaire ou une preuve externe absente. Dans ces cas uniquement, il doit conserver le Goal ouvert et formuler précisément la décision ou l’accès requis.
