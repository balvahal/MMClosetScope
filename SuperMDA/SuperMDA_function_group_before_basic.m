%%
%
function [SuperMDA] = SuperMDA_function_group_before_basic(SuperMDA)
%%
%
mmhandle = SuperMDA.mm;
t = SuperMDA.runtime_index(1); %time
i = SuperMDA.runtime_index(2); %group
j = SuperMDA.runtime_index(3); %position
k = SuperMDA.runtime_index(4); %settings
if SuperMDA.group(i).travel_offset_bool
    %% lower objective
    mmhandle.getXYZ;
    pos_next = mmhandle.pos + [0,0,SuperMDA.group(i).travel_offset];
    mmhandle.setXYZ(pos_next(3),'direction','z');
    SuperMDA.mm.core.waitForDevice(SuperMDA.mm.FocusDevice);
    %% find and travel to next position
    pos_next = SuperMDA.group(i).position(1).xyz(t,:);
    mmhandle.setXYZ(pos_next(1:2));
    mmhandle.core.waitForDevice(mmhandle.xyStageDevice);
    mmhandle.setXYZ(pos_next(3),'direction','z');
    SuperMDA.mm.core.waitForDevice(SuperMDA.mm.FocusDevice);
    SuperMDA.mm.core.setProperty(SuperMDA.mm.AutoFocusDevice,'Position',SuperMDA.group(i).position(1).continuous_focus_offset);
    SuperMDA.mm.core.setProperty(SuperMDA.mm.AutoFocusStatusDevice,'State','On')
    pause(5);
end
