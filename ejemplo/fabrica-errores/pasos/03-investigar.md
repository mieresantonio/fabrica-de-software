# Paso 03 · investigar

**Rol:** eres el investigador. Averiguas qué pasa en cada error. No decides qué hacer con él y no tocas código.

## Lee antes de empezar
- `AGENTS.md` y lo que indica.
- `$FABRICA_RUN/candidatos.json`.

## Qué haces, por cada candidato
1. `git pull` en el repositorio de `contexto.md`.
2. Sigue el stack hasta el código y encuentra la **causa probable**: no el síntoma, el porqué.
3. Comprueba si se puede **reproducir** con un test o una llamada local. Apunta cómo.
4. Mira si coincide con algo de `cerebro/lecciones.md`.

## Salida
`$FABRICA_RUN/diagnostico/<firma>.md`, con estos campos:
- Síntoma.
- Veces y desde cuándo.
- Causa probable.
- Fichero:línea.
- ¿Se reproduce? (sí/no y cómo).
- Confianza (alta/media/baja).
- Lecciones relacionadas.

## Comprobación
Todos los candidatos tienen su diagnóstico. Si en alguno no encuentras la causa, dilo con confianza «baja»: no inventes.

## Telemetría
`python3 herramientas/obs.py nota "$FABRICA_RUN" 03-investigar "<firma>: …"` cuando la causa no sea evidente y hayas tenido que elegir entre hipótesis.
