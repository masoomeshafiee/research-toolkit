function  Smaug_input
% filters the spots and tracks to include only those landing within the
% cells (segmented mask), discards the tracks shorter than 4 length and the
% output are .mat files ready to use for smaug file with the format explained
% bellow.
% 
% inputs:
% - masks_list (cell array): each element is a binary mask 
% - tracks_list (cell array): each element of the cell is a matrix of tracks
% - spots_list (cell array): each element of the cell is a matrix of spots
% outputs:
% filename.mat (mat): is a matrix
% of spots that landed within the cells in the current mask (field of
% view)
% SMAUG needs 5 columns of data: 
% -column 1: track number
% -column 2: step number within that track
% -column 3: a placeholder they used for some simulations and testing
% -column 4: x position (in pixels)
% -column 5: y position (in pixels)
%
%% getting the data from the user:
[masks_list, tracks_list, spots_list] = data_get;

%% 
    num_files = numel(masks_list);
    tracks_within_cells = cell(1, num_files);
    spots_within_cells = cell(1, num_files);
    % iterate over each file to extract the X and Y coordinates from the track data:
    for j = 1: num_files
        current_tracks_file = tracks_list{j};
        current_spots_file = spots_list{j};
        x_coordinates = current_tracks_file(:, 17);
        y_coordinates = current_tracks_file(:, 18);
        current_mask = masks_list{j};
        is_within_cell = cell(0, 1);
        filtered_spots = [];
        Smaug_input_final = [];
        for i = 1 : size(current_tracks_file, 1)
            y_coord = round(y_coordinates(i));
            x_coord = round(x_coordinates(i));
            if (x_coord > 0 && y_coord > 0 && current_tracks_file(i, 14)>3)
                
                if current_mask(y_coord, x_coord) > 0
                    is_within_cell{end + 1, 1} = current_tracks_file(i, :);
                    %
                    spots_in_the_track = current_spots_file(current_spots_file(:,1) == current_tracks_file(i, 1),:);
                    filtered_spots = [filtered_spots;spots_in_the_track];
                    % preapering the smaug input file
                    sorted_spots = sortrows(spots_in_the_track,2);
                    sorted_spots(:,2) = (sorted_spots(:,2)- min(sorted_spots(:,2))) + 1;
                    current_Smaug_input = sorted_spots(:,[1,2,5,3,4]);
                    %current_Smaug_input(:,3) = NaN;
                    Smaug_input_final = [Smaug_input_final;current_Smaug_input];
                end
            else
                %fprintf('Track length < 4 or Index exceeds current_mask dimensions.\n');
            end
        end
        %size(is_within_cell)
        tracks_within_cells{j} = cell2mat(is_within_cell);
        spots_within_cells{j} = filtered_spots;
        trfile = Smaug_input_final;
        save(['DDC2_HU_field_of_view_' num2str(j) '.mat'],'trfile');
    end
    save('tracks_within_cells.mat', "tracks_within_cells");
    save('spots_within_cells.mat', "spots_within_cells");
%
%%  
    function [masks_list, tracks_list, spots_list] = data_get
    % This function reads and stores binary masks and the tracks files into
    % cell arrays:
    %
    % inputs(user): 
    % - binary masks (file address): the segmented images
    % - track files (file address): the tracks files outputted from trackmate
    % - spot files (file address): the spot files outputted from trackmate
    % outputs: 
    % - mask_list (cell array): each element of the cell array is a matrix
    % representing the binary mask image
    % - tracks_list (cell array): each element of the cell array is a matrix of tracks
    % the matrix has 18 coloumns: [Track_IDs, spt_tr, spt_widt, mean_sp, max_sp, min_sp,
    % med_sp, std_sp, mean_q, max_q_tr, min_q_tr, med_q_tr, std_q_tr, tr_dur, tr_start, tr_fin, x_lc, y_lc]
    % - spots_list (cell array): each element of the cell array is a matrix
    % of spots. The matrix has 5 coloumns: [tr_identifi, tr_fram, x_tr, y_tr, inten]
    %
    list_of_masks = uigetfile('*.png', 'Please choose your binary masks','MultiSelect','on');
    %list_of_masks = {list_of_masks};
    num_masks = numel(list_of_masks);
    masks_list = cell(1, num_masks);
    for i = 1:num_masks
        mask = imread(list_of_masks{1,i});
        mask = uint16(mask);
        masks_list{i} = mask;
    end
    list_of_tracks = uigetfile('*tracks.csv', 'Please choose the tracks files outputted from trackmate','MultiSelect','on');
    %list_of_tracks = {list_of_tracks};
    num_tracks = numel(list_of_tracks);
    tracks_list = cell(1, num_tracks);
    for i = 1: num_tracks
        tracks = readmatrix(list_of_tracks{1,i});
        tracks_list{i} = tracks;
    end
    list_of_spots = uigetfile('*spots.csv', 'Please choose the spots files outputted from trackmate','MultiSelect','on');
    %list_of_spots = {list_of_spots};
    num_spots = numel(list_of_spots);
    spots_list = cell(1, num_spots);
    for i = 1: num_spots
        spots = readmatrix(list_of_spots{1,i});
        spots_list{i} = spots;
    end
end
end

