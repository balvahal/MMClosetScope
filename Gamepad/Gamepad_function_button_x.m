%%
%
function [gamepad] = Gamepad_function_button_x(gamepad)
    if gamepad.button_x == gamepad.button_x_old
        return
    elseif gamepad.button_x == 1
        disp('you pressed ''x''');
        return
    else
        return
    end
end