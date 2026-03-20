# Muse\_EEG

Preprocessing and spectral analysis pipeline for EEG data recorded with **MUSE Athena S**, using EEGLAB (MATLAB) and R.

## Study Description

EEG activity was recorded from 8 participants (IDs: 01, 02, 03, 05, 06, 07, 08, 09) during 9 experimental tasks:

| Task | Description |
|-|-|
| **Basal** | Resting state (baseline) |
| **Documental** | Watching a documentary |
| **Leer** | Reading a text |
| **Música** | Listening to music pieces |
| **Podcast** | Listening to a podcast |
| **Reality** | Watching a reality show |
| **Tetris** | Playing Tetris |
| **Tiktok** | Watching TikTok |
| **Maximal** | N-Back short-term memory task |

The MUSE Athena S device records 4 EEG channels corresponding to the 10-20 system positions:

* **TP9** – Left temporal
* **AF7** – Left frontal
* **AF8** – Right frontal
* **TP10** – Right temporal

---

## Repository Structure

```
Muse\_EEG/
│
├── Script\_csv.m          # Main preprocessing (from .csv files)
├── Script\_edf.m          # Alternative preprocessing (from .edf files)
├── Spectra.m             # Spectral data extraction from EEGLAB
├── analisis\_ratio.R      # Theta/Alpha and Alpha/Theta ratio analysis
│
├── Participantes/        # Raw EEG files organized by participant
├── Datos/                # Raw EEG files organized by task
├── Datos Filtrados/      # Preprocessed .set files
└── Spectra/              # RStudio project with spectral data CSVs
```

---

## Requirements

### MATLAB

* [EEGLAB](https://sccn.ucsd.edu/eeglab/) (with included plugins)
* **Muse Monitor Import** plugin (`pop\_musemonitor`) for importing MUSE .csv files
* **BIOSIG** plugin (`pop\_biosig`) for importing .edf files
* **ERPLAB** plugin (`pop\_basicfilter`) — required only by `Script\_edf.m`
* **clean\_rawdata** plugin (`pop\_clean\_rawdata`)

### R

* `dplyr` package

---

## Usage Guide

### 1\. Preprocessing with `Script\_csv.m` (main workflow)

This is the main script for preprocessing MUSE Athena S data. It uses `.csv` files exported from the Muse Monitor app.

**Pipeline steps:**

1. **Import data** — Loads the `.csv` file with `pop\_musemonitor` at a sampling rate of 256 Hz.
2. **Remove epoch baseline** — `pop\_rmbase`.
3. **Event channel** — Extracts events from a channel with `pop\_chanevent`.
4. **Select channels** — Retains only the 4 EEG channels (`eeg\_1` through `eeg\_4`).
5. **Filtering** — 1–35 Hz bandpass filter with `pop\_eegfiltnew`.
6. **Time trimming (optional)** — The script includes a commented-out section for trimming the recording to a specific time window (`MM:SS` format). Uncomment and adjust `tiempo\_inicio` and `tiempo\_fin` as needed.
7. **Artifact cleaning** — Artifact Subspace Reconstruction (ASR) with `pop\_clean\_rawdata` (burst criterion = 20, window criterion = 0.25).
8. **Save** — Exports the processed `.set` file.

**To use the script:**

1. Open EEGLAB in MATLAB.
2. Modify the paths in the script:

   * `cfg.dir` → destination folder.
   * Input `.csv` file path in `pop\_musemonitor`.
   * Output paths in `pop\_saveset` (filename and directory).
3. If you need to trim the recording, uncomment the "Cut Data" section and define the start and end times.
4. Run the entire script.
5. Repeat for each file of each participant and task, updating the corresponding paths and filenames.

> **Note:** The script must be run file by file, manually modifying the input and output paths for each participant/task.

---

### 2\. Alternative preprocessing with `Script\_edf.m`

This script is used **exclusively when `.csv` files contain incomplete recordings**. In this study, it was applied only for the **Tiktok** task, where some participants had truncated `.csv` files compared to their `.edf` files.

**Differences from `Script\_csv.m`:**

* Imports `.edf` files with `pop\_biosig` instead of `.csv`.
* Requires a **resampling step to 256 Hz** (`pop\_resample`), since `.edf` files may have a different sampling rate.
* Manually renames channels to `eeg\_1`–`eeg\_4`.
* Applies **average re-referencing** across all channels (`pop\_reref`).
* Uses a 2nd-order Butterworth filter (1–35 Hz) via ERPLAB (`pop\_basicfilter`) instead of `pop\_eegfiltnew`.

**To use the script:**

1. Follow the same steps as with `Script\_csv.m`, but point to an `.edf` file.
2. Use this script only if the participant/task `.csv` file shows incomplete data.

---

### 3\. Spectral data extraction with `Spectra.m`

Once all `.set` files are processed, they must be organized into an EEGLAB **STUDY** file to perform group-level spectral analysis.

**Prerequisites:**

1. Have all `.set` files in a common folder (e.g., `Datos Filtrados/All/`).
2. Create a `.study` file in EEGLAB (menu: `Study > Create a STUDY set`) defining participants, conditions/tasks, and groups.
3. Pre-compute channel measures: `Study > Precompute channel measures > Power Spectrum`.

**Script functionalities:**

The script contains several sections (separated by `%%`) that export spectral data in different formats:

| Section | Output | Description |
|-|-|-|
| 1 | `spectral\_data\_9\_tasks.csv` | All available frequencies × 9 tasks (group) |
| 2 | `spectral\_data\_1to20Hz.csv` | 1–20 Hz frequencies with original values (group) |
| 3 | `spectral\_data\_1to20Hz\_interpolated.csv` | Integer frequencies from 1–20 Hz, interpolated (group) |
| 4 | `spectral\_data\_XX\_1to20Hz.csv` | Individual per-participant data (1–20 Hz, interpolated) |

The script works by extracting numerical data directly from the plot lines generated by `std\_specplot`, since EEGLAB does not provide a built-in function to export these values directly.

**To use the script:**

1. Load the STUDY from EEGLAB or directly with `pop\_loadstudy` in the script.
2. Adjust the `.study` file path and data folder.
3. Run the desired section depending on the output format needed.
4. For individual export (section 4), verify that the `participant\_ids` vector matches the IDs defined in the STUDY.

---

### 4\. Ratio analysis with `analisis\_ratio.R`

This R script calculates **Theta/Alpha** and **Alpha/Theta** ratios from the individual CSV files generated by `Spectra.m`.

**Frequency bands used:**

* **Theta:** 4–8 Hz (rows 4 to 8 of the CSV)
* **Alpha:** 8–12 Hz (rows 8 to 12 of the CSV)

**Outputs:**

* `mean\_band\_participants.csv` — Mean Theta and Alpha power per participant and task.
* `ThetaAlpha\_ratios.csv` — T/A and A/T ratios per participant and task.

**To use the script:**

1. Place the `spectral\_data\_XX\_1to20Hz.csv` files in the R working directory.
2. Verify that the `participantes` vector matches the subject IDs.
3. Run the entire script.

---

## Author

Diego Garrido Cerpa — Viña del Mar, Chile
