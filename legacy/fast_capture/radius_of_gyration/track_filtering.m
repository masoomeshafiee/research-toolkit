function  tracks_within_cells = track_filtering(masks_list, tracks_list)
% filters the tracks to include only those landing within the cells (segmented mask)
% 
% inputs:
% - masks_list (cell array): each element is a binary mask 
% - tracks_list (cell array): each element of the cel is a matrix of tracks
% outputs:
% tracks_within_cells (cell array): each element of the array is a matrix
% of tracks that landed within the cells in the current mask (field of
% view)
%
% Note:
% the inputs of this function are the output of the data_get function

    num_files = numel(masks_list);
    tracks_within_cells = cell(1, num_files);
    % iterate over each file to extract the X and Y coordinates from the track data:
    for j = 1: num_files
        current_tracks_file = tracks_list{j};
        x_coordinates = current_tracks_file(:, 17);
        y_coordinates = current_tracks_file(:, 18);
        current_mask = masks_list{j};
        is_within_cell = cell(0, 1);
        for i = 1 : size(current_tracks_file, 1)
            y_coord = round(y_coordinates(i));
            x_coord = round(x_coordinates(i));
            if (x_coord > 0 && y_coord > 0 && current_tracks_file(i, 2)>3)
                
                if current_mask(y_coord, x_coord) > 0
                    is_within_cell{end + 1, 1} = current_tracks_file(i, :);
                end
            else
                %fprintf('Track length < 4 or Index exceeds current_mask dimensions.\n');
            end
        end
        %size(is_within_cell)
        tracks_within_cells{j} = cell2mat(is_within_cell);
    end
    save('tracks_within_cells.mat', "tracks_within_cells");
end
