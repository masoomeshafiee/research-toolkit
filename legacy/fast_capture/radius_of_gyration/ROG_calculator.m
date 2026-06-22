function radius_of_gyration_list = ROG_calculator(coordinates_list)
    % This function calculates the radius of gyration for the given tracks
    % inputs:
    % coordinates_list (cell array): each element of the cell is a n * 2 matrix
    % containing the x and y position of the spots within a track. (n =
    % track length or the number of localization)
    % outputs:
    % - radius_of_gyration_list (array): a (m * 1) list. m = number of tracks 
    num_tracks = length(coordinates_list);
    % Initialize an empty array to store the Rg values
    radius_of_gyration_list = zeros(num_tracks, 1);
    for i = 1 : num_tracks
        % Extract the x and y coordinates for each track
        current_track_positions = coordinates_list{i};
        x_coordinates = current_track_positions(:, 1);
        y_coordinates = current_track_positions(:, 2);
        % Calculate the average X and Y position
        x_avg = mean(x_coordinates);
        y_avg = mean(y_coordinates);
        % Compute the square of the deviations
        deviation_sq = (x_coordinates - x_avg).^2 + (y_coordinates - y_avg).^2;
        % Compute the Rg for this track
        radius_of_gyration_list(i) = sqrt(sum(deviation_sq) / length(deviation_sq));
    end

end