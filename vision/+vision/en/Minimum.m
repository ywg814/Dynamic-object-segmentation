classdef Minimum
%Minimum Minimum values
%   HMIN = vision.Minimum returns a System object, HMIN, that computes the
%   value and/or index of the minimum element in an input or a sequence of
%   inputs.
%
%   HMIN = vision.Minimum('PropertyName', PropertyValue, ...) returns a
%   minimum System object, HMIN, with each specified property set to the
%   specified value.
%
%   Step method syntax:
%
%   [VAL, IND] = step(HMIN, X) computes minimum value, VAL, and index or
%   position of the minimum value, IND, in each row or column of input X,
%   along vectors of a specified dimension of X, or of the entire input X,
%   depending on the value of the Dimension property.
%
%   VAL = step(HMIN, X) returns the minimum value, VAL, of the input X.
%   When the RunningMinimum property is true, VAL corresponds to the
%   minimum of the input elements over successive calls to the step method.
%
%   IND = step(HMIN, X) returns the one-based index IND of the minimum
%   value when the IndexOutputPort property is true and the ValueOutputPort
%   property is false. The RunningMinimum property must be false.
%
%   VAL = step(HMIN, X, R) computes the minimum value, VAL, of the input
%   elements over successive calls to the step method. The object
%   optionally resets its state based on the value of reset input signal,
%   R, and the ResetCondition property. This option is available when you
%   set both the RunningMinimum and the ResetInputPort properties to true.
%
%   [...] = step(HMIN, I, ROI) computes the minimum of input image, I,
%   within the given region of interest, ROI, when the ROIProcessing
%   property is true and the ROIForm property is 'Lines', 'Rectangles' or
%   'Binary mask'.
%
%   [...] = step(HMIN, I, LABEL, LABELNUMBERS) computes the minimum of
%   input image, I, for region whose labels are specified in vector
%   LABELNUMBERS. The regions are defined and labeled in matrix LABEL. This
%   option is available when the ROIProcessing property is true and the
%   ROIForm property is 'Label matrix'.
%
%   [..., FLAG] = step(HMIN, I, ROI) also returns FLAG which indicates
%   whether the given ROI is within the image bounds when both the
%   ROIProcessing and ValidityOutputPort properties are true and the
%   ROIForm property is 'Lines', 'Rectangles' or 'Binary mask'.
%
%   [..., FLAG] = step(HMIN, I, LABEL, LABELNUMBERS) also returns FLAG
%   which indicates whether the input label numbers are valid when both the
%   ROIProcessing and ValidityOutputPort properties are true and the
%   ROIForm property is 'Label matrix'.
%
%   Minimum methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create minimum object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset states of running minimum
%
%   Minimum properties:
%
%   ValueOutputPort    - Enables output of the minimum value
%   RunningMinimum     - Calculation over successive calls to step method
%   IndexOutputPort    - Enables output of the index of the minimum
%   ResetInputPort     - Enables resetting in running minimum mode
%   ResetCondition     - Reset condition for running minimum mode
%   Dimension          - Dimension to operate along
%   CustomDimension    - Numerical dimension to operate along
%   ROIProcessing      - Enables region of interest processing
%   ROIForm            - Type of region of interest
%   ROIPortion         - Calculate over entire ROI or just perimeter
%   ROIStatistics      - Statistics for each ROI, or one for all ROIs
%   ValidityOutputPort - Return validity check of ROI or label numbers
%
%   This System object supports fixed-point operations. For more
%   information, type vision.Minimum.helpFixedPoint.
%
%   % EXAMPLE : Determine the minimum and its index in a grayscale image.
%       img = im2single(rgb2gray(imread('peppers.png')));
%       hmin = vision.Minimum;
%       [m, ind] = step(hmin, img);
%
%   See also vision.Minimum.helpFixedPoint.

 
%   Copyright 2004-2010 The MathWorks, Inc.

    methods
        function out=Minimum
            %Minimum Minimum values
            %   HMIN = vision.Minimum returns a System object, HMIN, that computes the
            %   value and/or index of the minimum element in an input or a sequence of
            %   inputs.
            %
            %   HMIN = vision.Minimum('PropertyName', PropertyValue, ...) returns a
            %   minimum System object, HMIN, with each specified property set to the
            %   specified value.
            %
            %   Step method syntax:
            %
            %   [VAL, IND] = step(HMIN, X) computes minimum value, VAL, and index or
            %   position of the minimum value, IND, in each row or column of input X,
            %   along vectors of a specified dimension of X, or of the entire input X,
            %   depending on the value of the Dimension property.
            %
            %   VAL = step(HMIN, X) returns the minimum value, VAL, of the input X.
            %   When the RunningMinimum property is true, VAL corresponds to the
            %   minimum of the input elements over successive calls to the step method.
            %
            %   IND = step(HMIN, X) returns the one-based index IND of the minimum
            %   value when the IndexOutputPort property is true and the ValueOutputPort
            %   property is false. The RunningMinimum property must be false.
            %
            %   VAL = step(HMIN, X, R) computes the minimum value, VAL, of the input
            %   elements over successive calls to the step method. The object
            %   optionally resets its state based on the value of reset input signal,
            %   R, and the ResetCondition property. This option is available when you
            %   set both the RunningMinimum and the ResetInputPort properties to true.
            %
            %   [...] = step(HMIN, I, ROI) computes the minimum of input image, I,
            %   within the given region of interest, ROI, when the ROIProcessing
            %   property is true and the ROIForm property is 'Lines', 'Rectangles' or
            %   'Binary mask'.
            %
            %   [...] = step(HMIN, I, LABEL, LABELNUMBERS) computes the minimum of
            %   input image, I, for region whose labels are specified in vector
            %   LABELNUMBERS. The regions are defined and labeled in matrix LABEL. This
            %   option is available when the ROIProcessing property is true and the
            %   ROIForm property is 'Label matrix'.
            %
            %   [..., FLAG] = step(HMIN, I, ROI) also returns FLAG which indicates
            %   whether the given ROI is within the image bounds when both the
            %   ROIProcessing and ValidityOutputPort properties are true and the
            %   ROIForm property is 'Lines', 'Rectangles' or 'Binary mask'.
            %
            %   [..., FLAG] = step(HMIN, I, LABEL, LABELNUMBERS) also returns FLAG
            %   which indicates whether the input label numbers are valid when both the
            %   ROIProcessing and ValidityOutputPort properties are true and the
            %   ROIForm property is 'Label matrix'.
            %
            %   Minimum methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create minimum object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset states of running minimum
            %
            %   Minimum properties:
            %
            %   ValueOutputPort    - Enables output of the minimum value
            %   RunningMinimum     - Calculation over successive calls to step method
            %   IndexOutputPort    - Enables output of the index of the minimum
            %   ResetInputPort     - Enables resetting in running minimum mode
            %   ResetCondition     - Reset condition for running minimum mode
            %   Dimension          - Dimension to operate along
            %   CustomDimension    - Numerical dimension to operate along
            %   ROIProcessing      - Enables region of interest processing
            %   ROIForm            - Type of region of interest
            %   ROIPortion         - Calculate over entire ROI or just perimeter
            %   ROIStatistics      - Statistics for each ROI, or one for all ROIs
            %   ValidityOutputPort - Return validity check of ROI or label numbers
            %
            %   This System object supports fixed-point operations. For more
            %   information, type vision.Minimum.helpFixedPoint.
            %
            %   % EXAMPLE : Determine the minimum and its index in a grayscale image.
            %       img = im2single(rgb2gray(imread('peppers.png')));
            %       hmin = vision.Minimum;
            %       [m, ind] = step(hmin, img);
            %
            %   See also vision.Minimum.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display vision.Minimum System object fixed-point
            %               information
            %   vision.Minimum.helpFixedPoint displays information about
            %   fixed-point properties and operations of the vision.Minimum
            %   System object.
        end

    end
    methods (Abstract)
    end
    properties
        %Dimension Dimension to operate along
        %   Specify how the minimum calculation is performed over the data as
        %   one of [{'All'} | 'Row' | 'Column' | 'Custom']. This property is
        %   applicable when the RunningMinimum property is false.
        Dimension;

    end
end
