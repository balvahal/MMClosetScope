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
    smdaPilot.mm.setXYZ(xyz(1:2));
    smdaPilot.mm.core.waitForDevice(smdaPilot.mm.xyStageDevice);
    if strcmp(smdaPilot.mm.core.getProperty(smdaPilot.mm.AutoFocusStatusDevice,'State'),'Off')
        smdaPilot.mm.setXYZ(xyz(3),'direction','z');
        smdaPilot.mm.core.waitForDevice(smdaPilot.mm.FocusDevice);
        smdaPilot.mm.core.setProperty(smdaPilot.mm.AutoFocusDevice,'Position',smdaPilot.itinerary.group(i).position(j).continuous_focus_offset);
        smdaPilot.mm.core.fullFocus();
    else
        smdaPilot.mm.core.setProperty(smdaPilot.mm.AutoFocusDevice,'Position',smdaPilot.itinerary.group(i).position(j).continuous_focus_offset);
    end
else
    smdaPilot.mm.setXYZ(xyz);
    smdaPilot.mm.core.waitForDevice(smdaPilot.mm.FocusDevice);
    smdaPilot.mm.core.waitForDevice(smdaPilot.mm.xyStageDevice);
end