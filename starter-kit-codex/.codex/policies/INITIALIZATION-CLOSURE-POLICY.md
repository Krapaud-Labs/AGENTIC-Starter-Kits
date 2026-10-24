# Porte de clôture de l’initialisation

## Budget et périmètre obligatoires

L'initialisation est une phase courte de cadrage bornée à 15 minutes de travail actif et 20 actions maximum. Elle doit lire et formaliser le cahier des charges, créer les documents de conception, recenser le projet, décomposer le MVP et le Post-MVP et créer les cartes détaillées nécessaires avec labels, descriptions, dépendances et checklists. Elle ne développe rien, n'exécute aucune carte et ne réalise pas d'audit approfondi par domaine. Les audits techniques, visuels, sécurité, exploitation et les preuves de production deviennent des cartes distinctes exécutées plus tard. Si le budget est atteint, le Coordinateur arrête l'initialisation avec un inventaire des cartes restantes, sans boucle ni répétition.

Pour un projet existant, le parcours accéléré limite l'inventaire à une passe de 20 minutes et 30 actions maximum. Il ne relit pas toutes les cartes ni tous les domaines en profondeur. Il crée des cartes d'audit regroupées et déléguées, puis remet les détails à leur exécution dédiée.

L'initialisation est livrée lorsque le cahier, les documents de conception, la matrice MVP/Post-MVP, les cartes et la livraison d'onboarding sont vérifiés. Elle n'attend pas l'implémentation, les audits détaillés ou la readiness globale du produit.

## Séquence obligatoire

1. Lire toutes les instructions, le cahier, l’état Git, les outils disponibles et le kit courant.
2. Mettre à jour `.gitignore` avant toute copie ou modification locale du kit. Dans un projet consommateur, `.codex/` et les états runtime restent ignorés et ne peuvent jamais être ajoutés avec `git add -f`.
3. Créer ou reprendre le Goal d’initialisation avant la première action observable.
4. Compléter le profil et les documents de conception sans inventer une technologie ou une obligation.
5. Si Trello est activé, créer ou remettre en conformité les listes, labels nommés, cartes, numéros, dépendances, descriptions et checklists.
6. Relire réellement chaque carte et enregistrer le nombre, l’ordre, la liste, les labels, la description et les checks observés. Un fichier local décrivant Trello ne constitue pas une preuve Trello.
7. Pour un projet existant, effectuer uniquement un inventaire rapide des écarts visibles dans code, architecture, données, sécurité, UX, accessibilité, tests, documentation, CI, exploitation et risques. Chaque piste applicable devient une carte d'audit dédiée ; ne pas résoudre ni approfondir ces écarts pendant l'initialisation.
7 bis. Construire une matrice de couverture cahier → conception → carte locale → carte distante. Vérifier le nombre, les identifiants, les phases MVP/Post-MVP, les dépendances, les étiquettes, les descriptions, les checklists et les preuves de relecture pour chaque carte. Un fichier local ou un tableau partiellement synchronisé ne constitue jamais une preuve de création complète ; tant que la comparaison distante n'est pas vérifiée, `trello_sync_status` reste `syncing` ou `needs-review` et l'initialisation ne peut pas être déclarée terminée.
8. Inscrire dans le Goal le plan d’agents et les lots de l'onboarding. Les agents d'implémentation et les audits détaillés ne sont pas lancés pendant cette phase ; un agent de conception peut seulement vérifier la complétude des documents.
9. Créer la branche d’onboarding, committer seulement les artefacts autorisés, pousser, ouvrir la PR vers `dev`, vérifier son état et ses contrôles, puis relire la branche distante.

## Ouverture autonome de la PR d'onboarding

Quand l'utilisateur a demandé l'initialisation, la livraison ou l'exécution jusqu'au bout, cette demande autorise déjà les étapes réversibles de livraison. Dès que la branche d'onboarding est publiée, que le diff est conforme, que les contrôles locaux sont verts et que les gates sont suffisamment documentés pour ouvrir la PR, le Coordinateur doit créer immédiatement la PR vers `dev` ou `develop`, sans demander « confirme la création de la PR » ni une confirmation équivalente. Il doit ensuite relire la PR, attendre les contrôles, corriger les échecs et poursuivre le Goal jusqu'à fusion ou blocage réel.

Une page GitHub ouverte, un formulaire prérempli ou une PR seulement préparée ne constitue pas une PR créée. L'état `delivery-gate: pending` ne justifie pas une demande de confirmation lorsque l'ouverture est techniquement disponible. Une intervention humaine n'est permise que pour une protection de branche, une revue obligatoire, un conflit, une décision métier, un secret, une dépense ou une action explicitement sensible.

## États interdits

- `complete` ou « onboarding terminé » si Trello est seulement préparé localement, si une carte, un label ou une checklist reste non relu, si la PR vers `dev` n’est pas créée et vérifiée, ou si une action autonome reste ouverte.
- `needs-review` pour masquer une action autonome, une reconnexion, une installation d’outil gratuit, une relecture ou une correction encore réalisable.
- `blocked` sans preuve du blocage réel, alternatives essayées et tâches indépendantes terminées.
- « synchronisation indisponible » sans avoir vérifié connecteur, navigateur existant, CLI, PATH, extensions et alternative documentée.

## Reprise obligatoire avant toute conclusion

Si `docs/design/design-readiness.md` est encore en `draft`, `review` ou `rework`, l'initialisation enregistre ce statut et crée les cartes de conception manquantes. Elle ne lance pas la réalisation de ces cartes et ne transforme pas leur statut en blocage de l'onboarding.

Un état `blocked` pendant l'initialisation n'est autorisé que si une dépendance externe ou une décision explicitement humaine empêche réellement toute action autonome. Dans ce cas, `next_action` doit identifier l'événement attendu et les tâches indépendantes doivent être terminées ou attribuées. Une conception encore modifiable, un audit non lancé, une carte non créée, une PR non ouverte ou un outil gratuit installable ne sont jamais des blocages.

L'absence de validation indépendante des stories P0, une conception en `review` et des `audit-gate` ouverts sont des cartes de travail à planifier, pas des blocages de l'initialisation. Seuls les artefacts d'onboarding, la branche et la PR d'onboarding doivent être livrés dans ce Goal.

La fin d’onboarding ne demande le démarrage du développement qu’après cette porte complète. Toute autre conclusion est un échec de validation.
