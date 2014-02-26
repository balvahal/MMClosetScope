%% Initialize communication between MATLAB, uManager, and the microscope
% This script will move the microscope to a defined x, y, z position
%% Inputs
% * mmhandle, the struct that contains micro-manager objects
% * x, y, z target positions
%% Outputs
% * mmhandle, the struct that contains micro-manager objects
function mmhandle = Core_general_setXYZ(mmhandle, pos, varargin)
p = inputParser;
addRequired(p, 'mmhandle', @(x) isa(x,'Core_MicroManagerHandle'));
addRequired(p, 'pos', @(x) numel(x) >=1 && numel(x) <=3);
addOptional(p, 'direction', 'x', @(x) any(strcmp(x,{'x', 'y', 'z'})));
parse(p,mmhandle,pos,varargin{:});
%%
% Define default positions as the current ones
mmhandle = Core_general_getXYZ(mmhandle);
x = mmhandle.pos(1);
y = mmhandle.pos(2);
z = mmhandle.pos(3); %#ok<NASGU>
%% Determine user defined changes
% Determine number of elements in pos
numPos = numel(pos);
switch numPos
    case 1
        switch p.Results.direction
            case 'x'
                x = pos;
                % move to the xy position
                mmhandle.core.setXYPosition(mmhandle.xyStageDevice, x, y);
            case 'y'
                y = pos;
                % move to the xy position
                mmhandle.core.setXYPosition(mmhandle.xyStageDevice, x, y);
            case 'z'
                z = pos;
                % Move to the z position
                mmhandle.core.setPosition(mmhandle.FocusDevice, z);
        end
    case 2
        x = pos(1);
        y = pos(2);
        % move to the xy position
        mmhandle.core.setXYPosition(mmhandle.xyStageDevice, x, y);
    case 3
        x = pos(1);
        y = pos(2);
        z = pos(3);
        % Move to the z position
        mmhandle.core.setPosition(mmhandle.FocusDevice, z);
        % move to the xy position
        mmhandle.core.setXYPosition(mmhandle.xyStageDevice, x, y);
end
