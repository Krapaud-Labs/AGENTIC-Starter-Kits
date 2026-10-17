# Validation avant push

## Règle absolue

Avant chaque `git push` vers GitHub, l'agent responsable exécute `bash .claude/scripts/verify-before-push.sh`. Un échec interdit le push. `git push --no-verify` est interdit.

## Contrôles exigés

Le contrôle exécute le preflight, le socle cybersécurité, lint, les tests déclarés, le build déclaré et la vérification du diff. Lorsqu'un projet active `frontend` ou `backend`, les commandes `commands.lint` et `commands.test` sont obligatoires dans le profil technique.

## Contrôle après ouverture ou modification

Dès qu'un agent ouvre un fichier source, de configuration, de test ou de documentation destiné à être modifié, il détecte le linter ou formateur réellement configuré pour son type de fichier et l'exécute sur le périmètre concerné. Toute erreur de lint est corrigée immédiatement, puis le contrôle est relancé jusqu'à réussite. Si l'outil n'est pas installé, l'agent vérifie d'abord les outils déjà disponibles, installe provisoirement l'outil gratuit déclaré par le projet si nécessaire, puis journalise la commande et sa preuve. S'il n'existe aucun linter applicable, il enregistre `lint_status: not-applicable` avec le type de fichier et la raison ; il ne prétend jamais avoir validé un lint absent.

Une modification ne peut pas être considérée comme terminée, poussée ou attribuée à un agent spécialisé sans preuve `lint_status: passed` ou `not-applicable` justifiée dans le work item et le rapport de l'agent. Le Coordinateur bloque toute transition si cette preuve manque.

Il vérifie aussi le périmètre de la branche depuis la branche d'intégration. Le diff est comparé au résultat attendu, au hors périmètre et aux fichiers autorisés du work item. Toute modification non rattachée au work item bloque le push de livraison, même si lint et tests passent. Pour corriger une branche mélangée, créer une branche propre depuis `dev` ou `develop`, reporter uniquement les commits liés au work item, puis relancer toute la validation.

## Responsabilités

L'agent qui modifie le code exécute les contrôles et fournit les résultats. L'Auditeur vérifie les preuves avant fusion lorsque la matrice de risque l'exige. Aucun agent ne présente un contrôle non exécuté comme réussi.

## Hook local

`init-project.sh` installe le hook `pre-push` quand Git est disponible. Le hook relance la validation et bloque l'envoi local en cas d'échec.
