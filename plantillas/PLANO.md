# Plano: <nombre de la fábrica>

**Materia prima:** <qué entra>
**Producto:** <qué sale>
**Se lanza:** <como skill («pasa esto por la fábrica») · como proceso (`./fabrica.sh <entrada>`, a mano, cada mañana, cuando llega algo…)>

## Los cuatro bloques

```
CEREBRO        → <qué lee y qué sincroniza>
CONSTRUCCIÓN   → <paso 1> → <paso 2> → <paso 3>
LOOP           → <comprobación> ✗ vuelve a <paso> (máx. N reintentos)
DESPLIEGUE     → <qué sale> ⏸ espera tu OK si sale fuera
```

## Pasos

| # | Paso | Tipo | Entrada | Salida | Comprobación (si falla, para) | Si falla vuelve a |
|---|---|---|---|---|---|---|
| 1 | <nombre> | código / agente / tú | <…> | <…> | <…> | <…> |

## Puertas humanas
<Cada paso donde espera al usuario y por qué: responsabilidad, acción que solo puede hacer una persona, o porque sale fuera.>

## Telemetría
<Qué métricas apunta cada paso además de lo automático (tiempo, resultado, log): coste, elementos procesados… y qué mirar en `obs.py resumen` para saber que la fábrica va bien.>

## Coste
<Qué modelo usa cada paso de agente y una estimación de cuánto gasta una ejecución.>
