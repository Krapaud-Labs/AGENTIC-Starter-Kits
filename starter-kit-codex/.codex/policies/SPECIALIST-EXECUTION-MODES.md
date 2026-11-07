# Contrat commun des agents spécialistes

Le Coordinateur attribue à chaque agent un `work_item_mode` parmi `quick-fix`, `feature` et `audit`, un périmètre de fichiers, un livrable et une preuve attendue.

En mode `quick-fix`, l'agent traite uniquement la correction demandée et exécute les contrôles directement concernés. En mode `feature`, il livre la fonctionnalité complète puis contribue à une seule validation finale proportionnée. En mode `audit`, il exécute la revue demandée sur le périmètre défini.

Aucun agent ne déclenche de lui-même un audit exhaustif, navigateur, responsive, accessibilité, performance ou média pendant l'implémentation, sauf risque critique documenté ou demande explicite. Les audits lourds sont regroupés à la fin de la carte ou dans une carte d'audit dédiée.

Chaque rapport indique le mode, le périmètre, le SHA observé, les commandes réellement exécutées, les résultats et les limites. Un agent ne relit pas plusieurs fois le même état sans changement de code ou de preuve. Le Coordinateur ne remplace pas un spécialiste disponible et ne lance pas de spécialiste hors périmètre.
