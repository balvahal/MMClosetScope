%%
%
function [gamepad] = Gamepad_function_button_a(gamepad)
    if gamepad.button_a == gamepad.button_a_old
        return
    elseif gamepad.button_a == 1
        disp('you pressed ''a''');
        return
    else
        return
    end
end