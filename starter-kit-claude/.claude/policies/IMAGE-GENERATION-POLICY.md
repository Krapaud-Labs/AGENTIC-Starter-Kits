# Politique de génération et de sélection des images

Cette politique s'applique à toute photo, illustration, texture, icône, vidéo, visuel généré ou ressource externe intégrée au produit.

## Routage obligatoire

Le Coordinateur active `image-generation` pour toute demande de création, génération, sélection, retouche, remplacement ou audit d'un média. Pour une interface, `frontend`, `image-generation`, `qa` et `auditeur` sont requis lorsque le média influence le rendu ou le parcours.

## Règles

- Une demande de photo vise un rendu photoréaliste, naturel, premium et proche du réel.
- Chaque image respecte le thème, la direction artistique, la palette, la lumière, le contexte culturel et le ton du projet.
- Le brief précise sujet, point focal, cadrage, ratio, lumière, éléments exclus et variantes desktop/mobile.
- Contrôler mains, visages, yeux, dents, cheveux, textes, logos, perspective, ombres, répétitions, objets impossibles, artefacts et échelle.
- Ne jamais présenter une image générée comme la preuve d'un événement, témoignage, personne réelle ou résultat utilisateur.
- Ne pas imiter une personne identifiable, inventer un logo officiel ou supprimer un filigrane.
- Documenter source, outil, auteur, date, licence, attribution, brief, retouches, fichier et usage dans `docs/design/media-inventory.md`.
- Prévoir texte alternatif, alternative si l'image est essentielle, contraste, mode sombre, zoom, responsive, poids maîtrisé et format moderne avec fallback.

Sans brief, provenance, contrôle des artefacts et preuve d'intégration réelle, le média reste `rework`.
