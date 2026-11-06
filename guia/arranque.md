# Cómo se pone en marcha la fábrica

Hay dos formas. Pregúntale a la persona cuál quiere, explicándoselas con su caso concreto. Puede elegir las dos: el plano y los pasos son los mismos, y lo único que cambia es quién orquesta.

| | Skill dentro del agente | Proceso en el ordenador |
|---|---|---|
| **Cómo se lanza** | Abre su agente y le pide «pasa esto por la fábrica» | `./fabrica.sh <entrada>`, a mano o de forma programada |
| **Quién orquesta** | El agente, con un subagente por paso | Un script que llama al agente en modo no interactivo |
| **Ideal para** | Empezar, ver cómo trabaja, materia prima que trae ella | Materia prima que llega sola, que corra sin estar delante |
| **Ejemplos** | Editar un vídeo cuando lo grabas, revisar un PR cuando lo pides | Un parte cada mañana al encender el ordenador, revisar errores cada hora |

En los dos casos **todo paso pasa por `herramientas/obs.py`**. Copia `plantillas/herramientas/obs.py` a `herramientas/obs.py` de la fábrica antes de construir el primer paso.

## A · Como skill

1. Copia `plantillas/arranque/SKILL.md` a la carpeta de skills de su agente y rellénalo:
   - **Claude Code:** `.claude/skills/<nombre>/SKILL.md` en el proyecto, o `~/.claude/skills/<nombre>/` para tenerla en todos.
   - **Codex:** `.agents/skills/<nombre>/SKILL.md` en el proyecto.
   - **Otros agentes:** si admiten skills (el formato `SKILL.md` con `name` y `description` es estándar), en su carpeta de skills. Si no, añade a `AGENTS.md` una sección «Cuando te pidan "pasa X por la fábrica"» con el mismo contenido.
2. Si su agente tiene **subagentes**, cada paso de agente va en un subagente distinto. Si no los tiene, el orquestador ejecuta los pasos uno a uno y vuelve a leer `pasos/<nombre>.md` al empezar cada uno, sin arrastrar lo que hizo en el paso anterior.
3. **Prueba:** abre el agente en la carpeta de la fábrica y lanza la skill con una materia prima real.

## B · Como proceso

1. Copia `plantillas/arranque/fabrica.sh` a la raíz de la fábrica y `plantillas/arranque/agente.sh` a `pasos/agente.sh`. Escribe los pasos del plano en el bloque marcado de `fabrica.sh`. Si la persona usa Windows sin WSL, escribe los dos en Python con la misma lógica.
2. **`agente.sh` lanza cada paso de agente en modo no interactivo.** Ya hace cuatro cosas:
   - Le pasa al agente rutas **absolutas** (fábrica, ejecución, proyecto).
   - Le da permisos mínimos.
   - Apunta el coste.
   - Falla si el agente toca el proyecto fuera de `runs/`.

   Viene para Claude Code (`claude -p`). Para otro agente, adapta su bloque «LLAMADA»: Codex `codex exec`, Gemini CLI `gemini -p`; para otro, busca en su documentación el modo «headless», «print» o «exec».
3. **Permisos.** En modo no interactivo el agente no puede preguntar, así que en `agente.sh` deja solo los permisos que necesita cada paso: leer, escribir en `runs/`, ejecutar los tests… **Nunca** des permisos para lo que sale fuera (push, tag, merge, desplegar, publicar, enviar). Eso lo hace un paso de código tras el OK de la persona, o la propia persona.
4. **Pruébalo antes de seguir.** Lanza un paso de agente sencillo y comprueba tres cosas:
   - Que encuentra los ficheros, por las rutas absolutas.
   - Que no le bloquea un permiso que sí necesita.
   - Que `obs.py ver` muestra su coste.
5. **Programarlo**, si la materia prima llega sola:
   - **macOS:** un `launchd` (`~/Library/LaunchAgents/<nombre>.plist`), con `RunAtLoad` para lanzarlo al iniciar sesión o `StartCalendarInterval` para una hora fija.
   - **Linux:** `cron` (`crontab -e`) o un timer de systemd.
   - **Windows:** el Programador de tareas.
   - Lo que se lance solo tiene que dejar el informe donde la persona lo vea: un fichero, una notificación o un correo **a ella misma**.
6. **Prueba:** `./fabrica.sh <una materia prima real>` y después `python3 herramientas/obs.py ver runs/<id>`.

## Observabilidad: no es opcional

Una fábrica sin telemetría no se puede mejorar: cuando algo sale mal, no sabes qué pieza fue. Antes de dar la fábrica por terminada, comprueba estas cuatro cosas:
- [ ] **Cada paso**, de código o de agente, se ejecuta a través de `obs.py paso`, o deja su `obs.py nota` si lo lanza un subagente.
- [ ] **Cada paso de agente** apunta sus decisiones con `obs.py nota` y, si falla, deja el motivo en la última línea.
- [ ] **Cada métrica la apunta un solo sitio,** a ser posible el código. Si la apuntan también los agentes, el resumen la cuenta dos veces.
- [ ] **Cada ejecución termina** con `obs.py fin` y un `informe.md`.
- [ ] **`python3 herramientas/obs.py resumen` muestra datos con sentido** tras la primera tanda de pruebas. Enséñaselo a la persona y explícale cómo leerlo: es lo primero que mira `MEJORAR.md`.

Si la fábrica toca un sistema con sus propios logs (producción, una API, un CI), añade un paso que guarde en `runs/<id>/` lo relevante de esos logs para esa ejecución, para tenerlo todo en un sitio.
