#!/usr/bin/env bash
# Corre las tres pruebas del ejemplo en orden —humo, completa y
# centinela— y sale 1 si alguna falla. Las tres se corren aunque una
# falle, para ver el estado completo de un vistazo.
# Uso: ./prueba-todo.sh
set -uo pipefail
cd "$(dirname "$0")"
fallo=0
for prueba in prueba-pasos.sh prueba-completa.sh prueba-centinela.sh; do
  echo "=== $prueba ==="
  bash "./$prueba" || fallo=1
done
if [ $fallo -eq 0 ]; then
  echo "TODO OK: humo + completa + centinela en verde"
else
  echo "FALLO: alguna prueba está en rojo (ver arriba)"
  exit 1
fi
