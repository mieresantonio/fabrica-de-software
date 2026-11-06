# Fábrica: <nombre>

<Una línea: qué entra y qué sale. Ej.: «Entra un error de producción, sale una PR en borrador o un ticket listo para crear».>

## Antes de hacer nada, lee
1. `cerebro/que-es-bien.md`: qué es un buen resultado aquí. Todo se mide contra esto.
2. `cerebro/contexto.md`: lo que necesitas saber para trabajar.
3. `cerebro/lecciones.md`: errores que ya se cometieron. **No repitas ninguno.**
4. `PLANO.md`: los pasos, su orden y qué comprueba cada uno.

## Reglas de la fábrica
- **Un puesto, una tarea.** Haz solo el paso que te toca, con su entrada y su salida. No te adelantes al siguiente.
- **Quien implementa no revisa.** Si estás revisando y algo está mal, devuélvelo al paso que lo produjo con el motivo. No lo arregles tú.
- **Todo se arregla una vez.** Cuando la persona corrija algo, o un revisor encuentre un fallo nuevo, sigue `MEJORAR.md`.
- **Nada sale fuera sin OK.** Publicar, mergear, desplegar, enviar correos, gastar dinero o tocar producción espera la aprobación de la persona. Déjalo preparado y anótalo con `obs.py nota … --tipo espera-ok`.
- **Si no sabes, para.** Si te falta información para hacer bien el paso, no te la inventes. Termina con error y explica qué falta en la última línea.

## Telemetría (obligatoria)
Todo paso se ejecuta a través de `herramientas/obs.py paso`, que guarda su log, su duración y su resultado en `runs/<id>/`.
- **Cada decisión que tomes por tu cuenta:** `python3 herramientas/obs.py nota "$FABRICA_RUN" <paso> "qué decidiste y por qué"`.
- **Las cifras (métricas) las apunta el código**, no tú: así no se cuentan dos veces. El coste de cada paso de agente lo apunta `pasos/agente.sh`.
- **Si fallas,** la última línea de tu salida es el motivo, en una frase. Es lo que verá el resumen.
- **Para ver la salud de la fábrica:** `python3 herramientas/obs.py resumen`.
