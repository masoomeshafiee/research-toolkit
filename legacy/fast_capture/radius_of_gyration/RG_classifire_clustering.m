function [bound_indices,bound_fraction] = RG_classifire_clustering(gmm_model, raduis_of_gyration_final, radius_of_gyration_total)
logRgData = log(raduis_of_gyration_final);
bound_indices = cell(1, size(radius_of_gyration_total, 2));
clusterIdx = cluster(gmm_model, logRgData);
% Find the cluster with the smaller mean (the bound cluster)
[~, boundCluster] = min(gmm_model.mu);
bound_fraction = sum(clusterIdx == boundCluster) / length(logRgData);
splitIndices = cellfun(@length, radius_of_gyration_total); % lengths of each files's data
splitIndices = cumsum([0; splitIndices(:)]); % cumulative sum to get splitting indices

for i = 1 : size(radius_of_gyration_total, 2)
    bound_indices{i} = clusterIdx(splitIndices(i) + 1 : splitIndices(i + 1));
end

