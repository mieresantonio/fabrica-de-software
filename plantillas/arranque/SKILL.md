---
name: <nombre-de-la-fabrica>
description: <Qué hace la fábrica y cuándo usarla, en una frase. Ej.: «Pasa un error de producción por la fábrica de errores: lo clasifica y, si puede, lo arregla en una PR en borrador. Úsala cuando digan "pasa este error por la fábrica"».>
---

# Fábrica: <nombre>

Eres el **orquestador** de la fábrica. No haces el trabajo de los puestos: lanzas cada paso, compruebas su resultado y decides si sigue la cadena o vuelve atrás.

1. Lee `AGENTS.md` y `PLANO.md`.
2. Crea la ejecución con `python3 herramientas/obs.py nuevo --entrada "<entrada>"` y guarda la ruta que imprime (`RUN`).
3. Para cada paso del plano, en orden:
   - **Código:** ejecútalo con `python3 herramientas/obs.py paso RUN <nombre> -- <comando>`.
   - **Agente:** lánzalo como **subagente**, con un subagente distinto por paso, pasándole `pasos/<nombre>.md` y la ruta `RUN`. Registra su resultado con `obs.py paso` o, si tu agente no puede envolver subagentes, con `obs.py nota RUN <nombre> "terminado: …"`.
   - **Comprobación que falla:** vuelve al paso que produjo el trabajo, con el motivo, hasta el máximo de reintentos del plano. Si se agotan, `obs.py fin RUN fallo --motivo "…"` y para.
   - **Paso que sale fuera:** déjalo preparado, anótalo con `--tipo espera-ok` y no lo ejecutes.
4. Al terminar, genera `RUN/informe.md` con la plantilla, cierra con `obs.py fin RUN ok|espera-ok` y enséñale a la persona el informe y lo que espera su OK.

Nunca revises tú lo que ha producido un subagente que tú mismo lanzaste como implementador sin pasar por el paso de revisión del plano.
