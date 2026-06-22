# Batch Projection Macro

## Purpose

This ImageJ/Fiji macro batch-processes GFP `.TIF` image stacks in a selected folder and creates a **maximum intensity projection** for each file.

This is useful for converting z-stacks or image stacks into 2D projected images for visualization or downstream analysis.

---

## Input

A folder containing GFP `.TIF` files.

By default, the macro only processes files ending with:

```text
 GFP.TIF
```

Example:

```text
cell_001 GFP.TIF
cell_002 GFP.TIF
cell_003 GFP.TIF
```

---

## Output

For each input image, the macro saves a new `.tif` file in the same folder with the suffix:

```text
Max_pro.tif
```

Example:

```text
cell_001 GFP.TIF
cell_001 GFPMax_pro.tif
```

---

## Method

The macro uses ImageJ/Fiji’s built-in Z projection command:

```javascript
run("Z Project...", "projection=[Max Intensity]");
```

This creates a maximum intensity projection, where each pixel in the output image represents the maximum intensity value across the stack.

---

## Usage

1. Open Fiji/ImageJ.
2. Go to:

```text
Plugins > Macros > Run...
```

3. Select the macro file.
4. Choose the input folder when prompted.
5. The projected images will be saved in the same folder.

---

## Customization

### Use a different projection method

To use another projection method, change this line:

```javascript
run("Z Project...", "projection=[Max Intensity]");
```

For example:

```javascript
run("Z Project...", "projection=[Average Intensity]");
```

Other common projection options include:

```text
Average Intensity
Sum Slices
Standard Deviation
Median
Min Intensity
Max Intensity
```

Use **Max Intensity** when you want to preserve bright objects across the stack. Use **Average Intensity** or **Sum Slices** when total or average signal across the stack is more relevant.

### Process files with a different ending

By default, the script only processes files ending with:

```javascript
if (endsWith(list[i], "GFP.TIF")) {
```

If your files end with `TFP.tif`, change it to:

```javascript
if (endsWith(list[i], "TFP.tif")) {
```

For example, this would process files like:

```text
cell_001_TFP.tif
cell_002_TFP.tif
```

If you want to process both naming patterns, use:

```javascript
if (endsWith(list[i], "GFP.TIF") || endsWith(list[i], "TFP.tif")) {
```

---

## Notes

* Only files matching the filename condition are processed.
* Files with lowercase `.tif` or different channel names will be skipped unless the condition is modified.
* The output filename is generated from the original filename before the first period.
* Running the macro multiple times may overwrite existing output files.

