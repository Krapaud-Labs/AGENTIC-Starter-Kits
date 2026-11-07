# Porte conception avant développement

La conception est une porte obligatoire avant toute écriture de code lorsque la carte introduit ou modifie une décision d'architecture, un contrat, un modèle de données, une règle de sécurité ou le design system. Elle n'est pas une approbation globale exigée pour chaque carte d'implémentation déjà couverte par une conception acceptée.

Le Coordinateur ne peut lancer une carte de conception ou une carte qui modifie un contrat structurant que lorsque `docs/design/design-readiness.md` indique `Status: approved`, que ses cases concernées sont cochées et que les documents impactés sont cohérents. Pour une carte d'implémentation fonctionnelle déjà couverte par la conception acceptée, il vérifie uniquement les documents et critères directement concernés. Une readiness globale en `review` ne bloque pas cette carte si aucun changement structurant n'est introduit.

Le dossier de conception doit couvrir au minimum la vision et le périmètre, les user stories, les parcours, l'architecture, les données, les contrats, la sécurité, la direction visuelle si applicable, la roadmap, les décisions, les diagrammes et les critères de validation. « Parfait » signifie ici complet au regard du cahier des charges accepté, cohérent entre documents, audité et approuvé ; toute inconnue bloquante doit être résolue ou explicitement marquée `needs-review` avant le code.

Une demande de code qui modifie un élément structurant avant cette approbation devient une action de conception. Une demande de code fonctionnelle déjà couverte par les documents acceptés reste une action d'implémentation et ne doit pas être transformée artificiellement en audit général.

## Transition de phase atomique

## Mode refonte par phases

Pour une refonte de plusieurs écrans, le Coordinateur regroupe toute la conception viewer, admin et pages secondaires dans un lot de design unique. Ce lot fixe la direction artistique, le design system, les composants, les assets, la navigation, les états et les variantes responsive. Aucun agent d'implémentation ni audit final répété écran par écran ne démarre avant la validation globale du lot de design. Ensuite seulement, l'implémentation est réalisée par lots cohérents, puis les tests fonctionnels et l'audit visuel final sont exécutés sur l'ensemble du périmètre. Toute exception doit être justifiée dans le Goal.

Le Coordinateur ne peut annoncer simultanément « conception en cours », « conception terminée » et « prêt pour l'implémentation ». `conception` reste l'étape active tant que tous les livrables, critères, décisions, preuves et relectures du `design-gate` ne sont pas vérifiés. Une conception partielle est `rework` avec la prochaine tâche de conception exécutée immédiatement. La phase `implementation` et tout agent de code ne commencent qu'après `design-gate=verified`, `design-readiness=approved` et preuve d'audit indépendant. Un commit ou un test isolé ne vaut jamais approbation de la conception.
