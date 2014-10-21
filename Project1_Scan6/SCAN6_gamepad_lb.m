function gamepad = SCAN6_gamepad_lb(gamepad)
if gamepad.button_lb == gamepad.button_lb_old
    return
elseif gamepad.button_lb == 1
    if gamepad.ITFpointer == 0
        gamepad.ITFpointer = 1;
    end
    %%
    % determine which functions to execute
    flag_group_before = false;
    flag_position_before = false;
    flag_group_after = false;
    flag_position_after = false;
    
    gpsInOrder = gamepad.smdaITF.gps(gamepad.smdaITF.orderVector,:);
    smdaI = gamepad.smdaITF;
    mmhandle = gamepad.microscope;
    gps_current = gpsInOrder(gamepad.ITFpointer,:);
    myTempPointer = gamepad.ITFpointer;
    while true
        if myTempPointer == 1
            myTempPointer = length(smdaI.orderVector);
        else
            myTempPointer = myTempPointer - 1;
        end
        if gpsInOrder(gamepad.ITFpointer,1) == gpsInOrder(myTempPointer,1)
            if myTempPointer == gamepad.ITFpointer
                %there is only one group
                return
            else
                continue
            end
        else
            gps_next = gpsInOrder(myTempPointer,:);
            gamepad.ITFpointer = myTempPointer;
            break
        end
    end
    flagcheck_before;
    flagcheck_after;
    flag_group_before = true;
    %%
    % execute the functions
    gps_execute;
    return
    %%
    %
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
        end
        if flag_position_after
            
        end
        if flag_group_after
            
        end
    end
end