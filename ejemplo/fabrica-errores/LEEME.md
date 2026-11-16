# Ejemplo: fábrica de errores de producción

Es una fábrica completa **de referencia**: entra un export de errores de producción y salen, por cada error, una de tres cosas:
- **Descartado**, si es ruido conocido.
- **Ticket listo para crear**, si necesita que actúe una persona.
- **PR en borrador** con el arreglo y un test, si la fábrica lo puede arreglar sola.

No está pensada para ejecutarse tal cual en tu proyecto: el contexto describe una API inventada. Sirve para ver cómo queda una fábrica terminada:
- **El cerebro:** qué es bien, contexto, lecciones y reglas del centinela.
- **El plano** con los cuatro bloques.
- **Cada paso:** de código (`.py`, `.sh`) o de agente (`.md`).
- **El orquestador** (`fabrica.sh`).
- **La telemetría** (`herramientas/obs.py`).
- **Una ejecución de muestra** en `runs/`.

Prueba la telemetría con la ejecución de muestra:
```
python3 herramientas/obs.py ver runs/2026-11-03-0905-a1f3
python3 herramientas/obs.py resumen
```

## Prueba de humo (sin agente ni API)

Los dos primeros pasos son código y se pueden verificar sin ejecutar
la fábrica entera (que necesita un agente y el repo de la API):

```
./prueba-pasos.sh
```

Crea una ejecución temporal con la muestra de
`export-muestra/errores.jsonl` (4 eventos), corre `01-recoger` y
`02-centinela` y comprueba el resultado esperado —3 errores únicos,
2 candidatos y 1 descartado por la regla `bots-404`—, y borra la
ejecución al terminar. Si algo cambia en esos pasos o en las reglas
del centinela, la prueba lo dice.

## Prueba completa (la fábrica entera, sin agente ni API)

```
./prueba-completa.sh
```

Corre la `./fabrica.sh` real de principio a fin con un `claude` falso
(`fixtures/bin/claude`, respuestas guionadas y deterministas por paso),
un `gh` falso (`fixtures/bin/gh`, devuelve una URL de PR inventada) y
un repo API falso en `/tmp` (`fixtures/repo-api`, git + proyecto Node
mínimo con tests en verde). Comprueba que la ejecución termina en
`espera-ok`, que la clasificación trae las decisiones esperadas
(arreglo + ticket), que la revisión es OK, que existe `informe.md` y
que la nota de PR trae una URL no vacía.

Para demostrar que no es vacua, la prueba se sabotea a sí misma dos
veces: el `claude` falso devuelve `FALLO:` en 07-revisar (la fábrica
debe reintentar 3 veces y terminar en fallo) y el `gh` falso falla
(08 debe fallar en voz alta, sin anotar una PR con URL vacía).
Si un sabotaje no pone la prueba en rojo, la prueba es vacua y sale 1.

## Suite del centinela

```
./prueba-centinela.sh
```

Diez casos para `02-centinela.py` y `reglas-ruido.json`
(`fixtures/casos-ruido.json`): un caso por regla que casa, un caso
por regla que NO casa (mensaje parecido pero ruta u origen distintos)
y los dos casos del pico —11× la media pasa a candidato, 10× exactos
sigue siendo ruido, porque la comparación es `>` estricta—.
Cada caso pasa por los pasos reales 01-recoger y 02-centinela.

También se sabotea a sí misma en una copia sombra (sin tocar el repo):
con `umbral_pico` 10 → 9 y con `bots-404` sin `y_ruta_empieza_por`.
Cada sabotaje debe poner la suite en rojo.

Las tres pruebas juntas, en orden:

```
./prueba-todo.sh
```
