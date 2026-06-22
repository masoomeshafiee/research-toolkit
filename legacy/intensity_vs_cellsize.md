# Intensity vs Cell Size Analysis Script

## Purpose

This MATLAB script measures the relationship between **cell size** and **average fluorescence intensity per pixel**.

It uses projected fluorescence images, usually from the red channel, together with segmented cell masks, usually generated from brightfield images using Cellpose.

For each segmented cell, the script calculates:

1. Cell area in pixels.
2. Average fluorescence intensity inside the cell.
3. A scatter plot of cell size versus average intensity.

---

## Input

The script asks the user to select two types of files:

1. **Projected fluorescence images**

```text
*.tif
```

These are typically projected red-channel images.

2. **Segmentation masks**

```text
*.png
```

These are non-binary labeled masks from Cellpose segmentation.

The image files and mask files should be selected in matching order.

---

## Output

The function returns:

| Output         | Description                                            |
| -------------- | ------------------------------------------------------ |
| `cellSize`     | Area of each segmented cell in pixels                  |
| `avgIntensity` | Average fluorescence intensity per pixel for each cell |

It also generates a scatter plot:

```text
cell size vs average intensity
```

---

## Method

For each image-mask pair, the script:

1. Reads the fluorescence image and matching segmentation mask.
2. Finds each unique cell label in the mask.
3. Creates a binary mask for each individual cell.
4. Measures the cell area using `regionprops`.
5. Segments the fluorescence image using the cell mask.
6. Measures mean fluorescence intensity inside each cell.
7. Combines measurements from all selected images.
8. Plots cell size against average intensity.

---

## Main Functions

### `intensityVsCellSize`

Main function that loads the data, loops through all images, collects cell size and intensity values, and creates the final scatter plot.

### `imgGet`

Prompts the user to select:

* `.tif` projected fluorescence images
* `.png` labeled segmentation masks

### `getCellsinfo`

Extracts cell area and average intensity for each labeled cell.

### `segmentation`

Applies a binary cell mask to the fluorescence image.

---

## Usage

Run the function in MATLAB:

```matlab
[cellSize, avgIntensity] = intensityVsCellSize;
```

Then select:

1. The projected fluorescence images.
2. The corresponding Cellpose masks.
3. Enter the strain name when prompted.

---

## Notes

* The script assumes masks are labeled images, not simple binary masks.
* The background label is assumed to be `0` and is ignored.
* The image and mask files must be selected in the same order.
* The intensity is multiplied by `65535`, assuming the image was converted to double and originated from a 16-bit image.
* Segmentation quality can strongly affect the average intensity measurement.
* Background correction is not included in this version.
* The strain name is requested but is not currently used in the plot title.

---

## Possible Improvements

Future versions could include:

* Background subtraction before measuring intensity.
* Saving the result table as `.csv`.
* Adding the strain name to the plot title.
* Checking that image and mask sizes match.
* Supporting automatic file matching by filename.
* Removing the `imshow` display inside the loop for faster batch processing.
