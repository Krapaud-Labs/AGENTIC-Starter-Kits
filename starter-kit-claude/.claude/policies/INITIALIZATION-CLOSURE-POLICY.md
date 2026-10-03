# Porte de clôture de l’initialisation

L’initialisation est un flux livré, pas un simple état de cadrage. Le Coordinateur garde le Goal `active` jusqu’à la preuve de chaque étape suivante.

## Séquence obligatoire

1. Lire toutes les instructions, le cahier, l’état Git, les outils disponibles et le kit courant.
2. Mettre à jour `.gitignore` avant toute copie ou modification locale du kit. Dans un projet consommateur, `.claude/` et les états runtime restent ignorés et ne peuvent jamais être ajoutés avec `git add -f`.
3. Créer ou reprendre le Goal d’initialisation avant la première action observable.
4. Compléter le profil et les documents de conception sans inventer une technologie ou une obligation.
5. Si Trello est activé, créer ou remettre en conformité les listes, labels nommés, cartes, numéros, dépendances, descriptions et checklists.
6. Relire réellement chaque carte et enregistrer le nombre, l’ordre, la liste, les labels, la description et les checks observés. Un fichier local décrivant Trello ne constitue pas une preuve Trello.
7. Pour un projet existant, auditer code, architecture, données, sécurité, UX, accessibilité, tests, documentation, CI, exploitation et risques. Chaque écart applicable devient une carte ; un contrôle hors cahier ou hors périmètre est abandonné et documenté comme non applicable.
8. Inscrire dans le Goal le plan d’agents, les lots, les fichiers autorisés, les preuves et l’agent intégrateur avant tout travail parallèle.
9. Créer la branche d’onboarding, committer seulement les artefacts autorisés, pousser, ouvrir la PR vers `dev`, vérifier son état et ses contrôles, puis relire la branche distante.

## États interdits

- `complete` ou « onboarding terminé » si Trello est seulement préparé localement, si une carte, un label ou une checklist reste non relu, si la PR vers `dev` n’est pas créée et vérifiée, ou si une action autonome reste ouverte.
- `needs-review` pour masquer une action autonome, une reconnexion, une installation d’outil gratuit, une relecture ou une correction encore réalisable.
- `blocked` sans preuve du blocage réel, alternatives essayées et tâches indépendantes terminées.
- « synchronisation indisponible » sans avoir vérifié connecteur, navigateur existant, CLI, PATH, extensions et alternative documentée.

La fin d’onboarding ne demande le démarrage du développement qu’après cette porte complète. Toute autre conclusion est un échec de validation.
