#!/usr/bin/env bash
# fabrica.sh — orquesta la destilación de un vídeo.
# Uso: fabrica.sh entrada.vtt [id-ejecucion]
#
# La entrada es un archivo de subtítulos (VTT) ya obtenido. Los pasos de
# agente (02, 03, 04) no los ejecuta este script: cuando falta la salida de
# uno, el script se detiene con código 2 y dice qué archivo hay que producir.
# Al volver a correrlo con el mismo id, retoma donde se quedó.
set -eu

DIR="$(cd "$(dirname "$0")" && pwd)"

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "uso: fabrica.sh entrada.vtt [id-ejecucion]" >&2
  exit 2
fi
ENTRADA="$1"
if [ ! -f "$ENTRADA" ]; then
  echo "error: no existe la entrada: $ENTRADA" >&2
  exit 1
fi
command -v python3 >/dev/null 2>&1 || {
  echo "error: hace falta python3 en el PATH" >&2
  exit 1
}

if [ "$#" -eq 2 ]; then
  RUN_ID="$2"
else
  RUN_ID="$(date +%Y-%m-%d-%H%M)-$(head -c 2 /dev/urandom | od -An -tx1 | tr -d ' \n')"
fi
RUN_DIR="$DIR/runs/$RUN_ID"
mkdir -p "$RUN_DIR"

log() {
  echo "$(date +%H:%M:%S) $1" | tee -a "$RUN_DIR/eventos.log"
}

espera_agente() {
  # $1 = paso, $2 = archivo esperado, $3 = qué debe contener
  log "$1: falta $2 — produce ese archivo y vuelve a correr:"
  log "  $0 $ENTRADA $RUN_ID"
  log "  ($3)"
  exit 2
}

log "inicio: $ENTRADA -> $RUN_DIR"

# Paso 01 (código): normalizar la transcripción.
if [ ! -f "$RUN_DIR/transcripcion.jsonl" ]; then
  log "paso 01-normalizar: inicio"
  python3 "$DIR/pasos/01-normalizar.py" "$ENTRADA" \
    "$RUN_DIR/transcripcion.jsonl" "$RUN_DIR/transcripcion-normalizada.txt"
  log "paso 01-normalizar: ok"
fi

# Paso 02 (agente): extraer afirmaciones.
if [ ! -f "$RUN_DIR/afirmaciones.json" ]; then
  espera_agente "paso 02-extraer-afirmaciones" "afirmaciones.json" \
    "ver pasos/02-extraer-afirmaciones.md"
fi

# Paso 03 (agente): clasificar por evidencia y destilar.
if [ ! -f "$RUN_DIR/registro-evidencias.json" ]; then
  espera_agente "paso 03-clasificar-evidencia" "registro-evidencias.json" \
    "ver pasos/03-clasificar-evidencia.md"
fi
if [ ! -f "$RUN_DIR/DESTILADO.md" ]; then
  espera_agente "paso 03-clasificar-evidencia" "DESTILADO.md" \
    "el documento destilado acompaña al registro"
fi

# Paso 04 (agente revisor, distinto del que destiló).
if [ ! -f "$RUN_DIR/revision.json" ]; then
  espera_agente "paso 04-revisar" "revision.json" \
    "ver pasos/04-revisar.md"
fi

# Paso 05 (código): verificar las citas del registro.
log "paso 05-verificar-citas: inicio"
python3 "$DIR/pasos/05-verificar-citas.py" \
  "$RUN_DIR/registro-evidencias.json" "$RUN_DIR/transcripcion.jsonl"
log "paso 05-verificar-citas: ok"

# Paso 06 (código): empaquetar e informe.
log "paso 06-empaquetar: inicio"
python3 "$DIR/pasos/06-empaquetar.py" "$RUN_DIR"
log "paso 06-empaquetar: ok"

echo "ejecución completa: $RUN_DIR"
