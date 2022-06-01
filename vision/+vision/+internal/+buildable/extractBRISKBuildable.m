classdef extractBRISKBuildable < coder.ExternalDependency %#codegen
   
    % Copyright 2012 The MathWorks, Inc.
        
    methods (Static)
        
        function name = getDescriptiveName(~)
            name = 'extractBRISKFeatures';
        end
        
        function b = isSupportedContext(context)
            b = context.isMatlabHostTarget();
        end
        
        function updateBuildInfo(buildInfo, context)
            vision.internal.buildable.opencvBuildInfo(buildInfo, context, ...
                'extractBRISK', false); % needNonFreeLib = false
        end
        
        %------------------------------------------------------------------
        % write all supported data-type specific function calls        
        function [features, valid_points] = extractBRISKFeatures(Iu8, points, params)
            
            coder.inline('always');
            coder.cinclude('cvstCG_extractBRISK.h');
                       
            vision.internal.buildable.errorIfInSimulink('extractFeatures with BRISK features');
            
            ptrKeypoints = coder.opaque('void *', 'NULL');
            ptrFeatures  = coder.opaque('void *', 'NULL');
            
            % call function
            numOut = int32(0);
            
            nRows = int32(size(Iu8,1));
            nCols = int32(size(Iu8,2));            
                                    
            inLocation    = points.Location;
            inMetric      = points.Metric;
            inScale       = points.Scale;
            inOrientation = points.Orientation;
            inMisc        = points.Misc;
            
            %> Extract BRISK Features                      
            numOut(1) = coder.ceval('extractBRISK_compute',...
                coder.ref(Iu8), ...
                nRows, nCols,...
                coder.ref(inLocation),...
                coder.ref(inMetric),...
                coder.ref(inScale),...
                coder.ref(inOrientation),...
                coder.ref(inMisc),...
                int32(size(inLocation,1)),...
                params.upright, ...
                coder.ref(ptrFeatures), coder.ref(ptrKeypoints));
            
            % output buffers for valid points
            coder.varsize('location',[inf 2]);
            coder.varsize('metric',[inf 1]);
            coder.varsize('scale',[inf 1]);            
            coder.varsize('orientation',[inf 1]);
            coder.varsize('misc',[inf 1]);
            
            location    = coder.nullcopy(zeros(numOut,2,'single'));
            metric      = coder.nullcopy(zeros(numOut,1,'single'));
            scale       = coder.nullcopy(zeros(numOut,1,'single'));
            misc        = coder.nullcopy(zeros(numOut,1,'int32'));          
            orientation = coder.nullcopy(zeros(numOut,1,'single'));
            
            % output buffer for features
            coder.varsize('features',[inf 64]);
            features = coder.nullcopy(zeros(numOut,64,'uint8'));
            
            %> Copy detected BRISK Features to output
            coder.ceval('extractBRISK_assignOutput', ...
                ptrFeatures, ptrKeypoints, ...
                coder.ref(location),...
                coder.ref(metric),...
                coder.ref(scale),...               
                coder.ref(orientation),... 
                coder.ref(misc),...
                coder.ref(features));    
                        
            valid_points.Location = location;
            valid_points.Metric   = metric;
            valid_points.Scale    = scale;
            valid_points.Misc     = misc;   
            valid_points.Orientation = orientation;  
            

        end       
    end   
end