%%
%
function [gamepad] = Gamepad_function_button_lb(gamepad)
    if gamepad.button_lb == gamepad.button_lb_old
        return
    elseif gamepad.button_lb == 1
        disp('you pressed ''lb''');
        return
    else
        return
    end
end