#!/usr/bin/env bash
# Prueba completa del ejemplo: corre la ./fabrica.sh REAL de principio a fin
# con un `claude` falso (fixtures/bin/claude, respuestas guionadas por paso),
# un `gh` falso (fixtures/bin/gh, devuelve una URL de PR inventada) y un repo
# API falso en /tmp (fixtures/repo-api: git + proyecto Node mínimo con tests
# en verde). No necesita agente, API ni red.
#
# Tres corridas, cada una con un repo falso y una ejecución nuevos:
#   1. camino bueno: la fábrica debe terminar en espera-ok, con la
#      clasificación esperada, revisión OK, informe.md y una nota de PR con
#      URL no vacía.
#   2. sabotaje 07: el claude falso devuelve FALLO: en 07-revisar. La fábrica
#      debe reintentar y terminar en fallo (si la prueba siguiera en verde,
#      sería vacua).
#   3. sabotaje gh: el gh falso falla. El paso 08 debe fallar en voz alta y
#      NO anotar una PR con URL vacía.
#
# Las ejecuciones se borran al terminar si todo va bien; si algo falla, la
# ejecución se conserva y se imprime su ruta para depurar.
# Uso: ./prueba-completa.sh
set -uo pipefail
cd "$(dirname "$0")"
FIXTURES="$PWD/fixtures"
ENTRADA="export-muestra/errores.jsonl"
PR_ESPERADA="https://github.com/fabrica-ejemplo/api/pull/1"

fallo() { echo "FALLO: $*"; exit 1; }

for cmd in git node npm python3; do
  command -v "$cmd" >/dev/null || fallo "falta $cmd en el PATH"
done
[ -f "$ENTRADA" ] || fallo "falta $ENTRADA"
# Los fixtures deben ser ejecutables, pero un clon fresco puede traerlos
# sin el bit +x (la subida por snapshot no conserva modos): asegurarlo aquí.
chmod +x "$FIXTURES/bin/claude" "$FIXTURES/bin/gh"
[ -x "$FIXTURES/bin/claude" ] || fallo "falta $FIXTURES/bin/claude (ejecutable)"
[ -x "$FIXTURES/bin/gh" ] || fallo "falta $FIXTURES/bin/gh (ejecutable)"
[ -f "$FIXTURES/repo-api/package.json" ] || fallo "falta $FIXTURES/repo-api"

TMP="$(mktemp -d /tmp/prueba-fabrica-completa.XXXXXX)"
# Si algo falla, el tmp se conserva: los logs de las corridas son la evidencia.
trap 'if [ "${PRUEBA_OK:-0}" = 1 ]; then rm -rf "$TMP"; else echo "tmp conservado en $TMP (logs de las corridas)"; fi' EXIT
export PATH="$FIXTURES/bin:$PATH"   # el claude y el gh falsos, antes que los reales

# preparar_repo <nombre>: clona el repo API falso a $TMP/<nombre>, con un
# remoto local (bare) como origin para que el push de 08 funcione sin red.
# Imprime la ruta del repo.
preparar_repo() {
  local nombre="$1" repo="$TMP/$nombre" remoto="$TMP/$nombre-remoto.git"
  cp -r "$FIXTURES/repo-api" "$repo"
  git -C "$repo" init -q -b main
  git -C "$repo" config user.email "fabrica-prueba@ejemplo.local"
  git -C "$repo" config user.name "Fábrica (prueba)"
  git -C "$repo" add -A && git -C "$repo" commit -qm "chore: api de ejemplo"
  git init -q --bare -b main "$remoto"
  git -C "$repo" remote add origin "$remoto"
  git -C "$repo" push -q -u origin main
  echo "$repo"
}

# correr <nombre> <sabotaje>: una ejecución completa de la fábrica.
# Imprime "<código>|<run>|<repo>". El log queda en $TMP/<nombre>.log.
correr() {
  local nombre="$1" sabotaje="$2" repo log codigo run
  repo="$(preparar_repo "$nombre")"
  log="$TMP/$nombre.log"
  REPO="$repo" FABRICA_PRUEBA_SABOTAJE="$sabotaje" \
    ./fabrica.sh "$ENTRADA" > "$log" 2>&1
  codigo=$?
  run="$(sed -n 's/^▶ run: //p' "$log" | head -n 1)"
  [ -n "$run" ] && [ -d "$run" ] || fallo "$nombre: no se creó la ejecución (ver $log)"
  echo "$codigo|$run|$repo"
}

# comprobar <modo> <run> <repo>: aserciones de una ejecución (python).
comprobar() {
  python3 - "$1" "$2" "$3" <<'PY'
import json, subprocess, sys
from pathlib import Path

modo, run, repo = sys.argv[1], Path(sys.argv[2]), sys.argv[3]
PR_ESPERADA = "https://github.com/fabrica-ejemplo/api/pull/1"

def comprobar(cond, msg):
    if not cond:
        print(f"FALLO [{modo}]: {msg}")
        sys.exit(1)

eventos = [json.loads(l) for l in (run / "eventos.jsonl").read_text(encoding="utf-8").splitlines() if l.strip()]
fines = [e for e in eventos if e.get("tipo") == "fin"]
comprobar(len(fines) == 1, f"esperaba 1 evento fin, hay {len(fines)}")
fin = fines[0]
notas_pr = [e["texto"] for e in eventos
            if e.get("tipo") == "nota" and "PR en borrador:" in e.get("texto", "")]

if modo == "bueno":
    comprobar(fin["resultado"] == "espera-ok",
              f"la ejecución debería terminar en espera-ok, terminó en {fin['resultado']!r}")
    clasificacion = json.loads((run / "clasificacion.json").read_text(encoding="utf-8"))
    comprobar(len(clasificacion) == 2,
              f"esperaba 2 clasificados, hay {len(clasificacion)}")
    arreglo = next((c for c in clasificacion if "TypeError" in c["mensaje"]), None)
    ticket = next((c for c in clasificacion if "PaymentProviderError" in c["mensaje"]), None)
    comprobar(arreglo and arreglo["decision"] == "arreglo",
              "el TypeError debería clasificarse como arreglo")
    comprobar(ticket and ticket["decision"] == "ticket",
              "el error de la pasarela debería clasificarse como ticket")
    comprobar((run / "tickets" / f"{ticket['firma']}.md").exists(),
              "falta el ticket del error de la pasarela")
    comprobar(len(list((run / "diagnostico").glob("*.md"))) == 2,
              "esperaba 2 diagnósticos")
    revisiones = list((run / "revision").glob("*.json"))
    comprobar(len(revisiones) == 1, f"esperaba 1 revisión, hay {len(revisiones)}")
    revision = json.loads(revisiones[0].read_text(encoding="utf-8"))
    comprobar(revision["veredicto"] == "OK", "la revisión debería ser OK")
    comprobar(len(revision["criterios"]) == 5
              and all(c["cumple"] for c in revision["criterios"]),
              "los 5 criterios de la revisión deberían cumplirse")
    arreglos = json.loads((run / "arreglos.json").read_text(encoding="utf-8"))
    comprobar(len(arreglos) == 1 and arreglos[0]["rama"] == f"fabrica/{arreglo['firma']}",
              "arreglos.json debería traer la rama del arreglo")
    rama = subprocess.run(["git", "-C", repo, "show-ref", "--verify", "--quiet",
                           f"refs/heads/{arreglos[0]['rama']}"]).returncode == 0
    comprobar(rama, f"la rama {arreglos[0]['rama']} no existe en el repo falso")
    comprobar(not (run / "devuelto.md").exists(),
              "devuelto.md no debería existir: el loop terminó limpio")
    comprobar(len(notas_pr) == 1, f"esperaba 1 nota de PR, hay {len(notas_pr)}")
    url = notas_pr[0].split("PR en borrador:", 1)[1].split("·")[0].strip()
    comprobar(url == PR_ESPERADA,
              f"la nota de PR debería traer {PR_ESPERADA}, trae {url!r}")
    informe = run / "informe.md"
    comprobar(informe.exists(), "falta informe.md")
    comprobar(PR_ESPERADA in informe.read_text(encoding="utf-8"),
              "informe.md debería enlazar la PR")
    print("BUENO OK: espera-ok · arreglo+ticket · revisión OK · "
          f"PR {PR_ESPERADA} · informe.md")

elif modo == "sabotaje-07":
    comprobar(fin["resultado"] == "fallo",
              f"con 07 en FALLO la ejecución debería terminar en fallo, terminó en {fin['resultado']!r}")
    comprobar("revisión" in fin.get("motivo", ""),
              f"el motivo debería nombrar la revisión, es {fin.get('motivo', '')!r}")
    intentos_07 = [e for e in eventos
                   if e.get("tipo") == "paso-fin" and e.get("paso") == "07-revisar"]
    comprobar(len(intentos_07) == 3,
              f"07 debería reintentarse 3 veces, corrió {len(intentos_07)}")
    comprobar(all(not e["ok"] for e in intentos_07),
              "los 3 intentos de 07 deberían fallar")
    comprobar(not notas_pr, "con 07 en rojo no debería haber ninguna nota de PR")
    print("SABOTAJE 07 OK: 3 reintentos de 07 en rojo · la fábrica termina en fallo")

elif modo == "sabotaje-gh":
    comprobar(fin["resultado"] == "fallo",
              f"con gh roto la ejecución debería terminar en fallo, terminó en {fin['resultado']!r}")
    paso08 = [e for e in eventos
              if e.get("tipo") == "paso-fin" and e.get("paso") == "08-preparar-salida"]
    comprobar(len(paso08) == 1 and not paso08[0]["ok"],
              "08-preparar-salida debería fallar")
    comprobar("no se pudo crear la PR" in paso08[0].get("motivo", ""),
              f"08 debería fallar por la PR, motivo: {paso08[0].get('motivo', '')!r}")
    comprobar(not notas_pr,
              "con gh roto no debe anotarse ninguna PR (ni con URL vacía)")
    print("SABOTAJE GH OK: 08 falla en voz alta · ninguna PR anotada")
PY
}

# ── 1. camino bueno ──────────────────────────────────────────────────────────
echo "▶ camino bueno…"
IFS='|' read -r codigo run repo < <(correr bueno "")
[ "$codigo" -eq 0 ] || fallo "camino bueno: fabrica.sh salió con $codigo (log: $TMP/bueno.log, run: $run)"
comprobar bueno "$run" "$repo" || { echo "  run conservado en $run · log en $TMP/bueno.log"; exit 1; }
rm -rf "$run"

# ── 2. sabotaje 07 ───────────────────────────────────────────────────────────
echo "▶ sabotaje 07 (el revisor devuelve FALLO:)…"
IFS='|' read -r codigo run repo < <(correr sabotaje-07 07)
[ "$codigo" -ne 0 ] || fallo "sabotaje 07: fabrica.sh salió 0 con el revisor en rojo: la prueba es vacua (run: $run)"
comprobar sabotaje-07 "$run" "$repo" || { echo "  run conservado en $run · log en $TMP/sabotaje-07.log"; exit 1; }
rm -rf "$run"

# ── 3. sabotaje gh ───────────────────────────────────────────────────────────
echo "▶ sabotaje gh (gh pr create falla)…"
IFS='|' read -r codigo run repo < <(correr sabotaje-gh gh)
[ "$codigo" -ne 0 ] || fallo "sabotaje gh: fabrica.sh salió 0 con gh roto: la prueba es vacua (run: $run)"
comprobar sabotaje-gh "$run" "$repo" || { echo "  run conservado en $run · log en $TMP/sabotaje-gh.log"; exit 1; }
rm -rf "$run"

PRUEBA_OK=1
echo "COMPLETA OK: camino bueno en espera-ok · sabotaje 07 en rojo · sabotaje gh en rojo"
