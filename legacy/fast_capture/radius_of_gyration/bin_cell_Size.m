% Assuming cellArea is a vector containing the area of each cell
% and boundFraction is a vector containing the bound fraction of each cell

% Define bin edges for cell size
binEdges = [0, 500, 1000, 1500, 2000, 2500, 3000,3500, 4000]; % Replace these numbers with appropriate bin edges for your data

% Initialize an array to store bound fractions for each bin
BoundFractionPerBin = zeros(1, length(binEdges) - 1);
RgPerBin = zeros(1, length(binEdges) - 1);
% Loop through each bin to calculate the bound fraction
for i = 1:(length(binEdges) - 1)
    % Find indices of cells whose size falls into the current bin
    idx = find(cellArea >= binEdges(i) & cellArea < binEdges(i + 1));
    
    % Calculate the mean bound fraction for cells in the current bin
    meanBoundFractionPerBin(i) = mean(boundFraction(idx));
end

% Now, meanBoundFractionPerBin contains the mean bound fraction for each bin
disp('Mean Bound Fraction Per Bin:');
disp(meanBoundFractionPerBin);

% You can also plot this information
figure;
bar(binEdges(1:end-1), meanBoundFractionPerBin, 'histc');
xlabel('Cell Area');
ylabel('Mean Bound Fraction');
