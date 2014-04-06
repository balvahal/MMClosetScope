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
mmhandle.setXYZ(pos_next(3),'direction','z');
smdaPilot.mm.core.waitForDevice(smdaPilot.mm.FocusDevice);
%% find and travel to next position
pos_next = smdaPilot.itinerary.group(i).position(1).xyz(t,:);
mmhandle.setXYZ(pos_next(1:2));
mmhandle.core.waitForDevice(mmhandle.xyStageDevice);
mmhandle.setXYZ(pos_next(3),'direction','z');
smdaPilot.mm.core.waitForDevice(smdaPilot.mm.FocusDevice);
%     smdaPilot.mm.core.setProperty(smdaPilot.mm.AutoFocusDevice,'Position',smdaPilot.itinerary.group(i).position(1).continuous_focus_offset);
%     smdaPilot.mm.core.setProperty(smdaPilot.mm.AutoFocusStatusDevice,'State','On')
%     pause(5);
