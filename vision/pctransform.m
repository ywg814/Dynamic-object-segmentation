function ptCloudOut = pctransform(ptCloudIn, tform)
%PCTRANSFORM Rigid transform a 3-D point cloud.
%   ptCloudOut = PCTRANSFORM(ptCloudIn, tform) apply forward
%   rigid transform to a point cloud. ptCloudIn is a pointCloud object.
%   tform is an affine3d object, and it has to be a valid rigid transform
%   (rotation and translation only).
% 
%   Note
%   ----
%   The transformation applies to both the coordinates of points and their
%   normal vectors.
% 
%   Class Support 
%   ------------- 
%   ptCloudIn and ptCloutOut must be pointCloud object. tform must be an
%   affine3d object.
%
%   Example: Rotate 3-D point cloud
%   -------------------------------
%   ptCloud = pcread('teapot.ply');
%
%   % Plot the original data
%   figure
%   pcshow(ptCloud) 
%   xlabel('X')
%   ylabel('Y')
%   zlabel('Z')
%
%   % Create a transform object with 45 degrees rotation along z-axis
%   A = [cos(pi/4) sin(pi/4) 0 0; ...
%        -sin(pi/4) cos(pi/4) 0 0; ...
%        0 0 1 0; ...
%        0 0 0 1];
%   tform = affine3d(A);
%
%   % Transform the point cloud
%   ptCloudOut = pctransform(ptCloud, tform);
%
%   % Plot the transformed point cloud
%   figure
%   pcshow(ptCloudOut)
%   xlabel('X')
%   ylabel('Y')
%   zlabel('Z')
%
% See also pointCloud, affine3d, pcshow, pcread

%  Copyright 2014 The MathWorks, Inc.
narginchk(2, 2);

% Validate the first argument
if ~isa(ptCloudIn, 'pointCloud')
    error(message('vision:pointcloud:notPointCloudObject', 'ptCloudIn'));
end

% Validate the second argument
validateattributes(tform, {'affine3d'}, {'scalar'}, mfilename, 'tform');

% Only rigid registration is allowed
if ~(isRigidTransform(tform))
    error(message('vision:pointcloud:rigidTransformOnly'));
end

R = tform.T(1:3, 1:3);
t = tform.T(4, 1:3);

% Apply forward transform to coordinates
if ismatrix(ptCloudIn.Location)
    loc = ptCloudIn.Location * R;
    loc(:,1) = loc(:,1) + t(1);
    loc(:,2) = loc(:,2) + t(2);
    loc(:,3) = loc(:,3) + t(3);
else
    loc = reshape(ptCloudIn.Location,[],3) * R;
    loc(:,1) = loc(:,1) + t(1);
    loc(:,2) = loc(:,2) + t(2);
    loc(:,3) = loc(:,3) + t(3);
    loc = reshape(loc, size(ptCloudIn.Location));
end

% Apply forward transform to normal vector
nv = single.empty();
if ~isempty(ptCloudIn.Normal)
    if ismatrix(ptCloudIn.Normal)
        nv = ptCloudIn.Normal * R;
    else
        nv = reshape(reshape(ptCloudIn.Normal, [], 3) * R, size(ptCloudIn.Normal));
    end
end
      
ptCloudOut = pointCloud(loc, 'Color', ptCloudIn.Color, 'Normal', nv);

end

%==========================================================================
% Determine if transformation is rigid transformation
%==========================================================================
function tf = isRigidTransform(tform)

singularValues = svd(tform.T(1:tform.Dimensionality,1:tform.Dimensionality));
tf = max(singularValues)-min(singularValues) < 100*eps(max(singularValues(:)));
tf = tf && abs(det(tform.T)-1) < 100*eps(class(tform.T));

end