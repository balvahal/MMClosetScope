%%
%
function [gamepad] = Gamepad_function_button_b(gamepad)
    if gamepad.button_b == gamepad.button_b_old
        return
    elseif gamepad.button_b == 1
        disp('you pressed ''b''');
        return
    else
        return
    end
end