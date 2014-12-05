%%
%
function [gamepad] = Gamepad_function_joystk_right(gamepad)
%%
% if the position of the joystick is not changing then do not take any
% further action
if (gamepad.joystk_right_mag_old == gamepad.joystk_right_mag) && (gamepad.joystk_right_dir_old == gamepad.joystk_right_dir)
    return;
end
fprintf('joystick right: mag: %d\ndir: %d\n',gamepad.joystk_right_mag,gamepad.joystk_right_dir);
end