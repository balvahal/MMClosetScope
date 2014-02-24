%%
%
function [SuperMDA] = super_mda_function_group_before_basic(SuperMDA)
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
    myflag = true;
    while myflag
        if ~mmhandle.core.deviceBusy(mmhandle.xyStageDevice)
            myflag = false;
        end
    end
    mmhandle.setXYZ(pos_next(3),'direction','z');
    SuperMDA.mm.core.waitForDevice(SuperMDA.mm.FocusDevice);
end
