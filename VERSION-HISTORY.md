# Historique des versions

## Objet

Ce document constitue la vue chronologique du projet Agentic Starter Kits. Il complète `CHANGELOG.md`, qui contient le détail opérationnel de chaque entrée. Les versions correspondent aux évolutions consommables du kit Codex ou Claude, et non à chaque commit interne.

## Origine du projet

Le dépôt a été initialisé le 21 septembre 2026. Les premiers commits ont établi la documentation du dépôt, les deux variantes Codex et Claude, les rôles spécialisés, les Skills, les scripts de cycle de vie, la sécurité, la validation avant push, le support multiplateforme et les standards de contribution.

## Historique chronologique

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

La version courante est `1.12.49`. Le changelog, les README et les manifestes `KIT.toml` doivent toujours porter la même version. Les tags historiques disponibles dans ce clone s’arrêtent actuellement à `v1.12.40`; les versions 1.12.41 à 1.12.49 sont documentées et fusionnées mais doivent recevoir leurs tags annotés lors de la prochaine opération de publication. Aucun tag existant ne doit être déplacé ou réutilisé.

## Sources de vérité

- `VERSION` contient la version courante.
- `CHANGELOG.md` contient le détail de chaque changement.
- `VERSIONING.md` définit le processus de publication.
- Les tags annotés `vX.Y.Z` identifient les versions publiées.
