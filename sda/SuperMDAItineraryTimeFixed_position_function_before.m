%%
%
function [smdaPilot] = SuperMDAItineraryTimeFixed_position_function_before(smdaPilot)
%% Tell the scope to move to the position
%
t = smdaPilot.t; %time
i = smdaPilot.gps_current(1); %group
j = smdaPilot.gps_current(2); %position
k = smdaPilot.gps_current(3); %settings
xyz = smdaPilot.itinerary.position_xyz(j,:);
if smdaPilot.itinerary.position_continuous_focus_bool(j)
    %% PFS lock-on will be attempted
    %
    smdaPilot.mm.setXYZ(xyz(1:2)); % setting the z through the focus device will disable the PFS. Therefore, the stage is moved in the XY direction before assessing the status of the PFS system.
    smdaPilot.mm.core.waitForDevice(smdaPilot.mm.xyStageDevice);
    if strcmp(smdaPilot.mm.core.getProperty(smdaPilot.mm.AutoFocusStatusDevice,'State'),'Off')
        %%
        % If the PFS is |OFF|, then the scope is moved to an absolute z
        % that will give the system the best chance of locking onto the
        % correct z.
        smdaPilot.mm.setXYZ(xyz(3),'direction','z');
        smdaPilot.mm.core.waitForDevice(smdaPilot.mm.FocusDevice);
        smdaPilot.mm.core.setProperty(smdaPilot.mm.AutoFocusDevice,'Position',smdaPilot.itinerary.position_continuous_focus_offset(j));
        try
            smdaPilot.mm.core.fullFocus(); % PFS will return to |OFF|
        catch
            if smdaPilot.mm.twitter.active
                smdaPilot.mm.twitter.update_status(sprintf('Error in perfect focus from the %s microscope. %s', smdaPilot.mm.computerName, datetime('now','Format','hh:mm:ss a')));                
            end
            fprintf('Error in perfect focus from the %s microscope. %s\n',smdaPilot.mm.computerName, datetime('now','Format','hh:mm:ss a'));
        end
    else
        %%
        % If the PFS system is already on, then changing the offset will
        % adjust the z-position. fullFocus() will have the system wait
        % until the new z-position has been reached.
        smdaPilot.mm.core.setProperty(smdaPilot.mm.AutoFocusDevice,'Position',smdaPilot.itinerary.position_continuous_focus_offset(j));
        try
            smdaPilot.mm.core.fullFocus(); % PFS will remain |ON|
        catch
            if smdaPilot.mm.twitter.active
                smdaPilot.mm.twitter.update_status(sprintf('Error in perfect focus from the %s microscope. %s',smdaPilot.mm.computerName, datetime('now','Format','hh:mm:ss a')));                
            end
            fprintf('Error in perfect focus from the %s microscope. %s\n',smdaPilot.mm.computerName, datetime('now','Format','hh:mm:ss a'));
        end
    end
    %%
    % Account for vertical stage drift by updating the z position
    % information in the intinerary. Updating the z position is also
    % important for imaging z-stacks using the PFS. Use this information to
    % update the z for the next position, too.
    smdaPilot.mm.getXYZ;
    smdaPilot.itinerary.position_xyz(j,3) = smdaPilot.mm.pos(3);
else
    %% PFS will not be utilized
    %
    smdaPilot.mm.setXYZ(xyz);
    smdaPilot.mm.core.waitForDevice(smdaPilot.mm.FocusDevice);
    smdaPilot.mm.core.waitForDevice(smdaPilot.mm.xyStageDevice);
end