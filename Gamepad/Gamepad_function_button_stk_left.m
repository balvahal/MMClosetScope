%%
%
function [gamepad] = Gamepad_function_button_stk_left(gamepad)
if gamepad.button_stk_left == gamepad.button_stk_left_old
    return
elseif gamepad.button_stk_left == 1
    disp('you pressed ''joystick button left''');
    return
else
    return
end
end