%%
%
function [gamepad] = Gamepad_function_button_start(gamepad)
    if gamepad.button_start == gamepad.button_start_old
        return
    elseif gamepad.button_start == 1
        disp('you pressed ''start''');
        return
    else
        return
    end
end