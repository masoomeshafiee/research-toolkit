function [coordinates_list] = spot_position_extraction(track_ID_list, spots_file)
    % This function takes a track ID and spots file and extracts the positions of the spots
    % within each track from the spots file.
    %
    % inputs:
    % - track_ID_list (n * 1 array): the list of track_IDs
    % - spots_file (array): the spots file outputted from trackmate
    % (columns: track_ID, tr_fram, x_tr, y_tr, inten)
    % outputs:
    % - coordinates_list (cell array): each element of the cell is a
    % matrix that contain the x and y positions of the spots within the track 
    % with the corresponding ID
    number_of_tracks = length(track_ID_list);
    coordinates_list = cell(1, number_of_tracks);
    for i = 1 : number_of_tracks
        spots_coordinates = spots_file(spots_file(:, 1) == track_ID_list(i), [3, 4]);
        coordinates_list{i} = spots_coordinates;
    end
end