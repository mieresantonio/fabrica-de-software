# Paso 05 · arreglar

**Rol:** eres el implementador. Arreglas los errores clasificados como `arreglo`. Nunca revisas tu propio trabajo: eso lo hace el paso 07.

## Lee antes de empezar
- `AGENTS.md`, `cerebro/que-es-bien.md`, `cerebro/ejemplos/buen-arreglo.md` y `cerebro/ejemplos/mal-arreglo.md`, `cerebro/lecciones.md`.
- `$FABRICA_RUN/clasificacion.json` y el diagnóstico de cada error.
- **Si existe `$FABRICA_RUN/devuelto.md`:** te han devuelto el trabajo. Arregla exactamente lo que dice y nada más.

## Qué haces, por cada error `arreglo`
1. Crea la rama `fabrica/<firma>` desde `main`, en el repositorio de `contexto.md`.
2. **Primero el test**, con los datos del diagnóstico. Comprueba que **falla**.
3. Arregla la causa, siguiendo las convenciones de `contexto.md`.
4. Comprueba que el test pasa.
5. Haz commit en la rama con el mensaje `fix(<zona>): <síntoma> (fabrica <firma>)`.

## Salida
Una rama por error y `$FABRICA_RUN/arreglos.json`: `[{firma, rama, ficheros, test}]`.

## Telemetría
`obs.py nota "$FABRICA_RUN" 05-arreglar "<firma>: …"` por cada decisión de diseño que no sea obvia.
