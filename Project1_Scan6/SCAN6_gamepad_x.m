%%
% update the current position
function [gamepad] = SCAN6_gamepad_x(gamepad)
    if gamepad.button_x == gamepad.button_x_old
        return
    elseif gamepad.button_x == 1
        gamepad.smdaITF.position_continuous_focus_offset(gamepad.pInd) = str2double(gamepad.microscope.core.getProperty(gamepad.microscope.AutoFocusDevice,'Position'));
        gamepad.smdaITF.position_xyz(gamepad.pInd,:) = gamepad.microscope.getXYZ;
        fprintf('position %d updated!\n',gamepad.pInd);
        return
    else
        return
    end
end