#!/usr/bin/env python3
"""02 centinela (código): descarta el ruido conocido según cerebro/reglas-ruido.json, salvo picos."""
import json, os, subprocess, sys

run = os.environ["FABRICA_RUN"]
cfg = json.load(open("cerebro/reglas-ruido.json", encoding="utf-8"))
errores = json.load(open(f"{run}/errores.json", encoding="utf-8"))

def nota(texto):
    subprocess.run([sys.executable, "herramientas/obs.py", "nota", run, "02-centinela", texto])

def regla_que_aplica(e):
    for r in cfg["reglas"]:
        if r["si_mensaje_contiene"] not in e["mensaje"]:
            continue
        if "y_ruta_empieza_por" in r and not any(e["ruta"].startswith(p) for p in r["y_ruta_empieza_por"]):
            continue
        if "y_origen" in r and e["origen"] != r["y_origen"]:
            continue
        return r
    return None

candidatos, descartados = [], []
for e in errores:
    r = regla_que_aplica(e)
    if r and e["veces"] > cfg["umbral_pico"] * r["media_diaria"]:
        nota(f"{e['firma']}: coincide con «{r['id']}» pero es un pico ({e['veces']} vs media {r['media_diaria']}), pasa a investigar")
        candidatos.append(e)
    elif r:
        descartados.append({**e, "regla": r["id"]})
    else:
        candidatos.append(e)

json.dump(candidatos, open(f"{run}/candidatos.json", "w", encoding="utf-8"), ensure_ascii=False, indent=2)
json.dump(descartados, open(f"{run}/descartados.json", "w", encoding="utf-8"), ensure_ascii=False, indent=2)
subprocess.run([sys.executable, "herramientas/obs.py", "metrica", run, "02-centinela", "descartados", str(len(descartados))])
print(f"{len(candidatos)} candidatos · {len(descartados)} descartados como ruido")
