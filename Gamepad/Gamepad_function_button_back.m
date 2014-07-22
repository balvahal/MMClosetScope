%%
%
function [gamepad] = Gamepad_function_button_back(gamepad)
    if gamepad.button_back == gamepad.button_back_old
        return
    elseif gamepad.button_back == 1
        disp('you pressed ''back''');
        return
    else
        return
    end
end