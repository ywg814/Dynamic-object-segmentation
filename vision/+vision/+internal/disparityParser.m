% disparityParser a.k.a. parseOptionalInputs_sim: This is used by disparity.m
% when matlab coder supports anonymous function call, inline the
% following function
function r = disparityParser(imageSize, defaults, varargin)
% Instantiate an input parser
parser = inputParser;
parser.FunctionName = 'disparity';

%--------------------------------------------------------------------------
% Specify the optional parameters, ROI1 and ROI2
%--------------------------------------------------------------------------
parser.addOptional('ROI1', defaults.ROI1, ...
  @(x)(checkROI('ROI1', x, imageSize, 3)));
parser.addOptional('ROI2', defaults.ROI2, ...
  @(x)(checkROI('ROI2', x, imageSize, 4)));

%--------------------------------------------------------------------------
% Specify the optional parameter value pairs
%--------------------------------------------------------------------------
parser.addParameter('ContrastThreshold', defaults.ContrastThreshold, ...
  @(x)(checkContrastThreshold(x)));
parser.addParameter('BlockSize', defaults.BlockSize, ...
  @(x)(checkBlockSize(x, imageSize)));
parser.addParameter('DisparityRange', defaults.DisparityRange, ...
  @(x)(checkDisparityRange(x, imageSize)));
parser.addParameter('TextureThreshold', defaults.TextureThreshold, ...
  @(x)(checkTextureThreshold(x)));
parser.addParameter('UniquenessThreshold', defaults.UniquenessThreshold, ...
  @(x)(checkUniquenessThreshold(x)));
parser.addParameter('DistanceThreshold', [], ...
  @(x)(checkDistanceThreshold(x, imageSize)));
parser.addParameter('Method', defaults.Method, ...
  @(x)(checkMethod(x)));
%--------------------------------------------------------------------------
% Parse and check the optional parameters
%--------------------------------------------------------------------------
parser.parse(varargin{:});
r = parser.Results;

%--------------------------------------------------------------------------
% Checks for functionality not available with SemiGlobal
%--------------------------------------------------------------------------
defaultROI = strfind(parser.UsingDefaults,'ROI1');
errIf(strcmpi(r.Method,'SemiGlobal') && ...
        sum([defaultROI{:}]) == 0, ...
    'vision:disparity:ROINotAvailableForSGBM');

defaultTextureThreshold = strfind(parser.UsingDefaults,'TextureThreshold');
if strcmpi(r.Method,'SemiGlobal') && ...
    sum([defaultTextureThreshold{:}]) == 0
   warning(message('vision:disparity:TextureThesholdNotAvailableForSGBM'));
end


%========================================================================== 
function r = checkMethod(value)
list = {'SemiGlobal', 'BlockMatching'};
validateattributes(value, {'char'}, ...
  {'nonempty'}, 'disparity'); 
validatestring(value, list, 'disparity', 'Method');
r = 1;


%========================================================================== 
function r = checkROI(name, value, imageSize, position)
validateattributes(value, {'numeric'}, ...
  {'real', 'nonsparse', 'integer', 'positive', 'finite', 'size', [1, 4]},...
  'disparity', name, position); 
errIf(value(1)+value(3) > imageSize(2)+1 || value(2)+value(4) > imageSize(1)+1, ...
    'vision:disparity:invalidROIValue');

r = 1;

%========================================================================== 
function r = checkContrastThreshold(value)
validateattributes(value, {'numeric'}, ...
  {'real', 'scalar', '>', 0, '<=', 1},...
  'disparity', 'ContrastThreshold');
r = 1;

%========================================================================== 
function r = checkBlockSize(value, imageSize)
maxBlockSize = min([imageSize, 255]);
validateattributes(value, {'numeric'}, ...
  {'real', 'scalar', 'integer', 'odd', '>=', 5, '<=', maxBlockSize},...
  'disparity', 'BlockSize');
r = 1;

%========================================================================== 
function r = checkDisparityRange(value,imageSize)
maxValue = imageSize(2);
validateattributes(value, {'numeric'}, ...
  {'real', 'nonsparse', 'integer', 'finite', 'size', [1,2], ...
  '>', -maxValue, '<', maxValue},...
  'disparity', 'DisparityRange');

errIf(value(2) <= value(1) || mod(value(2) - value(1), 16) ~= 0, ...
    'vision:disparity:invalidDisparityRange');  

r = 1;

%========================================================================== 
function r = checkTextureThreshold(value)
validateattributes(value, {'numeric'}, ...
  {'real', 'scalar', 'finite', 'nonnegative', '<', 1},...
  'disparity', 'TextureThreshold');
r = 1;

%========================================================================== 
function r = checkUniquenessThreshold(value)
validateattributes(value, {'numeric'}, ...
  {'real', 'scalar', 'integer', 'finite', 'nonnegative'},...
  'disparity', 'UniquenessThreshold');
r = 1;

%========================================================================== 
function r = checkDistanceThreshold(value, imageSize)
maxValue = min(imageSize);
if ~isempty(value)
  validateattributes(value, {'numeric'}, ...
    {'real', 'scalar', 'integer', 'finite', 'nonnegative','<',maxValue},...
    'disparity', 'DistanceThreshold');
end
r = 1;

%==========================================================================
function errIf(condition, msgID)

coder.internal.errorIf(condition, msgID);
