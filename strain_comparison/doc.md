# Fluorescence Intensity Analysis Pipeline

MATLAB pipeline for quantifying and comparing per-cell fluorescence intensities across yeast strains (e.g. Mrc1-Halo pdr mNG vs Δpdr mNG). Loads microscopy images and Cellpose segmentation masks, extracts per-cell size and mean intensity, and runs statistical comparisons between strains.

---

## File Overview

| File | Type | Purpose |
|---|---|---|
| `main.m` | Script | Top-level runner — executes the full pipeline in order |
| `config.m` | Script | Central configuration (bin widths, thresholds, etc.) |
| `imgGet.m` | Function | Interactively load `.tif` images and `.png` masks |
| `intensityVsSize.m` | Function | Extract per-cell area and mean intensity from images |
| `checkNormality.m` | Function | Lilliefors test + histogram + Q-Q plot |
| `plotBinnedIntensity.m` | Function | Bin cells by size and plot mean intensity per bin |
| `plotFits.m` | Function | Linear, polynomial, and Gaussian fits; binned bar chart |
| `compareStrainDistributions.m` | Function | Log-normal fitting, overlaid PDFs, bootstrap CIs |
| `tTestStrains.m` | Function | Two-sample t-test on log-transformed intensities |

---

## Requirements

- MATLAB R2021a or later (uses `arguments` blocks and `tiledlayout`)
- Toolboxes: **Statistics and Machine Learning**, **Curve Fitting**
- Segmentation masks produced by [Cellpose](https://github.com/MouseLand/cellpose) from brightfield images

---

## Quick Start

```matlab
% 1. Load config
config;

% 2. Extract data for each strain (launches file picker dialogs)
[cellSizePdr,  avgIntensityPdr]  = intensityVsSize('pdr mNG');
[cellSizeDpdr, avgIntensityDpdr] = intensityVsSize('Δpdr mNG');

% 3. Run the rest of the pipeline
main;
```

Or run `main.m` directly after loading your workspace variables.

---

## Configuration (`config.m`)

All magic numbers live here. Edit once; every function picks up the change.

| Variable | Default | Description |
|---|---|---|
| `CFG.BIN_WIDTH` | `300` | Bin width (pixels) for scatter/line plots |
| `CFG.BIN_WIDTH_BAR` | `500` | Bin width (pixels) for bar charts |
| `CFG.BIN_MAX` | `5000` | Upper cell-size limit for binning |
| `CFG.ZSCORE_THRESHOLD` | `3` | Z-score cutoff for outlier removal |
| `CFG.CONF_LEVEL` | `0.05` | Alpha for CIs and t-test |
| `CFG.N_BOOTSTRAP` | `1000` | Bootstrap replicates for parameter CIs |
| `CFG.POLY_DEGREE` | `2` | Degree for polynomial regression |

---

## Function Reference

### `imgGet`

```matlab
[imgList, maskList] = imgGet()
```

Opens two file-picker dialogs: one for `.tif` fluorescence stacks, one for `.png` Cellpose masks. Returns matched cell arrays of images and masks. Handles both single and multi-file selection.

**Returns**

| Variable | Type | Description |
|---|---|---|
| `imgList` | `1×N cell` | `uint16` fluorescence images |
| `maskList` | `1×N cell` | Corresponding segmentation masks |

---

### `intensityVsSize`

```matlab
[cellSize, avgIntensity] = intensityVsSize(strainName)
```

Calls `imgGet`, segments each image using its mask, and collects per-cell area and mean intensity via `regionprops`. Produces a scatter plot.

**Arguments**

| Argument | Type | Description |
|---|---|---|
| `strainName` | `char` | Strain label for the plot title. Prompts via dialog if omitted. |

**Returns**

| Variable | Type | Description |
|---|---|---|
| `cellSize` | `1×N double` | Per-cell area in pixels |
| `avgIntensity` | `1×N double` | Per-cell mean fluorescence intensity |

---

### `checkNormality`

```matlab
checkNormality(data, label)
```

Runs a Lilliefors test and prints the result. Displays a histogram and Q-Q plot side by side.

**Arguments**

| Argument | Default | Description |
|---|---|---|
| `data` | — | `1×N double` vector to test |
| `label` | `'Data'` | Display label used in titles and output |

---

### `plotBinnedIntensity`

```matlab
plotBinnedIntensity(cellSize, avgIntensity)
plotBinnedIntensity(cellSize, avgIntensity, opts)
```

Divides cells into size bins and plots mean intensity at each bin midpoint. Optionally removes outliers by z-score before binning.

**Options**

| Field | Default | Description |
|---|---|---|
| `binWidth` | `300` | Bin width in pixels |
| `binMax` | `5000` | Upper bound of bin range |
| `removeOutliers` | `false` | Enable z-score-based outlier removal |
| `zThreshold` | `3` | Z-score cutoff (used when `removeOutliers` is `true`) |
| `title` | `''` | Figure title |

---

### `plotFits`

```matlab
plotFits(cellSize, avgIntensity)
plotFits(cellSize, avgIntensity, opts)
```

Generates multiple figures showing the relationship between cell size and intensity. Each fit type can be toggled independently.

**Options**

| Field | Default | Description |
|---|---|---|
| `linear` | `true` | Linear regression via `fitlm` |
| `poly` | `true` | Polynomial regression via `polyfit` |
| `gaussian` | `true` | Bivariate Gaussian contours via `fitgmdist` |
| `bar` | `true` | Bar chart of mean intensity per size bin |
| `polyDeg` | `2` | Degree for polynomial fit |
| `binWidth` | `500` | Bin width for the bar chart |
| `title` | `''` | Prefix added to each figure title |

Always produces a scatter plot and a 2-D histogram regardless of options.

---

### `compareStrainDistributions`

```matlab
compareStrainDistributions(intensityPdr, intensityDpdr)
compareStrainDistributions(intensityPdr, intensityDpdr, opts)
```

Fits a normal distribution to `log(intensity)` for each strain and produces:
- Per-strain histogram overlaid with the fitted PDF
- Overlaid PDFs for both strains on one axes
- 2×2 summary panel (histograms + KDE plots)
- Printed summary statistics (mean, median, mu, sigma)
- Parametric 95% confidence intervals via `paramci`
- Bootstrap 95% confidence intervals on mu and sigma

**Options**

| Field | Default | Description |
|---|---|---|
| `label1` | `'pdr'` | Display name for strain 1 |
| `label2` | `'Δpdr'` | Display name for strain 2 |
| `nBootstrap` | `1000` | Number of bootstrap replicates |

---

### `tTestStrains`

```matlab
tTestStrains(intensityPdr, intensityDpdr)
tTestStrains(intensityPdr, intensityDpdr, opts)
```

Log-transforms both intensity vectors and runs a two-sample t-test (`ttest2`). Prints the hypothesis test result, raw means, and 95% confidence intervals for each strain.

**Options**

| Field | Default | Description |
|---|---|---|
| `alpha` | `0.05` | Significance level |
| `label1` | `'PDR5'` | Display name for strain 1 |
| `label2` | `'ΔPDR5'` | Display name for strain 2 |

---

## Pipeline Order

```
config
  └── intensityVsSize × 2  (one per strain)
        └── imgGet
  └── checkNormality
  └── plotBinnedIntensity
  └── plotFits
  └── compareStrainDistributions
  └── tTestStrains
```

---

## Expected Workspace Variables

Functions do not share global state. Pass variables explicitly as shown in `main.m`.

| Variable | Description |
|---|---|
| `cellSizePdr` | Cell areas for the pdr strain |
| `avgIntensityPdr` | Mean intensities for the pdr strain |
| `cellSizeDpdr` | Cell areas for the Δpdr strain |
| `avgIntensityDpdr` | Mean intensities for the Δpdr strain |

---

## Notes

- Intensity values are expected to be raw `uint16` pixel values from the fluorescence channel; log-transformation is applied internally where needed.
- Masks are treated as label images — any pixel value ≥ 1 is considered foreground. Multi-cell masks (where each cell has a unique label) are supported via `regionprops`.
- Bootstrap CIs in `compareStrainDistributions` are computed for strain 1 only by default; call the function a second time with arguments swapped to get CIs for strain 2.
