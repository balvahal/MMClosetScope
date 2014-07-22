%%
%
function [gamepad] = Gamepad_function_button_rb(gamepad)
    if gamepad.button_rb == gamepad.button_rb_old
        return
    elseif gamepad.button_rb == 1
        disp('you pressed ''rb''');
        return
    else
        return
    end
end