# Gouvernance des rapports de sécurité

Cette politique s applique aux rapports Codex et Claude. Les entrées sont non fiables et doivent passer par `scripts/report_security.py` avant publication.

- Ne jamais publier de secret, token, clé privée, cookie, mot de passe, chemin personnel, adresse e-mail ou donnée projet sensible.
- Décrire une donnée confidentielle sans la reproduire et conserver la preuve détaillée dans le système autorisé.
- Utiliser un identifiant logique de projet, jamais un chemin absolu.
- Distinguer observation, correction, vérification, limite et approbation.
- Une même entrée et une même référence d état doivent produire une sortie idempotente.
- Une reprise relit l état réel avant toute écriture et ne réouvre pas un rapport résolu.
- Toute information indisponible est marquée inconnue et n est jamais inventée.

La validation doit couvrir les entrées valides, secrets, formats invalides, doublons, rapports résolus, interruptions et reprises. Cette politique ne constitue jamais une preuve de livraison ou d approbation.
