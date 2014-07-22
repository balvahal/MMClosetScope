%%
%
function [gamepad] = Gamepad_function_button_y(gamepad)
    if gamepad.button_y == gamepad.button_y_old
        return
    elseif gamepad.button_y == 1
        disp('you pressed ''y''');
        return
    else
        return
    end
end