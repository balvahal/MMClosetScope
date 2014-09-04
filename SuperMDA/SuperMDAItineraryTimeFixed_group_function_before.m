%%
%
function [smdaPilot] = SuperMDAItineraryTimeFixed_group_function_before(smdaPilot)
%%
%
mmhandle = smdaPilot.mm;
t = smdaPilot.t; %time
i = smdaPilot.gps_current(1); %group
j = smdaPilot.gps_current(2); %position
k = smdaPilot.gps_current(3); %settings
%% lower objective
mmhandle.getXYZ;
mmhandle.setXYZ(1000,'direction','z');
smdaPilot.mm.core.waitForDevice(smdaPilot.mm.FocusDevice);
%% find and travel to next position
pos_next = smdaPilot.itinerary.position_xyz(j,:);
mmhandle.setXYZ(pos_next(1:2));
mmhandle.core.waitForDevice(mmhandle.xyStageDevice);
mmhandle.setXYZ(pos_next(3),'direction','z');
smdaPilot.mm.core.waitForDevice(smdaPilot.mm.FocusDevice);
%% if using perfect focus...
% PFS will turn off if the z-drive is set. Therefore it must be turned back
% on. Assume PFS is being utilized if the first position uses PFS. PFS will
% be utilized even in mixed cases, but then fullFocus() will turn the PFS
% on and off at every position that uses PFS, which can slow things down
% and make a lot of beeping sounds.
if smdaPilot.itinerary.position_continuous_focus_bool(j)
    smdaPilot.mm.core.setProperty(smdaPilot.mm.AutoFocusDevice,'Position',smdaPilot.itinerary.position_continuous_focus_offset(j));
    smdaPilot.mm.core.setProperty(smdaPilot.mm.AutoFocusStatusDevice,'State','On');
    pause(3);
end
