# Matrice de scénarios des kits

Cette matrice définit les parcours à rejouer dans un projet temporaire avant toute promotion vers `dev` ou `main`. Un scénario est validé uniquement avec un résultat observable, une commande reproductible et une preuve conservée dans la sortie CI.

| Domaine | Scénario nominal obligatoire | Preuve attendue | Exécuté par |
|---|---|---|---|
| Initialisation | Nouveau projet avec cahier accepté | profil, conception et état créés | sandbox |
| Initialisation | Projet existant avec audit complet | cartes d’audit et couverture de conception | sandbox dynamique |
| Initialisation | Cahier incomplet | arrêt avant code et question consolidée | sandbox |
| Initialisation | Projet existant interrompu avant livraison | reprise du Goal et refus de clôture prématurée | sandbox dynamique |
| Conception | Documents incomplets | porte de conception bloquante | sandbox |
| Trello | Tableau neuf | listes ordonnées et labels nommés | sandbox |
| Trello | Carte explicitement demandée | création sans confirmation redondante | sandbox |
| Trello | Carte multi-checks | description, labels, checklist et preuve | sandbox |
| Trello | Connecteur d’écriture indisponible | complément navigateur puis relecture | sandbox |
| Trello | Séquence `01`, `02`, `03` | aucune carte suivante lancée hors ordre | sandbox |
| Goal | Carte à un check | Goal actif avant le premier check | sandbox |
| Goal | Carte multi-lots | plan d’agents inscrit avant action | sandbox |
| Hooks | Première initialisation | message de revue et approbation requise avant développement | sandbox |
| Hooks | Rapport initial sans approbation | la réponse demande explicitement `/hooks` et interdit l action produit avant preuve | sandbox |
| Hooks | Hook non approuvé ou modifié | avertissement et nouvelle revue obligatoire | documentation officielle |
| Hooks | Outil d’écriture sans Goal | refus `PreToolUse` observable | sandbox |
| Hooks | Permission API, branche protégée ou commande destructive | refus `PermissionRequest` observable | sandbox |
| Hooks | Résultat d’outil | événement `PostToolUse` journalisé | sandbox |
| Hooks | Sous-agent démarré puis arrêté | identifiant et livrable enregistrés | sandbox |
| Hooks | Réponse prématurée | continuation par `Stop` | sandbox |
| Délégation | Lots sans chevauchement | agents, fichiers et preuves attribués | sandbox |
| Délégation | Lots avec fichier partagé | mode séquentiel justifié | sandbox |
| Reprise | Goal en attente CI | état waiting et reprise automatique | sandbox |
| Reprise | Goal marqué blocked par erreur | réconciliation locale puis next action | sandbox |
| Reprise | Deux tours sans résolution | changement d’approche obligatoire | sandbox |
| Outils | Outil absent du PATH | recherche multi-emplacements | sandbox |
| Outils | Outil gratuit manquant | installation provisoire et test | sandbox |
| GitFlow | Branche de travail | commits sans PR prématurée | sandbox |
| GitFlow | Carte terminée | PR unique vers `dev` | sandbox |
| GitFlow | Promotion | PR unique `dev` vers `main` | sandbox |
| CI | Push de branche de travail | aucun workflow coûteux non prévu | sandbox |
| CI | PR d’intégration | contrôles complets et concurrence | sandbox |
| CI | PR vers `dev` | workflow déclenché et contrôles visibles | sandbox |
| Versionnement | Mise à jour du kit | VERSION, changelog et historique alignés | sandbox |
| Documentation | Livraison d’une feature | README et docs de conception synchronisés | sandbox |
| Navigateur | Validation externe terminée | onglets et session fermés | sandbox |
| Sécurité | Secret ou donnée sensible détecté | arrêt et absence de fuite | sandbox |
| Périmètre | Besoin non prévu | hors périmètre, aucun check ajouté | sandbox |
| Livraison | Goal complet | garde avant réponse acceptée | sandbox |

## Tests d'intégration réels

`scripts/test-integration-preflight.sh` exécute un test non destructif de worktrees et de détection de `.git/index.lock`. Il affiche séparément `not-executed` pour Trello, l'orchestrateur et le navigateur tant que les connecteurs de test ne sont pas explicitement activés. Une valeur `not-executed` ne constitue jamais une réussite d'intégration.

## Règle de promotion

Une ligne non exécutée, non prouvée ou en échec interdit la promotion. Les scénarios statiques vérifient la présence des règles ; les scénarios dynamiques doivent exécuter les scripts dans un projet temporaire isolé. Les intégrations externes sont testées avec des adaptateurs simulés et ne doivent jamais utiliser un tableau ou un dépôt de production.
