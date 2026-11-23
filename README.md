# Mi fábrica de software
[![CI](https://github.com/mieresantonio/fabrica-de-software/actions/workflows/ci.yml/badge.svg)](https://github.com/mieresantonio/fabrica-de-software/actions/workflows/ci.yml)

Copia de trabajo mantenida por **Antonio José Mieres Garabote** ([mieresantonio](https://github.com/mieresantonio)) del kit «Tu fábrica de software», creado por **Jesús, de AlpacaTech** y compartido gratuitamente junto a su vídeo [«Así Monté Mi Fábrica de Software con IA (SOLO CÓPIAME)»](https://youtu.be/b09rcG8yJxk). Todo el mérito del método es suyo; este repositorio es mi copia para estudiarlo, usarlo y construir sobre él.

## Qué es

Un método para convertir un proceso que repites cada semana en una **fábrica**: un sistema donde entra una materia prima (tickets, errores, vídeos, ideas) y sale siempre el mismo producto, con puestos especializados, comprobaciones entre puestos y aprobación humana para todo lo que sale fuera.

- **`EMPIEZA-AQUI.md`** — la puerta de entrada, para la persona.
- **`PARA-TU-AGENTE.md`** — las instrucciones completas para que un agente de IA (Claude Code, Codex, OpenCode…) entreviste, diseñe y construya la fábrica contigo.
- **`plantillas/`** — el esqueleto: cerebro (qué es «bien», contexto, lecciones), plano, informe por ejecución, procedimiento de mejora, orquestador y la telemetría `obs.py`.
- **`ejemplo/fabrica-errores/`** — una fábrica completa de ejemplo: entran errores de producción y salen descartados, tickets o arreglos, con una ejecución de muestra registrada.
- **`ejemplo/fabrica-videos/`** — una segunda fábrica de ejemplo: destila un vídeo educativo en un documento de método con su registro de evidencias. La entrada es un archivo de subtítulos (VTT); la salida es un destilado donde cada afirmación lleva su cita y su nivel de evidencia (A demostrado, B secundario estable, C afirmación del creador, X retractado). Trae una destilación completa y real de muestra (CenteIA, «Adiós a las transcripciones», 18 afirmaciones) y su prueba de humo (`bash prueba-todo.sh` desde la carpeta del ejemplo).
- **`guia/arranque.md`** — cómo ponerla en marcha: como skill dentro del agente o como proceso en el ordenador.

## Verificar que todo funciona

El ejemplo de errores trae sus propias pruebas y no necesita agente, API ni red. Desde la raíz del repo:

```
cd ejemplo/fabrica-errores
bash prueba-todo.sh
```

Corre tres pruebas en orden: la de humo (los dos pasos de código), la completa (la fábrica entera con dobles falsos) y la del centinela (diez casos con sus reglas). Al final debe aparecer `TODO OK: humo + completa + centinela en verde`.

Si prefieres invocar los scripts directamente (`./prueba-todo.sh`), dales antes permiso de ejecución con `chmod +x *.sh fixtures/bin/*` dentro de esa carpeta: un clon fresco puede traerlos sin él. Invocándolos con `bash` no hace falta.

El detalle de cada prueba, con lo que comprueba y cómo se sabotea a sí misma para demostrar que no es vacua, está en `ejemplo/fabrica-errores/LEEME.md`.

Para ver la telemetría sin correr nada, la ejecución de muestra que trae el repo:

```
cd ejemplo/fabrica-errores
python3 herramientas/obs.py ver runs/2026-11-03-0905-a1f3
python3 herramientas/obs.py resumen
```

## Nota sobre el contenido

El kit original incluye además `mapa-de-tu-fabrica.pdf`, el mapa visual del método resumido en una página, que se conserva junto al kit completo en el archivo de trabajo.

## Flujo de referencia: la factory en paralelo

Como complemento, este repositorio incluye [`flujo-paralelo.md`](flujo-paralelo.md): el esquema de fábrica con revisión en paralelo — seguridad, UX, UI y código revisan a la vez lo que construye el builder — y puerta humana que decide entre la ruta directa a `main` y la ruta de PR antes de producción. El esquema procede del vídeo [«Programar con agentes ya no basta: monta tu Software Factory»](https://youtu.be/p6nnqerea7w) de Eric Risco (parte 6 de su presentación). Combina bien con el kit: el cerebro y los puestos salen de estas plantillas; el orden de la línea, sus revisores en paralelo y sus puertas salen de ese esquema.

Primera fábrica que pienso montar con este método: la revisión y destilación de los materiales y vídeos que estudio con mi agente — el mismo proceso con el que este kit llegó hasta aquí.
