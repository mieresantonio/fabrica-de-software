#!/usr/bin/env bash
# Fábrica de errores de producción. Uso: ./fabrica.sh export/errores.jsonl
set -uo pipefail
cd "$(dirname "$0")"

export REPO="$(cd "${REPO:-../api}" && pwd)"   # el repo de la API, en ruta absoluta
OBS="python3 herramientas/obs.py"
MAX_REINTENTOS=2

ENTRADA="${1:?Uso: ./fabrica.sh export/errores.jsonl}"
RUN="$($OBS nuevo --entrada "$ENTRADA")"
export FABRICA_RUN="$RUN"
echo "▶ run: $RUN"

parar() { $OBS fin "$RUN" fallo --motivo "$1"; $OBS ver "$RUN"; exit 1; }
codigo() { local n="$1"; shift; $OBS paso "$RUN" "$n" -- "$@" || parar "falló $n"; }
agente() { local n="$1" m="${2:-}"; $OBS paso "$RUN" "$n" -- bash pasos/agente.sh "$n" "$m" || parar "falló $n"; }
hay()    { python3 -c "import json,sys; sys.exit(0 if any(c['decision']=='$1' for c in json.load(open('$RUN/clasificacion.json'))) else 1)"; }

# CEREBRO + CONSTRUCCIÓN
codigo 01-recoger   python3 pasos/01-recoger.py "$ENTRADA"
codigo 02-centinela python3 pasos/02-centinela.py
agente 03-investigar
agente 04-clasificar

# LOOP: arreglar → tests → revisar; cualquier fallo vuelve a 05 con el motivo en devuelto.md
if hay arreglo; then
  i=1
  while true; do
    $OBS paso "$RUN" 05-arreglar --intento "$i" -- bash pasos/agente.sh 05-arreglar "" "Intento $i: si existe $RUN/devuelto.md, arregla exactamente lo que dice." || parar "falló 05-arreglar"
    if $OBS paso "$RUN" 06-tests --intento "$i" -- bash pasos/06-tests.sh > "$RUN/devuelto.md" 2>&1 \
       && $OBS paso "$RUN" 07-revisar --intento "$i" -- bash pasos/agente.sh 07-revisar > "$RUN/devuelto.md" 2>&1; then
      rm -f "$RUN/devuelto.md"; break
    fi
    (( i > MAX_REINTENTOS )) && parar "el arreglo no pasa tests/revisión tras $i intentos (ver devuelto.md)"
    i=$((i + 1))
  done
fi

# DESPLIEGUE (PRs en borrador; el merge y los tickets esperan tu OK)
codigo 08-preparar-salida bash pasos/08-preparar-salida.sh
agente informe haiku
$OBS fin "$RUN" "$(grep -q '"espera-ok"' "$RUN/eventos.jsonl" && echo espera-ok || echo ok)"
$OBS ver "$RUN"
