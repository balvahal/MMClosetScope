%%
%
function [pilot] = position_function_before_default(pilot)
%% Tell the scope to move to the position
%
t = pilot.t; %time
i = pilot.gps_current(1); %group
j = pilot.gps_current(2); %position
k = pilot.gps_current(3); %settings
xyz = pilot.itinerary.position_xyz(j,:);
if pilot.itinerary.position_continuous_focus_bool(j)
    %% PFS lock-on will be attempted
    %
    pilot.microscope.setXYZ(xyz(1:2)); % setting the z through the focus device will disable the PFS. Therefore, the stage is moved in the XY direction before assessing the status of the PFS system.
    pilot.microscope.core.waitForDevice(pilot.microscope.xyStageDevice);
    %if strcmp(pilot.microscope.core.getProperty(pilot.microscope.AutoFocusStatusDevice,'State'),'Off')
        %%
        % If the PFS is |OFF|, then the scope is moved to an absolute z
        % that will give the system the best chance of locking onto the
        % correct z.
        pilot.microscope.setXYZ(xyz(3),'direction','z');
        pilot.microscope.core.waitForDevice(pilot.microscope.FocusDevice);
        pilot.microscope.core.setProperty(pilot.microscope.AutoFocusDevice,'Position',pilot.itinerary.position_continuous_focus_offset(j));
        try
            pilot.microscope.core.fullFocus(); % PFS will return to |OFF|
        catch
            if pilot.microscope.twitter.active
                pilot.microscope.twitter.update_status(sprintf('Error in perfect focus from the %s microscope. %s', pilot.microscope.computerName, datetime('now','Format','hh:mm:ss a')));                
            end
            fprintf('Error in perfect focus from the %s microscope. %s\n',pilot.microscope.computerName, datetime('now','Format','hh:mm:ss a'));
        end
    %else
        %%
        % If the PFS system is already on, then changing the offset will
        % adjust the z-position. fullFocus() will have the system wait
        % until the new z-position has been reached.
        pilot.microscope.core.setProperty(pilot.microscope.AutoFocusDevice,'Position',pilot.itinerary.position_continuous_focus_offset(j));
        try
            pilot.microscope.core.fullFocus(); % PFS will remain |ON|
        catch
            if pilot.microscope.twitter.active
                pilot.microscope.twitter.update_status(sprintf('Error in perfect focus from the %s microscope. %s',pilot.microscope.computerName, datetime('now','Format','hh:mm:ss a')));                
            end
            fprintf('Error in perfect focus from the %s microscope. %s\n',pilot.microscope.computerName, datetime('now','Format','hh:mm:ss a'));
        end
    %end
    %%
    % Account for vertical stage drift by updating the z position
    % information in the intinerary. Updating the z position is also
    % important for imaging z-stacks using the PFS. Use this information to
    % update the z for the next position, too.
    pilot.microscope.getXYZ;
    pilot.itinerary.position_xyz(j,3) = pilot.microscope.pos(3);
else
    %% PFS will not be utilized
    %
    pilot.microscope.setXYZ(xyz);
    pilot.microscope.core.waitForDevice(pilot.microscope.FocusDevice);
    pilot.microscope.core.waitForDevice(pilot.microscope.xyStageDevice);
end