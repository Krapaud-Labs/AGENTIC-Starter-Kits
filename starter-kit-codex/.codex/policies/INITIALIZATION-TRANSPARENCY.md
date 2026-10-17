# Politique de transparence de l'initialisation

## Objectif

Chaque initialisation doit expliquer d'où viennent les informations utilisées et pourquoi l'agent poursuit ou s'arrête.

## Vérification obligatoire

Avant toute action, lire et signaler explicitement :

1. La présence ou l'absence de .codex/PROJECT-BRIEF.md.
2. La date de modification et le statut du cahier.
3. L'origine du cahier : reçu dans le chat, fichier existant, ou génération depuis des documents existants.
4. Les documents de conception réellement lus.
5. Le profil technique réellement lu.
6. L'état d'exécution réellement lu.
7. Les décisions et work items réutilisés.
8. Les documents attendus mais absents.

## Réponses obligatoires

Si le cahier est absent, répondre avec le chemin vérifié, l'action d'attente et l'interdiction de commencer.

Si le cahier est présent et accepté, afficher son chemin, son statut, son origine, les documents réellement lus, les documents manquants et l'action de réutilisation sans remplacement.

L'agent ne doit jamais déclarer qu'un projet est configuré sans afficher ces informations. Le fichier existant ne doit jamais être considéré comme reçu dans le chat sans preuve.


## Porte de réponse

Le rapport de transparence est le premier et unique contenu du premier message du mode initialisation. Aucun résumé de configuration, aucune analyse et aucune annonce de tâche ne peut le précéder.

Le statut accepted ne dispense pas du rapport. Il remplace uniquement la demande d un nouveau cahier par une confirmation de réutilisation.

## Approbation des hooks

Le rapport initial doit demander explicitement l ouverture de `/hooks`, la relecture et l approbation des hooks du projet. Cette demande est une porte d environnement et non une confirmation métier. Tant que l approbation n est pas prouvée, l agent ne doit pas déclarer les garde-fous de cycle de vie actifs ni commencer une action produit irréversible.
