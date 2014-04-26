%%
%
function [smdaPilot] = SuperMDA_function_group_before_basic(smdaPilot)
%%
%
mmhandle = smdaPilot.mm;
t = smdaPilot.runtime_index(1); %time
i = smdaPilot.runtime_index(2); %group
j = smdaPilot.runtime_index(3); %position
k = smdaPilot.runtime_index(4); %settings
%% lower objective
mmhandle.getXYZ;
pos_next = mmhandle.pos + [0,0,-100];
mmhandle.setXYZ(1000,'direction','z');
smdaPilot.mm.core.waitForDevice(smdaPilot.mm.FocusDevice);
%% find and travel to next position
pos_next = smdaPilot.itinerary.group(i).position(1).xyz(t,:);
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
if smdaPilot.itinerary.group(i).position(1).continuous_focus_bool
    smdaPilot.mm.core.setProperty(smdaPilot.mm.AutoFocusDevice,'Position',smdaPilot.itinerary.group(i).position(1).continuous_focus_offset);
    smdaPilot.mm.core.setProperty(smdaPilot.mm.AutoFocusStatusDevice,'State','On');
    pause(3);
end
