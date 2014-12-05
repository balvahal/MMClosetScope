%%
%
function [gamepad] = SCAN6_gamepad_pov_dpad(gamepad)
%%
% if the position of the joystick is not changing then do not take any
% further action
if gamepad.pov_dpad_old == gamepad.pov_dpad
    return; %user input is smoothed out and if no one is using the controller an m-file directing the stage will still work.
end
switch gamepad.pov_dpad
    case -1
        gamepad.microscope.core.setSerialPortCommand(gamepad.stageport,'VS,0,0',sprintf('\r'));
    case 0
        my_command = sprintf('VS,%d,%d',gamepad.pov_speed(1)*0,gamepad.pov_speed(1)*(-1));
        gamepad.microscope.core.setSerialPortCommand(gamepad.stageport,my_command,sprintf('\r'));
    case 45
        my_command = sprintf('VS,%d,%d',gamepad.pov_speed(1)*0.7071,gamepad.pov_speed(1)*(-0.7071));
        gamepad.microscope.core.setSerialPortCommand(gamepad.stageport,my_command,sprintf('\r'));
    case 90
        my_command = sprintf('VS,%d,%d',gamepad.pov_speed(1)*1,gamepad.pov_speed(1)*0);
        gamepad.microscope.core.setSerialPortCommand(gamepad.stageport,my_command,sprintf('\r'));
    case 135
        my_command = sprintf('VS,%d,%d',gamepad.pov_speed(1)*0.7071,gamepad.pov_speed(1)*0.7071);
        gamepad.microscope.core.setSerialPortCommand(gamepad.stageport,my_command,sprintf('\r'));
    case 180
        my_command = sprintf('VS,%d,%d',gamepad.pov_speed(1)*0,gamepad.pov_speed(1)*1);
        gamepad.microscope.core.setSerialPortCommand(gamepad.stageport,my_command,sprintf('\r'));
    case 225
        my_command = sprintf('VS,%d,%d',gamepad.pov_speed(1)*(-0.7071),gamepad.pov_speed(1)*0.7071);
        gamepad.microscope.core.setSerialPortCommand(gamepad.stageport,my_command,sprintf('\r'));
    case 270
        my_command = sprintf('VS,%d,%d',gamepad.pov_speed(1)*(-1),gamepad.pov_speed(1)*0);
        gamepad.microscope.core.setSerialPortCommand(gamepad.stageport,my_command,sprintf('\r'));
    case 315
        my_command = sprintf('VS,%d,%d',gamepad.pov_speed(1)*(-0.7071),gamepad.pov_speed(1)*(-0.7071));
        gamepad.microscope.core.setSerialPortCommand(gamepad.stageport,my_command,sprintf('\r'));
        %gamepad.microscope.core.setSerialPortCommand(gamepad.stageport,'=',sprintf('\r'));
        % * -1 = no direction/centered
        % * 0 = N
        % * 45 = NE
        % * 90 = E
        % * 135 = SE
        % * 180 = S
        % * 225 = SW
        % * 270 = W
        % * 315 = NW
end
end