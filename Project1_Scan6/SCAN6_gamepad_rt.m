%%
% trigger buttons loop within a group
function gamepad = SCAN6_gamepad_rt(gamepad)
if gamepad.button_rt == gamepad.button_rt_old
    return
elseif gamepad.button_rt == 1
    %%
    %
    positionOrder = gamepad.smdaITF.order_position{gamepad.gInd};
    placeInOrder = find(positionOrder == gamepad.pInd,1,'first');
    
    if isempty(placeInOrder)
        warning('gamepad:rt','Group index is out of sync with position index.')
        return
    elseif placeInOrder == numel(positionOrder)
        placeInOrder = 1;
        gamepad.pInd = positionOrder(placeInOrder);
    else
        placeInOrder = placeInOrder + 1;
        gamepad.pInd = positionOrder(placeInOrder);
    end
    xyz = gamepad.smdaITF.position_xyz(gamepad.pInd,:);
    gamepad.microscope.setXYZ(xyz(1:2)); % setting the z through the focus device will disable the PFS. Therefore, the stage is moved in the XY direction before assessing the status of the PFS system.
    gamepad.microscope.core.waitForDevice(gamepad.microscope.xyStageDevice);
else
    return
end
end