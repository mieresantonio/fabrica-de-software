#!/usr/bin/env python3
"""Paso 01 - normalizar: VTT -> transcripcion normalizada (JSONL + texto).

Uso:
    python3 01-normalizar.py entrada.vtt salida.jsonl [salida.txt]

Cada cue del VTT produce un segmento {"inicio": s, "fin": s, "texto": "..."}.
Los cues de subtitulos automaticos se solapan en el tiempo; se emiten tal
cual, sin reordenar ni fusionar: el segmento conserva sus marcas reales.

El texto de salida (opcional) escribe un segmento por linea con su marca
[HH:MM:SS]. Solo libreria estandar.
"""
import json
import re
import sys

TS = re.compile(r"(\d+):(\d+):(\d+)\.(\d+)\s*-->\s*(\d+):(\d+):(\d+)\.(\d+)")
TAG = re.compile(r"<[^>]*>")


def a_segundos(h, m, s, ms):
    return int(h) * 3600 + int(m) * 60 + int(s) + int(ms) / 1000.0


def marca(seg):
    total = int(seg)
    return "[%02d:%02d:%02d]" % (total // 3600, (total % 3600) // 60, total % 60)


def leer_vtt(ruta):
    with open(ruta, encoding="utf-8") as f:
        lineas = f.read().splitlines()
    segmentos = []
    i = 0
    while i < len(lineas):
        linea = lineas[i].strip()
        m = TS.match(linea)
        if m:
            inicio = a_segundos(*m.groups()[:4])
            fin = a_segundos(*m.groups()[4:])
            texto = []
            i += 1
            while i < len(lineas) and lineas[i].strip():
                texto.append(lineas[i].strip())
                i += 1
            limpio = TAG.sub("", " ".join(texto))
            limpio = " ".join(limpio.split())
            if limpio:
                segmentos.append({"inicio": inicio, "fin": fin, "texto": limpio})
        else:
            i += 1
    return segmentos


def main(argv):
    if len(argv) < 3 or len(argv) > 4:
        print("uso: 01-normalizar.py entrada.vtt salida.jsonl [salida.txt]",
              file=sys.stderr)
        return 2
    entrada, salida_jsonl = argv[1], argv[2]
    try:
        segmentos = leer_vtt(entrada)
    except FileNotFoundError:
        print("error: no existe la entrada: %s" % entrada, file=sys.stderr)
        return 1
    if not segmentos:
        print("error: sin segmentos en %s (¿es un VTT con cues?)" % entrada,
              file=sys.stderr)
        return 1
    with open(salida_jsonl, "w", encoding="utf-8") as f:
        for seg in segmentos:
            f.write(json.dumps(seg, ensure_ascii=False) + "\n")
    duracion = max(s["fin"] for s in segmentos)
    if len(argv) == 4:
        with open(argv[3], "w", encoding="utf-8") as f:
            for seg in segmentos:
                f.write("%s %s\n" % (marca(seg["inicio"]), seg["texto"]))
    print("segmentos: %d, duracion: %.2f s" % (len(segmentos), duracion))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
