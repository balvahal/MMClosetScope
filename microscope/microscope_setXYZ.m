%% Initialize communication between MATLAB, uManager, and the microscope
% This script will move the microscope to a defined x, y, z position
%% Inputs
% * microscope: the object that utilizes the uManager API.
% * direction: _x_, _y_, or _z_. When paired with a single number the
% microscope will move in the specified direction to that position.
%% Outputs
% * microscope: the object that utilizes the uManager API.
function [microscope] = microscope_setXYZ(microscope, pos, varargin)
p = inputParser;
addRequired(p, 'microscope', @(x) isa(x,'microscope_class'));
addRequired(p, 'pos', @(x) numel(x) >=1 && numel(x) <=3);
addOptional(p, 'direction', 'x', @(x) any(strcmp(x,{'x', 'y', 'z'})));
parse(p,microscope,pos,varargin{:});
%%
% Define default positions as the current ones
microscope.getXYZ;
x = microscope.pos(1);
y = microscope.pos(2);
z = microscope.pos(3); %#ok<NASGU>
%% Determine user defined changes
% Determine number of elements in pos
numPos = numel(pos);
switch numPos
    case 1
        switch p.Results.direction
            case 'x'
                x = pos;
                % move to the xy position
                microscope.core.setXYPosition(microscope.xyStageDevice, x, y);
            case 'y'
                y = pos;
                % move to the xy position
                microscope.core.setXYPosition(microscope.xyStageDevice, x, y);
            case 'z'
                z = pos;
                % Move to the z position
                microscope.core.setPosition(microscope.FocusDevice, z);
        end
    case 2
        x = pos(1);
        y = pos(2);
        % move to the xy position
        microscope.core.setXYPosition(microscope.xyStageDevice, x, y);
    case 3
        x = pos(1);
        y = pos(2);
        z = pos(3);
        % Move to the z position
        microscope.core.setPosition(microscope.FocusDevice, z);
        % move to the xy position
        microscope.core.setXYPosition(microscope.xyStageDevice, x, y);
end
