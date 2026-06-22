% Assuming numTracksPerCell is an array containing the number of tracks for each cell
numTracksPerCell = vertcat(tracks_num_list{:});
% Assuming numTracksPerCell is an array containing the number of tracks for each cell
minTracks = min(numTracksPerCell);
maxTracks = max(numTracksPerCell);

% Define bin edges
binEdges = minTracks:20:maxTracks;

% Plot the histogram
histogram(numTracksPerCell, binEdges);

xlabel('Number of Tracks per Cell');
ylabel('Frequency');
title('Histogram of Tracks per Cell with Bin Width of 30');
