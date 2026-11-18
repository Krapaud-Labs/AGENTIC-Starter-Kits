---
name: project-intake
description: Exige et formalise le cahier des charges avant toute analyse, choix technique ou modification du projet.
---

# Skill project-intake

## Objectif

Obtenir et formaliser le cahier des charges avant toute analyse technique ou modification du projet.

## Quand l'utiliser

Obligatoire si `.claude/PROJECT-BRIEF.md` est absent ou si son statut est `pending`.

## Entrées requises

Un cahier des charges fourni par l'utilisateur dans le chat. Il peut être structuré ou rédigé naturellement.

## Procédure

1. Demander le cahier des charges si aucun contenu suffisant n'a été fourni.
2. Ne pas analyser le dépôt, choisir de technologies, créer de code, créer de work item ou lancer de contrôle avant réception.
3. À réception, choisir le modèle universel dans `.claude/templates/project-brief.md`, compléter `.claude/PROJECT-BRIEF.md` et conserver le cahier vierge comme modèle non accepté.
4. Analyser systématiquement les informations manquantes : utilisateurs, objectifs mesurables, périmètre, parcours, règles métier, stack, données, sécurité, design, exploitation, équipe, budget, délai, CI et gestionnaire de suivi souhaité.
5. Présenter une seule série de questions structurées. Pour chaque question, proposer deux ou trois choix concrets, marquer le meilleur choix recommandé par l’agent, expliquer brièvement le compromis et permettre une réponse personnalisée.
6. Attendre les réponses à cette série avant toute implémentation. Si la réponse est partielle, enregistrer les éléments reçus et demander uniquement les réponses encore manquantes, sans demander à l’utilisateur de dire « continue ». Dès que les décisions bloquantes sont résolues, transmettre automatiquement au Skill `project-onboarding` et poursuivre le flux prévu. Les hypothèses restantes doivent être listées et validées explicitement comme hypothèses réversibles.
7. Marquer le statut `accepted` uniquement si vision, utilisateurs, objectifs, périmètre MVP, hors périmètre, contraintes, critères de réussite et Definition of Done sont présents. Une reconstitution reste `reconstructed` jusqu'à validation explicite.
8. Demander explicitement le gestionnaire de suivi souhaité parmi `local`, `github` (GitHub Projects) et `trello`, sans présélectionner Trello. Recommander `local` si aucun service externe n’est nécessaire; accepter le choix personnalisé de l’utilisateur.
9. Enregistrer `tracking.mode` selon le choix. Pour `local`, mettre `github_projects_choice = "disabled"` et `trello_choice = "disabled"`. Pour `github`, mettre `github_projects_choice = "enabled"` et `trello_choice = "disabled"`, puis demander le dépôt cible et les membres avec leur rôle GitHub si nécessaire. Pour `trello`, mettre `trello_choice = "enabled"` et `github_projects_choice = "disabled"`, puis recueillir le nom du tableau et les membres utiles. N’activer qu’un seul gestionnaire distant à la fois; appeler le Skill correspondant seulement si ce gestionnaire est sélectionné.
10. Lister les inconnues qui demandent une décision humaine, sans bloquer les détails secondaires.
11. Passer automatiquement au Skill `project-onboarding` pour adapter le profil technique dès que la série de décisions bloquantes est complète. L’absence d’une formule explicite comme « continue » ou « fais tout » ne constitue pas un motif d’arrêt.

## Contrôles

Ne jamais inventer un besoin métier, une technologie imposée, une échéance ou une contrainte réglementaire. Le cahier doit distinguer explicitement le périmètre du hors périmètre.

## Sortie

`PROJECT-BRIEF.md` complet, statut `accepted`, inconnues explicites et autorisation de démarrer l'onboarding.

## Mesures

Champs manquants, demandes de clarification, changements de périmètre ultérieurs et reprises de conception.

## Arrêt

S'arrêter après avoir demandé le cahier des charges. Ne démarrer aucune autre étape tant que le cahier n'est pas fourni et accepté.
