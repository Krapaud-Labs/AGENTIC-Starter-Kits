# Porte conception avant développement

La conception est une porte obligatoire avant toute écriture de code, délégation d'implémentation, création de branche de feature ou PR de code.

Le Coordinateur ne peut lancer le développement que lorsque `docs/design/design-readiness.md` indique `Status: approved`, que toutes ses cases sont cochées et que chaque document obligatoire est présent, cohérent, relu et sans marqueur `[[A_COMPLETER]]`, `TODO` ou `FIXME` non traité.

Le dossier de conception doit couvrir au minimum la vision et le périmètre, les user stories, les parcours, l'architecture, les données, les contrats, la sécurité, la direction visuelle si applicable, la roadmap, les décisions, les diagrammes et les critères de validation. « Parfait » signifie ici complet au regard du cahier des charges accepté, cohérent entre documents, audité et approuvé ; toute inconnue bloquante doit être résolue ou explicitement marquée `needs-review` avant le code.

Une demande de code reçue avant cette approbation devient une action de conception : compléter les documents, faire relire la conception et exécuter le preflight. Aucun agent d'implémentation ne doit être activé avant le passage de cette porte.

## Transition de phase atomique

## Mode refonte par phases

Pour une refonte de plusieurs écrans, le Coordinateur regroupe toute la conception viewer, admin et pages secondaires dans un lot de design unique. Ce lot fixe la direction artistique, le design system, les composants, les assets, la navigation, les états et les variantes responsive. Aucun agent d'implémentation ni audit final répété écran par écran ne démarre avant la validation globale du lot de design. Ensuite seulement, l'implémentation est réalisée par lots cohérents, puis les tests fonctionnels et l'audit visuel final sont exécutés sur l'ensemble du périmètre. Toute exception doit être justifiée dans le Goal.

Le Coordinateur ne peut annoncer simultanément « conception en cours », « conception terminée » et « prêt pour l'implémentation ». `conception` reste l'étape active tant que tous les livrables, critères, décisions, preuves et relectures du `design-gate` ne sont pas vérifiés. Une conception partielle est `rework` avec la prochaine tâche de conception exécutée immédiatement. La phase `implementation` et tout agent de code ne commencent qu'après `design-gate=verified`, `design-readiness=approved` et preuve d'audit indépendant. Un commit ou un test isolé ne vaut jamais approbation de la conception.
