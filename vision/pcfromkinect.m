function ptCloud = pcfromkinect(varargin)
%PCFROMKINECT Get point cloud from Kinect for Windows.
%   ptCloud = PCFROMKINECT(depthDevice, depthImage) returns a point cloud
%   from a Kinect depth image, depthImage. depthDevice is a videoinput
%   object or an imaq.VideoDevice object. The origin of the coordinate
%   system of the returned point cloud is located at the center of the
%   depth camera.
%     
%   ptCloud = PCFROMKINECT(..., colorImage) returns a point cloud with
%   color. This means the depthImage is adjusted to align with the
%   colorImage.
%
%   ptCloud = PCFROMKINECT(..., colorImage, alignment) returns a point
%   cloud with color. alignment is a string that determines the direction
%   of alignment. Valid strings are 'colorCentric' or 'depthCentric'.
%
%   Notes
%   -----
%   - This function requires Image Acquisition Toolbox that supports Kinect
%     for Windows.
%
%   - The origin of a right-handed world coordinate system is at the center
%     of the camera. The X axis of the coordinate system is pointing to the
%     right, Y axis is pointing downward, and the Z axis is pointing away
%     from the camera.
%
%   - Since Kinect depth camera has limited range, some pixels in depth
%     image do not have corresponding 3-D coordinates. The values for those
%     pixels are set to NaN in the Location property of ptCloud.
%
%   - Since Kinect was designed for gaming, the original images, colorImage
%     and depthImage, from Kinect are mirror images of the scene. The
%     returned point cloud is corrected to match the actual scene.
%
%   Class Support 
%   ------------- 
%   depthDevice must be a videoinput object or an imaq.VideoDevice object
%   for Kinect's depth device. depthImage must be uint16. colorImage must
%   be uint8.
%
%   Example: Plot colored point cloud from Kinect for Windows
%   --------------------------------------------------------- 
%   % Create system objects for the Kinect device
%   colorDevice = imaq.VideoDevice('kinect',1)
%   % Change the returned type of color image from single to uint8
%   colorDevice.ReturnedDataType = 'uint8';
%
%   depthDevice = imaq.VideoDevice('kinect',2)
% 
%   % Initialize the cameras
%   step(colorDevice);
%   step(depthDevice);
%
%   % Grab one frame from the devices
%   colorImage = step(colorDevice);
%   depthImage = step(depthDevice);
% 
%   % Extract the point cloud
%   ptCloud = pcfromkinect(depthDevice, depthImage, colorImage);
%   
%   % Initialize a player to visualize 3-D point cloud data. The axis is 
%   % set appropriately to visualize the point cloud from Kinect.
%   player = pcplayer(ptCloud.XLimits, ptCloud.YLimits, ptCloud.ZLimits,...
%               'VerticalAxis', 'y', 'VerticalAxisDir', 'down');
%
%   xlabel(player.Axes, 'X (m)');
%   ylabel(player.Axes, 'Y (m)');
%   zlabel(player.Axes, 'Z (m)');
%
%   % Acquire and view 500 frames of live Kinect point cloud data
%   for i = 1:500    
%      colorImage = step(colorDevice);  
%      depthImage = step(depthDevice);
%
%      ptCloud = pcfromkinect(depthDevice, depthImage, colorImage);
%
%      view(player, ptCloud);
%   end
%
%   % Release the devices
%   release(colorDevice);
%   release(depthDevice);
%
% See also imaq.VideoDevice, videoinput, pcshow, pcplayer
 
%  Copyright 2015 The MathWorks, Inc.

[depthDevice, depthImage, isDepthOnly, colorImage, isDepthCentric] = ...
                                            validateAndParseInputs(varargin{:});

if isDepthOnly
    xyzPoints = vision.internal.visionKinectDepthToSkeleton(depthDevice, depthImage);    
    invalidIndex = find(depthImage(:)==0);
else    
    [xyzPoints, alignedFlippedImage] = ...
        vision.internal.visionKinectColorToSkeleton(depthDevice, depthImage, colorImage, isDepthCentric);
    invalidIndex = find(xyzPoints(:, :, 3)==0);
end

szImg = numel(depthImage);
xyzPoints(invalidIndex)         = NaN;
xyzPoints(invalidIndex+szImg)   = NaN;
xyzPoints(invalidIndex+szImg*2) = NaN;

% flip along X and Y axis to match the CVST coordinate system conventions
xyzPoints        = fliplr(xyzPoints);
xyzPoints(:,:,1) = -xyzPoints(:,:,1);
xyzPoints(:,:,2) = -xyzPoints(:,:,2);

if isDepthOnly
    ptCloud = pointCloud(xyzPoints);
else
    ptCloud = pointCloud(xyzPoints, 'Color', alignedFlippedImage);
end

%==========================================================================
%   Parameter validation
%==========================================================================
function [depthDevice, depthImage, isDepthOnly, colorImage, isDepthCentric] = ...
                                            validateAndParseInputs(varargin)
% validate and parse inputs
persistent depthParser colorParser;

isDepthOnly = (length(varargin) < 3);
if isDepthOnly 
    if isempty(depthParser)
        depthParser = inputParser;
        depthParser.CaseSensitive = false;
        depthParser.addRequired('DepthDevice', @validateDepthDevice)
        depthParser.addRequired('DepthImage', @(x)validateattributes(x, {'uint16'}, ...
                                {'real','nonsparse','2d','nonempty'}));
        parser = depthParser;
    else
        parser = depthParser;
    end
else
    if isempty(colorParser)
        colorParser = inputParser;
        colorParser.CaseSensitive = false;
        colorParser.addRequired('DepthDevice', @validateDepthDevice)
        colorParser.addRequired('DepthImage', @(x)validateattributes(x, {'uint16'}, ...
                                {'real','nonsparse','2d','nonempty'}));
        colorParser.addRequired('ColorImage', @(x)validateattributes(x, {'uint8'}, ...
                            {'real','nonsparse','nonempty','size',[NaN,NaN,3]}));
        colorParser.addOptional('Alignment', 'colorCentric', @validateAlignmentString);
        parser = colorParser;
    else
        parser = colorParser;
    end
end

parser.parse(varargin{:});

depthDevice = parser.Results.DepthDevice;
depthImage  = parser.Results.DepthImage;

if ~isDepthOnly
    colorImage = parser.Results.ColorImage;

    % validate the resolution of the input
    if size(depthImage,1)~=size(colorImage,1)||size(depthImage,2)~=size(colorImage,2)
        error(message('vision:pointcloud:mismatchDepthToColor'));
    end
    
    isDepthCentric = false;
    if strncmpi(parser.Results.Alignment,'d', 1)
        isDepthCentric = true;
    end
else
    colorImage = [];
    isDepthCentric = true;
end

%==========================================================================
%   Validate Depth Device
%==========================================================================
function tf = validateDepthDevice(value)
% validate the object class of the video device
if ~isa(value, 'videoinput') && ~isa(value, 'imaq.VideoDevice')
    error(message('vision:pointcloud:invalidDepthDevice'));
end
tf = true;

%==========================================================================
%   Validate Alignment String
%==========================================================================
function tf = validateAlignmentString(value)
% validate the alignment string
validatestring(value, {'colorCentric','depthCentric'});
tf = true;