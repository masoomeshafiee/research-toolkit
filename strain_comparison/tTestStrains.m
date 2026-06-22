function tTestStrains(intensityPdr, intensityDpdr, opts)
% TTESTSTRAINS  Two-sample t-test on log-transformed intensities, with
%               means and 95 % confidence intervals.
%
% Usage:
%   tTestStrains(avgIntensityPdr, avgIntensityDpdr)
%   tTestStrains(avgIntensityPdr, avgIntensityDpdr, opts)
%
% Options:
%   opts.alpha  – significance level (default 0.05)
%   opts.label1 – name for strain 1  (default 'PDR5')
%   opts.label2 – name for strain 2  (default 'ΔPDR5')

    arguments
        intensityPdr  (1,:) double
        intensityDpdr (1,:) double
        opts.alpha  (1,1) double = 0.05
        opts.label1 (1,:) char  = 'PDR5'
        opts.label2 (1,:) char  = 'ΔPDR5'
    end

    logPdr  = log(intensityPdr(:));
    logDpdr = log(intensityDpdr(:));

    [h, p] = ttest2(logPdr, logDpdr, 'Alpha', opts.alpha);

    fprintf('\n── Two-sample t-test (log-transformed intensities) ──\n');
    if h
        fprintf('  Reject H₀ (means differ).  p = %.4g\n', p);
    else
        fprintf('  Fail to reject H₀.          p = %.4g\n', p);
    end

    datasets = {intensityPdr,  intensityDpdr};
    labels   = {opts.label1,  opts.label2};
    for k = 1:2
        ci = confidenceInterval(datasets{k}, opts.alpha);
        fprintf('\n  %s\n', labels{k});
        fprintf('    Mean : %.4f\n',            mean(datasets{k}));
        fprintf('    95%% CI: [%.4f, %.4f]\n', ci(1), ci(2));
    end
end

% ── Helper ───────────────────────────────────────────────────────────────

function ci = confidenceInterval(data, alpha)
    n   = numel(data);
    sem = std(data) / sqrt(n);
    t   = tinv(1 - alpha/2, n - 1);
    ci  = mean(data) + t * sem * [-1, 1];
end
