#!/usr/bin/env bash
# 06 tests (código): tests + linter en cada rama de arreglo. Si algo falla, la salida vuelve a 05 como devuelto.md.
# La última línea es el motivo que registra obs.py: nombra las ramas en rojo, no solo que las hay.
set -uo pipefail
REPO="${REPO:-../api}"
arreglos="${FABRICA_RUN:?falta FABRICA_RUN}/arreglos.json"
[ -f "$arreglos" ] || { echo "falta arreglos.json: 05 no dejó ramas que probar"; exit 1; }
python3 -c 'import json,sys; sys.exit(0 if json.load(open(sys.argv[1])) else 1)' "$arreglos" \
  || { echo "arreglos.json está vacío: 05 no dejó ramas que probar"; exit 1; }
fallo=0
rojas=""
for rama in $(python3 -c "import json,os; print(' '.join(a['rama'] for a in json.load(open(os.environ['FABRICA_RUN']+'/arreglos.json'))))"); do
  git -C "$REPO" checkout -q "$rama" || { echo "$rama: no existe la rama"; fallo=1; rojas="$rojas $rama"; continue; }
  (cd "$REPO" && npm test --silent && npm run lint --silent) || { echo "$rama: tests o linter en rojo"; fallo=1; rojas="$rojas $rama"; }
done
git -C "$REPO" checkout -q main
[ $fallo -eq 0 ] && echo "todas las ramas en verde" || { echo "hay ramas en rojo:${rojas} — arréglalas"; exit 1; }
