# Politique de documentation canonique

Ne pas créer un nouveau fichier pour chaque reprise, agent, audit partiel ou correction mineure. Rechercher le document canonique du sujet et le mettre à jour avant de créer quoi que ce soit.

Séparer les références canoniques, décisions, preuves finales et archives. Les rapports d agents, captures intermédiaires, traces et historiques vont dans les archives ou preuves dédiées et ne deviennent pas automatiquement des documents de référence.

Avant une initialisation ou une carte importante, exécuter `bash .claude/scripts/audit-documentation-structure.sh`. Une collision de numérotation ou un artefact doit être traité dans une consolidation, pas contourner en créant d autres fichiers.

Consolider les audits en une synthèse unique qui pointe vers les preuves existantes. Déplacer les anciennes versions vers `archive/` ou les marquer `superseded` sans supprimer une preuve nécessaire.
