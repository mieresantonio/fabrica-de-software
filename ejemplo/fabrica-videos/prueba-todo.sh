#!/usr/bin/env bash
# prueba-todo.sh — puerta de entrada de las pruebas de fabrica-videos.
# Invoca cada prueba con bash (no depende del bit +x) y sale 1 si alguna falla.
set -eu

DIR="$(cd "$(dirname "$0")" && pwd)"

bash "$DIR/prueba-pasos.sh"

echo "prueba-todo: OK"
