%%
%
function [gamepad] = Gamepad_function_button_stk_right(gamepad)
if gamepad.button_stk_right == gamepad.button_stk_right_old
    return
elseif gamepad.button_stk_right == 1
        disp('you pressed ''joystick button right''');
    return
else
    return
end
end