% config.m
% Central configuration for the fluorescence intensity analysis pipeline.
% Edit values here rather than hunting through individual scripts.

% ── Binning ──────────────────────────────────────────────────────────────
CFG.BIN_WIDTH        = 300;    % pixels – cell-size bin width for scatter plots
CFG.BIN_WIDTH_BAR    = 500;    % pixels – bin width for bar-chart average intensities
CFG.BIN_MAX          = 5000;   % pixels – upper bound of bin range

% ── Outlier removal ──────────────────────────────────────────────────────
CFG.ZSCORE_THRESHOLD = 3;      % std-devs beyond which a cell is considered an outlier

% ── Statistics ───────────────────────────────────────────────────────────
CFG.CONF_LEVEL       = 0.05;   % alpha for confidence intervals / t-test
CFG.N_BOOTSTRAP      = 1000;   % bootstrap replicates for parameter CI estimation

% ── Polynomial fit ───────────────────────────────────────────────────────
CFG.POLY_DEGREE      = 2;      % degree used in polyFit
