#!/usr/bin/env bash
# prueba-pasos.sh — prueba de humo de fabrica-videos.
#
# Crea una ejecución temporal con el fixture (6 cues reales del vídeo de
# muestra), corre los pasos de código (01 y 05) y comprueba los resultados
# esperados. Borra la ejecución al terminar. No necesita agente, red ni API.
set -eu

DIR="$(cd "$(dirname "$0")" && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

command -v python3 >/dev/null 2>&1 || { echo "falta python3"; exit 1; }

# Paso 01: normalizar el fixture (6 cues, duración 27.88 s).
SALIDA="$TMP/normalizar.txt"
python3 "$DIR/pasos/01-normalizar.py" "$DIR/fixtures/transcripcion-muestra.vtt" \
  "$TMP/transcripcion.jsonl" "$TMP/transcripcion.txt" > "$SALIDA"
grep -q "segmentos: 6, duracion: 27.88 s" "$SALIDA" || {
  echo "01: recuento inesperado"; cat "$SALIDA"; exit 1
}
NLINEAS="$(wc -l < "$TMP/transcripcion.jsonl" | tr -d ' ')"
[ "$NLINEAS" = "6" ] || { echo "01: el JSONL no tiene 6 líneas"; exit 1; }
head -1 "$TMP/transcripcion.txt" | grep -q "^\[00:00:00\]" || {
  echo "01: la primera marca no es [00:00:00]"; exit 1
}

# Paso 05: el registro bueno pasa (2 afirmaciones, 0 fallos).
SALIDA_BUENO="$TMP/bueno.txt"
python3 "$DIR/pasos/05-verificar-citas.py" "$DIR/fixtures/registro-bueno.json" \
  "$TMP/transcripcion.jsonl" > "$SALIDA_BUENO" || {
  echo "05: el registro bueno no pasó"; cat "$SALIDA_BUENO"; exit 1
}
grep -q "(2 verificadas, 0 fallos)" "$SALIDA_BUENO" || {
  echo "05: recuento inesperado en el registro bueno"; cat "$SALIDA_BUENO"; exit 1
}

# Paso 05: el registro roto debe fallar (3 afirmaciones, 3 fallos).
# Si el verificador lo acepta, esta prueba es vacua: no demuestra nada.
SALIDA_ROTO="$TMP/roto.txt"
if python3 "$DIR/pasos/05-verificar-citas.py" "$DIR/fixtures/registro-roto.json" \
  "$TMP/transcripcion.jsonl" > "$SALIDA_ROTO" 2>&1; then
  echo "PRUEBA VACUA: el verificador aceptó el registro roto"
  exit 1
fi
grep -q "(3 verificadas, 3 fallos)" "$SALIDA_ROTO" || {
  echo "05: el registro roto no falló como se esperaba"; cat "$SALIDA_ROTO"; exit 1
}

echo "prueba-pasos: OK (01: 6 segmentos; 05: bueno pasa, roto falla con 3 fallos)"
