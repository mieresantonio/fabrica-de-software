#!/usr/bin/env python3
"""Paso 06 - empaquetar: genera el informe de la ejecucion a partir del
registro de evidencias y la fuente, y comprueba que las salidas existen.

Uso:
    python3 06-empaquetar.py dir-ejecucion

Lee dir-ejecucion/registro-evidencias.json y dir-ejecucion/fuente.json,
comprueba que existen DESTILADO.md y transcripcion-normalizada.txt, y
escribe dir-ejecucion/informe.md. Solo libreria estandar.
"""
import json
import os
import sys

NECESARIOS = ("registro-evidencias.json", "fuente.json", "DESTILADO.md",
              "transcripcion-normalizada.txt")


def main(argv):
    if len(argv) != 2:
        print("uso: 06-empaquetar.py dir-ejecucion", file=sys.stderr)
        return 2
    d = argv[1]
    faltan = [n for n in NECESARIOS if not os.path.isfile(os.path.join(d, n))]
    if faltan:
        print("error: faltan salidas en %s: %s" % (d, ", ".join(faltan)),
              file=sys.stderr)
        return 1
    with open(os.path.join(d, "registro-evidencias.json"), encoding="utf-8") as f:
        registro = json.load(f)
    with open(os.path.join(d, "fuente.json"), encoding="utf-8") as f:
        fuente = json.load(f)
    afirmaciones = registro.get("afirmaciones", [])
    niveles = {}
    for af in afirmaciones:
        nivel = af.get("nivel", "?")
        niveles[nivel] = niveles.get(nivel, 0) + 1
    lineas = [
        "# Informe de destilacion",
        "",
        "Fuente: %s" % fuente.get("titulo", "?"),
        "Canal: %s" % fuente.get("canal", "?"),
        "URL: %s" % fuente.get("url", "?"),
        "Duracion: %s s" % fuente.get("duracion_s", "?"),
        "",
        "Afirmaciones: %d" % len(afirmaciones),
    ]
    for nivel in ("A", "B", "C", "X"):
        lineas.append("- Nivel %s: %d" % (nivel, niveles.get(nivel, 0)))
    lineas += [
        "",
        "Salidas: DESTILADO.md, registro-evidencias.json, "
        "transcripcion-normalizada.txt",
        "",
    ]
    with open(os.path.join(d, "informe.md"), "w", encoding="utf-8") as f:
        f.write("\n".join(lineas))
    print("informe escrito: %s (afirmaciones: %d)"
          % (os.path.join(d, "informe.md"), len(afirmaciones)))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
