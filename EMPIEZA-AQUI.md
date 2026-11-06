# Tu fábrica de software

Gracias por descargarlo. Esta carpeta convierte a tu agente de IA en tu guía para montar tu propia fábrica de software: te hace las preguntas necesarias, diseña la fábrica contigo y la construye hasta que funciona.

## Cómo empezar (2 minutos)
1. Descomprime la carpeta donde quieras.
2. Ábrela con tu agente: Claude Code, Codex, Cursor, Gemini CLI… En la terminal sería `cd fabrica-de-software` y luego `claude`, `codex` o el que uses.
3. Escríbele: **«Lee PARA-TU-AGENTE.md y empecemos»**.

A partir de ahí, él te va preguntando. Al final tendrás tu fábrica en la carpeta que elijas, con todo lo necesario para seguir mejorándola por tu cuenta.

## Antes de empezar, ten a mano
- **Algo que repitas cada semana** y que te gustaría que saliera solo.
- **3-5 ejemplos de un buen resultado** de ese proceso. Son obligatorios: sin saber qué es «bien», no hay fábrica que valga. Si no los tienes, hazlo a mano unas cuantas veces y vuelve.
- Tiempo sin prisas. La entrevista dura lo que haga falta según lo grande que sea tu fábrica.

## Qué hay aquí
- **`EMPIEZA-AQUI.md`:** este fichero, para ti.
- **`PARA-TU-AGENTE.md`:** las instrucciones para tu agente. No hace falta que lo leas, aunque puedes.
- **`mapa-de-tu-fabrica.pdf`:** todo el método en una página. Tenlo a mano mientras montas la fábrica.
- **`plantillas/`:** el esqueleto de tu fábrica:
  - El cerebro: qué es bien, el contexto y las lecciones.
  - El plano.
  - El informe de cada ejecución.
  - El procedimiento de mejora.
  - El orquestador.
- **`plantillas/herramientas/obs.py`:** la telemetría. Cada paso de tu fábrica deja su log, su tiempo, su coste y las decisiones que tomó, y `obs.py resumen` te dice qué pieza falla más. Es lo que hace que mejorar la fábrica sea fácil.
- **`ejemplo/fabrica-errores/`:** una fábrica completa de ejemplo. Entran errores de producción y salen descartados, tickets o PRs con el arreglo. Mírala para ver cómo queda una terminada. Prueba `python3 ejemplo/fabrica-errores/herramientas/obs.py resumen` para ver la telemetría de una ejecución de muestra.
- **`guia/`:** cómo se pone en marcha la fábrica, como skill de tu agente o como proceso en tu ordenador. La usa tu agente.

## Cuando ya la tengas
- **Si algo sale mal o no te convence,** díselo a tu agente, explícale por qué y pídele: «mejora la fábrica con lo que pasó en la última ejecución».
- **Lo que sale fuera** (publicar, mergear, mandar un correo) siempre espera a que tú le des el OK. Lo de dentro corre solo.

Si la montas, cuéntame en los comentarios del vídeo qué has automatizado. Me encanta verlo.

— Jesús, AlpacaTech
