% ImageSet Stores all information about images that need to be labeled
%
%    This class stores all the information about the labeld images
%    including the ROIs.

% Copyright 2013 The MathWorks, Inc.

classdef ImageSet < handle
    
    properties
        
        % Array of image structs
        % Contains the following fields:
        %   1. imageFilename
        %   2. objectBoundingBoxes
        %   3. ImageIcon
        %   4. ImageLabel
        
        ImageStruct;           % Empty array of image structs
        ROIBoundingBoxes;      % ROI Bounding Box struct that can be used in trainCascade algorithm
        AreThumbnailsGenerated % logical array that stores whether or not an icon has been generated for each image in the ImageStruct
        
    end
    
    % Adding property 'IsROISelected' to store selection status of ROIs 
    % It is 'Transient' since we do not want to save it in the MAT file
    
    properties(Transient = true)
        IsROISelected;
    end
    
    properties(Access=private, Hidden)
        
        Version = ver('vision');
        
    end
    
    methods
        
        %------------------------------------------------------------------
        % Constructor
        %----------------------------------------------------------------
        
        function this = ImageSet()
            
            this.ImageStruct = [];
            this.ROIBoundingBoxes = [];
            this.AreThumbnailsGenerated = [];
            this.IsROISelected = [];
            
        end
        
        
        %------------------------------------------------------------------
        % Returns true if the session already has images else returns false
        %------------------------------------------------------------------
        
        function ret = hasAnyImages(this)
            
            ret = ~isempty(this.ImageStruct);
            
        end
        
        %------------------------------------------------------------------
        % Creates and populates a struct file ImageStruct
        %------------------------------------------------------------------
        % edit: create new struct and then append        
        function startingIndex = addImagesToSession(this, imageFileNames)

            startingIndex = []; % initialize the index
            
            % Function that eliminates files that are not images
            imageFileNames = this.eliminateNonImages(imageFileNames);
            
            % If there are no images
            if isempty(imageFileNames)
                return;
            end
            
            % look for duplicates and if found, silently remove them
            if this.hasAnyImages() 
                imageFileNames = this.getUniqueFiles(imageFileNames);
                if isempty(imageFileNames)
                    return; % nothing to add
                end                
            end            
            
            labels = generateImageLabels(imageFileNames);
            placeholders = this.generatePlaceHolders(imageFileNames);
            icons = placeholders;
            areThumbnailsGenerated = zeros(1, numel(imageFileNames));
            newImageStruct = struct('imageFilename', imageFileNames, ...
                'objectBoundingBoxes', cell(1, numel(imageFileNames)), ...
                'ImageIcon', icons, 'ImageLabel', labels, ...
                'ImagePlaceHolder', placeholders);
            
            newROIselected = cell(1, numel(imageFileNames));
            
            if this.hasAnyImages()                
                this.AreThumbnailsGenerated = [this.AreThumbnailsGenerated, ...
                    areThumbnailsGenerated];
                startingIndex = numel(this.ImageStruct)+1;
                this.ImageStruct = [this.ImageStruct newImageStruct];
                this.IsROISelected = [this.IsROISelected newROIselected];
            else
                this.ImageStruct = newImageStruct;
                this.AreThumbnailsGenerated = areThumbnailsGenerated;
                this.IsROISelected = newROIselected;
                startingIndex = 1;
            end            
        end
        
        
        %------------------------------------------------------------------
        % inputs:
        % newImageStruct            - ImageStruct from the newly opened session;
        % newAreThumbnailsGenerated - Logical array to indicate if thumbnails
        %                             are generated;
        %------------------------------------------------------------------
        
        function addedImages = addImageStructToCurrentSession(this, newImageStruct, newAreThumbnailsGenerated)
            
            % Look for duplicate images in the added session
            imageFilenames = this.getUniqueFiles({newImageStruct.imageFilename});
            if isempty(imageFilenames)
                addedImages = false;
                return;
            end
            addedImages = true;
            [~, indices] = intersect({newImageStruct.imageFilename}, imageFilenames);
            
            this.ImageStruct = [this.ImageStruct newImageStruct(indices)];
            % Initialize 'IsROISelected' for newly added session
            for i = 1: length(newImageStruct)
                this.IsROISelected{end+1} = false(size(newImageStruct...
                    (i).objectBoundingBoxes,1),1);
            end
            this.AreThumbnailsGenerated = [this.AreThumbnailsGenerated,...
                newAreThumbnailsGenerated(indices)];
        end
        
        %--------------------------------------------------------------
        function [imageMatrix, imageLabel] = getImages(this, selectedIndex)
            
            % If multiple files are selected grab just the first one
            selectedIndex = selectedIndex(1);
            imageMatrix = imread(this.ImageStruct(selectedIndex).imageFilename);
            imageLabel = this.ImageStruct(selectedIndex).ImageLabel;
            
        end
        
        %------------------------------------------------------------------
        function needsUpdate = updateBoundingBoxes(this, selectedIndex, boundingBoxes, roiselected)
            
            % If multiple files are selected grab just the first one
            selectedIndex = selectedIndex(1);
            needsUpdate = false;
            if ~isequal(this.ImageStruct(selectedIndex).objectBoundingBoxes, ...
                    boundingBoxes)
                this.ImageStruct(selectedIndex).objectBoundingBoxes = boundingBoxes;
                if ~isequal(this.IsROISelected{selectedIndex}, roiselected)
                    this.IsROISelected{selectedIndex} = roiselected;
                end
                needsUpdate = true;
            else
                if ~isequal(this.IsROISelected{selectedIndex}, roiselected)
                    this.IsROISelected{selectedIndex} = roiselected;
                    needsUpdate = true;
                end
            end
            
        end
        
        %------------------------------------------------------------------
        function removeImage(this, selectedIndex)
            
            this.ImageStruct(selectedIndex)            = [];
            this.AreThumbnailsGenerated(selectedIndex) = [];
            this.IsROISelected(selectedIndex) = [];
            
        end
        
        %------------------------------------------------------------------
        function rotateImages(this, selectedIndex, rotationType)
           
            for i = 1:numel(selectedIndex)
                try
                    imageFileName = this.ImageStruct(selectedIndex(i)).imageFilename;
                    im = imread(imageFileName);
                    if strcmp(rotationType, 'Clockwise')
                        im_rot = imrotate(im, -90);
                    elseif strcmp(rotationType, 'CounterClockwise')
                        im_rot = imrotate(im, 90);
                    end
                    % edit: How should we handle writing when you don't have
                    % disk permissions?
                    imwrite(im_rot, imageFileName);
                    numROIs = this.getNumROIs(selectedIndex(i));
                    icon = this.generateImageIcon(imageFileName, numROIs);
                    this.ImageStruct(selectedIndex(i)).ImageIcon = icon{1};
                    
                    [numRows,numCols,~] = size(im);                                           
                    
                    % Store current ROI co-ordinates
                    oldBoxPoints = this.ImageStruct(selectedIndex(i)).objectBoundingBoxes;            
                    
                    % Update ROI co-ordinates after rotation
                    for index = 1:size(oldBoxPoints,1)
                        % The distance of the box edges to the image edges
                        % remains the same after rotation.
                        % So modify xmin and ymin accordingly
                        if strcmp(rotationType, 'Clockwise')
                            x = numRows - (oldBoxPoints(index,2) + oldBoxPoints(index,4));     
                            y = oldBoxPoints(index,1);                                          
                        elseif strcmp(rotationType, 'CounterClockwise')
                            x = oldBoxPoints(index,2);                                         
                            y = numCols - (oldBoxPoints(index,1) + oldBoxPoints(index,3));     
                        end
                        
                        % Width and height get interchanged after rotation
                        % Save the new position values to ImageStruct
                        this.ImageStruct(selectedIndex(i)).objectBoundingBoxes(index,1:4) = ...
                            [x y oldBoxPoints(index,4) oldBoxPoints(index,3)];
                    end
                    
                    
                catch err
                    errordlg(err.message,...
                        vision.getMessage('vision:trainingtool:WritingToDiskFailed'),...
                        'modal');
                end
                
            end
            
        end
        
        %------------------------------------------------------------------
        function reset(this)                
            this.ImageStruct = [];                
            this.ROIBoundingBoxes = [];
            this.AreThumbnailsGenerated = [];
        end
        
        %------------------------------------------------------------------
        function setROIBoundingBoxes(this)
            
            fieldsToRemove = {'ImageIcon', 'ImageLabel', 'ImagePlaceHolder'};
            imagesWithoutROIs = cellfun(@isempty, {this.ImageStruct.objectBoundingBoxes});
            modifiedImageStruct = this.ImageStruct;
            modifiedImageStruct(imagesWithoutROIs) = [];
            this.ROIBoundingBoxes = rmfield(modifiedImageStruct, fieldsToRemove);
            
        end
        
        %------------------------------------------------------------------
        function numROIs = getNumROIs(this, selectedIndex)
            
            numROIs = size(this.ImageStruct(selectedIndex).objectBoundingBoxes,1);
            
        end
        
        %------------------------------------------------------------------
        function updateIconDescription(this, selectedIndex)
            
            label = this.ImageStruct(selectedIndex).ImageLabel;
            numROIs = this.getNumROIs(selectedIndex);
            this.ImageStruct(selectedIndex).ImageIcon.setDescription...
                ([label, '<br><br>ROIs: ', num2str(numROIs)]);
            
        end
        
        %------------------------------------------------------------------
        % This method should be called after the Image Session is loaded from a
        % MAT file to check that all the images can be found at their
        % specified locations
        %------------------------------------------------------------------
        function checkImagePaths(this, currentSessionFilePath,...
                origFullSessionFileName)
            
            % verify that all the images are present; adjust path if
            % necessary
            for i=1:numel(this.ImageStruct)
                if ~exist(this.ImageStruct(i).imageFilename,'file')
                    
                    this.ImageStruct(i).imageFilename = ...
                        vision.internal.uitools.tryToAdjustPath(...
                        this.ImageStruct(i).imageFilename, ...
                        currentSessionFilePath, origFullSessionFileName);
                    
                end
            end            
        end 
        
        %------------------------------------------------------------------
        function ret = areAllImagesLabeled(this)
            
            ret = ~any(cellfun(@isempty, {this.ImageStruct.objectBoundingBoxes}));
            
        end
        
        %------------------------------------------------------------------
        % edit: change the name to updateImageListEntry(this, selectedIndex)
        function updateMade = updateImageListEntry(this, selectedIndex)
            
            updateMade = true;            
            
            if selectedIndex == -1 % when JList is loading for the first time
                selectedIndex = 1;
            else
                selectedIndex = selectedIndex+1; % making it MATLAB based
            end
            
            if this.AreThumbnailsGenerated(selectedIndex)
                updateMade = false;
                return;
            end
            
            fileName = this.ImageStruct(selectedIndex).imageFilename;
            numROIs = this.getNumROIs(selectedIndex);
            icon = this.generateImageIcon(fileName, numROIs);
            this.ImageStruct(selectedIndex).ImageIcon = icon{1};
            this.AreThumbnailsGenerated(selectedIndex) = 1;
            
        end
        
        %------------------------------------------------------------------
        function ret = areAllIconsGenerated(this)
            ret = all(this.AreThumbnailsGenerated);
        end
        
    end
    
    %======================================================================
    methods (Access=private)
        
        %------------------------------------------------------------------
        function uniqueImageFileNames = getUniqueFiles(this, imageFileNames)
            uniqueImageFileNames = setdiff(unique(...
                [{this.ImageStruct.imageFilename} imageFileNames]),...
                {this.ImageStruct.imageFilename});
        end
        
        %------------------------------------------------------------------
    end
    %======================================================================
    
    methods(Access = private, Static)
                
        %------------------------------------------------------------------
        % This function generates place holder icons for images that are
        % not yet visible in the image browser window
        %------------------------------------------------------------------
        function icons = generatePlaceHolders(imageFileNames)
            icons = cell(1, numel(imageFileNames));
            
            % grab a place holder image from the disk
            placeHolderImage = fullfile(matlabroot,'toolbox','vision',...
                'vision','+vision','+internal','+cascadeTrainer','+tool',...
                'PlaceHolderImage_72.png');            
            im = imread(placeHolderImage);
            
            % prapare list data
            javaImage = im2java2d(im);
            numROIsStr = num2str(0); % no ROIs for placeholders
            labels = generateImageLabels(imageFileNames);

            % populate the icons
            for i = 1:numel(imageFileNames)
                icons{i} = javax.swing.ImageIcon(javaImage);
                icons{i}.setDescription([labels{i}, '<br><br>ROIs: ', numROIsStr]);
            end
        end
        
        %------------------------------------------------------------------
        % edit code to return icon as a java icon object and not a cell array
        %------------------------------------------------------------------
        
        function icon = generateImageIcon(imageFileName, numROIs)
            if ~iscell(imageFileName)
                imageFileName = cellstr(imageFileName);
            end
            label = generateImageLabels(imageFileName);
            try
                im = imread(imageFileName{1});
                javaImage = im2java2d(imresize(im, [72 72]));
                icon{1} = javax.swing.ImageIcon(javaImage);
                icon{1}.setDescription([label{1}, '<br><br>ROIs: ', num2str(numROIs)]);
            catch loadingEx
                errordlg(loadingEx.message,...
                    vision.getMessage('vision:uitools:LoadingImageFailedTitle'),...
                    'modal');
            end
        end
        
        %------------------------------------------------------------------
        function files = eliminateNonImages(imageFileNames)
            isImage = true(1, numel(imageFileNames));
            disableImfinfoWarnings();
            for i = 1:numel(imageFileNames)
                
                try
                    imfinfo(imageFileNames{i});
                catch
                    isImage(i) = false;
                end
            end
            enableImfInfoWarnings();
            files = imageFileNames(isImage);
            
            % Nested functions
            %--------------------------------------------------------------
            function disableImfinfoWarnings()
                imfinfoWarnings('off');
            end
            %--------------------------------------------------------------
            function enableImfInfoWarnings()
                imfinfoWarnings('on');
            end
            %--------------------------------------------------------------
            function imfinfoWarnings(onOff)
                warnings = {'MATLAB:imagesci:tifftagsread:badTagValueDivisionByZero',...
                    'MATLAB:imagesci:tifftagsread:numDirectoryEntriesIsZero',...
                    'MATLAB:imagesci:tifftagsread:tagDataPastEOF'};
                for j = 1:length(warnings)
                    warning(onOff, warnings{j});
                end
            end
            %--------------------------------------------------------------
        end
    end
    %======================================================================
    
    %----------------------------------------------------------------------
    % saveobj and loadobj are implemented to ensure compatibility across
    % releases even if architecture of Session class changes
    %----------------------------------------------------------------------
    methods (Hidden)
        
        function thisOut = saveobj(this)
            thisOut = this;
        end
        
    end
    %======================================================================
    
    methods (Static, Hidden)
        
        function thisOut = loadobj(this)
            thisOut = this;
        end
        
    end
    %======================================================================
    
end

%------------------------------------------------------------------
% edit: trace where the imageFileNames first come into play and protect it over there.
function labels = generateImageLabels(imageFileNames)

if ~iscell(imageFileNames)
    imageFileNames = cellstr(imageFileNames);
end
[~, labels, ~] = cellfun(@fileparts, imageFileNames, 'UniformOutput', 0);

end
