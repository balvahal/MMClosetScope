%%
%
function [pilot] = group_function_before_default(pilot)
%%
%
t = pilot.t; %time
i = pilot.gps_current(1); %group
j = pilot.gps_current(2); %position
k = pilot.gps_current(3); %settings
%% lower objective
pilot.microscope.getXYZ;
pilot.microscope.setXYZ(1000,'direction','z');
pilot.microscope.core.waitForDevice(pilot.microscope.FocusDevice);
%% find and travel to next position
pos_next = pilot.itinerary.position_xyz(j,:);
pilot.microscope.setXYZ(pos_next(1:2));
pilot.microscope.core.waitForDevice(pilot.microscope.xyStageDevice);
pilot.microscope.setXYZ(pos_next(3),'direction','z');
pilot.microscope.core.waitForDevice(pilot.microscope.FocusDevice);
%% if using perfect focus...
% PFS will turn off if the z-drive is set. Therefore it must be turned back
% on. Assume PFS is being utilized if the first position uses PFS. PFS will
% be utilized even in mixed cases, but then fullFocus() will turn the PFS
% on and off at every position that uses PFS, which can slow things down
% and make a lot of beeping sounds.
if pilot.itinerary.position_continuous_focus_bool(j)
    pilot.microscope.core.setProperty(pilot.microscope.AutoFocusDevice,'Position',pilot.itinerary.position_continuous_focus_offset(j));
    %pilot.microscope.core.setProperty(pilot.microscope.AutoFocusStatusDevice,'State','On');
    pilot.microscope.core.fullFocus;
    pause(3);
end
