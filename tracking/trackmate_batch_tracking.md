# Batch TrackMate Tracking Scripts

## Purpose

These Fiji/Jython scripts batch-process `.tif` single-cell microscopy images using **TrackMate**. They detect fluorescent spots, link spots into tracks, and export track-level and spot-level measurements as `.csv` files.

The repository includes two versions:

1. **Two-mode tracking version** — runs both bound and lifetime tracking on each image.
2. **Single-configuration version** — runs one TrackMate configuration per image with user-defined tracking parameters.

Both scripts are useful for single-molecule microscopy tracking analysis.

---

# Version 1: Two-Mode Tracking Script

## Purpose

This version runs two different tracking configurations for each `.tif` image:

1. **Bound tracking** — uses stricter linking parameters for short/localized tracks.
2. **Lifetime tracking** — uses more permissive parameters for longer trajectories.

## Input

A folder containing single-cell `.tif` microscopy images.

The input directory is hard-coded and should be updated before running:

```python
dir_tiff = "/Users/masoomeshafiee/Desktop/trackmate/streams/"
```

## Output

The script creates an `Analysis/` folder inside the input directory.

For each image, it saves:

```text
<image_name>_tracksBound.csv
<image_name>_spotsBound.csv
<image_name>_tracksLifetime.csv
<image_name>_spotsLifetime.csv
```

It also creates summary files:

```text
_SummaryBound.csv
_SummaryLifetime.csv
```

## Main Parameters

```python
link_parameters  = [3.0, 5.0, 0.0, 0.0, 240.0, 0.3, files, save_analysis_dir]
link_parameters2 = [7.0, 8.0, 0.0, 0.0, 600.0, 0.0, files, save_analysis_dir]
```

| Parameter                | Description                                                  |
| ------------------------ | ------------------------------------------------------------ |
| Linking max distance     | Maximum distance for linking spots between frames            |
| Gap-closing max distance | Maximum distance allowed for reconnecting missing detections |
| Splitting distance       | Not used; splitting is disabled                              |
| Merging distance         | Not used; merging is disabled                                |
| Detection threshold      | TrackMate spot detection threshold                           |
| Quality penalty          | Feature penalty used during linking                          |
| File list                | List of `.tif` files to process                              |
| Output directory         | Folder where output CSVs are saved                           |

## TrackMate Settings

* **Detector:** LoG detector
* **Tracker:** Sparse LAP tracker
* **Spot radius:** `1.5 px`
* **Median filtering:** enabled
* **Track splitting:** disabled
* **Track merging:** disabled
* **Maximum frame gap:** differs between bound and lifetime modes

---

# Version 2: Single-Configuration Tracking Script

## Purpose

This version runs one TrackMate tracking configuration per `.tif` image. It is simpler and stores the selected parameters directly in the output folder name.

## Input

A folder containing `.tif` microscopy images.

The input directory is hard-coded and should be updated before running:

```python
dir_tiff = "/Users/masoomeshafiee/Desktop/Bound2learn/myscript/Trtackmate/trackmate"
```

## Output

The script creates an output folder with the main tracking parameters in its name:

```text
Analysis_COST_thr<int_thresh>_lnk<link_dist>_gp<gap_link_dist>__cost_INT<cost_q>
```

For each image, it saves:

```text
<image_name>_tracks.csv
<image_name>_spots.csv
```

## Main Parameters

```python
link_dist = 3.0
gap_link_dist = 5.0
int_thresh = 100.
cost_q = 0.3
```

| Parameter       | Description                                       |
| --------------- | ------------------------------------------------- |
| `link_dist`     | Maximum distance for linking spots between frames |
| `gap_link_dist` | Maximum distance for gap closing                  |
| `int_thresh`    | Spot detection threshold                          |
| `cost_q`        | Quality penalty used during track linking         |

## TrackMate Settings

* **Detector:** LoG detector
* **Tracker:** Sparse LAP tracker
* **Spot radius:** `1.6 px`
* **Median filtering:** enabled
* **Maximum frame gap:** `1`
* **Track splitting:** disabled
* **Track merging:** disabled
* **Number of threads:** `8`

---

# Exported Measurements

## Track-Level Output

The track-level CSV files contain measurements such as:

* Track ID
* Number of spots per track
* Spot width or estimated diameter
* Mean, max, min, median, and standard deviation of speed
* Mean, max, min, median, and standard deviation of quality
* Track duration
* Track start and end frame
* Mean X and Y track position

## Spot-Level Output

The spot-level CSV files contain:

* Track ID
* Frame number
* X position
* Y position
* Total spot intensity

## Summary Output

Only the two-mode version creates summary files. These include:

* Cell/image ID
* Quality threshold used
* Number of spots
* Average intensity
* Number of tracks
* Longest track
* Average track duration

---

# Usage

1. Open Fiji.
2. Make sure the TrackMate plugin is installed.
3. Open the script in Fiji’s Script Editor.
4. Update the hard-coded input directory path.
5. Adjust tracking parameters if needed.
6. Run the script.
7. Check the generated analysis folder for output `.csv` files.

---

# Notes

* Both scripts process files ending with `.tif`.
* Input paths are hard-coded and must be updated before running.
* If the output folder already exists, `os.mkdir()` may raise an error.
* TrackMate import paths may change between Fiji versions.
* Track splitting and merging are disabled in both versions.
* Images with no detected spots or no tracks may be skipped, depending on the script version.
* The two-mode version is better when comparing bound-like and lifetime-like tracking behavior.
* The single-configuration version is better for simpler batch runs with one parameter set.
