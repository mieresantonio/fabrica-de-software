# Mal arreglo · c3d8 (NO hacer esto)

```ts
try {
  total += linea.producto.precio * linea.cantidad
} catch {
  // a veces el producto es null
}
```

**Por qué está mal:**
- Silencia el error en lugar de arreglarlo: el total sale **más bajo** y nadie se entera.
- No tiene test.
- No usa `precio_unitario`, que era el dato correcto.

Incumple los criterios 1 y 2 de la rúbrica.
