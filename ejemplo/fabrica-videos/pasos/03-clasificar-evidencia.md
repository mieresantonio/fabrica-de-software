# Paso 03 — clasificar por evidencia y destilar (agente)

Entrada: `afirmaciones.json` de la ejecución, `fuente.json`,
`transcripcion-normalizada.txt`.
Salida: `registro-evidencias.json` y `DESTILADO.md` en la ejecución.

## Qué hacer

1. Clasifica cada afirmación con un nivel de evidencia (ver
   `cerebro/niveles-evidencia.md`): A demostrado, B secundario estable,
   C afirmación del creador, X retractado.
2. Escribe el documento destilado (`DESTILADO.md`): el método del vídeo en
   forma estructurada, usable sin ver el vídeo.

## Formato del registro

Como `afirmaciones.json`, añadiendo a cada afirmación `nivel` y `notas`, y
un bloque `niveles` con las definiciones y un `resumen` con el recuento
por nivel. El `resumen` debe cuadrar con las afirmaciones listadas.

## Reglas de clasificación

- A solo para lo verificado de primera mano en la fuente: el contenido del
  propio vídeo (transcripción, descripción, capítulos) o una comprobación
  hecha por ti.
- C para todo lo que solo el creador afirma: cifras de audiencia, tiempos,
  costes, porcentajes y superlativos sin fuente citada.
- B solo con una fuente secundaria independiente citada en `notas`. Si no
  la hay, es C, no B.
- X solo con motivo y fecha de retractación en `notas`. Si nada se
  retractó, X queda en 0 y se dice así.
- En caso de duda entre dos niveles, el más bajo (más exigente con la
  evidencia).

## Reglas del destilado

- Estructura: idea en una frase, cómo funciona, pasos o método, casos de
  uso, coste (si lo hay), y una sección «Lo que este destilado NO afirma»
  con los niveles C que alguien podría leer como hechos.
- Cada afirmación del documento remite a su id del registro (`[A01]`).
- Los nombres propios se escriben correctos en el documento; si la
  transcripción los deformó, la nota va en el registro, no en el texto.
- El documento no afirma nada que no esté en el registro.
