function compareStrainDistributions(intensityPdr, intensityDpdr, opts)
% COMPARESTRAINDISTRIBUTIONS  Fit log-normal distributions to two intensity
%   vectors, plot overlaid histograms + PDFs, print summary statistics, and
%   compute 95 % confidence intervals via both parametric and bootstrap methods.
%
% Usage:
%   compareStrainDistributions(avgIntensityPdr, avgIntensityDpdr)
%   compareStrainDistributions(avgIntensityPdr, avgIntensityDpdr, opts)
%
% Options (struct fields, all optional):
%   opts.label1      – display name for strain 1  (default 'pdr')
%   opts.label2      – display name for strain 2  (default 'Δpdr')
%   opts.nBootstrap  – bootstrap replicates        (default 1000)

    arguments
        intensityPdr  (1,:) double
        intensityDpdr (1,:) double
        opts.label1     (1,:) char = 'pdr'
        opts.label2     (1,:) char = 'Δpdr'
        opts.nBootstrap (1,1) double = 1000
    end

    data1 = log(intensityPdr(:));
    data2 = log(intensityDpdr(:));

    % ── Fit normal distributions to log-transformed data ─────────────────
    dist1 = fitdist(data1, 'Normal');
    dist2 = fitdist(data2, 'Normal');

    % ── Per-strain histograms ─────────────────────────────────────────────
    plotSingleHist(data1, dist1, opts.label1);
    plotSingleHist(data2, dist2, opts.label2);

    % ── Overlaid PDFs ─────────────────────────────────────────────────────
    xRange = linspace(min([data1; data2]), max([data1; data2]), 1000);
    figure;
    plot(xRange, pdf(dist1, xRange), 'b-', 'LineWidth', 2); hold on;
    plot(xRange, pdf(dist2, xRange), 'r-', 'LineWidth', 2); hold off;
    xlabel('log(intensity)');
    ylabel('PDF');
    title(['Log-intensity distributions: ', opts.label1, ' vs ', opts.label2]);
    legend(opts.label1, opts.label2);
    grid on;

    % ── 2×2 summary panel ────────────────────────────────────────────────
    figure;
    subplot(2,2,1); histogram(data1, 'Normalization', 'probability');
    title(['Histogram – ', opts.label1]); xlabel('log(intensity)'); ylabel('Probability');

    subplot(2,2,2); histogram(data2, 'Normalization', 'probability');
    title(['Histogram – ', opts.label2]); xlabel('log(intensity)'); ylabel('Probability');

    subplot(2,2,3); ksdensity(data1);
    xlabel('log(intensity)'); ylabel('Density'); title(opts.label1);

    subplot(2,2,4); ksdensity(data2);
    xlabel('log(intensity)'); ylabel('Density'); title(opts.label2);

    % ── Summary statistics ────────────────────────────────────────────────
    printSummary(data1, dist1, opts.label1);
    printSummary(data2, dist2, opts.label2);

    % ── Parametric confidence intervals ───────────────────────────────────
    printParamCI(dist1, opts.label1);
    printParamCI(dist2, opts.label2);

    % ── Bootstrap CI on dist1 (pdr) parameters ───────────────────────────
    bootstrapCI(data1, opts.label1, opts.nBootstrap);
end

% ── Private helpers ───────────────────────────────────────────────────────

function plotSingleHist(data, dist, label)
    x = linspace(min(data), max(data), 500)';
    figure;
    histogram(data, 'BinMethod', 'fd', 'Normalization', 'pdf'); hold on;
    plot(x, pdf(dist, x), 'r-', 'LineWidth', 2); hold off;
    title(label);
    xlabel('log(intensity)');
    ylabel('PDF');
    legend('Data', 'Normal fit');
end

function printSummary(data, dist, label)
    fprintf('\n── %s ──\n', label);
    fprintf('  mu    = %.4f   (95%% CI: [%.4f, %.4f])\n', dist.mu, ...
        paramci(dist, 'Alpha', 0.05));
    fprintf('  sigma = %.4f\n', dist.sigma);
    fprintf('  Mean of log-data  : %.4f\n', mean(data));
    fprintf('  Median of log-data: %.4f\n', median(data));
end

function printParamCI(dist, label)
    ci = paramci(dist, 'Alpha', 0.05);
    fprintf('\nParametric 95%% CI – %s:\n', label);
    fprintf('  mu    : [%.4f, %.4f]\n', ci(1,1), ci(1,2));
    fprintf('  sigma : [%.4f, %.4f]\n', ci(2,1), ci(2,2));
end

function bootstrapCI(data, label, nBoot)
    muBoot    = zeros(nBoot, 1);
    sigmaBoot = zeros(nBoot, 1);
    for k = 1:nBoot
        s          = datasample(data, numel(data), 'Replace', true);
        d          = fitdist(s, 'Normal');
        muBoot(k)  = d.mu;
        sigmaBoot(k) = d.sigma;
    end
    ciMu    = prctile(muBoot,    [2.5, 97.5]);
    ciSigma = prctile(sigmaBoot, [2.5, 97.5]);
    fprintf('\nBootstrap 95%% CI – %s:\n', label);
    fprintf('  mu    : [%.4f, %.4f]\n', ciMu(1),    ciMu(2));
    fprintf('  sigma : [%.4f, %.4f]\n', ciSigma(1), ciSigma(2));
end
