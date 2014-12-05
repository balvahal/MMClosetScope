%%
%
function [gamepad] = SCAN6_gamepad_button_stk_left(gamepad)
if gamepad.button_stk_left == gamepad.button_stk_left_old
    return
elseif gamepad.button_stk_left == 1
    gamepad.pov_speed = circshift(gamepad.pov_speed,[1 -1]);
    fprintf('d-pad speed is %d microns per second\n',gamepad.pov_speed(1));
    if strcmp(gamepad.joystk_left_speedMode,'slow')
        gamepad.makeJoyStkLeftLookup('fast');
        gamepad.joystk_left_speedMode = 'fast';
        fprintf('joystick left speed FAST\n');
    else
        gamepad.makeJoyStkLeftLookup('slow');
        gamepad.joystk_left_speedMode = 'slow';
        fprintf('joystick left speed SLOW\n');
    end
    return
else
    return
end
end