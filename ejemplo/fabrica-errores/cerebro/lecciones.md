# Lecciones

La fábrica lee este fichero antes de cada ejecución. Cada fallo se arregla **una sola vez**.

## 2026-10-29 · 05 arreglar
- **Qué pasó:** el arreglo de `TypeError: Cannot read properties of undefined (reading 'email')` añadió `usuario?.email`. El usuario llegaba vacío porque el repositorio no filtraba los borrados, y el arreglo lo escondía.
- **Regla:** ante un `undefined`, busca primero **por qué llega vacío**. Solo si llegar vacío es válido según el dominio, trátalo, y explica por qué en la PR.
- **Cómo se comprueba:** criterio 1 de la rúbrica del revisor (07).

## 2026-10-27 · 02 centinela
- **Qué pasó:** se descartaron como ruido los `ECONNRESET` del servicio de emails, pero ese día eran 400 y era una caída real.
- **Regla:** un error de la lista de ruido deja de ser ruido si supera 10× su media diaria. Pasa a investigar y luego a ticket.
- **Cómo se comprueba:** `umbral_pico` en `reglas-ruido.json`; el centinela anota cuándo lo aplica.
