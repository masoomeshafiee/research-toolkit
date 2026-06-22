function plotBinnedIntensity(cellSize, avgIntensity, opts)
% PLOTBINNEDINTENSITY  Bin cells by size and plot mean intensity per bin.
%
% Usage:
%   plotBinnedIntensity(cellSize, avgIntensity)
%   plotBinnedIntensity(cellSize, avgIntensity, opts)
%
% Options (struct fields, all optional):
%   opts.binWidth        – bin width in pixels          (default 300)
%   opts.binMax          – upper edge of last bin        (default 5000)
%   opts.removeOutliers  – logical, z-score filtering    (default false)
%   opts.zThreshold      – z-score cutoff when filtering (default 3)
%   opts.title           – figure title string

    arguments
        cellSize     (1,:) double
        avgIntensity (1,:) double
        opts.binWidth       (1,1) double  = 300
        opts.binMax         (1,1) double  = 5000
        opts.removeOutliers (1,1) logical = false
        opts.zThreshold     (1,1) double  = 3
        opts.title          (1,:) char    = 'Mean intensity vs cell size'
    end

    % ── Optional outlier removal ──────────────────────────────────────────
    if opts.removeOutliers
        keep         = abs(zscore(cellSize)) < opts.zThreshold;
        cellSize     = cellSize(keep);
        avgIntensity = avgIntensity(keep);
    end

    % ── Bin and average ───────────────────────────────────────────────────
    edges       = 0 : opts.binWidth : opts.binMax;
    binIdx      = discretize(cellSize, edges);
    nBins       = numel(edges) - 1;
    binMeans    = arrayfun(@(k) mean(avgIntensity(binIdx == k)), 1:nBins);
    binMidpoints = (edges(1:end-1) + edges(2:end)) / 2;

    % ── Plot ─────────────────────────────────────────────────────────────
    figure;
    plot(binMidpoints, binMeans, 'o-', 'LineWidth', 1.5);
    xlabel('Cell size (pixels)');
    ylabel('Mean intensity');
    title(opts.title);
    grid on;
end
