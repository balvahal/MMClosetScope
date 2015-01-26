%%
% create a new position
function [gamepad] = SCAN6_gamepad_a(gamepad)
    if gamepad.button_a == gamepad.button_a_old
        return
    elseif gamepad.button_a == 1
            pFirst = gamepad.smdaITF.order_position{gamepad.gInd}(1);
            gamepad.pInd = gamepad.smdaITF.newPosition;
            gamepad.smdaITF.connectGPS('g',gamepad.gInd,'p',gamepad.pInd,'s',gamepad.smdaITF.order_settings{pFirst});
            fprintf('new position, %d, added to group %d.\n',gamepad.pInd,gamepad.gInd);
        return
    else
        return
    end
end