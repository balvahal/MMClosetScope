%%
%
function [gamepad] = Gamepad_function_pov_dpad(gamepad)
%%
% if the position of the joystick is not changing then do not take any
% further action
if gamepad.pov_dpad_old == gamepad.pov_dpad
    return; %user input is smoothed out and if no one is using the controller an m-file directing the stage will still work.
end
switch gamepad.pov_dpad
    case -1
        disp('dpad ''no input''');
    case 0
        disp('you pressed ''North''');
    case 45
        disp('you pressed ''North-East''');
    case 90
        disp('you pressed ''East''');
    case 135
        disp('you pressed ''South-East''');
    case 180
        disp('you pressed ''South''');
    case 225
        disp('you pressed ''South-West''');
    case 270
        disp('you pressed ''West''');
    case 315
        disp('you pressed ''North-West''');
        %%%
        %
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