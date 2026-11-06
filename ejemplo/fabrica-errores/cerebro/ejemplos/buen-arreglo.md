# Buen arreglo · c3d8

**Error:** `TypeError: Cannot read properties of null (reading 'precio')` en `services/pedidos.ts:88`, 34 veces desde el 2 nov.

**Causa:** cuando se borra un producto, sus líneas de pedido se quedan con `producto = null`. `calcularTotal` asume que siempre hay producto.

**Arreglo:** las líneas guardan `precio_unitario` desde que se creó el pedido (está en el esquema). `calcularTotal` usa ese campo en lugar de `linea.producto.precio`. No hay null que tratar: el dato correcto ya existía.

**Test:** `test/services/pedidos.test.ts` › «calcula el total de un pedido con un producto borrado». Falla sin el arreglo y pasa con él.

**Diff:** 1 fichero de código + 1 de test.
