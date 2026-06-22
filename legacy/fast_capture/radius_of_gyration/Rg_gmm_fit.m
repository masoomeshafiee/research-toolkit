function gmm = Rg_gmm_fit(radius_of_gyration_final)
% This function takes the radius of gyration, fits its log into the guassian
% mixture model with two components.
% inputs: 
% - radius_of_gyration_final ( n * 1 vecotr)
% outputs:
% gmm (gmm object): the parameters of the gmm model that was fitted.
% Notes: 
% - We give the starting values of the gmm parameters so that the algorithm
% finds the best fit easier.
 
Rg = log(radius_of_gyration_final);
S.mu = [-0.5; 0.5]; % you can change it base on your own dataset
S.Sigma = cat(3, 1, 1); % you can change it base on your own dataset
S.ComponentProportion = [0.1 0.9]; % you can change it base on your own dataset
options = statset('Display','final', 'MaxIter', 1000);
gmm = fitgmdist(Rg, 2, 'Start', S, 'Options', options);
%gmm = fitgmdist(Rg, 2, 'CovarianceType', 'diagonal');

mu1 = gmm.mu(1);
mu2 = gmm.mu(2);
sigma1 = sqrt(gmm.Sigma(1));
sigma2 = sqrt(gmm.Sigma(2));
w1 = gmm.ComponentProportion(1);
w2 = gmm.ComponentProportion(2);
% Define the gaussian mixture PDF:
f = @(x, mu, sigma, weight) weight * (1/(sigma * sqrt(2*pi))) * exp(-(x - mu).^2 / (2 * sigma^2));

% Define a range for plotting the GMM dpending on you own data (change it
% if it does not work!)
x_vals = linspace(min(Rg), max(Rg), 1000)';

% Plot histogram
figure;
histogram(Rg, 'Normalization', 'pdf', 'FaceColor', [0.8 0.8 0.8]);
hold on;

% Plot Gaussian components
plot(x_vals, f(x_vals, mu1,sigma1, w1), 'r-', 'LineWidth', 2);
plot(x_vals, f(x_vals, mu2, sigma2, w2), 'b-', 'LineWidth', 2);

xlabel('Rg');
ylabel('Probability Density');
title('log of Rg Distribution with gmm model');
legend('Histogram', 'Gaussian 1','Gaussian 2');
hold off;
end