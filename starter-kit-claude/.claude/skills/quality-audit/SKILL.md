---
name: quality-audit
description: Audite indépendamment critères, tests, documentation et régressions avant une décision de livraison.
---

# Skill quality-audit

## Objectif

Vérifier indépendamment que la livraison satisfait le besoin sans régression connue.

## Quand l'utiliser

Pour toute livraison. L'intensité des contrôles dépend de la matrice de risque.

## Entrées requises

Work item, critères, diff, preuves de l'implémenteur, profil projet, résultats de tests et rapport sécurité lorsque requis.

## Procédure

1. Construire une matrice critère, preuve, résultat et limite.
2. Relire le diff en recherchant les écarts de périmètre et les régressions.
3. Rejouer les contrôles pertinents ou vérifier leurs résultats observables.
4. Vérifier documentation, messages d erreur, comportements négatifs et compatibilité nécessaire.
5. Vérifier que les documents `docs/` concernés reflètent le code, les contrats, les risques et le périmètre. Signaler tout écart comme bloquant.
6. Distinguer explicitement le vérifié, le non vérifié et l'inconnu.

## Audit visuel et médias

Pour tout périmètre frontend, vérifier la direction artistique, la hiérarchie, la singularité, le design system, les états, le responsive, les animations, `prefers-reduced-motion`, le clavier, les contrastes, la performance et les captures réellement observées. Contrôler chaque média dans `docs/design/media-inventory.md` : source, auteur, licence, attribution, retouches et usage. Une interface générique, un placeholder non déclaré ou une image sans preuve de licence est une non-conformité.

## Contrôles

L'Auditeur ne s'auto-approuve pas et ne remplace pas une preuve par une impression. Une validation visuelle nécessite un viewport ou un environnement réellement contrôlable.

## Sortie

`accepted`, `rework` ou `blocked`, avec matrice de preuve, non-conformités, risques résiduels et recommandation.

## Mesures

Taux d'acceptation au premier passage, défauts après livraison, critères sans preuve et temps de revue.

## Arrêt

Retourner `rework` et produire ou déléguer la preuve manquante si elle peut encore être obtenue dans le périmètre autorisé. Réserver `blocked` au cas où une dépendance externe ou une décision humaine indispensable empêche réellement toute obtention de preuve après alternatives vérifiées.
