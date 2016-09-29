% cell_brightness_estimator
% EJR, 2016, CC-BY
%
% Approximately follows the cell-brightness estimating macro from
% CHMM / GS, for sample image data of Gen Simpson
% 
% Instructions:
% 1. Run this script in Matlab
% 2. Use the "open file" GUI to select one file of raw image data
% 3. This script then attempts to process each image file in the same
% folder
%
% Notes:
% 1. The background estimation parameter can be edited in section 0
% 2. Sample image data seems to 8-bit values stored in a 32-bit tif
%    (It seems possible my recommendations on file types have gone astray:
%     because the 8-bit values may have been rescaled! But maybe not - max
%     values of 203 (not 255) are identifiable.)
%    ---> No! Some values go up to 600, and import as uint16


% 0. Settings
%    Settings for running this script

backgroundP  = 0.25; % Set 0.25 to estimate the 25th percentile of imDat(:) as the d.c. background
threshParam  = 0.25; % Set a value between 0 and 1. 
maskErodeRad = 4;   % Might need an erosion filter - set radius here
erodeStrel   = strel('disk',maskErodeRad); 

% 1. Input
% (a) User specifies target folder
% (b) Create empty lists to store the results for each Tif in the folder

[FileNameSample,PathName] = uigetfile('*.tif',...
    'Open image data file in target folder (Tif)'); 

listOfFiles   = dir([PathName,'*.tif']);
numberOfFiles = length(listOfFiles);

% Preallocate a list to store detected 'cell' areas and intensities.
% Residual '-1' values at the end can be interpretted as an error
listArea       = -ones(numberOfFiles, 1); % Area in pixels
listBrightness = -ones(numberOfFiles, 1); % Mean raw brightness of ROIs
listMax        = -ones(numberOfFiles, 1); % Max pixel value in imDat
listMin        = -ones(numberOfFiles, 1); % Min pixel value in imDat
listBGestimate = -ones(numberOfFiles, 1); % DC background level estimate
listThresh     = -ones(numberOfFiles, 1); % Identified threshold;
listStdev      = -ones(numberOfFiles, 1); % Identified variation;

listNames      = cell(numberOfFiles, 1);

% 2. Analyse
% (a) Process each file in the chosen folder in series
% (b) Try to detect cell area and (pixel-average) brightness

for lpIm = 1:numberOfFiles
    imDat = imread([PathName,listOfFiles(lpIm).name]);
    
    imMax = max(imDat(:));
    imMin = min(imDat(:));
    imBG  = quantile(imDat(:), backgroundP);
    imTh  = imBG + threshParam * (imMax - imBG);
    
    imMsk = (imDat > imTh);
    imCut = imDat;
    imCut(not(imMsk)) = 0;
    figure(1)
    imagesc(imCut);
    colormap(gray)
    drawnow;
    
    imArea = sum(imMsk(:));
    imBr   = mean(imDat(imMsk));
    imSt   = std(double(imDat(imMsk)));
    
    listArea(lpIm)       = imArea;
    listBrightness(lpIm) = imBr;
    listMax(lpIm)        = imMax;
    listMin(lpIm)        = imMin;
    listBGestimate(lpIm) = imBG;
    listThresh(lpIm)     = imTh;
    listStdev(lpIm)      = imSt;
    
    listNames{lpIm}      = listOfFiles(lpIm).name;
end

% 3. Output
% (a) Results should now be sitting in the listXXXX arrays
% (b) Possibly export the results to a CSV spreadsheet