#!/usr/bin/env bash
# Suite de casos para el centinela (02-centinela.py + cerebro/reglas-ruido.json).
#
# Cada caso de fixtures/casos-ruido.json genera eventos sintéticos y los pasa
# por los pasos REALES 01-recoger y 02-centinela: un caso por regla que casa,
# un caso por regla que NO casa (mensaje parecido pero ruta u origen
# distintos) y los dos casos del pico (11x la media pasa a candidato, 10x
# exactos sigue siendo ruido: la comparación es `>` estricta).
#
# No-vacuidad: tras la pasada buena, la suite se sabotea a sí misma en una
# copia sombra (sin tocar el repo): umbral_pico 10 -> 9, y quitar
# y_ruta_empieza_por de bots-404. Cada sabotaje DEBE poner la suite en rojo;
# si alguno no lo hace, la suite es vacua y el script sale 1.
#
# Las ejecuciones temporales se borran al terminar.
# Uso: ./prueba-centinela.sh
set -uo pipefail
cd "$(dirname "$0")"
CASOS="fixtures/casos-ruido.json"
[ -f "$CASOS" ] || { echo "FALLO: falta $CASOS"; exit 1; }
command -v python3 >/dev/null || { echo "FALLO: falta python3"; exit 1; }

python3 - "$CASOS" <<'PY'
import json, shutil, subprocess, sys, tempfile
from pathlib import Path

casos = json.load(open(sys.argv[1], encoding="utf-8"))["casos"]
RAIZ = Path.cwd()
OBS = ["python3", "herramientas/obs.py"]


def correr_casos(raiz):
    """Corre todos los casos contra los pasos reales en `raiz`.
    Devuelve la lista de fallos (vacía = verde)."""
    tmp = Path(tempfile.mkdtemp(prefix="prueba-centinela-"))
    fallos = []
    try:
        for caso in casos:
            entrada = tmp / f"{caso['id']}.jsonl"
            evento = {"t": "2026-11-16T10:00:00", "mensaje": caso["mensaje"],
                      "ruta": caso["ruta"], "origen": caso["origen"],
                      "stack": caso["stack"]}
            entrada.write_text(
                "".join(json.dumps(evento, ensure_ascii=False) + "\n"
                        for _ in range(caso["veces"])), encoding="utf-8")
            run = subprocess.run([*OBS, "nuevo", "--entrada", str(entrada)],
                                 cwd=raiz, capture_output=True, text=True,
                                 check=True).stdout.strip()
            try:
                for paso, script in (("01-recoger", "pasos/01-recoger.py"),
                                      ("02-centinela", "pasos/02-centinela.py")):
                    args = [script] + ([str(entrada)] if paso == "01-recoger" else [])
                    r = subprocess.run([*OBS, "paso", run, paso, "--",
                                        "python3", *args],
                                       cwd=raiz, capture_output=True, text=True)
                    if r.returncode != 0:
                        fallos.append(f"{caso['id']}: {paso} salió {r.returncode}")
                        break
                else:
                    candidatos = json.loads((Path(run) / "candidatos.json").read_text(encoding="utf-8"))
                    descartados = json.loads((Path(run) / "descartados.json").read_text(encoding="utf-8"))
                    if len(candidatos) + len(descartados) != 1:
                        fallos.append(f"{caso['id']}: esperaba 1 error único, "
                                      f"hay {len(candidatos) + len(descartados)}")
                    elif caso["espera"] == "candidato" and len(candidatos) != 1:
                        fallos.append(f"{caso['id']}: esperaba candidato, fue descartado "
                                      f"por {descartados[0].get('regla')!r}")
                    elif caso["espera"] == "descartado" and (
                            len(descartados) != 1
                            or descartados[0].get("regla") != caso["regla"]):
                        regla = descartados[0].get("regla") if descartados else "candidato"
                        fallos.append(f"{caso['id']}: esperaba descartado por "
                                      f"{caso['regla']!r}, fue {regla!r}")
            finally:
                shutil.rmtree(run, ignore_errors=True)
    finally:
        shutil.rmtree(tmp, ignore_errors=True)
    return fallos


def sombra(sabotaje):
    """Copia sombra de lo que usa el centinela, con una regla saboteada."""
    tmp = Path(tempfile.mkdtemp(prefix="prueba-centinela-sombra-"))
    for d in ("pasos", "herramientas", "cerebro"):
        shutil.copytree(RAIZ / d, tmp / d)
    reglas = tmp / "cerebro" / "reglas-ruido.json"
    cfg = json.loads(reglas.read_text(encoding="utf-8"))
    sabotaje(cfg)
    reglas.write_text(json.dumps(cfg, ensure_ascii=False, indent=2), encoding="utf-8")
    return tmp


# ── 1. pasada buena ──────────────────────────────────────────────────────────
fallos = correr_casos(RAIZ)
if fallos:
    print("FALLO: la suite está en rojo con las reglas reales:")
    print("\n".join(f"  - {f}" for f in fallos))
    sys.exit(1)
print(f"CASOS OK: {len(casos)} casos en verde")

# ── 2. sabotaje: umbral_pico 10 -> 9 ─────────────────────────────────────────
s = sombra(lambda cfg: cfg.__setitem__("umbral_pico", 9))
try:
    fallos = correr_casos(s)
finally:
    shutil.rmtree(s, ignore_errors=True)
if not fallos:
    print("FALLO: con umbral_pico=9 la suite sigue en verde: es vacua")
    sys.exit(1)
print(f"SABOTAJE UMBRAL OK: en rojo ({len(fallos)} caso(s), p. ej. {fallos[0]})")

# ── 3. sabotaje: bots-404 sin y_ruta_empieza_por ─────────────────────────────
def quitar_ruta(cfg):
    for r in cfg["reglas"]:
        r.pop("y_ruta_empieza_por", None)

s = sombra(quitar_ruta)
try:
    fallos = correr_casos(s)
finally:
    shutil.rmtree(s, ignore_errors=True)
if not fallos:
    print("FALLO: sin y_ruta_empieza_por la suite sigue en verde: es vacua")
    sys.exit(1)
print(f"SABOTAJE REGLA OK: en rojo ({len(fallos)} caso(s), p. ej. {fallos[0]})")

print(f"CENTINELA OK: {len(casos)} casos en verde · 2 sabotajes en rojo")
PY
