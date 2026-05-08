# Sistema Experto de Diagnóstico de Fallas Automotrices

**Autor:** Diego Estrada  
**Curso:** Programación / Inteligencia Artificial  
**Universidad:** Noveno Semestre  
**Versión:** 3.0  
**Lenguaje:** Prolog (SWI-Prolog 7.x) + XPCE (interfaz gráfica)

---

## ¿Qué hace este programa?

Es un **sistema experto** que ayuda a diagnosticar fallas en un automóvil. El usuario responde una serie de preguntas de Sí/No y el sistema determina qué falla tiene el vehículo y muestra los pasos para solucionarla.

### Fallas que puede diagnosticar

| # | Categoría | Ejemplo de síntoma |
|---|---|---|
| 1 | Motor / Aceite | Ruidos, pérdida de fuerza, gasto excesivo de combustible |
| 2 | Suspensión / Alineación | Llantas desgastadas de un lado, timón que vibra |
| 3 | Sistema Eléctrico / Batería | Luces bajas, auto que no enciende, radio sin funcionar |
| 4 | Sistema de Frenos | Ruidos al frenar, tarda en frenar |
| 5 | Computadora (Check Engine) | Luz check engine encendida, tirones al acelerar |
| 6 | Bocinas / Sonido | Bocinas que no suenan |

---

## Requisitos

- **SWI-Prolog 7.x** instalado en Windows
  - Ruta típica: `C:\Program Files (x86)\swipl\bin\swipl.exe`
- No se requieren librerías externas adicionales

---

## Estructura del proyecto

```
ProyectoTaller/
├── main.pl              → Punto de entrada. Carga todo y abre la ventana.
├── src/
│   ├── motor.pl         → Motor de inferencia (preguntas, memoización, historial)
│   ├── conocimiento.pl  → Base de conocimiento (fallas, reglas, preguntas)
│   └── gui.pl           → Interfaz gráfica XPCE (ventanas, botones, colores)
├── img/
│   └── IMAGENES.txt     → Guía de imágenes opcionales para la interfaz
├── historial.txt        → Se genera al exportar (no existe hasta el primer export)
└── README.md            → Este archivo
```

---

## Cómo ejecutar

### Opción 1 — Doble clic (más fácil)
1. Abrir el Explorador de Windows
2. Navegar a la carpeta `ProyectoTaller`
3. **Doble clic en `main.pl`**
4. La ventana del sistema se abre automáticamente

### Opción 2 — Desde SWI-Prolog manualmente
1. Abrir SWI-Prolog desde el menú Inicio
2. Cambiar al directorio del proyecto:
   ```prolog
   ?- working_directory(_, 'C:/Users/DIEGO QUIÑONEZ/Documents/UNIVERSIDAD/NOVENO SEMESTRE/INTELIGENCIA ARTIFICIAL/ProyectoTaller').
   ```
3. Cargar el proyecto:
   ```prolog
   ?- [main].
   ```

---

## Cómo usar la interfaz

La ventana principal tiene tres secciones:

```
┌─────────────────────────────────────────────────────┐
│  Sistema Experto de Diagnostico Automotriz          │  ← Banner azul
│  Autor: Diego Estrada                               │
│  Curso: Programacion / Inteligencia Artificial      │
├─────────────────────────────────────────────────────┤
│ Estado: Bienvenido...          Diagnósticos: 0      │  ← Estado y contador
│ RESULTADO DEL DIAGNOSTICO:                          │
│ ┌─────────────────────────────────────────────────┐ │
│ │  (aquí aparece la solución al finalizar)        │ │  ← Área de resultado
│ │                                                 │ │     con scroll
│ └─────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────┤
│ [Iniciar Diagnóstico] [Ver Historial] [Exportar TXT] [Salir] │
└─────────────────────────────────────────────────────┘
```

### Paso a paso

1. Presionar **"Iniciar Diagnostico"**
2. Responder cada pregunta emergente con **SI** o **NO**
3. El sistema navega por las categorías automáticamente según las respuestas
4. Al terminar, la solución aparece en el área central
5. El contador en la parte superior se actualiza

### Botones

| Botón | Color | Función |
|---|---|---|
| Iniciar Diagnostico | Verde | Comienza el cuestionario |
| Ver Historial | Naranja | Muestra todos los diagnósticos de la sesión |
| Exportar TXT | Azul | Guarda el historial en `historial.txt` |
| Salir | Rojo | Cierra la aplicación |

---

## Cómo funciona internamente

### Motor de inferencia (Prolog puro)

El sistema usa **encadenamiento hacia atrás**: Prolog intenta resolver `fallas(X)` probando cada categoría en orden. Si todas las preguntas de una categoría se responden con Sí, esa es la falla. Si alguna se responde con No, pasa a la siguiente categoría.

```
¿PROBLEMAS DE MOTOR?      → NO → ¿PROBLEMAS DE SUSPENSION?
                          → SI → ¿TU MOTOR ESTA FALLANDO?
                                 ¿GASTANDO DEMASIADO COMBUSTIBLE?
                                 ... (más preguntas)
                                 → todas SI → SOLUCIÓN: Cambio de aceite
```

### Memoización

El sistema **no repite preguntas**. Si ya respondió "Sí" a algo, lo recuerda con `assert(si(...))`. Si respondió "No", lo recuerda con `assert(no(...))`. Esto evita preguntar lo mismo dos veces aunque dos categorías compartan una pregunta.

### Contador de diagnósticos

Cada vez que se completa un diagnóstico, se guarda con `assert(historial(...))`. El contador cuenta cuántos hechos `historial/1` existen en la base de datos dinámica y actualiza el label en pantalla.

### Exportación a TXT

Al presionar "Exportar TXT", el sistema:
1. Recolecta todos los diagnósticos con `findall/3`
2. Abre/crea `historial.txt` con `open/3`
3. Escribe cada diagnóstico numerado con `write/2` y `format/3`
4. Cierra el archivo con `close/1`
5. Muestra un aviso de confirmación en pantalla

El archivo se genera en la misma carpeta que `main.pl`.

---

## Agregar imágenes (opcional)

Colocar archivos PNG en la carpeta `img/` con estos nombres para que aparezcan en la interfaz:

| Archivo | Dónde aparece |
|---|---|
| `auto.png` | Esquina del banner principal |
| `motor.png` | Resultado de falla de motor |
| `suspension.png` | Resultado de falla de suspensión |
| `electrico.png` | Resultado de falla eléctrica |
| `frenos.png` | Resultado de falla de frenos |
| `computadora.png` | Resultado de falla de computadora |
| `bocinas.png` | Resultado de falla de bocinas |

Tamaño recomendado: **64×64 o 128×128 píxeles en formato PNG**.  
Si un archivo no existe, el sistema lo ignora sin generar error.

---

## Tecnologías utilizadas

| Tecnología | Versión | Uso |
|---|---|---|
| SWI-Prolog | 7.2.3 | Lenguaje lógico, motor de inferencia |
| XPCE (library/pce) | Incluido en SWI | Interfaz gráfica de ventanas |
| Prolog dinámico | Estándar | Memoización y base de hechos en tiempo de ejecución |
| I/O de archivos Prolog | Estándar | Exportación a TXT |
