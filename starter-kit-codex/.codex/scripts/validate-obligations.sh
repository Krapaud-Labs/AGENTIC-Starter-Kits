#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
mode="${1:---if-present}"

active=""
while IFS= read -r brief; do
  if grep -Fq '| Statut | in-progress |' "$brief"; then
    if [ -n "$active" ]; then
      echo "ECHEC OBLIGATIONS: plusieurs work items actifs"
      exit 1
    fi
    active="$(dirname "$brief")"
  fi
done < <(find "$config/work-items" -mindepth 2 -maxdepth 2 -type f -name brief.md 2>/dev/null | sort)

if [ -z "$active" ]; then
  if [ "$mode" = "--require-active" ]; then
    echo "ECHEC OBLIGATIONS: aucun work item actif"
    exit 1
  fi
  echo "Validation obligations ignorée: aucun work item actif"
  exit 0
fi

register="$active/obligations.tsv"
[ -f "$register" ] || { echo "ECHEC OBLIGATIONS: registre absent: $register"; exit 1; }

required="intake-gate design-gate scope-gate validation-gate documentation-gate integration-gate audit-gate delivery-gate"
seen=" "
fail=0
line_number=0
while IFS=$'\t' read -r gate owner trigger status evidence next_check extra; do
  line_number=$((line_number + 1))
  [ "$line_number" -eq 1 ] && continue
  [ -n "$gate" ] || continue
  case " $required " in *" $gate "*) ;; *) echo "ECHEC OBLIGATIONS: porte inconnue $gate"; fail=1; continue ;; esac
  case "$seen" in *" $gate "*) echo "ECHEC OBLIGATIONS: porte dupliquée $gate"; fail=1 ;; esac
  seen="$seen$gate "
  [ -n "$owner" ] || { echo "ECHEC OBLIGATIONS: responsable absent pour $gate"; fail=1; }
  [ -n "$trigger" ] || { echo "ECHEC OBLIGATIONS: déclencheur absent pour $gate"; fail=1; }
  [ -n "$next_check" ] || { echo "ECHEC OBLIGATIONS: prochaine vérification absente pour $gate"; fail=1; }
  case "$status" in
    verified|not-applicable)
      if [ -z "$evidence" ] || [ "$evidence" = "not-collected" ]; then
        echo "ECHEC OBLIGATIONS: preuve absente pour $gate ($status)"; fail=1
      fi
      ;;
    pending|running|needs-review|blocked)
      echo "ECHEC OBLIGATIONS: $gate reste $status"
      fail=1
      ;;
    *) echo "ECHEC OBLIGATIONS: statut invalide pour $gate: $status"; fail=1 ;;
  esac
done < "$register"

for gate in $required; do
  case "$seen" in *" $gate "*) ;; *) echo "ECHEC OBLIGATIONS: porte manquante $gate"; fail=1 ;; esac
done

[ "$fail" -eq 0 ] || exit 1
echo "Validation obligations OK: $(basename "$active")"
