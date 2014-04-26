%%
%
function [smdaPilot] = SuperMDA_function_position_before_basic(smdaPilot)
%% Tell the scope to move to the position
%
t = smdaPilot.runtime_index(1);
i = smdaPilot.runtime_index(2);
j = smdaPilot.runtime_index(3);
xyz = smdaPilot.itinerary.group(i).position(j).xyz(t,:);
if smdaPilot.itinerary.group(i).position(j).continuous_focus_bool
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
        smdaPilot.mm.core.setProperty(smdaPilot.mm.AutoFocusDevice,'Position',smdaPilot.itinerary.group(i).position(j).continuous_focus_offset);
        smdaPilot.mm.core.fullFocus(); % PFS will return to |OFF|
    else
        %%
        % If the PFS system is already on, then changing the offset will
        % adjust the z-position. fullFocus() will have the system wait
        % until the new z-position has been reached.
        smdaPilot.mm.core.setProperty(smdaPilot.mm.AutoFocusDevice,'Position',smdaPilot.itinerary.group(i).position(j).continuous_focus_offset);
        smdaPilot.mm.core.fullFocus(); % PFS will remain |ON|
    end
    %%
    % Account for vertical stage drift by updating the z position
    % information in the intinerary. Updating the z position is also
    % important for imaging z-stacks using the PFS. Use this information to
    % update the z for the next position, too.
    smdaPilot.mm.getXYZ;
    smdaPilot.itinerary.group(i).position(j).xyz(t,3) = smdaPilot.mm.pos(3);
    if t < smdaPilot.itinerary.number_of_timepoints
        smdaPilot.itinerary.group(i).position(j).xyz(t+1,3) = smdaPilot.mm.pos(3);
    end
else
    %% PFS will not be utilized
    %
    smdaPilot.mm.setXYZ(xyz);
    smdaPilot.mm.core.waitForDevice(smdaPilot.mm.FocusDevice);
    smdaPilot.mm.core.waitForDevice(smdaPilot.mm.xyStageDevice);
end