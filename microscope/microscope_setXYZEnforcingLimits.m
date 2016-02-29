%% Initialize communication between MATLAB, uManager, and the microscope
% This script will move the microscope to a defined x, y, z position, but
% no beyond the limits defined in the microscope object.
%% Inputs
% * microscope: the object that utilizes the uManager API.
% * direction: _x_, _y_, or _z_. When paired with a single number the
% microscope will move in the specified direction to that position.
%% Outputs
% * microscope: the object that utilizes the uManager API.
function [microscope] = microscope_setXYZEnforcingLimits(microscope, pos, varargin)
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
                if pos < microscope.xyStageLimits(1)
                    pos = microscope.xyStageLimits(1);
                elseif pos > microscope.xyStageLimits(2)
                    pos = microscope.xyStageLimits(2);
                end
                x = pos;
                % move to the xy position
                microscope.core.setXYPosition(microscope.xyStageDevice, x, y);
            case 'y'
                if pos < microscope.xyStageLimits(3)
                    pos = microscope.xyStageLimits(3);
                elseif pos > microscope.xyStageLimits(4)
                    pos = microscope.xyStageLimits(4);
                end
                y = pos;
                % move to the xy position
                microscope.core.setXYPosition(microscope.xyStageDevice, x, y);
            case 'z'
                if pos < microscope.zLimits(1)
                    pos = microscope.zLimits(1) + 50; % a 50um buffer seemed reasonable, so that no chance of an error can occur
                elseif pos > microscope.zLimits(2)
                    pos = microscope.zLimits(2) - 50;
                end
                z = pos;
                % Move to the z position
                microscope.core.setPosition(microscope.FocusDevice, z);
        end
    case 2
        x = pos(1);
        if x < microscope.xyStageLimits(1)
            x = microscope.xyStageLimits(1); 
        elseif x > microscope.xyStageLimits(2)
            x = microscope.xyStageLimits(2);
        end
        y = pos(2);
        if y < microscope.xyStageLimits(3)
            y = microscope.xyStageLimits(3);
        elseif y > microscope.xyStageLimits(4)
            y = microscope.xyStageLimits(4);
        end
        % move to the xy position
        microscope.core.setXYPosition(microscope.xyStageDevice, x, y);
    case 3
        x = pos(1);
        if x < microscope.xyStageLimits(1)
            x = microscope.xyStageLimits(1);
        elseif x > microscope.xyStageLimits(2)
            x = microscope.xyStageLimits(2);
        end
        y = pos(2);
        if y < microscope.xyStageLimits(3)
            y = microscope.xyStageLimits(3);
        elseif y > microscope.xyStageLimits(4)
            y = microscope.xyStageLimits(4);
        end
        z = pos(3);
        if z < microscope.zLimits(1)
            z = microscope.zLimits(1) + 50; % a 50um buffer seemed reasonable, so that no chance of an error can occur
        elseif z > microscope.zLimits(2)
            z = microscope.zLimits(2) - 50;
        end
        % Move to the z position
        microscope.core.setPosition(microscope.FocusDevice, z);
        % move to the xy position
        microscope.core.setXYPosition(microscope.xyStageDevice, x, y);
end
