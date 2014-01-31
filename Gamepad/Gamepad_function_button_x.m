%%
%
function [] = Gamepad_function_button_x(gamepad)
    if gamepad.button_x == gamepad.button_x_old
        return
    elseif gamepad.button_x == 1
        gamepad.button_x_old = gamepad.button_x;
        disp('you pressed ''x''');
        return
    else
        gamepad.button_x_old = gamepad.button_x;
        return
    end
end