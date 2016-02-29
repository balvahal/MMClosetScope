%% Microscope Configuration
% The installation of uManager should be configured and tested before
% attempting to control a microscope using MATLAB. Even with a properly
% configured uManager installation there are device specific features and
% numbers that must be stored within the microscope object.
%
% The _NOSCOPE_ file was optimized for a Nikon Ti microscope with a Perfect
% Focus System, a Prior ProScan motorized stage, and a Hamamatsu camera.
% When using *super-dimensional-acquisition* for the first time use this
% file as a template.
%% Inputs
% * microscope: the object that utilizes the uManager API.
%% Outputs
% * microscope: the object that utilizes the uManager API.
function [microscope] = microscope_config_NOSCOPE(microscope)
%% Identify microscope device names
% These names are stored in the microscope object, so that the uManager API
% does not need to be accessed repeatedly.
microscope.xyStageDevice = microscope.core.getXYStageDevice;
microscope.FocusDevice = microscope.core.getFocusDevice;
microscope.AutoFocusDevice = microscope.core.getFocusDevice;
microscope.AutoFocusStatusDevice = microscope.core.getAutoFocusDevice;
%% Import numerical limits and properties
% The (x,y,z) limits define the physical space that is accessible by the
% objective and a motorized stage.
%
% The calibration angle is the angle between the axes of movement defined
% by the motorized stage and the orientation of the image sensor. This is
% important for aligning grids of images.
customFileName = sprintf('microscope_json_%s.txt',microscope.computerName);
[mfilepath,~,~] = fileparts(mfilename('fullpath'));
if exist(customFileName,'file')
    myjson = core_jsonparser.import_json(fullfile(mfilepath,customFileName));
else
    myjson = core_jsonparser.import_json(fullfile(mfilepath,'microscope_json_NOSCOPE.txt'));
end
microscope.zLimits = [myjson.zmin,myjson.zmax];
microscope.xyStageLimits = [myjson.xlim1,myjson.xlim2,myjson.ylim1,myjson.ylim2];
microscope.calibrationAngle = myjson.calibrationAngle;
%% Gamepad control of the motorized stage
% The correct COM port must be known for communicating with a motorized
% stage serially, such as a Prior ProScan.
microscope.stageport = 'COM1';
%% Device Specific Syntax
% Between a Hamamatsu camera and a non-Hamamatsu camera the syntax is
% different, to change the binning of an image. I.e., '1x1' and '1'. To
% avoid hard coding either, a function handle specific to a device is
% assigned to a microscope property, acting in practice like a method.
microscope.binningfun = @binning_function_NOSCOPE;
end