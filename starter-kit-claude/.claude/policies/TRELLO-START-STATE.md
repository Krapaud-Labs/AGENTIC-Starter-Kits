# État initial obligatoire d'une carte Trello

Avant tout code, modification de fichier, délégation ou implémentation technique liée à une carte Trello, le Coordinateur doit déplacer la carte active dans la liste exacte `En cours` et relire la carte depuis Trello.

Le contrôle de démarrage doit vérifier :

- La carte existe et possède un identifiant et une URL stables.
- La carte se trouve dans `En cours`.
- La carte possède un responsable, un périmètre, des dépendances et une Definition of Done.
- Le work item actif et `RUNTIME-STATE.md` référencent le même identifiant de carte.
- Les étiquettes et la checklist de la carte sont présentes et lisibles.

Le Coordinateur doit enregistrer l'horodatage, l'identifiant, la liste précédente, la nouvelle liste et la preuve de relecture dans le work item et le journal qualité. Si la carte est déjà dans `Terminé`, `Revue` ou `Bloqué`, le Coordinateur ne doit pas coder dessus avant d'avoir réconcilié son état selon le système visuel Trello.

Si Trello est indisponible, enregistrer la transition tentée comme un blocage local et utiliser l'état du work item. Ne jamais prétendre que la carte a été déplacée ou synchronisée sans relecture réussie.

## Synchronisation en temps réel de la checklist

Réaliser les éléments de checklist strictement dans l'ordre des dépendances. Après chaque élément :

1. Réaliser le travail.
2. Exécuter la validation requise.
3. Enregistrer la preuve localement.
4. Cocher uniquement l'élément terminé dans Trello.
5. Mettre à jour la description ou le commentaire avec la preuve.
6. Relire la carte et confirmer l'élément coché, la liste actuelle et le prochain élément ouvert.
7. Commencer l'élément suivant uniquement après cette relecture réussie.

Ne jamais cocher plusieurs éléments rétrospectivement, cocher un élément avant l'existence de sa preuve ou poursuivre avec Trello obsolète ou contradictoire.
