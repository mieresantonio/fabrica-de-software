# Herramientas

Este ejemplo no trae una herramienta de telemetría propia. El orquestador
(`fabrica.sh`) registra cada paso en `runs/<id>/eventos.log` (hora, paso,
resultado), que basta para seguir una ejecución y para depurarla.

Si se quiere la telemetría completa del kit, al aplicar se puede copiar
aquí la herramienta de telemetría desde `plantillas/herramientas/obs.py`
y envolver los pasos de código con ella. No es necesario para que el ejemplo
funcione.
