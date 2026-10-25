# Politique d'efficacité d'exécution

Cette politique réduit la durée et le nombre d'appels sans supprimer les contrôles obligatoires.

## Plan unique par carte ou feature

Avant le premier outil, le Coordinateur produit un plan consolidé contenant le périmètre, les lots indépendants, les agents requis, les preuves et la Definition of Done. Il ne découpe pas une même feature en micro-goals, micro-branches, micro-PR ou micro-audits.

Une carte ou feature conserve une seule branche de travail et une seule PR finale. Les commits intermédiaires restent des checkpoints locaux ou sur cette branche. Une PR de déploiement n'est ouverte que si l'utilisateur demande explicitement une mise à jour de la branche d'intégration avant la fin.

## Passe spécialisée consolidée

Les agents spécialisés nécessaires sont créés ou réactivés dans le même cycle avant l'implémentation. Chaque agent reçoit un lot non recouvrant et un contexte minimal. Le Coordinateur attend les rapports du lot complet avant de lancer l'audit final.

Pour une tâche visuelle ou multi-écrans, une seule matrice couvre tous les écrans, états, dimensions, interactions, accessibilité et preuves. Les agents peuvent remplir des lignes distinctes en parallèle, mais aucun contrôle identique ne doit être répété.

## Limites d'itération

- Une passe d'inventaire et une passe de correction groupée avant la revalidation.
- Une revalidation finale complète après le lot de corrections.
- Une seule relance par agent pour un rapport incomplet ou invalide.
- Après deux échecs avec la même signature, changement d'approche obligatoire et journalisé.
- Aucun nouveau micro-audit sans changement de code, preuve, configuration ou état externe.

Un résultat `REWORK` est regroupé en actions correctives par domaine, puis relu en une seule passe. Les remarques identiques sont dédupliquées par identifiant stable.

## Règle de progression

Le Coordinateur poursuit automatiquement les actions autonomes du plan. Il ne demande pas « continue », « confirme » ou une validation intermédiaire pour une action déjà autorisée. Un blocage ne peut être déclaré qu'après exécution du lot autonome, de l'alternative prévue et d'une preuve externe réelle.

## Mesures obligatoires

Le rapport final indique le nombre de lots, agents, appels, relances, audits, revalidations et minutes. Une dérive de plus de 50 pour cent par rapport au budget du work item déclenche une consolidation immédiate, pas une nouvelle série de micro-tâches.
