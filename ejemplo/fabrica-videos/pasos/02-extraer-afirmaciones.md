# Paso 02 — extraer afirmaciones (agente)

Entrada: `transcripcion-normalizada.txt` de la ejecución.
Salida: `afirmaciones.json` en la ejecución.

## Qué hacer

Lee la transcripción completa y extrae las afirmaciones del vídeo que
importan: ideas del método, pasos, cifras, ejemplos y casos de uso. Una
afirmación por entrada. No clasifiques todavía (eso es el paso 03).

## Formato de salida

```json
{
  "fuente": "<título — canal, duración>",
  "paso": "02-extraer-afirmaciones (extracción sin clasificar; el nivel lo pone el paso 03)",
  "afirmaciones": [
    {
      "id": "A01",
      "texto": "La afirmación, en una frase, con tus palabras.",
      "cita": {
        "inicio_s": 12,
        "fin_s": 21,
        "texto": "fragmento literal de la transcripción"
      }
    }
  ]
}
```

## Reglas

- `id`: correlativo con prefijo provisional (A01, A02…); el paso 03 puede
  renumerar al clasificar, pero los ids no se reutilizan.
- `cita.texto`: fragmento LITERAL de la transcripción, copiado tal cual
  (incluidos los errores de la transcripción automática). El paso 05 lo
  buscará en el texto normalizado: si lo reescribes, la verificación falla.
  Preferir fragmentos dentro de un solo segmento: así la cita se comprueba
  también a mano en el `.txt`, donde las marcas `[HH:MM:SS]` interrumpen
  los fragmentos que cruzan de un segmento a otro.
- `cita.inicio_s` / `fin_s`: segundos del segmento donde aparece el
  fragmento (las marcas `[HH:MM:SS]` de la transcripción normalizada).
  `inicio_s < fin_s` y `fin_s` dentro de la duración del vídeo.
- Una afirmación, un fragmento. Si una idea se apoya en dos momentos, cita
  el principal y anota el otro en el paso 03.
- No inventes cifras, marcas de tiempo ni citas. Si algo no está en la
  transcripción, no entra aquí.
- Marca en `texto` los nombres propios tal cual los dice el vídeo; si la
  transcripción automática los deforma (nombres de herramientas, personas),
  déjalo así y anótalo: el paso 03 lo resuelve contra la descripción del
  vídeo.
