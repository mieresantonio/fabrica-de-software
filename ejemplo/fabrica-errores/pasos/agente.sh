#!/usr/bin/env bash
# Lanza UN paso de agente en modo no interactivo. Uso: bash pasos/agente.sh <paso> [modelo] [texto extra para el prompt]
# - Las instrucciones del paso están en pasos/<paso>.md.
# - Permisos mínimos: leer, escribir en runs/, llamar a obs.py y git de solo lectura. Nunca push, tag ni gh.
# - Apunta el coste del paso (coste_usd) si el agente lo devuelve.
# - Falla si la última línea del agente empieza por «FALLO», o si ha tocado el repo fuera de runs/.
#
# En esta fábrica, el paso 05-arreglar necesita crear ramas y hacer commit en el repo: ver el bloque «PERMISOS 05».
#
# Está escrito para Claude Code (claude -p). Para otro agente, cambia la llamada del bloque «LLAMADA»
# (Codex: codex exec --sandbox workspace-write · Gemini CLI: gemini -p) y quita lo que no admita.
set -uo pipefail
cd "$(dirname "$0")/.."
PASO="${1:?Uso: agente.sh <paso> [modelo] [extra]}"; MODELO="${2:-}"; EXTRA="${3:-}"
RUN="${FABRICA_RUN:?falta FABRICA_RUN (lo exporta fabrica.sh)}"
FABRICA="$(pwd)"
REPO="$(cd "${REPO:-$FABRICA}" && pwd)"   # SIEMPRE absoluta: el agente no sabe qué es «..»

antes="$(git -C "$REPO" status --porcelain 2>/dev/null)"
PROMPT="Eres el paso $PASO de esta fábrica. La fábrica está en $FABRICA y esta ejecución en FABRICA_RUN=$RUN (rutas absolutas).
Lee $FABRICA/AGENTS.md y sigue $FABRICA/pasos/$PASO.md al pie de la letra.
El proyecto sobre el que trabajas está en $REPO: cualquier git, hazlo con git -C $REPO. Escribe solo dentro de $RUN.
No apuntes métricas (las apunta el código); sí apunta tus decisiones con: python3 $FABRICA/herramientas/obs.py nota $RUN $PASO \"...\"
Si no puedes completar el paso, termina con una última línea que empiece por FALLO: y el motivo. $EXTRA"

# ── PERMISOS 05: el implementador trabaja en su rama fabrica/<firma>; el resto, solo lectura ──
PERMISOS_EXTRA=""; GUARDIA=1
if [ "$PASO" = "05-arreglar" ]; then
  PERMISOS_EXTRA=",Bash(git -C $REPO switch:*),Bash(git -C $REPO add:*),Bash(git -C $REPO commit:*),Bash(npm test:*)"
  GUARDIA=0   # cambia el repo a propósito (en su rama); lo vigilan 06-tests y 07-revisar
fi

# ── LLAMADA (el prompt va por stdin: así ningún flag de varios valores se lo traga) ──
salida="$(printf '%s' "$PROMPT" | claude -p ${MODELO:+--model "$MODELO"} --output-format json \
  --add-dir "$REPO" --add-dir "$RUN" \
  --allowedTools "Read,Glob,Grep,Write,Edit,Bash(python3 $FABRICA/herramientas/obs.py:*),Bash(git -C $REPO log:*),Bash(git -C $REPO show:*),Bash(git -C $REPO diff:*),Bash(ls:*)$PERMISOS_EXTRA" \
  --disallowedTools "Bash(git push:*),Bash(git tag:*),Bash(git reset:*),Bash(gh:*)" 2>&1)"
codigo=$?
# ─────────────────────────────────────────────────────────────────────────────────────

printf '%s' "$salida" > "$RUN/.agente-$PASO.json"
python3 - "$RUN" "$PASO" "$FABRICA" > "$RUN/.agente-$PASO.txt" <<'PY'
import json, subprocess, sys
run, paso, fabrica = sys.argv[1:4]
crudo = open(f"{run}/.agente-{paso}.json", encoding="utf-8").read()
try:
    d = json.loads(crudo[crudo.index("{"):])
except Exception:
    print(crudo); sys.exit(0)                    # agente sin salida JSON: se guarda el texto tal cual
if d.get("total_cost_usd") is not None:
    subprocess.run([sys.executable, f"{fabrica}/herramientas/obs.py", "metrica", run, paso, "coste_usd", str(d["total_cost_usd"])])
print(d.get("result", ""))
if d.get("is_error"):
    print(f"FALLO: el agente terminó con error ({d.get('subtype', '')})")
PY
cat "$RUN/.agente-$PASO.txt"

despues="$(git -C "$REPO" status --porcelain 2>/dev/null)"
[ $GUARDIA -eq 1 ] && [ "$antes" != "$despues" ] && { echo "FALLO: el agente ha tocado el proyecto fuera de runs/ (git status ha cambiado)"; exit 1; }
[ $codigo -ne 0 ] && { echo "FALLO: el agente terminó con código $codigo"; exit 1; }
ultima="$(grep -v '^[[:space:]]*$' "$RUN/.agente-$PASO.txt" | tail -n 1)"
case "$ultima" in FALLO*) exit 1 ;; esac
exit 0
