# fabrica-videos — destilación de vídeos educativos

Segundo ejemplo del kit: una fábrica que convierte un vídeo educativo en
un documento de método estructurado con su registro de evidencias. La
entrada es un archivo de subtítulos (VTT); la salida es un destilado
usable sin ver el vídeo, donde cada afirmación lleva su cita y su nivel
de evidencia (A demostrado, B secundario estable, C afirmación del
creador, X retractado).

El primer ejemplo del kit trabaja con errores de producción; este trabaja
con conocimiento en vídeo. Con dos ejemplos, el kit deja de ser un solo
caso para ser un método con dos demostraciones.

## Probar que funciona

Desde esta carpeta:

```sh
bash prueba-todo.sh
```

La prueba de humo (`prueba-pasos.sh`) corre los pasos de código sobre un
fixture de 6 cues reales y comprueba: 6 segmentos normalizados, el
registro bueno aceptado (2 afirmaciones, 0 fallos) y el registro roto
rechazado (3 afirmaciones, 3 fallos). Si el verificador aceptara el
registro roto, la prueba se declara vacua y falla. No necesita agente,
red ni API; solo `python3`.

## Destilar un vídeo

```sh
bash fabrica.sh entrada.vtt
```

La fábrica crea `runs/<id>/`, normaliza la transcripción (paso 01) y se
detiene en cada paso de agente diciendo qué archivo hay que producir.
Cuando el archivo existe, se vuelve a correr con el mismo id y retoma:

```sh
bash fabrica.sh entrada.vtt 2026-11-23-1700-a1f3
```

El código de salida 2 significa «espera al agente»; 0 significa
«ejecución completa». Los pasos de agente (02, 03, 04) están descritos en
`pasos/`.

## La ejecución de muestra

`runs/2026-11-23-demo-lY7fvJ6yPAI/` trae una destilación completa y real:
el vídeo «Adiós a las transcripciones: Cómo hacer que la IA analice
vídeos completos» (CenteIA Education, 11:16). 18 afirmaciones: 8 A, 0 B,
10 C, 0 X. La entrada está en `entrada-muestra/` (el VTT y la ficha de la
fuente). La transcripción normalizada de la muestra conserva el ajuste de
línea original; el paso 01 emite un segmento por línea.

## Mapa de archivos

- `PLANO.md` — el plano de la fábrica: pasos, entradas y salidas.
- `AGENTS.md` — notas para el agente que opera la fábrica.
- `MEJORAR.md` — registro de mejoras.
- `pasos/` — 01 normalizar (código), 02 extraer afirmaciones (agente),
  03 clasificar y destilar (agente), 04 revisar (agente),
  05 verificar citas (código), 06 empaquetar (código), `informe.md`.
- `cerebro/` — qué es una buena destilación, niveles de evidencia,
  contexto, lecciones y ejemplos de destilación buena y mala.
- `fixtures/` — 6 cues reales del vídeo de muestra y dos registros (uno
  bueno, uno roto) para la prueba de humo.
- `entrada-muestra/` — el VTT completo del vídeo de muestra y su ficha.
- `runs/` — ejecuciones; la de muestra está versionada a propósito.
- `herramientas/` — nota sobre la telemetría (el ejemplo registra los
  pasos en `eventos.log`, sin herramienta adicional).

## Notas

- La fábrica no descarga vídeos ni llama a ninguna API. La obtención de
  la transcripción es trabajo previo de quien la usa.
- La fábrica no mira los fotogramas: trabaja solo con la transcripción.
  Lo que solo se muestra en pantalla y no se dice no entra en el
  destilado.
- Tras clonar, los scripts pueden llegar sin permiso de ejecución; las
  pruebas se invocan con `bash` y no dependen del bit +x.
