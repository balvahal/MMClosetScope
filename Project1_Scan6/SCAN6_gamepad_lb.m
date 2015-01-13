function gamepad = SCAN6_gamepad_lb(gamepad)
if gamepad.button_lb == gamepad.button_lb_old
    return
elseif gamepad.button_lb == 1
    %%
    %
    groupOrder = gamepad.smdaITF.order_group;
    placeInOrder = find(groupOrder == gamepad.gInd,1,'first');
    
    if isempty(placeInOrder)
        warning('gamepad:lb','Group index does not exist.')
        return
    elseif placeInOrder == 1
        placeInOrder = numel(groupOrder);
        gamepad.gInd = groupOrder(placeInOrder);
        gamepad.pInd = gamepad.smdaITF.order_position{gamepad.gInd}(1);
    else
        placeInOrder = placeInOrder - 1;
        gamepad.gInd = groupOrder(placeInOrder);
        gamepad.pInd = gamepad.smdaITF.order_position{gamepad.gInd}(1);
    end
    %% lower objective
    gamepad.microscope.getXYZ;
    currentZ = gamepad.microscope.pos(3) - 500;
    if currentZ < 1000
        currentZ = 1000;
    end
    gamepad.microscope.setXYZ(1000,'direction','z');
    gamepad.microscope.core.waitForDevice(gamepad.microscope.FocusDevice);
    %% find and travel to next position
    pos_next = gamepad.smdaITF.position_xyz(gamepad.pInd,:);
    gamepad.microscope.setXYZ(pos_next(1:2));
    gamepad.microscope.core.waitForDevice(gamepad.microscope.xyStageDevice);
    gamepad.microscope.setXYZ(currentZ,'direction','z');
    gamepad.microscope.core.waitForDevice(gamepad.microscope.FocusDevice);
else
    return
end