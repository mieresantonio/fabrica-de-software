# Mejorar la fábrica

Úsalo cuando algo salga mal o un resultado no convenza. Basta con decirle al agente: «mejora la fábrica con lo que pasó en la última ejecución» (o en `runs/<id>`).

## 1. Mira los datos antes de opinar
- `python3 herramientas/obs.py resumen`: qué paso falla, tarda o reintenta más en las últimas ejecuciones.
- `python3 herramientas/obs.py ver runs/<id>`: la cronología de la ejecución concreta.
- `runs/<id>/logs/<paso>.log` del paso sospechoso, y `runs/<id>/informe.md`.

## 2. Encuentra LA pieza
Responde por escrito, en una frase: **¿qué paso produjo el fallo y por qué?** Suele ser una de estas causas:
- **Faltaba contexto.** El paso no tenía la información que necesitaba: arregla `cerebro/contexto.md` o el paso de sincronización.
- **Instrucciones ambiguas.** Arregla el fichero del paso en `pasos/`.
- **El revisor no lo vio.** Falta un criterio en la rúbrica de `cerebro/que-es-bien.md`.
- **Lo podía hacer código.** Convierte ese trozo del paso de agente en un script.
- **Comprobación que no comprueba.** Endurécela para que pare la cadena.

## 3. Arregla solo esa pieza
- No toques lo que funciona.
- Un commit con el arreglo, con un mensaje que diga qué falló.

## 4. Apunta la lección
Añade una entrada arriba del todo de `cerebro/lecciones.md`, con su formato: qué pasó, la regla y cómo se comprueba.

## 5. Compruébalo
Vuelve a pasar por la fábrica la misma materia prima que falló. Si ahora sale bien, compara con `obs.py resumen` dentro de unas cuantas ejecuciones, para confirmar que el fallo no vuelve.

## Señales de que hay que mejorar aunque nada haya «fallado»
- **Un paso reintenta mucho:** sus instrucciones o su contexto son flojos.
- **Un paso tarda o cuesta mucho más que el resto:** divídelo o pásalo a código.
- **Se repiten las mismas notas de tipo «decision»:** esa decisión debería estar escrita en el cerebro.
- **La persona retoca a mano el resultado siempre en el mismo sitio:** falta un criterio en `que-es-bien.md`.
