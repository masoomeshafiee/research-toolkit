SMAUG Input Preparation Script
Purpose

This MATLAB script prepares TrackMate tracking results for SMAUG analysis.

It filters tracks and spots to keep only molecules that:

Fall inside segmented cell masks.
Belong to tracks longer than 3 frames.

The script then reformats the filtered spot coordinates into the 5-column format required by SMAUG and saves the result as .mat files.

Input

The script asks the user to manually select three types of files:

Binary masks
Segmented cell masks in .png format.
TrackMate track files
CSV files ending with:
*tracks.csv
TrackMate spot files
CSV files ending with:
*spots.csv

The selected mask, track, and spot files should be in the same order, so each mask matches the correct field of view and TrackMate output.

TrackMate File Format
Track file

The track file is expected to have 18 columns:

[Track_IDs, spt_tr, spt_widt, mean_sp, max_sp, min_sp,
 med_sp, std_sp, mean_q, max_q_tr, min_q_tr, med_q_tr,
 std_q_tr, tr_dur, tr_start, tr_fin, x_lc, y_lc]

The script uses:

Column 1: track ID
Column 14: track duration / length filter
Column 17: mean X position
Column 18: mean Y position
Spot file

The spot file is expected to have 5 columns:

[track_ID, frame_number, x_position, y_position, intensity]
Filtering Logic

For each track, the script checks:

current_tracks_file(i, 14) > 3

and verifies that the rounded track position falls inside the binary mask:

current_mask(y_coord, x_coord) > 0

Only tracks that pass both conditions are kept.

SMAUG Output Format

SMAUG expects a 5-column matrix:

Column	Description
1	Track number
2	Step number within the track
3	Placeholder/intensity column from the original spot file
4	X position in pixels
5	Y position in pixels

The script creates this format using:

current_Smaug_input = sorted_spots(:, [1, 2, 5, 3, 4]);

Frame numbers are reset so each track starts at step 1.

Output

For each field of view, the script saves a SMAUG-ready .mat file:

DDC2_HU_field_of_view_<number>.mat

Each file contains the variable:

trfile

The script also saves:

tracks_within_cells.mat
spots_within_cells.mat

These files store the filtered tracks and spots for all fields of view.

Usage
Open MATLAB.
Run:
Smaug_input
Select the binary mask files.
Select the matching TrackMate tracks.csv files.
Select the matching TrackMate spots.csv files.
The .mat output files will be saved in the current MATLAB working directory.
Notes
The masks, tracks, and spots must be selected in matching order.
The script assumes track coordinates are in columns 17 and 18 of the track file.
The script assumes spot files contain track ID, frame, X, Y, and intensity in columns 1–5.
Tracks shorter than 4 frames are excluded.
The output filename is currently hard-coded for the DDC2_HU condition and should be renamed for other experiments.