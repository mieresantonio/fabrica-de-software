# Informe · 2026-11-03-0905-a1f3 · 3 nov 2026

**Entrada:** `export/errores.jsonl` (133 eventos, 3 errores únicos)
**Resultado:** ⏸ espera tu OK
**Tiempo y coste:** 7 min 18 s · 0,86 $

## Qué ha pasado
- **Ruido (1):** `Not Found /wp-admin/setup.php`, 96 veces (regla `bots-404`, media 120). Descartado.
- **Ticket (1):** `PaymentProviderError: insufficient balance`, 3 veces. La pasarela no tiene saldo: hay que recargarla a mano. → `tickets/c6a2.md`
- **Arreglo (1):** `TypeError … reading 'precio'`, 34 veces. `calcularTotal` fallaba con productos borrados; ahora usa `precio_unitario`. → PR #482 en borrador

## Cronología
`python3 herramientas/obs.py ver runs/2026-11-03-0905-a1f3`. Lo relevante:
- `06-tests` falló en el primer intento: el test nuevo no compilaba por un import. Volvió a `05-arreglar` y pasó en el segundo.

## Decisiones que tomé por mi cuenta
- **03 · 9c56:** entre «producto borrado» y «carrito sin validar», elegí producto borrado: las 34 líneas apuntan a productos con `deleted_at`.
- **04 · c6a2:** ticket y no arreglo: es saldo del proveedor, no código.
- **05 · 9c56:** usar `precio_unitario` en lugar de tratar el null (lección del 29 oct).
- **07 · 9c56:** el criterio 4 cumple por poco. El cambio afecta también al total de pedidos antiguos, pero da el mismo resultado.

## Espera tu OK
- **PR #482 (borrador):** pruébala y mergéala si te convence.
- **Ticket `tickets/c6a2.md`:** créalo en el gestor del equipo y recarga la pasarela.

## Posibles lecciones
- `05-arreglar` dejó un import roto en el test. Si se repite, añadir a sus instrucciones: «ejecuta el test nuevo antes de hacer commit».
