%%
%
function [gamepad] = Gamepad_function_button_lt(gamepad)
    if gamepad.button_lt == gamepad.button_lt_old
        return
    elseif gamepad.button_lt == 1
        disp('you pressed ''lt''');
        return
    else
        return
    end
end