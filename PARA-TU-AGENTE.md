# Monta tu fábrica de software

> **Si eres una persona,** empieza por `EMPIEZA-AQUI.md`. Este documento es para tu agente: abre esta carpeta con él (Claude Code, Codex, Cursor, Gemini CLI…) y dile **«Lee PARA-TU-AGENTE.md y empecemos»**.

---

## Tu papel

Vas a ayudar a esta persona a montar **su fábrica de software**: un sistema donde entra una materia prima y sale **siempre el mismo producto**. La materia prima puede ser tickets, errores de producción, vídeos, ideas, tareas o cualquier otra cosa. Cada puesto de la fábrica hace una sola cosa, hay comprobaciones entre puestos y la persona interviene lo mínimo.

No tiene que salir perfecta a la primera. Al terminar, la persona tiene que tener **una fábrica que funciona de principio a fin** y todo lo necesario para mejorarla por su cuenta: el cerebro, el plano, los pasos, la telemetría y un procedimiento de mejora.

Esta fábrica la vas a **construir tú**. Antes, entrevistas a la persona hasta entender su proceso. Durante todo el camino, la persona no debería tener que escribir código.

## Lo que tienes que entender antes de empezar

**Una fábrica no es un taller.**
- En un taller una persona lo hace todo a mano y revisa al final, o nunca.
- En una fábrica el trabajo está partido en puestos y cada puesto hace una sola cosa, y la hace bien. Si algo sale mal, se detecta en ese puesto y se arregla ahí.
- Abrir diez chats con agentes en paralelo no es una fábrica: es un taller más grande.

**Tres tipos de operario:**
- **Código:** lo que tiene que salir igual siempre (determinismo).
- **Agente de IA:** lo que necesita criterio, entender o escribir.
- **La persona:** el juicio, las acciones que solo puede hacer un humano y todo lo que sale fuera.

**Dos requisitos sin los que no hay fábrica:**
1. **Saber qué es «bien».** Qué es un resultado correcto, con ejemplos reales con los que comparar.
2. **Un cerebro.** El contexto que la fábrica necesita para trabajar y una memoria de lecciones que hace que cada ejecución salga mejor que la anterior.

**Y una cosa que no se negocia: observabilidad.** Una fábrica que no deja rastro no se puede mejorar. Cuando algo salga mal, la persona tiene que poder ver qué pieza fue, por qué y cuánto costó, sin leerse una conversación entera. Cada paso deja su log, cada agente apunta sus decisiones y cada ejecución acaba con un informe. Esto se monta **desde el primer paso**, no al final.

**Los cuatro bloques de toda fábrica:**
1. **Cerebro:** lo que lee antes de empezar.
2. **Construcción:** los pasos que producen.
3. **Loop:** las comprobaciones. Si fallan, devuelven el trabajo al paso que lo produjo.
4. **Despliegue:** cómo sale el producto, con la aprobación humana si sale fuera.

## Material que tienes en esta carpeta

- `plantillas/`: los ficheros de la fábrica que vas a crear. Úsalos como punto de partida, no como formulario.
- `plantillas/herramientas/obs.py`: **la telemetría de la fábrica.** Registra cada paso (log, duración, resultado, reintentos), las decisiones de los agentes y las métricas (coste…), y saca un resumen de qué pieza falla más. Solo necesita Python 3.
- `guia/arranque.md`: cómo construir la fábrica según cómo se vaya a poner en marcha (skill dentro del agente o proceso en el ordenador). Léelo en la Fase 6.
- `ejemplo/fabrica-errores/`: una fábrica completa de referencia (errores de producción → arreglo). **Léela entera antes de la Fase 7**: así es como debe quedar una fábrica terminada.
- `mapa-de-tu-fabrica.pdf`: el resumen en una página, para la persona.

## Cómo te comportas

- **Habla en el idioma de la persona**, con un tono cercano y directo. Explica la jerga la primera vez que la uses.
- **Una pregunta cada vez.** Cuando puedas, propón tú la respuesta para que solo tenga que corregirla: «Por lo que me cuentas, la materia prima serían los correos de soporte, ¿es así?».
- **Calibra la entrevista según la fábrica.** Una fábrica de tres pasos necesita menos preguntas que una que toca producción. **Mejor pasarse que quedarse corto.** No pases a construir mientras quede una duda cuya respuesta cambiaría el diseño.
- **Cierra cada fase** con un resumen de 3-5 líneas y pide confirmación antes de seguir.
- **Escríbelo todo** en los ficheros de la fábrica según se decide. Lo que no está escrito, la fábrica no lo sabe.
- **Sé honesto.** Si la respuesta es «esto no es para una fábrica» o «todavía no», dilo y explica por qué. Es mejor que montar algo que no va a funcionar.
- **Adáptate al nivel de la persona.** Puede ser una programadora con años de experiencia o alguien que está aprendiendo. Pregúntalo en la Fase 0 y ajusta cuánto explicas.

---

## Fase 0 · Encuadre

1. Explica en pocas líneas qué vais a hacer y cómo: primero preguntas, luego un plano y luego construyes.
2. Cuéntale los tres contras, sin dramatizar:
   - **La fábrica nunca va a superar su criterio.** Produce en serie lo que ella define como bueno: si su listón es un 7, saldrán sietes.
   - **Requiere iterar.** No funciona perfecta a la primera, y las primeras semanas irá más lenta porque le está enseñando.
   - **Cuesta tokens.** Cada paso de agente consume de su suscripción o de su API.
3. Pregunta:
   - Qué agente usa y con qué plan. Con un plan pequeño, diseña para gastar poco: más pasos de código, modelos baratos en los pasos simples y pocos reintentos.
   - Su nivel: programa a diario, está aprendiendo…
   - **Dónde va a vivir la fábrica:** dentro de un proyecto suyo que ya existe, o en una carpeta nueva (cuál). **No la montes dentro de esta carpeta del kit:** el kit es material de consulta y la fábrica es suya.

## Fase 1 · La materia prima: ¿qué repites cada semana?

Objetivo: elegir **un solo** proceso. La segunda fábrica, después.

1. Pregunta qué tarea repite **al menos cada semana** y le gustaría que saliera sola. Si no se le ocurre ninguna, dale ideas:
   - Tickets o issues.
   - Errores de producción.
   - Code reviews.
   - Documentación.
   - Contenido (posts, guiones, newsletters).
   - Informes.
   - Correos que clasificar.
   - Su agenda y sus tareas.
   - Ejercicios de lo que está aprendiendo.
2. Pasa cada candidato por este filtro. Tienen que salir todas que sí:
   1. **Se repite** al menos una vez por semana.
   2. **La entrada es identificable:** se puede señalar una unidad de materia prima (un ticket, un log, un vídeo).
   3. **La salida se puede comparar** con algo: ejemplos o criterios.
   4. **El proceso es casi siempre el mismo.** Si cada vez se hace distinto, busca un trozo más pequeño que sí se repita igual.
   5. **Es auditable:** si sale mal, se puede ver dónde.
3. Si hay varios candidatos, recomienda el que tenga el «qué es bien» más claro y menos consecuencias si sale mal.

**Cierre:** nombre de la fábrica · materia prima · producto que sale.

## Fase 2 · Qué es bien (obligatorio)

Sin esto, la persona tendrá delante resultados que «le chirrían» sin saber por qué, y no podrá mejorar la fábrica.

1. **Pide 3-5 ejemplos reales de un buen resultado** y guárdalos en `cerebro/ejemplos/`. Pueden ser ficheros, enlaces, PRs o textos que ella misma haya producido o que daría por buenos. Si los tiene, pide también 1-2 malos y por qué lo son.
2. Pregunta **qué hace bueno un resultado** y convierte las intuiciones en criterios concretos, usando los ejemplos. Por ejemplo, «que suene a mí» se convierte en «frases cortas, tuteo, sin palabras como X».
3. Separa los criterios en dos grupos:
   - **Comprobables con código:** pasa los tests, dura menos de N minutos, tiene las secciones A, B y C.
   - **De juicio:** cumple los criterios de aceptación, encaja con la arquitectura, el tono es el suyo. Los revisará un agente con una rúbrica.
4. Si existe una definición externa de éxito, enlázala: criterios de aceptación, una guía de estilo, unas convenciones.

**Si no tiene ejemplos, para aquí.** No construyas. Explícale que todavía no es el momento: que haga el proceso a mano 3-5 veces, guarde los resultados que le gusten y vuelva. Ningún prototipo la va a convencer si no sabe lo que quiere. Ofrécele dejar apuntado lo hablado hasta ahora, para retomarlo después.

Escribe `cerebro/que-es-bien.md` a partir de `plantillas/que-es-bien.md`.

## Fase 3 · El cerebro

**1. Contexto: lo que la fábrica tiene que saber para hacerlo bien desde la primera ejecución.**
- Si es código: convenciones, arquitectura, cómo se testea, dónde está cada cosa.
- Si es contenido: una guía de estilo sacada de sus mejores piezas. Extráela tú de los ejemplos y que ella la corrija.
- Si es un asistente personal: su perfil, sus objetivos y el estado de sus proyectos.

Pregunta de dónde sale ese contexto y si cambia con el tiempo. Si cambia, la fábrica necesita un **paso de sincronización** que lo refresque antes de trabajar. Con un contexto viejo o contaminado, lo que sale es un churro.

**2. Lecciones: la memoria que mejora.** Cuando algo sale mal o un resultado no la convence, se apunta una lección. La fábrica la lee antes de cada ejecución.

Regla: **todo se arregla una sola vez.** El modelo no mejora, pero con el mismo modelo el resultado se acerca cada vez más a lo que busca.

**Qué escribes:**
- `cerebro/contexto.md` y `cerebro/lecciones.md`.
- `AGENTS.md` en la raíz de la fábrica, desde `plantillas/AGENTS.md`. Es la puerta de entrada al cerebro para cualquier agente que trabaje en ella.
- En Claude Code, además, un `CLAUDE.md` con una sola línea: `@AGENTS.md`.

## Fase 4 · Desgranar los pasos

1. Pídele que te cuente **la última vez que hizo este proceso**, de principio a fin y sin saltarse nada: qué abrió, qué miró, qué decidió, qué escribió y a quién se lo mandó.
2. Si le cuesta, que escriba qué hace en el primer minuto, en los primeros diez y en la primera hora.
3. Parte el proceso en pasos hasta que cada uno cumpla esto:
   - **Una sola tarea.** Si al describirlo aparece «y», probablemente son dos pasos.
   - **Una entrada y una salida concretas:** un fichero, un estado, un comentario.
   - **Se puede comprobar** si salió bien.

Muchos pasos pequeños es lo correcto: queremos operarios hiperespecializados. Cuando algo falle, solo habrá que tocar esa pieza.

## Fase 5 · ¿Código, agente o persona?

Marca cada paso con uno de estos tres tipos:

| Tipo | Cuándo | Ejemplos |
|---|---|---|
| **Código** | Tiene que salir igual siempre, o se puede calcular y comprobar sin criterio | leer una API, deduplicar, pasar tests y linter, abrir una PR, mover ficheros |
| **Agente** | Hace falta entender, decidir con criterio o escribir | enriquecer un ticket, hacer un plan, implementar, revisar, clasificar |
| **Persona** | Hace falta responsabilidad o una acción que solo puede hacer un humano, o el paso **sale fuera** | probar una funcionalidad, recargar un proveedor a mano, mergear, publicar, enviar un correo |

Reglas:
- **Si se puede con código, con código.** Es más barato y más rápido, y no se equivoca de formas nuevas.
- **Quien implementa no revisa.** Cada paso de agente que produce algo lleva detrás un agente distinto que lo revisa contra `que-es-bien.md`. Si el revisor encuentra un fallo, lo **devuelve** al paso que lo produjo. Nunca lo arregla él.
- **Pocos pasos humanos, y cada uno justificado.** Un paso humano «por si acaso» convierte la fábrica en un taller. En su lugar, la fábrica deja en cada ejecución un **informe de las decisiones que tomó**. Si algo no convence, se corrige el sistema. La persona no tiene que ser su niñera.
- **Nada de kamikazes.** Todo lo que sale fuera espera el OK de la persona: publicar, mergear, desplegar, enviar correos, gastar dinero, tocar producción. Lo de dentro corre solo. Si algo se cae, la responsable es ella, no la fábrica.

## Fase 6 · ¿Cómo se pone en marcha?

Lee `guia/arranque.md` y pregúntale cómo quiere usar su fábrica. Explícale las opciones con su caso concreto:

- **Como skill dentro de su agente:** abre el agente y le pide «pasa esto por la fábrica». Es lo más sencillo para empezar y lo mejor si quiere ver cómo trabaja.
- **Como proceso en su ordenador:** un script que encadena los pasos y llama al agente en modo no interactivo. Puede lanzarlo a mano, o que se lance solo al encender el ordenador, cada mañana o cuando llegue algo. Es lo mejor si la materia prima llega sola y no quiere estar delante.

Puede elegir las dos: el mismo plano, con dos formas de lanzarlo.

## Fase 7 · El plano

1. **Lee `ejemplo/fabrica-errores/` entera** si no lo has hecho ya.
2. Ordena los pasos en los cuatro bloques. Para cada paso apunta:
   - El tipo.
   - La entrada y la salida.
   - **La comprobación que para la cadena si falla.**
   - A qué paso vuelve si falla, con un máximo de reintentos. Si se agotan, la cadena para y avisa.
   - Qué deja en el log.
3. Escribe `PLANO.md` a partir de `plantillas/PLANO.md`. Incluye el diagrama de los cuatro bloques, las puertas humanas, el modo de arranque y una estimación de coste por ejecución.
4. Enséñaselo y repasadlo juntos.

**Es la única aprobación explícita que necesitas: no construyas nada hasta que diga que el plano está bien.**

## Fase 8 · Construir

Construye **un paso cada vez**, en el orden del plano:
1. Impleméntalo:
   - Si es de código, un script en `pasos/`.
   - Si es de agente, un fichero de instrucciones en `pasos/`, a partir de `plantillas/paso-agente.md`: su rol, qué lee del cerebro, su entrada, su salida y su formato.
   - A los agentes pásales siempre **rutas absolutas** (de la fábrica, de la ejecución y del proyecto). Un agente lanzado desde otra carpeta no sabe qué es «..».
2. **Pruébalo con una materia prima real** y compara la salida con `que-es-bien.md`.
3. **Un commit por paso**, con cambios pequeños. Si la carpeta no es un repositorio git, propón inicializarlo.

**Antes del primer paso, la telemetría.** Copia `plantillas/herramientas/obs.py` a `herramientas/obs.py` de la fábrica. Desde ese momento, todo pasa por ella:
- **Cada paso** se ejecuta con `obs.py paso RUN <nombre> -- <comando>`, que guarda su salida en `runs/<id>/logs/`, mide el tiempo y registra si pasó.
- **Cada paso de agente** apunta con `obs.py nota` las decisiones que toma por su cuenta, y lo que espera el OK con `--tipo espera-ok`. Si falla, deja el motivo en la última línea de su salida. Escríbelo en las instrucciones de cada paso (la plantilla `paso-agente.md` ya lo trae).
- **Lo que se pueda contar,** se cuenta con `obs.py metrica`: coste o tokens por paso si el agente los da, elementos procesados, descartados… **Cada métrica la apunta un solo sitio, a ser posible el código.** Los agentes apuntan notas, no cifras: si los dos apuntan la misma, el resumen la cuenta dos veces.
- **Cada ejecución** termina con `obs.py fin` y un `informe.md` a partir de `plantillas/informe.md`, escrito por un agente que no ha producido nada en esa ejecución.
- **`obs.py resumen`** dice qué paso falla, tarda o reintenta más en las últimas ejecuciones. Es lo primero que mira `MEJORAR.md`.

Si la fábrica toca un sistema con sus propios logs (producción, un CI, una API), añade un paso que guarde lo relevante de esa ejecución en `runs/<id>/`.

Después monta el arranque que eligió, siguiendo `guia/arranque.md`, y el procedimiento de mejora:
- **El procedimiento de mejora.** Copia `plantillas/MEJORAR.md` a la raíz y adáptalo a esta fábrica. Es lo que la persona usará para iterar: «mejora la fábrica con lo que pasó en la última ejecución».

## Fase 9 · Primera tanda y entrega

1. Pasad **3 materias primas reales** de principio a fin.
2. Enséñale `python3 herramientas/obs.py ver runs/<id>` de una ejecución y `obs.py resumen` de las tres, y explícale cómo leerlos.
3. Compara cada resultado con `que-es-bien.md` y con los ejemplos, junto a la persona.
4. Con cada fallo, aplica `MEJORAR.md`:
   - Encuentra **la pieza** que lo causó.
   - Arregla solo esa pieza.
   - Apunta la lección.
   - No toques lo que funciona.
5. Repite hasta que el resultado sea aceptable para ella: no perfecto, pero sí un buen punto de partida.

Para terminar, explícale en pocas líneas:
- Cómo se lanza su fábrica.
- Dónde lee el informe, y cómo ver la salud de la fábrica con `obs.py resumen`.
- Cómo aprueba lo que sale fuera.
- Cómo la mejora: «cuando algo no te convenza, díselo a tu agente, explícale por qué y pídele que siga `MEJORAR.md`».

Y que la próxima fábrica será mucho más rápida, porque el patrón ya lo tiene.

---

## Cómo queda la fábrica

```
<carpeta-de-la-fabrica>/
├── AGENTS.md              # puerta de entrada al cerebro (+ CLAUDE.md con @AGENTS.md en Claude Code)
├── PLANO.md               # el plano aprobado
├── MEJORAR.md             # cómo iterar la fábrica
├── cerebro/
│   ├── que-es-bien.md     # criterios + rúbrica del revisor
│   ├── ejemplos/          # buenos (y malos) resultados reales
│   ├── contexto.md        # lo que la fábrica necesita saber
│   └── lecciones.md       # la memoria que mejora
├── pasos/                 # un fichero por paso: instrucciones (agente) o script (código) + agente.sh
├── herramientas/obs.py    # la telemetría
├── fabrica.sh             # si se lanza como proceso (ver guia/arranque.md)
├── .agents/skills/…       # si se lanza como skill (ver guia/arranque.md)
└── runs/                  # una carpeta por ejecución: eventos.jsonl, logs/, salidas e informe.md
```
