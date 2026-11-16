#!/usr/bin/env bash
# Prueba de humo de los pasos de código del ejemplo (01-recoger y 02-centinela).
# No necesita agente ni API: crea una ejecución temporal con la muestra de
# export-muestra/, comprueba el resultado esperado y borra la ejecución.
# Uso: ./prueba-pasos.sh
set -uo pipefail
cd "$(dirname "$0")"
OBS="python3 herramientas/obs.py"
ENTRADA="export-muestra/errores.jsonl"
[ -f "$ENTRADA" ] || { echo "FALLO: falta $ENTRADA"; exit 1; }
RUN="$($OBS nuevo --entrada "$ENTRADA")"
trap 'rm -rf "$RUN"' EXIT
$OBS paso "$RUN" 01-recoger -- python3 pasos/01-recoger.py "$ENTRADA" \
  || { echo "FALLO: 01-recoger"; exit 1; }
$OBS paso "$RUN" 02-centinela -- python3 pasos/02-centinela.py \
  || { echo "FALLO: 02-centinela"; exit 1; }
python3 - "$RUN" <<'PY'
import json, sys
run = sys.argv[1]
errores = json.load(open(f"{run}/errores.json", encoding="utf-8"))
candidatos = json.load(open(f"{run}/candidatos.json", encoding="utf-8"))
descartados = json.load(open(f"{run}/descartados.json", encoding="utf-8"))

def comprobar(cond, msg):
    if not cond:
        print(f"FALLO: {msg}")
        sys.exit(1)

comprobar(len(errores) == 3,
          f"esperaba 3 errores únicos, hay {len(errores)}")
comprobar(len(candidatos) == 2,
          f"esperaba 2 candidatos, hay {len(candidatos)}")
comprobar(len(descartados) == 1,
          f"esperaba 1 descartado, hay {len(descartados)}")
comprobar(descartados[0].get("regla") == "bots-404",
          "el descartado debería ser bots-404, es "
          f"{descartados[0].get('regla')!r}")
print("HUMO OK: 3 errores únicos en 4 eventos · 2 candidatos · "
      "1 descartado (bots-404)")
PY
