# Qué es bien: errores de producción

## El producto
Por cada error único, la decisión correcta y bien justificada: descartarlo, pedir ayuda humana con un ticket claro o arreglarlo con una PR que se pueda mergear sin retocar.

## Ejemplos
- Bueno: `ejemplos/buena-clasificacion.json` · tres errores, una decisión de cada tipo y el motivo en una frase.
- Bueno: `ejemplos/buen-arreglo.md` · arregla la causa, no el síntoma, y trae un test que reproduce el error.
- Malo: `ejemplos/mal-arreglo.md` · envuelve el error en un try/catch que lo silencia.

## Criterios comprobables con código
- [ ] `clasificacion.json` es válido y cada error tiene `decision` ∈ {ruido, ticket, arreglo} y `motivo`.
- [ ] Cada rama de arreglo añade al menos un test, y ese test **falla sin el arreglo**.
- [ ] Tests y linter en verde.
- [ ] El diff no toca más de 3 ficheros fuera de los tests (si toca más, es un ticket, no un arreglo).

## Criterios de juicio (rúbrica del revisor, paso 07)
Cada uno CUMPLE / NO CUMPLE; si no cumple, el motivo y la vuelta a 05.
1. **Arregla la causa, no el síntoma.** No hay try/catch que silencie, ni comprobaciones de null que oculten un dato que nunca debería llegar vacío.
2. **El test reproduce el error real**, con los datos del diagnóstico, no uno inventado.
3. **Sigue las convenciones** de `contexto.md`: capas, nombres, manejo de errores con `AppError`.
4. **No cambia comportamiento** fuera del caso del error.
5. **La descripción de la PR** explica el error, la causa y cómo se ha comprobado, en lenguaje de equipo.

## Un buen ticket
Título con el síntoma, qué pasa, desde cuándo y cuántas veces, la causa probable, qué acción humana hace falta y el enlace al diagnóstico.

## Fuera de alcance
- Refactorizar código que no toca el error.
- Errores de infraestructura: la caída de un proveedor, la base de datos llena. Van siempre como ticket.
