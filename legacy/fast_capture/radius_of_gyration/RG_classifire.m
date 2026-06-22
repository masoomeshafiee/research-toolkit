function [bound_indices,bound_fraction, threshold] = RG_classifire(gmm, raduis_of_gyration_final, radius_of_gyration_total)
    % This function gets the fitted GMM model and the data and classifies
    % the tracks as bound or diffusing based on the threshold set to the
    % GMM model.
    % inputs:
    % - gmm (matlab gmdistribution object): contains the parameter of the
    % fitted model (2 components gmm) outputted from Rg_gmm_fit
    % - raduis_of_gyration_final (coloumn vector): the raduis_of_gyration_final file outputted
    % from the main function.
    % - radius_of_gyration_total (cell array of coloumn vector): the raduis_of_gyration_total file outputted
    % from the main function.
    % outputs:
    % - bound_indices(cell array of column vector): each element of the cell 
    % belongs to a track file and contains a coloumn vector showing the indices
    % of the bound tracks (for each row(track) if the molecule is bound: 1 if its diffusing: 0
    % - bound_fraction(float): the fraction of bound molecules
    % - threshold (float): the threshold on the log of Radius of gyration in which
    % below that threshold the track will assign as bound
    mu = gmm.mu;
    sigma = sqrt(gmm.Sigma);  % Assuming gmm.Sigma is a 1x1x2 array; if not, adjust accordingly
    w = gmm.ComponentProportion;
    syms x;

    eqn = w(1) * (1/(sigma(1) * sqrt(2*pi))) * exp(-(x - mu(1))^2 / (2*sigma(1)^2)) == ...
      w(2) * (1/(sigma(2) * sqrt(2*pi))) * exp(-(x - mu(2))^2 / (2*sigma(2)^2));

    % Solve for x
    threshold = double(solve(eqn, x));
    % Choose the threshold value that is within the range of your data
    threshold = threshold(threshold >= min(log(raduis_of_gyration_final)) & threshold <= max(log(raduis_of_gyration_final)));
    %Estimate the Bound Fraction
    %threshold = - 0.405
    %threshold = min(threshold);
    bound_indices = cell(1,size(radius_of_gyration_total, 2));
    for i = 1: size(radius_of_gyration_total, 2)
        bound_index = log(radius_of_gyration_total{i}) < threshold;  % Assuming smaller Rg values indicate "bound" state
        bound_indices{i} = bound_index;
    end
    bound_fraction = sum(vertcat(bound_indices{:})) / length(log(raduis_of_gyration_final));

