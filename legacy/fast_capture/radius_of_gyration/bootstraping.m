data = log(radius_of_gyration_final); % Your data
numComponents = 2;
numBootstrapSamples = 1000;
%Initialize arrays to store parameter estimates:
bootstrapMu = zeros(numBootstrapSamples, numComponents);
bootstrapSigma = zeros(numBootstrapSamples, numComponents);
% Bootstrap loop: For each iteration, randomly sample from 
% your data with replacement and fit a GMM. Store the estimated parameters:
for i = 1:numBootstrapSamples
    % Sample data with replacement
    bootstrapSample = data(randi(length(data), [length(data), 1]));

    % Fit GMM to bootstrap sample
    gmm = fitgmdist(bootstrapSample, numComponents);

    % Store parameter estimates
    bootstrapMu(i, :) = sort(gmm.mu); % Sorting to ensure consistent order
    bootstrapSigma(i, :) = sort(sqrt(gmm.Sigma));
end
% For visualization: plot histograms of bootstrap estimates
figure;
subplot(2, 1, 1);
histogram(bootstrapMu(:, 1), 'Normalization', 'probability');
title('Bootstrap Distribution of Mu for Component 1');

subplot(2, 1, 2);
histogram(bootstrapMu(:, 2), 'Normalization', 'probability');
title('Bootstrap Distribution of Mu for Component 2');

% Similarly, you can visualize bootstrapSigma for the variances
CI_mu_component1 = prctile(bootstrapMu(:, 1), [2.5, 97.5]);
CI_mu_component2 = prctile(bootstrapMu(:, 2), [2.5, 97.5]);
% ... and similarly for bootstrapSigma
