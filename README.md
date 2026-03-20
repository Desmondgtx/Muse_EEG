# Muse\_EEG

Pipeline de preprocesamiento y análisis espectral de datos EEG registrados con **MUSE Athena S**, utilizando EEGLAB (MATLAB) y R.

## Descripción del estudio

Se registró actividad EEG de 8 participantes (IDs: 01, 02, 03, 05, 06, 07, 08, 09) durante 9 tareas experimentales:

|Tarea|Descripción|
|-|-|
|**Basal**|Estado resting (línea base)|
|**Documental**|Visualización de un documental|
|**Leer**|Lectura de un texto|
|**Música**|Escuchar piezas musicales|
|**Podcast**|Escuchar un podcast|
|**Reality**|Visualización de un reality|
|**Tetris**|Jugar al Tetris|
|**Tiktok**|Visualización de TikTok|
|**Maximal**|Tarea N-Back de memoria a corto plazo|

El dispositivo MUSE Athena S registra 4 canales EEG correspondientes a las posiciones del sistema 10-20:

* **TP9** – Temporal izquierdo
* **AF7** – Frontal izquierdo
* **AF8** – Frontal derecho
* **TP10** – Temporal derecho

\---

## Estructura del repositorio

```
Muse\_EEG/
│
├── Script\_csv.m          # Preprocesamiento principal (archivos .csv)
├── Script\_edf.m          # Preprocesamiento alternativo (archivos .edf)
├── Spectra.m             # Extracción de datos espectrales desde EEGLAB
├── analisis\_ratio.R      # Análisis de ratios Theta/Alpha y Alpha/Theta
│
├── Participantes/        # Archivos EEG crudos organizados por participante
├── Datos/                # Archivos EEG crudos organizados por tarea
├── Datos Filtrados/      # Archivos .set resultantes del preprocesamiento
└── Spectra/              # Proyecto RStudio con los CSVs de datos espectrales
```

\---

## Requisitos

### MATLAB

* [EEGLAB](https://sccn.ucsd.edu/eeglab/) (con los plugins incluidos)
* Plugin **Muse Monitor Import** (`pop\_musemonitor`) para importar archivos .csv del MUSE
* Plugin **BIOSIG** (`pop\_biosig`) para importar archivos .edf
* Plugin **ERPLAB** (`pop\_basicfilter`) — requerido únicamente por `Script\_edf.m`
* Plugin **clean\_rawdata** (`pop\_clean\_rawdata`)

### R

* Paquete `dplyr`

\---

## Guía de uso

### 1\. Preprocesamiento con `Script\_csv.m` (flujo principal)

Este es el script principal para preprocesar los datos del MUSE Athena S. Utiliza los archivos `.csv` exportados desde la app Muse Monitor.

**Pasos del pipeline:**

1. **Importar datos** — Carga el archivo `.csv` con `pop\_musemonitor` a una frecuencia de muestreo de 256 Hz.
2. **Remover línea base de época** — `pop\_rmbase`.
3. **Canal de eventos** — Extrae eventos desde un canal con `pop\_chanevent`.
4. **Seleccionar canales** — Retiene únicamente los 4 canales EEG (`eeg\_1` a `eeg\_4`).
5. **Filtrado** — Filtro pasa-banda de 1–35 Hz con `pop\_eegfiltnew`.
6. **Recorte temporal (opcional)** — El script incluye una sección comentada para recortar el registro a una ventana de tiempo específica (formato `MM:SS`). Descomentar y ajustar `tiempo\_inicio` y `tiempo\_fin` según sea necesario.
7. **Limpieza de artefactos** — Artifact Subspace Reconstruction (ASR) con `pop\_clean\_rawdata` (burst criterion = 20, window criterion = 0.25).
8. **Guardar** — Exporta el archivo `.set` procesado.

**Para usar el script:**

1. Abrir EEGLAB en MATLAB.
2. Modificar las rutas en el script:

   * `cfg.dir` → carpeta de destino.
   * Ruta del archivo `.csv` de entrada en `pop\_musemonitor`.
   * Rutas de salida en `pop\_saveset` (nombre de archivo y directorio).
3. Si es necesario recortar el registro, descomentar la sección "Cut Data" y definir los tiempos de inicio y fin.
4. Ejecutar el script completo.
5. Repetir para cada archivo de cada participante y tarea, actualizando las rutas y nombres de archivo correspondientes.

> \*\*Nota:\*\* El script debe ejecutarse archivo por archivo, modificando manualmente las rutas de entrada y salida para cada participante/tarea.

\---

### 2\. Preprocesamiento alternativo con `Script\_edf.m`

Este script se utiliza **exclusivamente cuando los archivos `.csv` presentan registros incompletos**. En este estudio, se aplicó únicamente para la tarea **Tiktok**, donde algunos participantes tenían archivos `.csv` truncados respecto a sus archivos `.edf`.

**Diferencias respecto a `Script\_csv.m`:**

* Importa archivos `.edf` con `pop\_biosig` en lugar de `.csv`.
* Requiere un paso de **resampleo a 256 Hz** (`pop\_resample`), ya que los `.edf` pueden tener una frecuencia de muestreo diferente.
* Renombra los canales manualmente a `eeg\_1`–`eeg\_4`.
* Aplica **re-referencia al promedio** de todos los canales (`pop\_reref`).
* Utiliza un filtro Butterworth de orden 2 (1–35 Hz) a través de ERPLAB (`pop\_basicfilter`) en lugar de `pop\_eegfiltnew`.

**Para usar el script:**

1. Seguir los mismos pasos que con `Script\_csv.m`, pero apuntar a un archivo `.edf`.
2. Utilizar este script solo si el archivo `.csv` del participante/tarea muestra datos incompletos.

\---

### 3\. Extracción de datos espectrales con `Spectra.m`

Una vez que todos los archivos `.set` estén procesados, se deben organizar en un archivo **STUDY** de EEGLAB para poder realizar el análisis espectral grupal.

**Requisitos previos:**

1. Tener todos los archivos `.set` en una carpeta común (e.g., `Datos Filtrados/All/`).
2. Crear un archivo `.study` en EEGLAB (menú: `Study > Create a STUDY set`) definiendo participantes, condiciones/tareas y grupos.
3. Pre-computar las medidas de canal: `Study > Precompute channel measures > Power Spectrum`.

**Funcionalidades del script:**

El script contiene varias secciones (separadas por `%%`) que exportan los datos espectrales en diferentes formatos:

|Sección|Salida|Descripción|
|-|-|-|
|1|`spectral\_data\_9\_tasks.csv`|Todas las frecuencias disponibles × 9 tareas (grupo)|
|2|`spectral\_data\_1to20Hz.csv`|Frecuencias de 1–20 Hz con valores originales (grupo)|
|3|`spectral\_data\_1to20Hz\_interpolated.csv`|Frecuencias enteras de 1–20 Hz interpoladas (grupo)|
|4|`spectral\_data\_XX\_1to20Hz.csv`|Datos individuales por participante (1–20 Hz, interpolados)|

El script funciona extrayendo los datos numéricos directamente desde las líneas de los gráficos generados por `std\_specplot`, ya que EEGLAB no ofrece una función directa para exportar estos valores.

**Para usar el script:**

1. Cargar el STUDY desde EEGLAB o directamente con `pop\_loadstudy` en el script.
2. Ajustar la ruta del archivo `.study` y la carpeta de datos.
3. Ejecutar la sección deseada según el formato de salida necesario.
4. Para la exportación individual (sección 4), verificar que el vector `participant\_ids` coincida con los IDs definidos en el STUDY.

\---

### 4\. Análisis de ratios con `analisis\_ratio.R`

Este script en R calcula los ratios **Theta/Alpha** y **Alpha/Theta** a partir de los archivos CSV individuales generados por `Spectra.m`.

**Bandas de frecuencia utilizadas:**

* **Theta:** 4–8 Hz (filas 4 a 8 del CSV)
* **Alpha:** 8–12 Hz (filas 8 a 12 del CSV)

**Salidas:**

* `mean\_band\_participants.csv` — Potencia media de Theta y Alpha por participante y tarea.
* `ThetaAlpha\_ratios.csv` — Ratios T/A y A/T por participante y tarea.

**Para usar el script:**

1. Colocar los archivos `spectral\_data\_XX\_1to20Hz.csv` en el directorio de trabajo de R.
2. Verificar que el vector `participantes` coincida con los IDs de los sujetos.
3. Ejecutar el script completo.

\---

## Autor

Diego Garrido Cerpa — Viña del Mar, Chile

