# Matrice de compatibilité et de release 2.0

Contrat vérifiable de la carte #924. Le contrôle exécutable est
`scripts/check-kit-compatibility.py`.

| Surface | Codex | Claude | macOS | Linux | Windows | Release 2.0 |
|---|---:|---:|---:|---:|---:|---:|
| Runtime et manifestes | oui | oui | oui | oui | oui | obligatoire |
| Outils partagés | oui | oui | oui | oui | Git Bash/WSL | obligatoire |
| Pause/reprise | oui | oui | oui | oui | Git Bash/WSL | obligatoire |
| Désinstallation simulée | oui | oui | oui | oui | oui | obligatoire |
| Désinstallation autorisée | oui | oui | oui | oui | oui | obligatoire |

Windows est supporté par Python et par les scripts `.sh` via Git Bash ou WSL.
PowerShell natif n’est pas annoncé comme supporté par ces scripts.

## Matrice de release

| Version | Contrat | Codex | Claude | OS | Statut |
|---|---|---|---|---|---|
| 2.0.x | runtime v2, outils partagés, désinstallation sûre | supporté | supporté | macOS/Linux/Windows | validé par le contrôle |

Une release est refusée si `VERSION` n’est pas SemVer 2.x, si un kit ou un outil
partagé manque, si un script n’est pas exécutable, ou si le désinstalleur manque.
