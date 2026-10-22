# Contrat de preuve des connecteurs externes

Le mode réel ne peut pas être déduit d’une autorisation, d’un texte fourni par
un agent ou d’un manifeste local isolé. Le connecteur doit avoir exécuté une
lecture ou une mutation autorisée, puis relu la ressource distante.

Le manifeste `CONNECTOR_EVIDENCE_FILE` contient exactement quatre entrées
`github`, `trello`, `browser` et `agents`. Chaque entrée en mode `real` doit
contenir `evidence_id`, `checked_at` avec fuseau, `source_sha` complet,
`resource_ref`, `read_back: true` et une méthode parmi
`connector-readback`, `browser-readback` ou `agent-runtime`.

Le validateur refuse les valeurs factices, les preuves de plus de dix minutes,
les SHA incomplets, les entrées sans relecture et tout champ dont le nom révèle
un secret. Les secrets restent en mémoire dans le connecteur et ne figurent ni
dans le manifeste, ni dans les logs, ni dans les commentaires.

Le préflight local vérifie la structure et la fraîcheur du contrat. Il ne
prétend pas exécuter un connecteur qui n’est pas exposé dans la session. La
preuve d’exécution doit être produite par l’intégration réelle, puis relue par
le Coordinateur. Sans cette preuve, le résultat reste `not-executed` ou
`unknown`, jamais `pass`.
