# Fonctionnalités réellement implémentées

Ce document est la référence synthétique du comportement livré par les kits. Il distingue les mécanismes exécutables des règles qui restent dépendantes de l'environnement Codex ou Claude.

## Versions et distributions

| Élément | État | Preuve |
|---|---|---|
| Version actuelle | `1.16.1` | `VERSION`, `KIT.toml` |
| Variante Codex | Implémentée | `starter-kit-codex/` |
| Variante Claude | Implémentée | `starter-kit-claude/` |
| Mise à jour des consommateurs | Implémentée | `sync-workspace-kit.sh` |
| Sauvegardes locales préservées | Implémentée | exclusion `backups/` de `rsync --delete` |

## Démarrage et initialisation

- `AGENTS.md` ou `CLAUDE.md` est installé et contrôlé par version.
- Le contrat agentic vérifie les politiques, le runtime et les garde-fous exécutables.
- `.gitignore` est préparé avant les autres mutations de l'installation.
- Les outils sont recherchés dans plusieurs emplacements avant toute conclusion d'indisponibilité.
- Les outils gratuits manquants peuvent être installés provisoirement pour les validations.
- L'initialisation demande la revue des hooks avant tout travail produit.
- Les données projet, les décisions, les work items, les rapports et le runtime sont conservés pendant les mises à jour.

## Orchestration et Goals

- Le rôle principal est le Coordinateur.
- Un Goal natif doit être créé ou repris avant une action, avec fallback local explicitement identifié si l'API native est indisponible.
- Un work item et un état runtime persistent les actions, preuves, obligations et prochaines actions.
- Une tâche spécialisée exige un agent réel, un identifiant, un périmètre et un livrable vérifiable.
- Les lots indépendants sont parallélisés lorsque plusieurs agents sont disponibles.
- Le Coordinateur ne remplace pas un spécialiste disponible.
- Les états `running`, `waiting-ci`, `blocked`, `needs-review` et `complete` sont contrôlés avant réponse.
- Une clôture reste interdite tant que la prochaine action, les preuves, la checklist et la livraison ne sont pas vérifiées.

## Hooks de cycle de vie

| Hook | Fonction | Niveau |
|---|---|---|
| `SessionStart` | recharge version, runtime, Goal et consignes | contexte automatique |
| `PreToolUse` | bloque les écritures sans Goal ou état valide | blocage exécutable |
| `PermissionRequest` | refuse API payante, branche protégée et commande destructive | blocage exécutable |
| `PostToolUse` | journalise outil et identifiant de preuve | traçabilité |
| `SubagentStart` | enregistre l'identifiant et le type du sous-agent | traçabilité |
| `SubagentStop` | demande la vérification du livrable indépendant | contrôle |
| `Stop` | appelle le garde avant réponse et continue si la livraison est incomplète | continuité |

Les hooks locaux doivent être relus et approuvés dans Codex avec `/hooks` après chaque installation ou modification. Le dépôt ne peut pas s'auto-approuver auprès du runtime.

## Facturation et outils externes

- Le mode par défaut utilise l'authentification abonnement de Codex ou Claude.
- Les clés `OPENAI_API_KEY`, `CODEX_API_KEY`, `ANTHROPIC_API_KEY` et `ANTHROPIC_AUTH_TOKEN` bloquent l'initialisation sans autorisation explicite.
- Les Agents API, Agents SDK, gateways et fournisseurs cloud sont hors périmètre abonnement par défaut.
- GitHub Actions, Trello, navigateur, Docker et autres services restent soumis à leur disponibilité et à leurs propres quotas.
- Une intégration non disponible ne doit jamais être déclarée comme exécutée.

## GitFlow et livraison

- Une branche dédiée est utilisée pour chaque work item.
- Les commits sont atomiques et contrôlés avant push.
- Une PR prématurée est refusée tant que la carte et sa checklist ne sont pas terminées.
- La branche d'intégration doit être relue après fusion.
- La promotion vers `main` suit la CI et la documentation du kit.
- La version, le changelog, l'historique et les README sont mis à jour pour les changements consommés.

## Trello

- Le connecteur lecture-écriture est prioritaire.
- Le navigateur complète uniquement les fonctions absentes ou instables du connecteur.
- Les listes, cartes, labels nommés, descriptions et checklists sont relus après écriture.
- Les cartes sont numérotées, ordonnées et liées à leurs dépendances.
- Une carte demandée directement ne reçoit pas de confirmation redondante.
- Les commentaires sont rédigés en français et relus après publication.
- Une absence de connecteur ne constitue jamais une preuve de synchronisation distante.

## Couverture de tests

- Tests de versions, documentation et cohérence de gouvernance.
- Tests des portes exécutables et de l'état runtime.
- Tests d'initialisation Codex et Claude en dépôts Git temporaires.
- Scénarios sandbox pour Goals, délégation, Trello, séquencement et reprise.
- Simulations d'adaptateurs GitFlow, navigateur, Trello et agents.
- Validation JSON et syntaxique de tous les hooks.
- CI Linux pour les contrôles principaux et PowerShell Core multiplateforme.

Les adaptateurs Trello, navigateur et agents natifs ne sont pas simulés comme des intégrations réelles dans la sandbox. Cette limite est volontairement signalée au lieu d'être présentée comme une réussite.
