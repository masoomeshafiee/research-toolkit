function plotFits(cellSize, avgIntensity, opts)
% PLOTFITS  Visualise intensity vs size relationships with various fits.
%           Generates one figure per requested fit type.
%
% Usage:
%   plotFits(cellSize, avgIntensity)
%   plotFits(cellSize, avgIntensity, opts)
%
% Options:
%   opts.linear    – show linear regression            (default true)
%   opts.poly      – show polynomial regression        (default true)
%   opts.gaussian  – show bivariate Gaussian contours  (default true)
%   opts.bar       – show bar chart of binned averages (default true)
%   opts.polyDeg   – polynomial degree                 (default 2)
%   opts.binWidth  – bin width for bar chart           (default 500)
%   opts.title     – prefix appended to each figure title

    arguments
        cellSize     (1,:) double
        avgIntensity (1,:) double
        opts.linear   (1,1) logical = true
        opts.poly     (1,1) logical = true
        opts.gaussian (1,1) logical = true
        opts.bar      (1,1) logical = true
        opts.polyDeg  (1,1) double  = 2
        opts.binWidth (1,1) double  = 500
        opts.title    (1,:) char    = ''
    end

    prefix = opts.title;
    if ~isempty(prefix), prefix = [prefix, ' – ']; end

    % ── Scatter (always shown) ────────────────────────────────────────────
    figure;
    scatter(cellSize, avgIntensity, 'filled');
    title([prefix, 'Cell size vs intensity']);
    xlabel('Cell size (pixels)'); ylabel('Mean intensity');

    % ── 2-D histogram ─────────────────────────────────────────────────────
    figure;
    histogram2(cellSize, avgIntensity, 'DisplayStyle', 'tile');
    colorbar;
    title([prefix, '2-D histogram']);
    xlabel('Cell size (pixels)'); ylabel('Mean intensity');

    % ── Linear regression ─────────────────────────────────────────────────
    if opts.linear
        lm = fitlm(cellSize, avgIntensity);
        disp(lm);
        figure;
        scatter(cellSize, avgIntensity, 'filled'); hold on;
        plot(cellSize, lm.Fitted, 'r-', 'LineWidth', 2); hold off;
        title([prefix, 'Linear regression']);
        xlabel('Cell size (pixels)'); ylabel('Mean intensity');
        legend('Data', 'Linear fit');
    end

    % ── Polynomial regression ─────────────────────────────────────────────
    if opts.poly
        coeffs = polyfit(cellSize, avgIntensity, opts.polyDeg);
        xRange = linspace(min(cellSize), max(cellSize), 200);
        figure;
        scatter(cellSize, avgIntensity, 'filled'); hold on;
        plot(xRange, polyval(coeffs, xRange), 'r-', 'LineWidth', 2); hold off;
        title([prefix, sprintf('Degree-%d polynomial regression', opts.polyDeg)]);
        xlabel('Cell size (pixels)'); ylabel('Mean intensity');
        legend('Data', 'Polynomial fit');
    end

    % ── Bivariate Gaussian ────────────────────────────────────────────────
    if opts.gaussian
        gm = fitgmdist([cellSize(:), avgIntensity(:)], 1, 'CovarianceType', 'diagonal');
        xg = linspace(min(cellSize),     max(cellSize),     100);
        yg = linspace(min(avgIntensity), max(avgIntensity), 100);
        [Xg, Yg] = meshgrid(xg, yg);
        Zg = reshape(pdf(gm, [Xg(:), Yg(:)]), size(Xg));
        figure;
        scatter(cellSize, avgIntensity, 'filled'); hold on;
        contour(Xg, Yg, Zg, 'LineWidth', 1.5); hold off;
        title([prefix, 'Bivariate Gaussian fit']);
        xlabel('Cell size (pixels)'); ylabel('Mean intensity');
        legend('Data', 'Gaussian contours');
    end

    % ── Binned bar chart ──────────────────────────────────────────────────
    if opts.bar
        edges      = 0 : opts.binWidth : max(cellSize);
        nBins      = numel(edges) - 1;
        binMeans   = arrayfun( ...
            @(k) mean(avgIntensity(cellSize >= edges(k) & cellSize < edges(k+1))), ...
            1:nBins);
        figure;
        bar(edges(1:end-1), binMeans);
        title([prefix, 'Mean intensity per size bin']);
        xlabel('Cell size (pixels)'); ylabel('Mean intensity');
    end
end
