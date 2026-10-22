# Politique de fraîcheur des builds et déploiements

Tout rebuild doit utiliser le dernier commit réellement présent sur la branche cible.

Avant un build, le coordinateur doit vérifier le checkout, actualiser les références distantes, sélectionner explicitement `dev` ou `main`, puis confirmer que `HEAD` est exactement égal à `origin/dev` ou `origin/main`. Un ancien checkout local, une image `latest` non vérifiée ou un conteneur existant ne sont jamais acceptés.

L'image doit être étiquetée avec le SHA source et le conteneur doit exposer ce même SHA. Une vérification fonctionnelle est obligatoire après le rebuild. Toute divergence suspend le déploiement.

Le rapport doit conserver la branche, le SHA source, le tag d'image, le SHA du conteneur, le résultat fonctionnel et les caches invalidés. Le rebuild, le redémarrage et la vérification constituent une seule étape consolidée.
