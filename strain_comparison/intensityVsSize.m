function [cellSize, avgIntensity] = intensityVsSize(strainName)
% INTENSITYVSSIZE  Load images interactively and extract per-cell size and
%                  mean fluorescence intensity.
%
% Usage:
%   [cellSize, avgIntensity] = intensityVsSize('Pdr mNG')
%
% If strainName is omitted, a dialog will ask for it.

    if nargin < 1 || isempty(strainName)
        answer     = inputdlg('Strain name:', 'Enter strain name');
        strainName = answer{1};
    end

    [imgList, maskList] = imgGet();

    cellSize     = [];
    avgIntensity = [];

    for i = 1:numel(imgList)
        props        = getCellProps(imgList{i}, maskList{i});
        cellSize     = [cellSize,     props.Area];        %#ok<AGROW>
        avgIntensity = [avgIntensity, props.MeanIntensity]; %#ok<AGROW>
    end

    figure;
    scatter(cellSize, avgIntensity, 'filled');
    title(['Intensity vs Cell Size – ', strainName]);
    xlabel('Cell size (pixels)');
    ylabel('Mean intensity per pixel');
end

% ── Helpers ──────────────────────────────────────────────────────────────

function props = getCellProps(img, mask)
% Return regionprops for every labelled cell in the mask.
    binaryMask = mask >= 1;                   % any label value → foreground
    props      = regionprops(binaryMask, img, 'Area', 'MeanIntensity');
end
