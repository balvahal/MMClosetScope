%%
%
function [gamepad] = Gamepad_function_joystk_left(gamepad)
%%
% if the position of the joystick is not changing then do not take any
% further action
if (gamepad.joystk_left_mag_old == gamepad.joystk_left_mag) && (gamepad.joystk_left_dir_old == gamepad.joystk_left_dir)
    return;
end
my_command = sprintf('VS,%d,%d',gamepad.joystk_left_lookup{gamepad.joystk_left_mag,gamepad.joystk_left_dir}(1),gamepad.joystk_left_lookup{gamepad.joystk_left_mag,gamepad.joystk_left_dir}(2));
gamepad.microscope.core.setSerialPortCommand(gamepad.stageport,my_command,sprintf('\r'));
end