%% Initialize communication between MATLAB, uManager, and the microscope
% This script will move the microscope to a defined x, y, z position
%% Inputs
% * mmhandle, the struct that contains micro-manager objects
% * x, y, z target positions
%% Outputs
% * mmhandle, the struct that contains micro-manager objects
function mmhandle = SCAN6general_setXYZ(mmhandle, pos, direction, varargin)
p = inputParser;
addRequired(p, 'mmhandle', @isstruct);
addRequired(p, 'pos', @(x) numel(x) >=1 && numel(x) <=3);
addOptional(p, 'direction', 'x', @(x) any(strcmp(x,{'x', 'y', 'z'})));
%%
% Define default positions as the current ones
mmhandle = SCAN6general_getXYZ(mmhandle);
x = mmhandle.pos(1);
y = mmhandle.pos(2);
z = mmhandle.pos(3);
%% Determine user defined changes
% Determine number of elements in pos
numPos = numel(pos);
switch numPos
    case 1
        switch p.Results.direction
            case 'x'
                x = pos;
            case 'y'
                y = pos;
            case 'z'
                z = pos;
        end
    case 2
        x = pos(1);
        y = pos(2);
    case 3
        x = pos(1);
        y = pos(2);
        z = pos(3);
end
%% Exception handling
%% Move stage
mmhandle.core.setPosition(mmhandle.FocusDevice, z);
mmhandle.core.setXYPosition(mmhandle.xyStageDevice, x, y);
mmhandle.core.waitForSystem();
mmhandle = SCAN6general_getXYZ(mmhandle);