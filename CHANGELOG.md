# Historial de cambios

Historial de cambios de este repositorio, en formato [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/).

Fechas en **America/Caracas (UTC-4)**. GitHub muestra los commits nocturnos con
la fecha UTC del día siguiente; las fechas de aquí son las del huso horario del
autor y coinciden con las que citan los propios mensajes de commit. Cada entrada
cita el commit que la respalda (`git show <sha>`).

El repositorio aún no tiene versiones ni etiquetas, así que las secciones van
por fecha. Cuando se publique la primera versión, las secciones pasarán a
llevar su número (`## [0.1.0] - 2026-11-05`, por ejemplo).

## [Sin publicar]

### Añadido

- Integración continua (GitHub Actions): en cada push a `main` y en cada pull
  request se comprueba la sintaxis de todos los scripts (`.sh` con `bash -n`,
  `.py` con `py_compile`) y se corre la prueba de pasos de cada ejemplo
  (`.github/workflows/ci.yml`, un job por ejemplo).
- Este historial de cambios (`CHANGELOG.md`).
- Insignia de CI en el README, enlazada a los runs del workflow.
- Segunda fábrica de ejemplo: `ejemplo/fabrica-videos/`, que destila un
  vídeo educativo en un documento de método con su registro de evidencias
  (niveles A/B/C/X), con una destilación real de muestra (CenteIA, «Adiós
  a las transcripciones», 18 afirmaciones) y su prueba de humo.
- Sección «Verificar que todo funciona» en el README y puerta de entrada
  única `prueba-todo.sh` en el LEEME del ejemplo.

### Corregido

- Robustez del ejemplo y las plantillas: `obs.py` registra como fallo el
  comando no encontrado (código 127), avisa cuando la entrada parece una
  ruta inexistente y tolera líneas corruptas en `eventos.jsonl`; los pasos
  de código resuelven sus rutas desde su propio archivo; `fabrica.sh`
  comprueba que existe el proyecto y separa la devolución de tests y
  revisión en dos archivos; `agente.sh` avisa si el proyecto no es un
  repositorio git; `prueba-todo.sh` comprueba que las dos copias de
  `obs.py` coinciden; `.gitignore` ignora las ejecuciones salvo las
  muestras versionadas.

## 2026-11-16

### Añadido

- Prueba completa de principio a fin del ejemplo, suite centinela y
  `prueba-todo.sh` (`800a684`).
- Prueba de humo del ejemplo (`9dd4ab1`).
- Mapa visual del método en una página: `mapa-de-tu-fabrica.pdf` (`fec5d96`).

### Corregido

- `prueba-completa.sh` autosuficiente en un clon fresco: da permiso de
  ejecución a `fabrica.sh`, mensaje de fallo limpio y nota en el LEEME del
  ejemplo (`eac4a5a`).
- Correcciones de documentación: plano del ejemplo, guía de arranque y
  lecciones (`9dd4ab1`).

## 2026-11-10

### Añadido

- `.gitignore` (`3021b2c`).

### Corregido

- Corrección del paso 05 del ejemplo de la fábrica de errores (`3021b2c`).

## 2026-11-05

### Añadido

- Kit «Tu fábrica de software» (Jesús, de AlpacaTech) con el README propio del
  autor (`3d1841e`).
- Flujo en paralelo: esquema de fábrica con revisión en paralelo y puerta
  humana, a partir de la presentación de Eric Risco, con su nota en el README
  (`6d0d20d`).
- Modelos por puesto según la presentación de Risco: el builder usa Opus y los
  revisores usan otros motores (`56eeb3d`).
- Commit inicial del repositorio (`989b679`).
