%% Initialize communication between MATLAB, uManager, and the microscope
% This script will move the microscope to a defined x, y, z position
%% Inputs
% * mmhandle, the struct that contains micro-manager objects
% * x, y, z target positions
%% Outputs
% * mmhandle, the struct that contains micro-manager objects
function mmhandle = Core_general_setXYZEnforcingLimits(mmhandle, pos, varargin)
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
                if pos < mmhandle.xyStageLimits(1)
                    pos = mmhandle.xyStageLimits(1) + 50; % a 50um buffer seemed reasonable, so that no chance of an error can occur
                elseif pos > mmhandle.xyStageLimits(2)
                    pos = mmhandle.xyStageLimits(2) - 50;
                end
                x = pos;
                % move to the xy position
                mmhandle.core.setXYPosition(mmhandle.xyStageDevice, x, y);
            case 'y'
                if pos < mmhandle.xyStageLimits(3)
                    pos = mmhandle.xyStageLimits(3) + 50; % a 50um buffer seemed reasonable, so that no chance of an error can occur
                elseif pos > mmhandle.xyStageLimits(4)
                    pos = mmhandle.xyStageLimits(4) - 50;
                end
                y = pos;
                % move to the xy position
                mmhandle.core.setXYPosition(mmhandle.xyStageDevice, x, y);
            case 'z'
                if pos < mmhandle.zLimits(1)
                    pos = mmhandle.zLimits(1) + 50; % a 50um buffer seemed reasonable, so that no chance of an error can occur
                elseif pos > mmhandle.zLimits(2)
                    pos = mmhandle.zLimits(2) - 50;
                end
                z = pos;
                % Move to the z position
                mmhandle.core.setPosition(mmhandle.FocusDevice, z);
        end
    case 2
        x = pos(1);
        if x < mmhandle.xyStageLimits(1)
            x = mmhandle.xyStageLimits(1) + 50; % a 50um buffer seemed reasonable, so that no chance of an error can occur
        elseif x > mmhandle.xyStageLimits(2)
            x = mmhandle.xyStageLimits(2) - 50;
        end
        y = pos(2);
        if y < mmhandle.xyStageLimits(3)
            y = mmhandle.xyStageLimits(3) + 50; % a 50um buffer seemed reasonable, so that no chance of an error can occur
        elseif y > mmhandle.xyStageLimits(4)
            y = mmhandle.xyStageLimits(4) - 50;
        end
        % move to the xy position
        mmhandle.core.setXYPosition(mmhandle.xyStageDevice, x, y);
    case 3
        x = pos(1);
        if x < mmhandle.xyStageLimits(1)
            x = mmhandle.xyStageLimits(1) + 50; % a 50um buffer seemed reasonable, so that no chance of an error can occur
        elseif x > mmhandle.xyStageLimits(2)
            x = mmhandle.xyStageLimits(2) - 50;
        end
        y = pos(2);
        if y < mmhandle.xyStageLimits(3)
            y = mmhandle.xyStageLimits(3) + 50; % a 50um buffer seemed reasonable, so that no chance of an error can occur
        elseif y > mmhandle.xyStageLimits(4)
            y = mmhandle.xyStageLimits(4) - 50;
        end
        z = pos(3);
        if z < mmhandle.zLimits(1)
            z = mmhandle.zLimits(1) + 50; % a 50um buffer seemed reasonable, so that no chance of an error can occur
        elseif z > mmhandle.zLimits(2)
            z = mmhandle.zLimits(2) - 50;
        end
        % Move to the z position
        mmhandle.core.setPosition(mmhandle.FocusDevice, z);
        % move to the xy position
        mmhandle.core.setXYPosition(mmhandle.xyStageDevice, x, y);
end
