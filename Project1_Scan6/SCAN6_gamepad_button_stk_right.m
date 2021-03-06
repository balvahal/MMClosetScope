%%
%
function [gamepad] = SCAN6_gamepad_button_stk_right(gamepad)
if gamepad.button_stk_right == gamepad.button_stk_right_old
    return
elseif gamepad.button_stk_right == 1
    gamepad.pov_speed = circshift(gamepad.pov_speed,[1 -1]);
    fprintf('d-pad speed is %d microns per second\n',gamepad.pov_speed(1));
    if strcmp(gamepad.joystk_right_speedMode,'slow')
        gamepad.makeJoyStkRightLookup('fast');
        gamepad.joystk_right_speedMode = 'fast';
        fprintf('joystick right speed FAST\n');
    else
        gamepad.makeJoyStkRightLookup('slow');
        gamepad.joystk_right_speedMode = 'slow';
        fprintf('joystick right speed SLOW\n');
    end
    return
else
    return
end
end