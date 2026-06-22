radius_of_gyration_final = log(radius_of_gyration_final);
hasMissingValues = any(isnan(radius_of_gyration_final));
if hasMissingValues
    disp(' you have missing values')
end
isDuplicate = numel(unique(radius_of_gyration_final)) < numel(radius_of_gyration_final);
if isDuplicate
    disp(' you have duplicate')
end
% using the Z-score to identify outliers
zScores = zscore(radius_of_gyration_final);
isOutlier = abs(zScores) > 3; % Adjust the threshold as needed
if any(isOutlier)
    disp(' you have outlier')
end

mean_value = mean(radius_of_gyration_final);
median_value = median(radius_of_gyration_final);
variance = var(radius_of_gyration_final);
skewness_value = skewness(radius_of_gyration_final);

