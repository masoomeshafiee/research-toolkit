function [cellSize, avgIntensity] = intensityVsCellSize
    % avg intensity? / how about the nois after segmentation?
    %taking the projected images from the red channel and the mask
    %from brightfield
    [imgList, noneBinaryList] = imgGet;
    cellSize = [];
    avgIntensity = [];
    for i = 1:numel(imgList)
        [CellsArea, finalIntensity] = getCellsinfo(imgList{i}, noneBinaryList{i});
        cellSize = [cellSize CellsArea'];
        avgIntensity = [avgIntensity finalIntensity'];
    end
    strainName = inputdlg('strain name', 'please insert the strain name');
    result = ['intensity vs cell size for', ' ', strainName{1}];
    scatter(cellSize, avgIntensity);
    title('intensity vs cell size');
    xlabel('cell size (pixel)');
    ylabel('Average intensity per pixel');
end
function segmentedImage = segmentation(image, binaryMask )
    image = im2double(image);
    segmentedImage = binaryMask .* image;
end
function [cellSizes, cellAvgIntensity]  = getCellsinfo(Img, nonbinaryMask)
    % Find unique labels in the mask
    uniqueLabels = unique(nonbinaryMask(:));

    % Remove the background label (assuming it's zero)
    uniqueLabels(uniqueLabels==0) = [];

    % Preallocate cell size vector
    cellSizes = zeros(length(uniqueLabels), 1);
    cellAvgIntensity = zeros(length(uniqueLabels), 1);

    % Measure the area (number of pixels) of each object (cell)
    for k = 1:length(uniqueLabels)
        % Create a binary image for the current cell
        binaryImage = nonbinaryMask == uniqueLabels(k);
    
        % Measure the area
        cellData = regionprops(binaryImage, 'Area');
    
        % Save the cell size
        cellSizes(k) = cellData.Area;
        % segment the current cell in the red channel projection image
        segmentedCell = segmentation(Img, binaryImage);
        %imshow(segmentedCell,[min(min(segmentedCell)),max(max(segmentedCell))])
        labeled_img = bwlabel(segmentedCell);
        imshow(labeled_img,[min(min(labeled_img)),max(max(labeled_img))])
        cellInfo = regionprops(labeled_img, segmentedCell, 'PixelList', 'PixelValues','MeanIntensity');
        %length(cellInfo)
        %k
        %length(cellInfo.PixelList)
        %avgIntensity = getAvgIntensity(cellInfo.PixelValues)
        cellAvgIntensity(k) = (cellInfo.MeanIntensity) * 65535;
        
    end
    
end

function intensity = getAvgIntensity(pixelValues)

    intensity = mean(im2double(pixelValues));
end
function [imgList, noneBinaryList] = imgGet
    % Read and store images in a cell array
    listOfImages = uigetfile('*.tif', 'Please choose your red channel projected stacks','MultiSelect','on');
    %listOfImages = {listOfImages};
    numImages = numel(listOfImages);
    imgList = cell(1, numImages);
    for i = 1:numImages
        img = imread(listOfImages{1,i});
        img = uint16(img);
        imgList{i} = img;
    end
    listOfMask = uigetfile('*.png', 'Please choose your masks created from Brightfield segmentation by cellpose','MultiSelect','on');
    %listOfMask = {listOfMask};
    noneBinaryList = cell(1, numImages);
    for i = 1:numImages
        mask = imread(listOfMask{1,i});
        noneBinaryList{i} = mask;
    end
end
