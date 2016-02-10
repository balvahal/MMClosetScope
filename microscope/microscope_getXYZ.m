%% Get x, y, and z position of microscope
% 
%% Inputs
% * microscope, the struct that contains micro-manager objects
%% Outputs
% * microscope, the struct that contains micro-manager objects
function [pos] = microscope_getXYZ(microscope)
%% retrieve x, y, and z
%
x = microscope.core.getXPosition(microscope.xyStageDevice);
y = microscope.core.getYPosition(microscope.xyStageDevice);
z = microscope.core.getPosition(microscope.FocusDevice);
microscope.pos = [x,y,z];
pos = [x,y,z];