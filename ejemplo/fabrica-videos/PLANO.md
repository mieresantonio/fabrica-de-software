# Plano — fabrica-videos

## Objetivo

Convertir un vídeo educativo en un documento de método estructurado con
su registro de evidencias, de forma repetible y auditable.

## Entrada y salida

- Entrada: un archivo de subtítulos (VTT) del vídeo.
- Salida (en `runs/<id>/`): transcripción normalizada, afirmaciones,
  registro de evidencias, documento destilado, revisión e informe.

## Pasos

| Paso | Tipo | Entrada | Salida |
|---|---|---|---|
| 01-normalizar | código | VTT | `transcripcion.jsonl`, `transcripcion-normalizada.txt` |
| 02-extraer-afirmaciones | agente | transcripción normalizada | `afirmaciones.json` |
| 03-clasificar-evidencia | agente | afirmaciones, fuente | `registro-evidencias.json`, `DESTILADO.md` |
| 04-revisar | agente | registro, destilado | `revision.json` (+ correcciones) |
| 05-verificar-citas | código | registro, transcripción JSONL | veredicto por afirmación |
| 06-empaquetar | código | registro, fuente, salidas | `informe.md` |

## Reglas de la línea

- Los pasos se comunican por archivos, con formato fijo. Nada se acuerda
  por conversación.
- Quien extrae y clasifica no revisa: el paso 04 lo hace otro rol.
- El paso 05 verifica citas, no niveles: un nivel mal puesto solo lo caza
  el revisor del paso 04.
- Una ejecución no está completa hasta que el paso 05 pasa y el paso 06
  escribe el informe.
- El orquestador (`fabrica.sh`) se detiene con código 2 cuando falta la
  salida de un paso de agente, y retoma con el mismo id de ejecución.

## Niveles de evidencia

A demostrado (verificado de primera mano), B secundario estable (fuente
independiente citada), C afirmación del creador (sin verificación
independiente), X retractado (con motivo y fecha). Definiciones completas
en `cerebro/niveles-evidencia.md`.
