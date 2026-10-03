---
name: project-onboarding
description: Détecte les technologies après acceptation du cahier et met à jour le profil de projet sans rien inventer.
---

# Skill project-onboarding

## Précondition obligatoire

Le Coordinateur applique d'abord la porte de démarrage d'initialisation de `ORCHESTRATION.md`, consigne les instructions relues, puis crée ou reprend le Goal persistant de l'initialisation. Ce Goal couvre tout le flux jusqu'à la livraison vérifiée ; il est obligatoire même sans code et même si Trello sert d'abord de checkpoint.

## Objectif

Adapter le kit à un nouveau projet avant toute modification du produit.

## Quand l'utiliser

Après acceptation du cahier des charges, après un changement majeur de stack ou si le profil est incomplet.

## Entrées

`.claude/PROJECT-BRIEF.md` accepté, `.claude/project-inventory.md`, `.claude/RISK-MATRIX.md`, état Git, manifests, documentation, scripts, CI existante et demande utilisateur.

## Procédure

1. Lire l'inventaire et les fichiers de projet pertinents.
3. Identifier langage, framework, gestionnaire de paquets, tests, build, CI, données, authentification, déploiement et conventions Git.
4. Si un choix technique n’est pas détectable, proposer une baseline cohérente avec le cahier, la documenter comme décision réversible et poursuivre sans demander une confirmation pour chaque outil. Demander uniquement les décisions métier, irréversibles, réglementaires, financières ou bloquantes.
6. Compléter `[stack]` dans `project-profile.toml` avec uniquement les technologies réellement détectées.
6. Compléter le reste du profil avec les commandes et conventions vérifiées.
7. Définir les commandes de validation réellement disponibles.
8. Proposer la cadence CI `pull-request-only` ou `every-push`, enregistrer le choix dans `[delivery].ci_trigger_mode` et générer le workflow correspondant. Recommander `pull-request-only` pour éviter les exécutions coûteuses sur chaque push ; ne sélectionner `every-push` qu'après décision explicite.
9. Conserver les conventions existantes, y compris la branche d'intégration.
9. Créer une décision locale si une convention est absente ou contradictoire.
10. Si `tracking.trello_choice = "enabled"`, appliquer le Skill `trello-planning` et compléter `docs/project-management/trello-board.md` avec toutes les cartes détaillées avant l implémentation.
11. Si le projet contient déjà du code, des fonctionnalités ou un historique de livraison, considérer l'initialisation comme une reprise de projet existant. Après le choix Trello, effectuer un audit complet et minutieux de la conception, du périmètre, de l'architecture, des données, de la sécurité, du code, des tests, de l'accessibilité, de l'UX, de la documentation, de la CI, de l'exploitation et des risques. Transformer chaque correction, dette, incohérence ou amélioration identifiée en carte Trello distincte, ordonnée par dépendances et classée MVP ou Post-MVP. Ne reprendre le développement qu'après la création et la relecture de toutes les cartes d'audit.
12. Si le tableau Trello existe déjà, le relire et le remettre directement en conformité avec les normes du kit avant toute reprise : listes adaptées à l'équipe, titres numérotés, périmètre MVP ou Post-MVP, dépendances, groupes de parallélisation, responsables, descriptions, checklists et règles de clôture. Préserver l'historique utile, corriger les incohérences sans doublonner les cartes, ajouter les cartes d'audit manquantes, puis relire le tableau complet et enregistrer la preuve de synchronisation.
13. Une fois toutes les réponses d'initialisation recueillies, terminer automatiquement l'onboarding avant toute question sur le développement. Compléter les profils et documents, mettre à jour `.gitignore` sans ignorer les livrables requis, créer une branche d'onboarding, committer uniquement ses artefacts, pousser la branche, ouvrir la PR vers `dev`, attendre et vérifier ses contrôles, puis fusionner ou documenter précisément le blocage. Un simple push sur `dev`, une branche créée ou une PR préparée ne constitue pas une livraison. Ne demander s'il faut lancer le développement qu'après la preuve de la PR vers `dev` et sa relecture. Si la PR est impossible, conserver l'onboarding ouvert et ne pas le déclarer terminé.
11. Exécuter `bash .claude/scripts/initialize-project-design.sh`, puis appliquer le Skill `conception` pour compléter `docs/` avant toute implémentation.

## Sortie

Profil complété, résumé des faits confirmés, inconnues restantes et recommandations de Skills actifs.

## Contrôles

Chaque valeur renseignée doit être reliée à un fichier, une commande ou un résultat observable. Les champs inconnus restent inconnus, sans inférence.

## Mesures

Nombre de conventions détectées, inconnues restantes, temps d'initialisation et corrections ultérieures du profil.

## Arrêt

Ne pas deviner une commande, un environnement de production, une branche ou une politique de sécurité. Demander une décision si l'information ne peut pas être établie.
