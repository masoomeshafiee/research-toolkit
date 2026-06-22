# Batch Background Subtraction Macro

## Purpose

This ImageJ/Fiji macro batch-processes `.TIF` microscopy images in a selected folder and applies rolling-ball background subtraction.

For each image, the macro:

1. Opens the `.TIF` file.
2. Applies background subtraction.
3. Saves a new image with the suffix `_subtracked.tif`.
4. Closes the image.

This is useful for preprocessing single-molecule microscopy images before downstream analysis.

---

## Input

A folder containing `.TIF` microscopy images.

Example:

```text
image_001.TIF
image_002.TIF
image_003.TIF
```

---

## Output

For each input image, the macro saves a background-subtracted `.tif` file in the same folder.

Example:

```text
image_001.TIF
image_001_subtracked.tif
```

---

## Method

The macro uses ImageJ/Fiji’s built-in command:

```javascript
run("Subtract Background...", "rolling=20 disable stack");
```

The rolling-ball radius is set to `20`. This value may need to be adjusted depending on image resolution, object size, and background intensity.

---

## Usage

1. Open Fiji/ImageJ.
2. Go to:

```text
Plugins > Macros > Run...
```

3. Select the macro file.
4. Choose the input folder when prompted.
5. The processed files will be saved in the same folder.

---

## Notes

* Only files ending with uppercase `.TIF` are processed.
* The optional mean filter is currently commented out:

```javascript
// run("Mean...", "radius=1.0");
```

* The suffix `_subtracked` refers to background-subtracted images.
* Running the macro multiple times may overwrite existing output files.

---

## Suggested Improvements

A slightly safer version would:

* Support both `.TIF` and `.tif` files.
* Move `close();` inside the file-processing block.
* Use a clearer suffix such as `_background_subtracted.tif`.

Recommended file name:

```text
batch_background_subtraction.ijm
```
