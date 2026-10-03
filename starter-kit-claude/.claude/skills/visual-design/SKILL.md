---
name: visual-design
description: Direction artistique frontend premium, motion design accessible et gestion vérifiable des médias.
---

# Skill visual-design

## Objectif

Concevoir une expérience frontend comme un travail de direction artistique, puis la traduire en interface maintenable. La qualité attendue est premium, singulière, cohérente et adaptée au produit. Une interface propre mais générique, prévisible ou reconnaissable comme une sortie automatique est insuffisante.

## Quand l’utiliser

Pour toute création, refonte ou correction d'interface, de composant, de parcours visuel ou de média frontend.

Pour les menus et navigations, effectuer une revue item par item contre le système de composants et l’élément voisin de référence. Contrôler la parité de structure, dimensions, alignement, espacement, états interactifs, icônes, libellés, focus clavier et responsive. Toute rupture non intentionnelle doit être corrigée avant la validation.

## Entrées requises

Cahier des charges accepté, dossier de conception, profil technologique, contraintes de marque, accessibilité et performance.

## Procédure

1. Lire le brief, les parcours et les contraintes.
2. Définir ou mettre à jour la direction artistique.
3. Concevoir le système visuel et les états.
4. Implémenter par petits changements cohérents.
5. Tester, capturer et faire auditer le rendu.

Une phrase indiquant qu’un composant a été corrigé ne constitue pas une preuve. La preuve doit provenir du rendu réellement observé après correction, avec viewport, parcours, interaction testée et écart résiduel explicite.

## Direction artistique

Avant de coder, produire ou mettre à jour `docs/design/visual-direction.md` avec l'intention émotionnelle, les références et anti-références, la palette sémantique, les typographies, le rythme spatial, les règles de composition, le langage des composants, les états, les transitions, le responsive et les principes de traitement des médias. Relier chaque décision aux utilisateurs et au produit.

Ne jamais empiler des effets pour faire premium. Chaque choix doit servir la hiérarchie, la compréhension, la confiance ou la personnalité de la marque.

## Interface et motion design

- créer un design system réutilisable avant de multiplier les écrans ;
- couvrir loading, vide, erreur, succès, focus, désactivé et tactile ;
- utiliser une hiérarchie visuelle forte, des compositions singulières et des détails de finition cohérents ;
- ajouter des animations utiles pour les états, feedbacks et transitions ;
- respecter `prefers-reduced-motion`, les performances et les usages clavier ;
- ne pas appliquer automatiquement gradients, glassmorphism, cartes, blobs ou néon ;
- vérifier petits écrans, grands écrans, lecteur d'écran et contraste.

## Images, photos et médias

Priorité : ressource fournie ou créée spécifiquement, image réaliste générée si autorisée, image libre de droit avec licence vérifiée, puis placeholder explicitement marqué. Pour toute ressource externe, documenter dans `docs/design/media-inventory.md` l'URL, l'auteur, la date, la licence, l'attribution, le fichier, les retouches et l'usage. Ne jamais retirer un filigrane, scraper ou prétendre qu'une licence est libre sans preuve.

Pour une image générée, documenter le brief visuel, le réalisme recherché, les retouches et les artefacts contrôlés. Éviter mains déformées, textes illisibles, logos inventés et faux témoignages. Toute retouche doit rester compatible avec la licence et ne pas tromper l'utilisateur.

Ne pas hésiter à générer une image lorsque le produit a besoin d'un visuel absent, mais rechercher un résultat proche du réel, premium et spécifique au contexte plutôt qu'une illustration générique. Définir avant génération le sujet, le point focal, la lumière, la palette, le cadrage, le ratio, les variantes mobile et desktop, le niveau de réalisme et les éléments à exclure. Après génération, contrôler les artefacts, le recadrage, la lisibilité, la cohérence de marque, le poids, la provenance et l'usage prévu avant intégration.

## Contrôles

Aucune ressource sans provenance, aucune animation sans stratégie de réduction du mouvement et aucune validation visuelle non vérifiée.

## Cible Framer-like

Pour les expériences frontend qui le permettent, viser un rendu Framer-like à 99 % sur la perception visuelle, sans copier une marque ou un site précis. Évaluer la cible sur la composition, la hiérarchie, le rythme, la typographie, la profondeur, la lumière, les textures, les transitions, les interactions, les états, le responsive et les micro-détails. Réaliser une comparaison réelle dans le navigateur aux viewports prévus, consigner les écarts observés et corriger les écarts majeurs avant livraison. La cible ne permet jamais de sacrifier accessibilité, performance, contenu réel, provenance ou maintenabilité.

## Validation obligatoire

Tester lint, tests, accessibilité, responsive, erreurs, performance et mouvement réduit. Fournir des captures des parcours importants. Faire relire le rendu par l'auditeur et inscrire chaque défaut dans `docs/quality/quality-journal.md`. Ne jamais pousser sans `verify-before-push`.

## Sortie

Livrables visuels, code, tests et preuves reproductibles.

## Mesures

Défauts visuels trouvés, taux de tests verts, performance, accessibilité et réutilisation des composants.

## Arrêt

Escalader si le brief, la licence, le contrat ou la capacité technique est ambiguë.

## Livrables

Direction artistique, inventaire médias, design system, composants, écrans, animations, tests, captures, résultats et risques résiduels.
