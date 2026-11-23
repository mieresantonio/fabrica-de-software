# Contexto de la fábrica

Esta fábrica convierte un vídeo educativo en un documento de método
estructurado con su registro de evidencias: qué dice el vídeo, con qué
cita y con qué nivel de evidencia.

## Entrada

Un archivo de subtítulos (VTT) ya obtenido. La fábrica no descarga vídeos
ni llama a ninguna API: la obtención de la transcripción es trabajo previo
de quien la usa.

## Salida

Por cada ejecución, en `runs/<id>/`:

- `transcripcion-normalizada.txt` — la transcripción por segmentos, con
  marcas de tiempo.
- `afirmaciones.json` — las afirmaciones extraídas (paso 02).
- `registro-evidencias.json` — las afirmaciones clasificadas A/B/C/X
  (paso 03).
- `DESTILADO.md` — el documento de método (paso 03).
- `revision.json` — el veredicto del revisor (paso 04).
- `informe.md` — recuentos de la ejecución (paso 06).

## Qué no hace

- No verifica las afirmaciones del creador contra fuentes externas (eso
  sería subirlas a B, y es trabajo opcional, no de la línea base).
- No mira los fotogramas del vídeo: trabaja solo con la transcripción.
  Lo que solo se muestra en pantalla y no se dice no entra en el destilado.
- No opina sobre si el método del vídeo es bueno: destila lo que dice,
  con su evidencia, y deja el juicio a quien lee.
