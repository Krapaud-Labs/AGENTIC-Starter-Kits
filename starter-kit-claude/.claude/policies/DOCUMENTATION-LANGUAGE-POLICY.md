# Politique de langue documentaire et des commentaires de code

## Langue obligatoire

Toute la documentation technique du dépôt doit être rédigée en français clair et professionnel, sauf si le profil du projet déclare explicitement une autre langue. Cela s'applique aux README, documents d'architecture, documentations API, changelogs, notes de migration, runbooks, ADR, work items, rapports d'audit, notes de version, exemples et guides techniques destinés aux utilisateurs.

Le français est également la langue par défaut des commentaires de code, docstrings, TODO, FIXME, avis de dépréciation, descriptions de tests, explications de fixtures, commentaires de configuration, scripts et messages CI. Les identifiants techniques, commandes, noms d'API et extraits de logs conservent leur forme originale lorsque leur traduction les rendrait ambigus.

## Structure documentaire obligatoire

Chaque README suit, lorsque cela est pertinent, une structure prévisible : objectif, périmètre, prérequis, installation, configuration, utilisation, structure du projet, commandes, tests, dépannage, sécurité, contribution, versionnement et licence.

Chaque document substantiel indique un titre, un périmètre, un statut, une date de mise à jour, un responsable, les hypothèses, les faits vérifiés, les limites, les preuves de validation et les références utiles.

## Séparateurs de sections

Les fichiers source et scripts longs doivent utiliser des séparateurs de section cohérents en français. Utiliser systématiquement le style du projet, par exemple :

```text
# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------
```

Ne pas utiliser de séparateurs décoratifs, ambigus ou mélangeant les langues. Un séparateur doit décrire la section qui le suit.

## Qualité des commentaires

Les commentaires expliquent l’intention, les contraintes, la sécurité ou les compromis non évidents. Ne pas décrire une syntaxe évidente, conserver des commentaires périmés, répéter le code ou masquer un travail inachevé. Chaque TODO ou FIXME indique un responsable, une raison, une référence de work item et une condition claire de résolution.

## Règle de synchronisation

Après toute modification significative du code, de l’architecture, de la sécurité, des API, de la CI ou du déploiement, l’agent Documentation inspecte et met à jour les README, commentaires, exemples, changelog, ADR, work items et notes de version concernés. Le travail est incomplet tant que la documentation contredit l’implémentation.

## Validation

Avant un commit ou une Pull Request, l'agent Documentation doit vérifier la cohérence française, les titres, les liens, les exemples de code, les commandes, les séparateurs, les références obsolètes, les versions, les métadonnées TODO et la documentation générée. Le Coordinateur doit refuser toute documentation incomplète ou contradictoire.

Si le produit exige une autre langue, créer des documents localisés explicitement nommés selon le profil du projet. Ne jamais mélanger silencieusement plusieurs langues dans un même document technique.
