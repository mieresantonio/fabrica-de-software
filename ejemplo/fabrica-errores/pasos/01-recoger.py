#!/usr/bin/env python3
"""01 recoger (código): agrupa los eventos de errores.jsonl por firma (mensaje + primera línea del stack)."""
import hashlib, json, os, subprocess, sys
from collections import OrderedDict

run, entrada = os.environ["FABRICA_RUN"], sys.argv[1]
grupos = OrderedDict()
with open(entrada, encoding="utf-8") as f:
    for n, linea in enumerate(f, 1):
        if not linea.strip():
            continue
        try:
            ev = json.loads(linea)
        except json.JSONDecodeError:
            sys.exit(f"línea {n} de {entrada} no es JSON válido")
        pila = (ev.get("stack") or "").splitlines()
        clave = ev.get("mensaje", "") + "|" + (pila[1].strip() if len(pila) > 1 else "")
        firma = hashlib.sha1(clave.encode()).hexdigest()[:4]
        g = grupos.setdefault(firma, {"firma": firma, "mensaje": ev.get("mensaje", ""), "ruta": ev.get("ruta", ""),
                                      "origen": ev.get("origen", ""), "stack": ev.get("stack", ""),
                                      "veces": 0, "primera": ev.get("t"), "ultima": ev.get("t")})
        g["veces"] += 1
        g["ultima"] = ev.get("t") or g["ultima"]

json.dump(list(grupos.values()), open(f"{run}/errores.json", "w", encoding="utf-8"), ensure_ascii=False, indent=2)
subprocess.run([sys.executable, "herramientas/obs.py", "metrica", run, "01-recoger", "errores_unicos", str(len(grupos))])
print(f"{len(grupos)} errores únicos en {sum(g['veces'] for g in grupos.values())} eventos")
