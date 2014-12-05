%%
%
function [gamepad] = Gamepad_function_joystk_left(gamepad)
%%
% if the position of the joystick is not changing then do not take any
% further action
if (gamepad.joystk_left_mag_old == gamepad.joystk_left_mag) && (gamepad.joystk_left_dir_old == gamepad.joystk_left_dir)
    return;
end
fprintf('joystick left: mag: %d\ndir: %d\n',gamepad.joystk_left_mag,gamepad.joystk_left_dir);
end