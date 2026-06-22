function radius_of_gyration_final = main
    [masks_list, tracks_list, spots_list] = data_get;
    tracks_within_cells = track_filtering(masks_list, tracks_list);
    tracks_within_cells(cellfun('isempty', tracks_within_cells)) = [];
    spots_list(cellfun('isempty', tracks_within_cells)) = [];
    num_files = length(tracks_within_cells);
    radius_of_gyration_total = cell(1,num_files);
    for file = 1: num_files
        current_tracks_matrix = tracks_within_cells{file};
        current_spots_matrix = spots_list{file};
        track_ID_list = current_tracks_matrix(:, 1);
        coordinates_list = spot_position_extraction(track_ID_list, current_spots_matrix);
        coordinates_list;
        radius_of_gyration_total{file} = ROG_calculator(coordinates_list);
    end
    % Using vertcat to merge the Rg of tracks from multiple filse into one large array
    % and converting the merged array into a vector
    disp(class(radius_of_gyration_total));
    save('radius_of_gyration_total.mat', "radius_of_gyration_total");
    radius_of_gyration_final = vertcat(radius_of_gyration_total{:});
    save("radius_of_gyration_final.mat","radius_of_gyration_final");
    plot_Rg_distribution(radius_of_gyration_final)
    gmm_model = Rg_gmm_fit(radius_of_gyration_final);
    [bound_indices,bound_fraction, threshold] = RG_classifire(gmm_model, radius_of_gyration_final, radius_of_gyration_total);
    bound_fraction_final.bound_fraction = bound_fraction;
    bound_fraction_final.threshold = threshold;
    bound_fraction_final.bound_indices = bound_indices;
    save('bound_fraction_final.mat', '-struct' , 'bound_fraction_final');
    save('gmm_model.mat', 'gmm_model');
    %propmt = {'Do you want to calculate the bound fraction at the single cell level? input 1 if yeas and 0 if not.'};
    %answer = inputdlg(propmt);
    %if answer{1} == '1'
        %BF_masks_list = BF_data_get;
        %[bound_fraction_list, cell_areas] = single_cell(masks_list,BF_masks_list, tracks_within_cells, bound_indices);
    %end
    

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
    % - Bf_mask_list (cell array): each element of the cell array is a matrix
    % representing the bright field mask image
    list_of_masks = uigetfile('*.tif', 'Please choose your binary masks','MultiSelect','on');
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
%%
function plot_Rg_distribution(Rg)
    % Plot the histogram
    figure;
    histogram(Rg, 'Normalization', 'probability'); 
    title('Distribution of Rg values');
    xlabel('Radius of Gyration');
    ylabel('Probability');
end
function BF_masks_list = BF_data_get

        list_of_BF_masks = uigetfile('*.png', 'Please choose your BF masks','MultiSelect','on');
        %list_of_BF_masks = {list_of_BF_masks};
        num_BF_masks = numel(list_of_BF_masks);
        BF_masks_list = cell(1, num_BF_masks);
        for j = 1:num_BF_masks
            BF_mask = imread(list_of_BF_masks{1,j});
            BF_mask = uint16(BF_mask);
            BF_masks_list{j} = BF_mask;
        end
end


end