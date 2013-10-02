%% Initialize communication between MATLAB, uManager, and the microscope
% This script will move the microscope to a defined x, y, z position
%% Inputs
% * mmhandle, the struct that contains micro-manager objects
% * x, y, z target positions
%% Outputs
% * mmhandle, the struct that contains micro-manager objects
function mmhandle = Core_general_setXYZ(mmhandle, pos, varargin)
p = inputParser;
addRequired(p, 'mmhandle', @isstruct);
addRequired(p, 'pos', @(x) numel(x) >=1 && numel(x) <=3);
addOptional(p, 'direction', 'x', @(x) any(strcmp(x,{'x', 'y', 'z'})));
parse(p,mmhandle,pos,varargin{:});
%%
% Define default positions as the current ones
mmhandle = Core_general_getXYZ(mmhandle);
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
% Move to the z position
mmhandle.core.setPosition(mmhandle.FocusDevice, z);
%%
% wait for the focus finish moving
while mmhandle.core.deviceBusy(mmhandle.FocusDevice)
    pause(0.05);
    mmhandle = Core_general_getXYZ(mmhandle);
    fprintf('z is busy, x=%2.3e y=%2.3e z=%2.3e \n',mmhandle.pos);
end
%%
% move to the xy position
mmhandle.core.setXYPosition(mmhandle.xyStageDevice, x, y);
%%
% wait for the stage to finish moving
while mmhandle.core.deviceBusy(mmhandle.xyStageDevice)
    pause(0.05);
    mmhandle = Core_general_getXYZ(mmhandle);
    fprintf('xy is busy, x=%2.3e y=%2.3e z=%2.3e \n',mmhandle.pos);
end
%%
% save the new position
mmhandle = Core_general_getXYZ(mmhandle);
