# Paso 04 · clasificar

**Rol:** eres el clasificador. Decides el destino de cada error a partir de su diagnóstico. No investigas de nuevo y no arreglas.

## Lee antes de empezar
- `AGENTS.md`, `cerebro/que-es-bien.md` y `cerebro/ejemplos/buena-clasificacion.json`.
- `$FABRICA_RUN/diagnostico/*.md`.

## Qué haces
Para cada error, una decisión:
- **ruido**: no afecta a nadie y no hay nada que hacer. Propón añadirlo a `reglas-ruido.json` en el informe (no lo añadas tú).
- **ticket**:
  - Necesita una acción humana: un proveedor, datos de producción, una decisión de producto.
  - O la causa tiene confianza baja.
  - O el arreglo tocaría más de 3 ficheros.
- **arreglo**: causa clara, se reproduce y el arreglo está acotado.

## Salida
`$FABRICA_RUN/clasificacion.json`: lista de `{firma, mensaje, decision, motivo}`, igual que el ejemplo. Por cada `ticket`, además, `$FABRICA_RUN/tickets/<firma>.md` según «Un buen ticket» de `que-es-bien.md`.

## Telemetría
- Cada decisión dudosa: `obs.py nota "$FABRICA_RUN" 04-clasificar "<firma>: arreglo y no ticket porque…"`.
- Al terminar, las métricas `ruido`, `ticket` y `arreglo` con su número: `obs.py metrica "$FABRICA_RUN" 04-clasificar <decision> <n>`.
