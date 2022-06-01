classdef FilePanelLiveCapture < vision.internal.calibration.tool.CalibratorFilePanel
    methods(Access=protected)
        %------------------------------------------------------------------
        function createAddImagesButton(this, icon, nameId, tag)
            this.AddImagesButton = this.createVerticalSplitButton(...
                icon, nameId, tag);
            
            this.AddImagesButton.Popup = this.createSplitButtonPopup(...
                this.getAddOptions(), 'AddImagesPopup');
        end
        
        % -----------------------------------------------------------------
        function items = getAddOptions(~)
            % defining the option entries appearing on the popup of the 
            % Add Images Button.
            
            addFromFileIcon = toolpack.component.Icon(...
                fullfile(matlabroot,'toolbox','vision','vision',...
                '+vision','+internal','+calibration','+tool','AddImage_16.png'));
            
            addFromCameraIcon = toolpack.component.Icon(...
                fullfile(matlabroot,'toolbox','vision','vision',...
                '+vision','+internal','+calibration','+tool','camera_calibrator_16.png'));
            
            items(1) = struct(...
                'Title', vision.getMessage('vision:uitools:AddFromFileOption'), ...
                'Description', '', ...
                'Icon', addFromFileIcon, ...
                'Help', [], ...
                'Header', false);
            items(2) = struct(...
                'Title', vision.getMessage('vision:uitools:AddFromCameraOption'), ...
                'Description', '', ...
                'Icon', addFromCameraIcon, ...
                'Help', [], ...
                'Header', false);
        end           
    end
end
