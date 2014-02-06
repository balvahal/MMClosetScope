%%
%
function [gamepad] = Gamepad_function_button_rt(gamepad)
    if gamepad.button_rt == gamepad.button_rt_old
        return
    elseif gamepad.button_rt == 1
        gamepad.microscope.snapImage;
        imshow(gamepad.microscope.I,[]);
        return
    else
        return
    end
end