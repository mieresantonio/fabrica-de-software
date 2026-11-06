# Fábrica: errores de producción

Entra un export de errores de producción (`errores.jsonl`). Por cada error único sale una de tres cosas: descartado como ruido, un ticket listo para crear o una PR en borrador con el arreglo y su test.

## Antes de hacer nada, lee
1. `cerebro/que-es-bien.md`: qué es una buena clasificación, un buen ticket y un buen arreglo.
2. `cerebro/contexto.md`: la aplicación, su arquitectura y cómo se testea.
3. `cerebro/lecciones.md`: errores que ya se cometieron. **No repitas ninguno.**
4. `PLANO.md`: los pasos, su orden y qué comprueba cada uno.

## Reglas de la fábrica
- **Un puesto, una tarea.** Haz solo el paso que te toca.
- **Quien implementa no revisa.** El paso `07-revisar` nunca arregla: devuelve a `05-arreglar` con el motivo.
- **Todo se arregla una vez.** Si la persona corrige algo, o un revisor encuentra un fallo nuevo, sigue `MEJORAR.md`.
- **Nada sale fuera sin OK.**
  - Mergear una PR, crear un ticket en el gestor del equipo o tocar datos o proveedores de producción espera a la persona.
  - Abrir una PR **en borrador** sí está permitido: no despliega nada.
- **Si no sabes, para.** Si no puedes reproducir un error o no tienes claro su origen, clasifícalo como `ticket` con lo que sepas. No arregles a ciegas.

## Telemetría (obligatoria)
- Todo paso se ejecuta a través de `herramientas/obs.py paso` (lo hace `fabrica.sh`).
- **Cada decisión que tomes por tu cuenta:** `python3 herramientas/obs.py nota "$FABRICA_RUN" <paso> "qué y por qué"`.
- **Si fallas,** la última línea de tu salida es el motivo.
- **Coste del paso,** si tu agente lo da: `python3 herramientas/obs.py metrica "$FABRICA_RUN" <paso> coste_usd <valor>`.
