# Spot Intensity Distribution Comparison Script

## Purpose

This Python script compares spot intensity distributions between two microscopy datasets or experimental days.

It reads multiple TrackMate `spots.csv` files from two folders, combines all spot intensities for each dataset, visualizes their distributions, and performs statistical tests to compare them.

This is useful for checking whether spot intensity distributions differ between imaging days, conditions, proteins, or batches.

---

## Input

Two folders containing TrackMate spot-level CSV files.

The script looks for files ending with:

```text
spots.csv
```

Example:

```text
cell_001_spots.csv
cell_002_spots.csv
cell_003_spots.csv
```

The input directories are currently hard-coded:

```python
directory_path_1 = "/path/to/dataset_1"
directory_path_2 = "/path/to/dataset_2"
```

Update these paths before running the script.

---

## Output

The script generates several plots:

1. Histogram of intensities for dataset 1.
2. Histogram of intensities for dataset 2.
3. Overlaid histograms comparing both datasets.
4. ECDF plots comparing both datasets.
5. Histogram + probability density function, PDF, overlays.
6. Separate histogram + PDF plots for each dataset.

It also prints statistical test results to the console.

---

## Method

The script:

1. Finds all files ending with `spots.csv` in each input folder.
2. Reads each CSV file using pandas.
3. Extracts the last column as spot intensity.
4. Combines intensities from all files within each dataset.
5. Plots histograms, ECDFs, and kernel density estimates.
6. Compares the two distributions using statistical tests.

---

## Statistical Tests

The script performs:

| Test                    | Purpose                                        |
| ----------------------- | ---------------------------------------------- |
| Kolmogorov-Smirnov test | Compares the overall distribution shapes       |
| Mann-Whitney U test     | Non-parametric comparison of intensity values  |
| Welch’s t-test          | Compares means without assuming equal variance |
| One-way ANOVA           | Compares group means                           |

The Kolmogorov-Smirnov test is especially useful here because it compares the empirical cumulative distributions and is sensitive to differences in distribution shape and location.

---

## Important Assumptions

* The input CSV files are TrackMate spot files.
* The last column contains spot intensity.
* All `spots.csv` files in each folder belong to the same dataset, condition, or imaging day.
* The two folders represent the groups being compared.
* Intensities are not normalized in the current version.

---

## Usage

Install the required packages:

```bash
pip install pandas numpy matplotlib scipy
```

Run the script:

```bash
python compare_spot_intensity_distributions.py
```

Before running, update:

```python
directory_path_1 = "/path/to/first/dataset"
directory_path_2 = "/path/to/second/dataset"
```

---

## Notes

* The script currently compares two datasets.
* The labels in the plots should be updated to match the actual samples or conditions.
* The script assumes intensity is stored in the last column of each spot CSV file.
* If TrackMate output column order changes, update the intensity column selection.
* Background correction or normalization should be considered before comparing intensities across different days.
* For batch comparisons, it may be better to normalize intensities per video, per cell, or using background intensity.
