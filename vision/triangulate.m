%TRIANGULATE Find 3-D locations of matching points in stereo images.
%
%   worldPoints = TRIANGULATE(matchedPoints1, matchedPoints2, stereoParams)
%   returns 3-D locations of matching pairs of undistorted image points
%   in stereo images. worldPoints is an M-by-3 matrix containing 3-D 
%   coordinates relative to the optical center of camera 1. matchedPoints1 
%   and matchedPoints2 can be M-by-2 matrices of [x,y] coordinates, 
%   cornerPoints objects, SURFPoints objects, MSERRegions objects, or
%   BRISKPoints objects. stereoParams is a stereoParameters object.
%
%   worldPoints = TRIANGULATE(matchedPoints1, matchedPoints2, 
%     cameraMatrix1, cameraMatrix2) returns the 3-D locations in a world
%   coordinate system defined by 4-by-3 camera projection matrices: 
%   cameraMatrix1 and cameraMatrix2, which map a 3-D world point in 
%   homogeneous coordinates onto the corresponding image points.
%
%   [worldPoints, reprojectionErrors] = TRIANGULATE(...) additionally
%   returns reprojection errors for the world points. reprojectionErrors is
%   an M-by-1 vector containing the average reprojection error for each
%   world point.
% 
%   Notes
%   -----
%   - The function does not account for lens distortion. You can either
%     undistort the images using the undistortImage function before 
%     detecting the points, or you can undistort the points themselves 
%     using the undistortPoints function.
%
%   - If you pass a stereoParameters object to the function, the world
%     coordinate system has the origin at the optical center of camera 1,
%     with the X-axis pointing to the right, the Y-axis pointing down, and
%     the Z-axis pointing away from the camera.
%
%   - If you pass camera matrices to the function, the world coordinate 
%     system is defined by those matrices. In both cases the function uses 
%     a right-handed coordinate system.
%   
%   Class Support
%   -------------
%   matchedPoints1 and matchedPoints2 can be double, single, or any of the
%   <a href="matlab:helpview(fullfile(docroot,'toolbox','vision','vision.map'),'pointfeaturetypes')">point feature types</a>. stereoParams must be a stereoParameters object. 
%   cameraMatrix1 and cameraMatrix2 must be real and non-sparse numeric matrices.
%   worldPoints is double if matchedPoints1 and matchedPoints2 are double.
%   Otherwise worldPoints is of class single.
%   
%   Example 1 - Measure distance to a face 
%   --------------------------------------
%   % Load stereoParams
%   load('webcamsSceneReconstruction.mat');
%
%   % Read in the stereo pair of images.
%   I1 = imread('sceneReconstructionLeft.jpg');
%   I2 = imread('sceneReconstructionRight.jpg');
%
%   % Undistort the images
%   I1 = undistortImage(I1, stereoParams.CameraParameters1);
%   I2 = undistortImage(I2, stereoParams.CameraParameters2);
%
%   % Detect a face in both images
%   faceDetector = vision.CascadeObjectDetector;
%   face1 = step(faceDetector, I1);
%   face2 = step(faceDetector, I2);
%
%   % Find the center of the face
%   center1 = face1(1:2) + face1(3:4) / 2;
%   center2 = face2(1:2) + face2(3:4) / 2;
%
%   % Compute the distance from camera 1 to the face
%   point3d = triangulate(center1, center2, stereoParams);
%   distanceInMeters = norm(point3d) / 1000;
%
%   % Display detected face and distance
%   distanceAsString = sprintf('%0.2f meters', distanceInMeters);
%   I1 = insertObjectAnnotation(I1, 'rectangle', face1, distanceAsString, ...
%       'FontSize', 18);
%   I2 = insertObjectAnnotation(I2, 'rectangle', face2, distanceAsString, ...
%       'FontSize', 18);
%   I1 = insertShape(I1, 'FilledRectangle', face1);
%   I2 = insertShape(I2, 'FilledRectangle', face2);
%
%   imshowpair(I1, I2, 'montage');
%
%   Example 2 - Structure From Motion From Two Views
%   ----------------------------------------------------
%   % This example shows you how to build a point cloud based on features
%   % matched between two images of an object.
%   % <a href="matlab:web(fullfile(matlabroot,'toolbox','vision','visiondemos','html','StructureFromMotionExample.html'))">View example</a>
%
%   See also estimateCameraParameters, cameraCalibrator, 
%     stereoCameraCalibrator, cameraMatrix, cameraPose, undistortImage, 
%     undistortPoints, reconstructScene, cameraParameters, stereoParameters

% Copyright 2014 MathWorks, Inc.

% References:
%
% Hartley, Richard, and Andrew Zisserman. Multiple View Geometry in
% Computer Vision. Second Edition. Cambridge, 2000. p. 312

%#codegen

function [points3d, reprojectionErrors] = triangulate(matchedPoints1, ...
    matchedPoints2, varargin)

[points2d, cameraMatrices] = ...
    parseInputs(matchedPoints1, matchedPoints2, varargin{:});

numPoints = size(points2d, 1);
points3d = zeros(numPoints, 3, 'like', points2d);
reprojectionErrors = zeros(numPoints, 1, 'like', points2d);

for i = 1:numPoints
    [points3d(i, :), errors] = ...
        triangulateOnePoint(cameraMatrices, squeeze(points2d(i, :, :))');
    reprojectionErrors(i) = mean(hypot(errors(:, 1), errors(:, 2)));
end

%--------------------------------------------------------------------------
function [points2d, cameraMatrices] = ...
    parseInputs(matchedPoints1, matchedPoints2, varargin)

narginchk(3, 4);
points2d = parsePoints(matchedPoints1, matchedPoints2);
cameraMatrices = cast(parseCameraMatrices(varargin{:}), 'like', points2d);

%--------------------------------------------------------------------------
function points2d = parsePoints(matchedPoints1, matchedPoints2)

[points1, points2] =  ...
    vision.internal.inputValidation.checkAndConvertMatchedPoints(...
    matchedPoints1, matchedPoints2, mfilename, 'matchedPoints1', ...
    'matchedPoints2');

points = cat(3, points1, points2);
if isa(points, 'double')
    points2d = points;
else
    points2d = single(points);
end

%--------------------------------------------------------------------------
function cameraMatrices = parseCameraMatrices(varargin)
if nargin == 1
    stereoParams = varargin{1};
    validateattributes(stereoParams, {'stereoParameters'}, {}, ...
        mfilename, 'stereoParams');
    cameraMatrix1 = cameraMatrix(stereoParams.CameraParameters1, eye(3), [0 0 0]);
    cameraMatrix2 = cameraMatrix(stereoParams.CameraParameters2, ...
        stereoParams.RotationOfCamera2, stereoParams.TranslationOfCamera2);
else
    narginchk(2, 2);
    cameraMatrix1 = varargin{1};
    cameraMatrix2 = varargin{2};
    validateCameraMatrix(cameraMatrix1, 'cameraMatrix1');
    validateCameraMatrix(cameraMatrix2, 'cameraMatrix2');
end

cameraMatrices = cat(3, cameraMatrix1, cameraMatrix2);

%--------------------------------------------------------------------------
function validateCameraMatrix(M, varName)
validateattributes(M, {'numeric'}, ...
    {'2d', 'size', [4, 3], 'finite', 'real', 'nonsparse'},...
    mfilename, varName);

%--------------------------------------------------------------------------
function [point3d, reprojectionErrors] = ...
    triangulateOnePoint(cameraMatrices, matchingPoints)

% do the triangulation
numViews = size(cameraMatrices, 3);
A = zeros(numViews * 2, 4);
for i = 1:numViews
    P = cameraMatrices(:,:,i)';
    A(2*i - 1, :) = matchingPoints(i, 1) * P(3,:) - P(1,:);
    A(2*i    , :) = matchingPoints(i, 2) * P(3,:) - P(2,:);
end

[~,~,V] = svd(A);
X = V(:, end);
X = X/X(end);

point3d = X(1:3)';

reprojectedPoints = zeros(size(matchingPoints), 'like', matchingPoints);
for i = 1:numViews
    reprojectedPoints(i, :) = projectPoints(point3d, cameraMatrices(:, :, i));
end
reprojectionErrors = reprojectedPoints - matchingPoints;

%--------------------------------------------------------------------------
function points2d = projectPoints(points3d, P)
points3dHomog = [points3d, ones(size(points3d, 1), 1, 'like', points3d)];
points2dHomog = points3dHomog * P;
points2d = bsxfun(@rdivide, points2dHomog(:, 1:2), points2dHomog(:, 3));
