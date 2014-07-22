%%
%
function [gamepad] = SCAN6_gamepad_x(gamepad)
    if gamepad.button_x == gamepad.button_x_old
        return
    elseif gamepad.button_x == 1
        mm = gamepad.microscope;
        smdaI = gamepad.smdaITF;
        myPInd = smdaI.gps(smdaI.orderVector(gamepad.ITFpointer),2);
        smdaI.position_continuous_focus_offset(myPInd) = str2double(mm.core.getProperty(mm.AutoFocusDevice,'Position'));
        smdaI.position_xyz(myPInd,:) = mm.getXYZ;
        fprintf('position %d updated!\n',myPInd);
        return
    else
        return
    end
end