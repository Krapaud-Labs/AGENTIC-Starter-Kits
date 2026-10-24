# Skill project-intake

## Objectif

Obtenir et formaliser le cahier des charges avant toute analyse technique ou modification du projet.

## Quand l'utiliser

Obligatoire si `.codex/PROJECT-BRIEF.md` est absent ou si son statut est `pending`.

## Entrées requises

Un cahier des charges fourni par l'utilisateur dans le chat. Il peut être structuré ou rédigé naturellement.

## Procédure

1. Demander le cahier des charges si aucun contenu suffisant n'a été fourni.
2. Ne pas analyser le dépôt, choisir de technologies, créer de code, créer de work item ou lancer de contrôle avant réception.
3. À réception, choisir le modèle universel dans `.codex/templates/project-brief.md`, compléter `.codex/PROJECT-BRIEF.md` et conserver le cahier vierge comme modèle non accepté.
4. Analyser systématiquement les informations manquantes : utilisateurs, objectifs mesurables, périmètre, parcours, règles métier, stack, données, sécurité, design, exploitation, équipe, budget, délai, CI et GitHub Projects.
5. Présenter une seule série de questions structurées. Pour chaque question, proposer deux ou trois choix concrets, marquer le meilleur choix recommandé par l’agent, expliquer brièvement le compromis et permettre une réponse personnalisée.
6. Attendre les réponses à cette série avant toute implémentation. Si la réponse est partielle, enregistrer les éléments reçus et demander uniquement les réponses encore manquantes, sans demander à l’utilisateur de dire « continue ». Dès que les décisions bloquantes sont résolues, transmettre automatiquement au Skill `project-onboarding` et poursuivre le flux prévu. Les hypothèses restantes doivent être listées et validées explicitement comme hypothèses réversibles.
7. Marquer le statut `accepted` uniquement si vision, utilisateurs, objectifs, périmètre MVP, hors périmètre, contraintes, critères de réussite et Definition of Done sont présents. Une reconstitution reste `reconstructed` jusqu'à validation explicite.
8. Demander explicitement : `Veux-tu que je prépare un GitHub Project complet avec toutes les Issues détaillées du projet ? Réponds oui ou non.` Ne jamais déduire la réponse.
9. Enregistrer `tracking.github_projects_choice = "enabled"` si la réponse est oui, ou `tracking.github_projects_choice = "disabled"` si la réponse est non. Si oui, demander le dépôt cible et les membres avec leur rôle GitHub si nécessaire. Le Skill `github-projects-planning` est alors obligatoire.
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
