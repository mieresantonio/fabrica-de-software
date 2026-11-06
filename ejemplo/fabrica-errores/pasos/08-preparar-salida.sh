#!/usr/bin/env bash
# 08 preparar salida (código): sube las ramas OK y abre las PRs EN BORRADOR. El merge y los tickets esperan a la persona.
set -uo pipefail
REPO="${REPO:-../api}"; OBS="python3 herramientas/obs.py"
for f in "$FABRICA_RUN"/revision/*.json; do
  [ -e "$f" ] || continue
  firma=$(basename "$f" .json)
  grep -q '"veredicto": *"OK"' "$f" || continue
  rama="fabrica/$firma"
  git -C "$REPO" push -q -u origin "$rama" || { echo "no se pudo subir $rama"; exit 1; }
  url=$(cd "$REPO" && gh pr create --draft --base main --head "$rama" --label fabrica \
        --title "fix: error $firma (fábrica)" --body-file "$FABRICA_RUN/diagnostico/$firma.md")
  $OBS nota "$FABRICA_RUN" 08-preparar-salida "PR en borrador: $url · espera que la pruebes y la mergees" --tipo espera-ok
done
for t in "$FABRICA_RUN"/tickets/*.md; do
  [ -e "$t" ] && $OBS nota "$FABRICA_RUN" 08-preparar-salida "Ticket listo para crear: $t" --tipo espera-ok
done
echo "salida preparada"
