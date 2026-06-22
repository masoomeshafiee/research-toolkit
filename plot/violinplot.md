# Bound-Time Violin Plot Script

## Purpose

This Python script compares bound-time distributions between two proteins or experimental conditions using violin plots.

It loads bound-time data from MATLAB `.mat` files, combines the values into a single pandas DataFrame, and visualizes the distributions using Seaborn.

---

## Requirements

Install the required Python packages before running the script:

```bash
pip install pandas matplotlib seaborn scipy
```

Required libraries:

```python
import scipy.io
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import numpy as np
```

---

## Input

The script expects MATLAB `.mat` files containing the variable:

```text
On_time_bound_single_filtered
```

Example file paths are hard-coded in the script:

```python
file_path_rfa1 = "/path/to/Rfa1/Trackmate_On_time_bound_single_filtered.mat"
file_path_rad53 = "/path/to/Rad53/Trackmate_On_time_bound_single_filtered.mat"
```

These paths should be updated before running the script.

---

## Output

The script generates a violin plot comparing bound-time distributions between samples.

The plot shows:

* X-axis: protein or condition name
* Y-axis: bound time
* Distribution shape for each group

---

## Method

The script:

1. Loads bound-time data from `.mat` files.
2. Extracts the `On_time_bound_single_filtered` variable.
3. Flattens the data into one-dimensional arrays.
4. Combines the datasets into a pandas DataFrame.
5. Plots the bound-time distributions using `sns.violinplot()`.

---

## Example DataFrame Format

```text
Bound Time    Protein
12.5          Rfa1
15.2          Rfa1
8.7           Rad53
10.4          Rad53
```

---

## Customization

### Add more proteins or conditions

To compare more than two groups, add the new loaded data to both `np.concatenate()` and the label list.

Example:

```python
df = pd.DataFrame({
    "Bound Time": np.concatenate([rfa1_data, rad53_data, h3_data]),
    "Protein": (
        ["Rfa1"] * len(rfa1_data) +
        ["Rad53"] * len(rad53_data) +
        ["H3"] * len(h3_data)
    )
})
```

### Change colors

Colors are controlled by:

```python
protein_colors = {
    "Rfa1": "purple",
    "Rad53": "mediumorchid",
    "H3": "saddlebrown"
}
```

Add or modify colors based on the groups included in the plot.

---

## Notes

* The `.mat` files must contain the variable `On_time_bound_single_filtered`.
* File paths are hard-coded and should be updated before use.
* The script removes zero values from the y-axis lower-limit calculation.
