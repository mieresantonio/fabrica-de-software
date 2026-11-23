#!/usr/bin/env python3
"""Paso 05 - verificar citas: comprueba que cada afirmacion del registro de
evidencias cita un fragmento que existe en la transcripcion normalizada.

Uso:
    python3 05-verificar-citas.py registro.json transcripcion.jsonl

Comprueba por afirmacion:
  - id presente y unico; texto no vacio; nivel en {A, B, C, X};
  - cita con inicio_s < fin_s dentro de [0, duracion];
  - cita_texto (normalizado: minusculas, espacios colapsados) aparece en
    el texto de la transcripcion.
Sale 0 si todo pasa; 1 si hay algun fallo. Solo libreria estandar.
"""
import json
import sys

NIVELES = {"A", "B", "C", "X"}


def normalizar(texto):
    return " ".join(texto.lower().split())


def cargar_transcripcion(ruta):
    segmentos = []
    with open(ruta, encoding="utf-8") as f:
        for linea in f:
            linea = linea.strip()
            if linea:
                segmentos.append(json.loads(linea))
    texto = " ".join(s["texto"] for s in segmentos)
    duracion = max((s["fin"] for s in segmentos), default=0.0)
    return normalizar(texto), duracion


def main(argv):
    if len(argv) != 3:
        print("uso: 05-verificar-citas.py registro.json transcripcion.jsonl",
              file=sys.stderr)
        return 2
    try:
        with open(argv[1], encoding="utf-8") as f:
            registro = json.load(f)
    except FileNotFoundError:
        print("error: no existe el registro: %s" % argv[1], file=sys.stderr)
        return 1
    except json.JSONDecodeError as e:
        print("error: registro JSON invalido: %s" % e, file=sys.stderr)
        return 1
    try:
        texto, duracion = cargar_transcripcion(argv[2])
    except FileNotFoundError:
        print("error: no existe la transcripcion: %s" % argv[2], file=sys.stderr)
        return 1
    afirmaciones = registro.get("afirmaciones", [])
    vistos = set()
    fallos = 0
    for af in afirmaciones:
        problemas = []
        aid = af.get("id", "")
        if not aid:
            problemas.append("sin id")
        elif aid in vistos:
            problemas.append("id duplicado: %s" % aid)
        vistos.add(aid)
        if not (af.get("texto") or "").strip():
            problemas.append("texto vacio")
        nivel = af.get("nivel", "")
        if nivel not in NIVELES:
            problemas.append("nivel invalido: %r (debe ser A, B, C o X)" % nivel)
        cita = af.get("cita") or {}
        inicio = cita.get("inicio_s")
        fin = cita.get("fin_s")
        fragmento = cita.get("texto", "")
        if not isinstance(inicio, (int, float)) or not isinstance(fin, (int, float)):
            problemas.append("cita sin inicio_s/fin_s numericos")
        else:
            if not (0 <= inicio < fin):
                problemas.append("ventana invalida: inicio %s, fin %s" % (inicio, fin))
            if fin > duracion:
                problemas.append("fin %s supera la duracion %.2f s" % (fin, duracion))
        if not (fragmento or "").strip():
            problemas.append("cita sin texto")
        elif normalizar(fragmento) not in texto:
            problemas.append("fragmento no encontrado en la transcripcion: %r" % fragmento)
        if problemas:
            fallos += 1
            print("FALLO %s: %s" % (aid or "?", "; ".join(problemas)))
        else:
            print("OK %s" % aid)
    print("resultado: %s (%d verificadas, %d fallos)"
          % ("OK" if fallos == 0 else "FALLO", len(afirmaciones), fallos))
    return 0 if fallos == 0 else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
