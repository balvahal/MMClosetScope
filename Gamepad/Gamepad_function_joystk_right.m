%%
%
function [gamepad] = Gamepad_function_joystk_right(gamepad)
%%
% if the position of the joystick is not changing then do not take any
% further action
if (gamepad.joystk_right_mag_old == gamepad.joystk_right_mag) && (gamepad.joystk_right_dir_old == gamepad.joystk_right_dir)
    return;
end
my_command = sprintf('VS,%d,%d',gamepad.joystk_right_lookup{gamepad.joystk_right_mag,gamepad.joystk_right_dir}(1),gamepad.joystk_right_lookup{gamepad.joystk_right_mag,gamepad.joystk_right_dir}(2));
gamepad.microscope.core.setSerialPortCommand(gamepad.stageport,my_command,sprintf('\r'));
end