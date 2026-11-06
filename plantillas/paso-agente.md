# Paso <NN> · <nombre>

**Rol:** <una frase: qué operario eres. Ej.: «Eres el revisor de código. No implementas: revisas y devuelves».>

## Lee antes de empezar
- `AGENTS.md` y lo que indica (que-es-bien, contexto, lecciones)
- <otros ficheros que necesite este paso>

## Entrada
<Qué recibes y dónde está. Ej.: `$FABRICA_RUN/clasificacion.json`.>

## Qué haces
1. <…>
2. <…>

## Salida
<Qué produces, dónde y en qué formato exacto. Ej.: `$FABRICA_RUN/revision.json` con `{"veredicto": "OK" | "DEVOLVER", "motivos": [...]}`.>

## Comprobación
<Qué tiene que cumplir tu salida. Si no puedes cumplirlo, termina con error y explica el motivo en la última línea.>

## Telemetría
- Cada decisión que tomes por tu cuenta: `python3 herramientas/obs.py nota "$FABRICA_RUN" <nombre> "…"`
- Si algo debe esperar el OK de la persona: añade `--tipo espera-ok`
- No apuntes métricas: las cuenta el código.
- Si no puedes completar el paso, la última línea de tu salida empieza por `FALLO:` y dice el motivo.
