function [imgList, maskList] = imgGet()
% IMGGET  Interactively load fluorescence images and their binary masks.
%
% Returns:
%   imgList  – 1×N cell array of uint16 fluorescence images
%   maskList – 1×N cell array of corresponding segmentation masks

    tifFiles = uigetfile('*.tif', ...
        'Select red-channel projected stacks', 'MultiSelect', 'on');
    if ischar(tifFiles)          % single file selected → wrap in cell
        tifFiles = {tifFiles};
    end

    n       = numel(tifFiles);
    imgList = cell(1, n);
    for i = 1:n
        imgList{i} = uint16(imread(tifFiles{i}));
    end

    pngFiles = uigetfile('*.png', ...
        'Select Cellpose brightfield masks', 'MultiSelect', 'on');
    if ischar(pngFiles)
        pngFiles = {pngFiles};
    end

    maskList = cell(1, n);
    for i = 1:n
        maskList{i} = imread(pngFiles{i});
    end
end
