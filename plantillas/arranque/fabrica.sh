#!/usr/bin/env bash
# Orquestador de la fábrica. Uso: ./fabrica.sh <entrada>
# Encadena los pasos de PLANO.md. Cada paso pasa por obs.py, que guarda log, tiempo y resultado.
set -uo pipefail
cd "$(dirname "$0")"

# Los pasos de agente se lanzan con pasos/agente.sh (permisos mínimos, coste, guardia). Si tu agente
# no es Claude Code, adapta su bloque «LLAMADA».
export REPO="${REPO:-$(pwd)}"   # el proyecto sobre el que trabaja la fábrica, en ruta absoluta
OBS="python3 herramientas/obs.py"
MAX_REINTENTOS=2

ENTRADA="${1:?Uso: ./fabrica.sh <entrada>}"
RUN="$($OBS nuevo --entrada "$ENTRADA")"
export FABRICA_RUN="$RUN"
echo "▶ run: $RUN"

parar() { $OBS fin "$RUN" fallo --motivo "$1"; $OBS ver "$RUN"; exit 1; }

# Paso de código
codigo() { local nombre="$1"; shift; $OBS paso "$RUN" "$nombre" -- "$@" || parar "falló $nombre"; }

# Paso de agente: las instrucciones están en pasos/<nombre>.md; modelo opcional (p. ej. haiku para lo sencillo)
agente() { local nombre="$1" modelo="${2:-}"; $OBS paso "$RUN" "$nombre" -- bash pasos/agente.sh "$nombre" "$modelo" || parar "falló $nombre"; }

# Loop: produce con <paso>, comprueba con <comprobacion>; si falla, vuelve a <paso> con el motivo
loop() {
  local paso="$1" comprobacion="$2" i=1
  while true; do
    $OBS paso "$RUN" "$paso" --intento "$i" -- bash pasos/agente.sh "$paso" "" "Intento $i: si existe $RUN/devuelto.md, arregla exactamente lo que dice." \
      || parar "falló $paso"
    if $OBS paso "$RUN" "$comprobacion" --intento "$i" -- "${@:3}" > "$RUN/devuelto.md" 2>&1; then
      rm -f "$RUN/devuelto.md"; return 0
    fi
    (( i > MAX_REINTENTOS )) && parar "$comprobacion sigue fallando tras $i intentos"
    i=$((i + 1))
  done
}

# ── Los pasos de tu PLANO.md ──────────────────────────────
# codigo  recoger        python3 pasos/01-recoger.py
# agente  02-plan
# loop    03-implementar  04-tests  sh pasos/04-tests.sh
# agente  05-revisar
# ─────────────────────────────────────────────────────────

# Informe final, hecho por un agente que no ha producido nada en esta ejecución
agente informe
$OBS fin "$RUN" "$(grep -q 'espera-ok' "$RUN/eventos.jsonl" && echo espera-ok || echo ok)"
$OBS ver "$RUN"
