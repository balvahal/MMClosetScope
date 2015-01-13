%%
% update all z positions for a group
function [gamepad] = SCAN6_gamepad_y(gamepad)
    if gamepad.button_y == gamepad.button_y_old
        return
    elseif gamepad.button_y == 1
        positionList = gamepad.smdaITF.ind_position{gamepad.gInd};
        gamepad.smdaITF.position_continuous_focus_offset(positionList) = str2double(gamepad.microscope.core.getProperty(gamepad.microscope.AutoFocusDevice,'Position'));
        xyz = gamepad.microscope.getXYZ;
        gamepad.smdaITF.position_xyz(positionList,3) = xyz(3);
        fprintf('positions in group %d have Z postions updated!\n',gamepad.gInd);
        return
    else
        return
    end
end