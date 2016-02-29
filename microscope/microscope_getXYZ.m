%% Get x, y, and z position of microscope
% Utilize the uManager API to query where
%% Inputs
% * microscope: the object that utilizes the uManager API.
%% Outputs
% * pos: a 1x3 array that specifies the (X,Y,Z) of the microscope.
function [pos] = microscope_getXYZ(microscope)
%% retrieve x, y, and z
%
x = microscope.core.getXPosition(microscope.xyStageDevice);
y = microscope.core.getYPosition(microscope.xyStageDevice);
z = microscope.core.getPosition(microscope.FocusDevice);
microscope.pos = [x,y,z];
pos = [x,y,z];