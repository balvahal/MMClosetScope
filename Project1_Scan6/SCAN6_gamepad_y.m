%%
%
function [gamepad] = SCAN6_gamepad_y(gamepad)
    if gamepad.button_y == gamepad.button_x_old
        return
    elseif gamepad.button_y == 1
        mm = gamepad.microscope;
        smdaI = gamepad.smdaITF;
        myGInd = smdaI.gps(smdaI.orderVector(gamepad.ITFpointer),1);
        myPInd = smdaI.indOfPosition(myGInd);
        smdaI.position_continuous_focus_offset(myPInd) = str2double(mm.core.getProperty(mm.AutoFocusDevice,'Position'));
        xyz = mm.getXYZ;
        smdaI.position_xyz(myPInd,3) = xyz(3);
        fprintf('positions in group %d have Z postions updated!\n',myGInd);
        return
    else
        return
    end
end