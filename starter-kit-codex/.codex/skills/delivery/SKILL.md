# Skill delivery

## Objectif

Préparer une livraison Git propre, lisible, réversible et conforme aux conventions du projet.

## Entrées requises

Work item accepté, profil projet, état Git, rapport Auditeur, rapport Cybersécurité si requis et preuves de tests.

## Procédure

1. Vérifier branche cible, version `VERSION`, entrée `CHANGELOG.md` et statut Git. statut Git et changements hors périmètre.
2. Si un lockfile dépasse les limites de lignes, l’isoler automatiquement dans un commit séparé et documenter sa génération. Ne jamais demander à l’utilisateur une exception pour ce cas standard.
3. Vérifier que la branche est dédiée au work item, que les commits sont atomiques, sous les limites déclarées et que la documentation est affectée. Refuser tout commit massif ou mélange de features.
4. Vérifier que le commit ou la release respecte `VERSIONING.md` et que `CHANGELOG.md` recense le changement.
5. Lancer le preflight et les contrôles du profil projet.
6. Préparer la revue avec objectif, critères, preuves, risques et plan de retour.
7. Respecter le Git Flow existant et les protections de branche.
8. Vérifier que le README concerné a été mis à jour et décrit le changement, son usage, ses prérequis, ses limites et son impact. Refuser la livraison si la documentation publique est incomplète.

## Contrôles

Produire systématiquement un rapport final avec statut, fichiers, tests, erreurs corrigées, sources consultées, limites et prochaine action.

Ne jamais affirmer qu'une CI, une Pull Request ou un déploiement est vert sans résultat observable. Ne jamais fusionner dans `main` sans les autorisations et portes nécessaires.

## Sortie

Résumé de livraison, commandes, résultats, risques résiduels, décision de promotion et prochaine étape.

## Mesures

Temps de revue, échecs CI, retours de Pull Request, retours arrière et défauts après livraison.

## Arrêt

Si un contrôle échoue, si un rapport requis manque ou si la branche est incorrecte, diagnostiquer, corriger ou déléguer la correction, puis relancer le contrôle dans le même Goal. N'arrêter qu'après preuve d'une dépendance externe inaccessible ou d'une décision humaine indispensable ; préparer alors les alternatives et conserver une `next_action` explicite.
