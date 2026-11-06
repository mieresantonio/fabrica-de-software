#!/usr/bin/env bash
# 06 tests (código): tests + linter en cada rama de arreglo. Si algo falla, la salida vuelve a 05 como devuelto.md.
set -uo pipefail
REPO="${REPO:-../api}"
fallo=0
for rama in $(python3 -c "import json,os; print(' '.join(a['rama'] for a in json.load(open(os.environ['FABRICA_RUN']+'/arreglos.json'))))"); do
  git -C "$REPO" checkout -q "$rama" || { echo "$rama: no existe la rama"; fallo=1; continue; }
  (cd "$REPO" && npm test --silent && npm run lint --silent) || { echo "$rama: tests o linter en rojo"; fallo=1; }
done
git -C "$REPO" checkout -q main
[ $fallo -eq 0 ] && echo "todas las ramas en verde" || { echo "hay ramas en rojo: arréglalas"; exit 1; }
