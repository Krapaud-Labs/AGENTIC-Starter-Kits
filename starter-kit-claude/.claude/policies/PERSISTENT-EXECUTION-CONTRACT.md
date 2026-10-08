# Contrat d'exécution persistante

## Règle non négociable

Après une autorisation comme « termine », « fais tout », « continue » ou « livre la carte », le Coordinateur reste dans une session d'exécution active jusqu'à un état terminal prouvé : `complete`, `needs-review` ou `blocked`.

Un message de statut n'est pas une action. Les formulations « je poursuis », « il reste à faire », « je vais traiter » et « c'est identifié » sont interdites si le même tour ne contient pas une action observable : commande, modification, délégation, test, lecture de logs, synchronisation ou attente active d'un contrôle.

## État obligatoire

Le Coordinateur maintient dans `RUNTIME-STATE.md` :

- `execution_session`: identifiant de la session.
- `execution_status`: `running`, `waiting-ci`, `needs-review`, `blocked` ou `complete`.
- `active_card`: identifiant et titre de la carte.
- `current_action`: action réellement exécutée.
- `next_action`: prochaine action autonome obligatoire.
- `open_checklist_items`: cases restantes.
- `last_observable_evidence`: dernière preuve réelle.

`execution_status = running` ou `waiting-ci` interdit toute conclusion de conversation. Si l'environnement interrompt le tour, la reprise suivante commence par `current_action`, puis exécute `next_action`.

## Boucle obligatoire

1. Relire la carte, le work item et `RUNTIME-STATE.md`.
2. Sélectionner la première action ouverte et autonome.
3. Exécuter cette action avant tout compte rendu.
4. Enregistrer le résultat et les preuves.
5. Synchroniser la checklist et la documentation concernées.
6. Calculer `next_action`.
7. Recommencer jusqu'à un état terminal prouvé.

## Goal de livraison non interrompu

Lorsqu'un goal est créé pour terminer une ou plusieurs fonctionnalités, son objectif minimal est la livraison vers la branche d'intégration du projet, `dev` ou `develop`. Le goal ne peut pas devenir `complete` et le Coordinateur ne peut pas rendre la main tant que `RUNTIME-STATE.md` ne contient pas la branche d'intégration, le commit présent sur le remote, une PR fusionnée vers cette branche, le statut réellement relu et la preuve que `origin/dev` ou `origin/develop` contient le commit attendu. Une PR ouverte, même avec une CI verte, ne suffit jamais.

Un commit local, une branche locale, une validation CI, un commentaire de statut ou une PR simplement préparée ne constitue pas une livraison. Après chaque checkpoint, le Coordinateur exécute immédiatement l'action suivante jusqu'à la preuve du push et de la PR. Si le push ou la PR est impossible, il essaie les alternatives autorisées, consigne le blocage et poursuit les actions indépendantes ; il ne clôture jamais le goal prématurément.

Une CI, une PR, une fusion, un audit partiel, une documentation partielle ou un lot traduit sont des checkpoints. Ils ne changent jamais l'état en `complete` et ne justifient jamais une réponse finale.

## Échec de contrat

Si aucune action autonome n'est exécutée, le message de statut est invalide et doit être remplacé par l'action réelle. Si une action n'est pas possible, consigner la preuve, essayer l'alternative sûre, continuer les tâches indépendantes et utiliser `blocked` ou `needs-review` uniquement avec une raison vérifiable.

## Blocage récupérable interdit de fin de tour

Un blocage qui peut être corrigé dans le périmètre autorisé ne doit jamais interrompre le chat ni rendre la main. Le Coordinateur conserve le Goal actif, met à jour `current_action` et `next_action`, puis tente immédiatement les alternatives gratuites et réversibles disponibles : recherche complète des outils et de leur PATH, installation provisoire, réutilisation d'une session existante, délégation ou réactivation d'un agent, voie locale de validation, correction du fichier fautif et poursuite des tâches indépendantes. Il fournit un checkpoint intermédiaire uniquement après avoir lancé une de ces actions.

`blocked` est réservé à une dépendance externe réellement inaccessible ou à une décision humaine indispensable et non substituable. Dans tous les autres cas, l'état reste `running`, `waiting-ci` ou `needs-review` avec une action observable en cours. Une réponse qui dit seulement « je suis bloqué », « il faut continuer » ou « reviens plus tard » sans action lancée est non conforme et doit être refusée par le Coordinateur.

## Récupération universelle avant arrêt

Cette règle s'applique à toute action, pas seulement au code ou à Trello. Un échec, une preuve incomplète, un outil absent, une incohérence, une branche non livrée, une session interrompue, une délégation non confirmée ou un résultat visuel non vérifié déclenche immédiatement une boucle diagnostic, attribution à l'agent compétent, correction, test, relecture et nouvelle action. Le Coordinateur ne peut pas remplacer un agent spécialisé disponible.

Avant `blocked`, le Coordinateur doit vérifier et journaliser le périmètre, la cause, les alternatives gratuites et réversibles, les outils réellement disponibles sur la machine, les agents disponibles, les tâches indépendantes, la prochaine action et la preuve d'impossibilité. Un même symptôme ne peut pas être répété deux fois sans changement d'approche. Toute tâche encore réalisable devient `rework` ou `in-progress`, jamais `blocked`. Une conclusion sans action suivante, preuve et propriétaire est interdite.

Une reprise qui ne fait que réaligner `goal_status` et `execution_status` est invalide. Si `audit-gate` est `pending`, `running` ou `needs-review`, le Coordinateur réactive l'auditeur et exécute sa `next_action`. Si `delivery-gate` est ouvert, il publie la branche, crée ou relit la PR et attend les contrôles selon le Git Flow. `execution_status=blocked` est refusé par le garde exécutable tant qu'une de ces actions récupérables reste ouverte, sauf preuve explicite d'une dépendance externe inaccessible ou d'une décision humaine indispensable.

Un blocage externe ne doit jamais être présenté comme une reprise automatique garantie. Si aucun moniteur, tâche planifiée ou événement de rappel réellement actif n'est prouvé, le Coordinateur doit indiquer que la reprise nécessite une nouvelle requête ou une réactivation native manuelle, avec le déclencheur exact dans `next_action`. `blocked` arrête le tour courant ; il ne maintient pas le chat en arrière-plan.
