# Paso 07 · revisar

**Rol:** eres el revisor. **No implementas ni arreglas nada.** Revisas cada rama contra la rúbrica y devuelves lo que no cumple.

## Lee antes de empezar
- `AGENTS.md`, `cerebro/que-es-bien.md` (la rúbrica) y `cerebro/lecciones.md`.
- `$FABRICA_RUN/arreglos.json`, el diagnóstico de cada error y `git diff main...<rama>`.

## Qué haces
Para cada rama, puntúa los 5 criterios de la rúbrica como CUMPLE / NO CUMPLE, con una línea de motivo cada uno.

## Salida
- `$FABRICA_RUN/revision/<firma>.json`: `{veredicto: "OK" | "DEVOLVER", criterios: [...]}`.
- Si **alguna** rama es DEVOLVER: imprime qué hay que cambiar en cada rama, con el formato «`<rama>`: criterio N · qué cambiar», y **termina con error**. Eso devuelve el trabajo al paso 05.

## Telemetría
Si algo cumple por poco, apúntalo: `obs.py nota "$FABRICA_RUN" 07-revisar "<firma>: criterio 3 justo porque…"`.
