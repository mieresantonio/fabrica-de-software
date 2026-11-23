# Paso 04 — revisar (agente revisor)

Entrada: `registro-evidencias.json` y `DESTILADO.md` de la ejecución.
Salida: `revision.json` en la ejecución (y correcciones directas en ambos
archivos cuando haga falta).

## Quién revisa

El revisor es distinto del agente que extrajo y clasificó. Quien destila
no revisa su propio destilado.

## Qué comprobar

1. Cada afirmación del registro tiene cita con fragmento literal y ventana
   válida (el paso 05 lo verificará en ejecución; aquí se revisa el
   sentido: ¿el fragmento apoya de verdad la afirmación?).
2. Los niveles son honestos: ningún C presentado como A; ningún B sin
   fuente secundaria citada.
3. El `resumen` del registro cuadra con las afirmaciones listadas.
4. El destilado no afirma nada fuera del registro, y su sección «Lo que
   este destilado NO afirma» cubre los niveles C con consecuencias (dinero,
   tiempo, cifras).
5. Nombres propios correctos en el destilado; las deformaciones de la
   transcripción automática están anotadas en el registro.

## Formato de salida

```json
{
  "revisor": "paso 04-revisar (rol revisor, distinto del extractor)",
  "veredicto": "aprobado",
  "notas": ["..."],
  "cambios": ["..."]
}
```

`veredicto` es `aprobado` o `rechazado`. Si es `rechazado`, `notas`
explica qué debe rehacer el paso 03 y la ejecución se detiene hasta que
haya un registro y un destilado nuevos.
