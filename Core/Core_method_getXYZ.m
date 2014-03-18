%% Get x, y, and z position of microscope
% 
%% Inputs
% * mmhandle, the struct that contains micro-manager objects
%% Outputs
% * mmhandle, the struct that contains micro-manager objects
function [mmhandle] = Core_method_getXYZ(mmhandle)
%% retrieve x, y, and z
%
x = mmhandle.core.getXPosition(mmhandle.xyStageDevice);
y = mmhandle.core.getYPosition(mmhandle.xyStageDevice);
z = mmhandle.core.getPosition(mmhandle.FocusDevice);
mmhandle.pos = [x,y,z];