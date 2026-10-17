# Politique de génération et de sélection des images

Cette politique s'applique à toute photo, illustration, texture, icône, vidéo, visuel généré ou ressource externe intégrée au produit.

## Routage obligatoire

Le Coordinateur active `image-generation` pour toute demande de création, génération, sélection, retouche, remplacement ou audit d'un média. Pour une interface, `frontend`, `image-generation`, `qa` et `auditeur` sont requis lorsque le média influence le rendu ou le parcours. Le Coordinateur ne remplace pas l'agent image.

## Qualité visuelle

- Une demande de photo doit viser un rendu photoréaliste, naturel et proche du réel, sans aspect artificiel ou générique.
- Chaque image respecte la direction artistique, la palette, la lumière, le niveau de contraste, l'époque, le contexte culturel et le ton du projet.
- Le brief définit le sujet, le point focal, le cadrage, le ratio, la profondeur, la lumière, les éléments à exclure et les variantes desktop/mobile.
- L'agent contrôle les mains, visages, yeux, dents, cheveux, textes, logos, perspective, ombres, répétitions, objets impossibles, artefacts de compression et incohérences d'échelle.
- Aucune image ne doit contenir un texte important, une marque ou un logo inventé sans validation explicite ; le texte d'interface reste dans le code.

## Provenance, sécurité et accessibilité

- Toute ressource est inscrite dans `docs/design/media-inventory.md` avec source, auteur ou outil, date, licence, attribution, brief, retouches, fichier et usage.
- Une image générée ne constitue jamais la preuve d'un événement, d'un témoignage, d'une personne réelle ou d'un résultat utilisateur.
- Ne pas imiter une personne identifiable, produire de contenu trompeur ou supprimer un filigrane.
- Prévoir un texte alternatif pertinent, une variante sans image si le contenu est essentiel, un contraste suffisant et un comportement adapté au mode sombre, au zoom et aux petits écrans.
- Optimiser le poids, le format et le chargement sans dégrader le rendu ; utiliser un format moderne avec fallback si nécessaire.

## Validation

Avant livraison, l'agent fournit le brief, la provenance, les contrôles d'artefacts, les captures ou rendus observés, les variantes responsive et les écarts restants. QA vérifie l'intégration réelle et l'Auditeur relit indépendamment. Sans ces preuves, le média reste `rework`.
