# Plano: errores de producción

**Materia prima:** export de errores de las últimas 24 h (`errores.jsonl`, una línea por evento).
**Producto:** por cada error único, una de tres cosas: descartado (ruido), ticket listo para crear o PR en borrador con arreglo y test.
**Se lanza:** como proceso, cada mañana a las 8:00 (`launchd`): `./fabrica.sh export/errores.jsonl`. También a mano.

## Los cuatro bloques

```
CEREBRO        → que-es-bien · contexto · lecciones · reglas-ruido.json
CONSTRUCCIÓN   → 01 recoger → 02 centinela → 03 investigar → 04 clasificar
                                                  ├─ ruido   → descartado (con motivo)
                                                  ├─ ticket  → ticket listo para crear
                                                  └─ arreglo → 05 arreglar
LOOP           → 06 tests + linter ✗ vuelve a 05 (máx. 2)
                 07 revisar ✗ vuelve a 05 (máx. 2)
DESPLIEGUE     → 08 PR en borrador · ⏸ el merge y los tickets esperan tu OK → 09 informe
```

## Pasos

| # | Paso | Tipo | Entrada | Salida | Comprobación (si falla, para) | Si falla vuelve a |
|---|---|---|---|---|---|---|
| 01 | recoger | código | `errores.jsonl` | `errores.json` (agrupados por firma) | JSON válido, ≥ 1 error o fin limpio «sin errores» | — |
| 02 | centinela | código | `errores.json` + `cerebro/reglas-ruido.json` | `candidatos.json` | cada error descartado lleva la regla que lo descartó | — |
| 03 | investigar | agente | un candidato | `diagnostico/<firma>.md` | tiene causa probable, fichero y línea, y si se reproduce | — |
| 04 | clasificar | agente | diagnóstico | `clasificacion.json` | cada error: `ruido`, `ticket` o `arreglo`, con motivo | — |
| 05 | arreglar | agente | errores `arreglo` | rama `fabrica/<firma>` con arreglo + test que reproduce | hay un test nuevo que falla sin el arreglo | — |
| 06 | tests | código | rama | resultado de tests + linter | todo en verde | 05 |
| 07 | revisar | agente (≠ 05) | diff de la rama | `revision/<firma>.json` | veredicto OK según la rúbrica | 05 |
| 08 | preparar salida | código | ramas OK + tickets | PRs en borrador + `tickets/<firma>.md` | cada PR enlaza su diagnóstico | — |
| 09 | informe | agente | `runs/<id>/` | `informe.md` | sigue la plantilla | — |

## Puertas humanas
- **Merge de cada PR:** la persona prueba el arreglo y mergea. Es responsable de lo que llega a producción.
- **Crear los tickets:** la fábrica los deja escritos; la persona los crea en el gestor del equipo o los descarta.
- **Acciones en producción** (recargar un proveedor, tocar datos): siempre van como ticket, nunca las hace la fábrica.

## Telemetría
- Automática en cada paso: tiempo, resultado y log.
- Métricas: `errores_unicos` (01), `descartados` (02), `ruido`/`ticket`/`arreglo` (04), `coste_usd` en cada paso de agente.
- En `obs.py resumen` hay que vigilar:
  - **Los reintentos de 05:** si suben, falta contexto o lecciones.
  - **Los descartados de 02:** si caen de golpe, ha cambiado el formato de los logs.

## Coste
Pasos 03-05 y 07 con el modelo bueno; 09 con uno barato. Entre 0,30 y 1,50 $ por ejecución según cuántos errores lleguen a `arreglo`.
