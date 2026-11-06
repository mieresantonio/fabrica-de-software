# Contexto

## Lo fijo
- **La aplicación:** API REST en Node 20 + TypeScript + Express, Postgres con Prisma. Repositorio en `../api` (la fábrica trabaja ahí).
- **Capas:** `routes/` → `services/` → `repositories/`. La lógica de negocio va en `services/`, nunca en las rutas.
- **Errores:** siempre con `AppError(codigo, mensaje, contexto)` de `src/errors.ts`. Prohibido `throw new Error` en código nuevo.
- **Tests:** Vitest, en `test/`, junto al nombre del fichero (`services/pagos.ts` → `test/services/pagos.test.ts`). Comando: `npm test`. Linter: `npm run lint`.
- **Proveedores externos:** pasarela de pagos y servicio de emails. Sus fallos (timeouts, 5xx, saldo agotado) **no se arreglan con código**: son tickets.
- **Ramas y PRs:** rama `fabrica/<firma>`, PR en borrador contra `main` con la etiqueta `fabrica`.

## Lo que cambia
- **Los errores de cada día:** los trae el paso 01 desde `export/errores.jsonl`, que deja el export programado del monitor de errores.
- **El código:** el paso 03 hace `git pull` en `../api` antes de investigar.
