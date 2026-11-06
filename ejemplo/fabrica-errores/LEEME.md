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
