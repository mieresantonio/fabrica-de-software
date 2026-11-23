# Destilado: Adiós a las transcripciones — cómo hacer que la IA analice vídeos completos

Fuente: CenteIA Education, Jordi Segura, 31 jul 2026, 11:16 (676 s).
URL: https://www.youtube.com/watch?v=lY7fvJ6yPAI
Registro de evidencias: `registro-evidencias.json` (18 afirmaciones: 8 A, 0 B, 10 C, 0 X).
Cada afirmación del documento remite a su id en el registro.

## La idea en una frase

Un vídeo son fotogramas + audio; la mayoría de herramientas solo leen la
transcripción y pierden todo lo que pasa en pantalla. Una skill gratuita
para agentes (Codex, Claude Code) descompone el vídeo en fotogramas y
transcripción sincronizada por tiempo, de modo que el agente responde qué
se dice Y qué se muestra [A01].

## Cómo funciona

- La skill extrae fotogramas cada pocos segundos y los combina con la
  transcripción, con el tiempo sincronizado [A01].
- Con eso se le puede preguntar al agente qué sucede en un minuto concreto,
  si aparece una gráfica o qué dice el ponente [A01].
- El ejemplo del vídeo: una conferencia de Sam Altman sobre startups, donde
  sin los frames se perderían los datos y las gráficas en pantalla [A01].

## Instalación

- La skill es pública en GitHub; el enlace está en la descripción del
  vídeo [A02].
- Se instala pidiéndole al agente que la instale con sus dependencias
  [A02]. El presentador dice que lleva 5 minutos [C04].
- Herramientas que usa: yt-dlp (descargar el vídeo), FFmpeg/FFprobe
  (extraer fotogramas) y Whisper vía Groq para transcribir vídeos sin
  subtítulos (Loom, grabaciones de pantalla, Reels) [A03].
- Para vídeos de YouTube con subtítulos, la skill toma la transcripción
  directamente y no hace falta transcribir [A03].
- Para Groq hace falta una clave API (nivel gratuito); tras instalar, hay
  que reiniciar el agente para que detecte la skill [A02, C05].

## Uso

- Comando: `/watch` seguido de la URL del vídeo [A04].
- Si el vídeo tiene subtítulos, funciona sin más; si no, pide la clave de
  Groq [A04].

## Caso de uso 1: análisis de competencia

- Tomar un vídeo que funciona en tu sector y pedir al agente qué sucede en
  los primeros 30 segundos, cómo es el hook, qué hay en pantalla y en qué
  segundo entra el patrón de interrupción [A05].
- Demostración del vídeo: un vídeo de NotebookLM; el agente analiza los
  primeros 15 segundos (hook, b-roll, interfaz, patrón «noticia
  infravalorada, contradicción, promesa de sistema») y señala qué podría
  debilitarlo [A05].

## Caso de uso 2: segundo cerebro en Obsidian

- Convertir charlas largas en notas estructuradas en Obsidian: dos
  conferencias de Sam Altman (48 y 16 minutos) como ejemplo [A06].
- La nota pedida incluye título, resumen, hook, estructura, ideas clave y
  por qué el vídeo funciona o es interesante [A07].
- Las notas en Markdown quedan relacionadas por etiquetas en Obsidian: ese
  es el «segundo cerebro» [A06, A07].

## Coste (declarado por el creador, no verificado)

- La transcripción de YouTube es gratuita; Groq cubre la transcripción de
  vídeos sin subtítulos dentro de su plan gratuito [C03, C05].
- La skill escala los fotogramas con la duración y topa en 100 frames a
  partir de 30 minutos, así que un vídeo de 30 minutos y uno de 2 horas
  cuestan prácticamente lo mismo: alrededor de 1 euro por sesión [C03, C06].
- El presentador dice llevar 2 semanas de uso diario sin salir del plan
  gratuito de Groq [C09].

## Lo que este destilado NO afirma

- No se verificó ningún tiempo declarado (45 min en 90 s [C01]; dos
  charlas en 3 min [C08]; instalación en 5 min [C04]): son cifras del
  creador, en pantalla, sin medición independiente.
- No se verificó el coste (~1 € por sesión [C03]) ni el tope de 100 frames
  [C06]: no se leyó el código de la skill ni se probó.
- No se verificaron las cifras de audiencia del canal [C07].
- El «90% de las herramientas» [C02] y los superlativos sobre yt-dlp y
  FFmpeg [C10] son afirmaciones del creador sin fuente citada.

## Nota sobre la fuente

La transcripción es automática y confunde nombres propios: escribe
«Centella» por CenteIA, «Grok» por Groq y «Cloud» por Claude Code [A08].
También renderiza «/watch» como «{guion} watch {barra} watch» [A04]. Las
citas del registro usan el texto tal cual aparece en la transcripción; el
documento escribe los nombres correctos, verificados contra la descripción
del vídeo.
