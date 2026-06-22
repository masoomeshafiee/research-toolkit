function checkNormality(data, label)
% CHECKNORMALITY  Lilliefors test + histogram + Q-Q plot for a data vector.
%
% Usage:
%   checkNormality(avgIntensity, 'Average Intensity')
%   checkNormality(cellSize,     'Cell Size')

    arguments
        data  (1,:) double
        label (1,:) char = 'Data'
    end

    [~, p] = lillietest(data);
    if p > 0.05
        fprintf('%s: likely normally distributed (p = %.4g)\n', label, p);
    else
        fprintf('%s: likely NOT normally distributed (p = %.4g)\n', label, p);
    end

    figure;
    tiledlayout(1, 2);

    nexttile;
    histogram(data);
    title(['Histogram – ', label]);
    xlabel(label); ylabel('Frequency');

    nexttile;
    qqplot(data);
    title(['Q-Q plot – ', label]);
    xlabel('Theoretical quantiles'); ylabel('Sample quantiles');
end
