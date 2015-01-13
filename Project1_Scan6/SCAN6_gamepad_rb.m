function gamepad = SCAN6_gamepad_rb(gamepad)
if gamepad.button_rb == gamepad.button_rb_old
    return
elseif gamepad.button_rb == 1
    %%
    %
    groupOrder = gamepad.smdaITF.order_group;
    placeInOrder = find(groupOrder == gamepad.gInd,1,'first');
    
    if isempty(placeInOrder)
        warning('gamepad:rb','Group index does not exist.')
        return
    elseif placeInOrder == numel(groupOrder)
        placeInOrder = 1;
        gamepad.gInd = groupOrder(placeInOrder);
        gamepad.pInd = gamepad.smdaITF.order_position{gamepad.gInd}(1);
    else
        placeInOrder = placeInOrder + 1;
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

%%
% functions with the logic to determine which function to execute
    function flagcheck_before
        mydiff = gps_current - gps_next;
        if mydiff(1) ~= 0
            flag_group_before = true;
        end
        if mydiff(2) ~= 0
            flag_position_before = true;
        end
    end
    function flagcheck_after
        mydiff = gps_next - gps_current;
        if mydiff(1) ~= 0
            flag_group_after = true;
        end
        if mydiff(2) ~= 0
            flag_position_after = true;
        end
    end
    function gps_execute
        p = gpsInOrder(gamepad.ITFpointer,2);
        if flag_group_before
            %% lower objective

            mmhandle.getXYZ;
            currentZ = mmhandle.pos(3) - 500;
            if currentZ < 1000
                currentZ = 1000;
            end
            mmhandle.setXYZ(1000,'direction','z');
            mmhandle.core.waitForDevice(mmhandle.FocusDevice);
            %% find and travel to next position
            pos_next = smdaI.position_xyz(p,:);
            mmhandle.setXYZ(pos_next(1:2));
            mmhandle.core.waitForDevice(mmhandle.xyStageDevice);
            mmhandle.setXYZ(currentZ,'direction','z');
            mmhandle.core.waitForDevice(mmhandle.FocusDevice);
        end
        if flag_position_before
            xyz = smdaI.position_xyz(p,:);
            mmhandle.setXYZ(xyz(1:2)); % setting the z through the focus device will disable the PFS. Therefore, the stage is moved in the XY direction before assessing the status of the PFS system.
            mmhandle.core.waitForDevice(mmhandle.xyStageDevice);
%             if smdaI.position_continuous_focus_bool(p)
%                 %% PFS lock-on will be attempted
%                 %
%                 mmhandle.setXYZ(xyz(1:2)); % setting the z through the focus device will disable the PFS. Therefore, the stage is moved in the XY direction before assessing the status of the PFS system.
%                 mmhandle.core.waitForDevice(mmhandle.xyStageDevice);
%                 if strcmp(mmhandle.core.getProperty(mmhandle.AutoFocusStatusDevice,'State'),'Off')
%                     %%
%                     % If the PFS is |OFF|, then the scope is moved to an absolute z
%                     % that will give the system the best chance of locking onto the
%                     % correct z.
%                     mmhandle.setXYZ(xyz(3),'direction','z');
%                     mmhandle.core.waitForDevice(mmhandle.FocusDevice);
%                     mmhandle.core.setProperty(mmhandle.AutoFocusDevice,'Position',smdaI.position_continuous_focus_offset(p));
%                     mmhandle.core.fullFocus(); % PFS will return to |OFF|
%                 else
%                     %%
%                     % If the PFS system is already on, then changing the offset will
%                     % adjust the z-position. fullFocus() will have the system wait
%                     % until the new z-position has been reached.
%                     mmhandle.core.setProperty(mmhandle.AutoFocusDevice,'Position',smdaI.position_continuous_focus_offset(p));
%                     mmhandle.core.fullFocus(); % PFS will remain |ON|
%                 end
%                 %%
%                 % Account for vertical stage drift by updating the z position
%                 % information in the intinerary. Updating the z position is also
%                 % important for imaging z-stacks using the PFS. Use this information to
%                 % update the z for the next position, too.
%                 mmhandle.getXYZ;
%                 smdaI.position_xyz(p,3) = mmhandle.pos(3);
%             else
%                 %% PFS will not be utilized
%                 %
%                 mmhandle.setXYZ(xyz);
%                 mmhandle.core.waitForDevice(mmhandle.FocusDevice);
%                 mmhandle.core.waitForDevice(mmhandle.xyStageDevice);
%             end
        end
        if flag_position_after
            
        end
        if flag_group_after
            
        end
    end
end