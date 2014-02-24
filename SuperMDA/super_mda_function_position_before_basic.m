%%
%
function [SuperMDA] = super_mda_function_position_before_basic(SuperMDA)
%% Tell the scope to move to the position
%
t = SuperMDA.runtime_index(1);
i = SuperMDA.runtime_index(2);
j = SuperMDA.runtime_index(3);
xyz = SuperMDA.group(i).position(j).xyz(t,:);
if SuperMDA.group(i).position(j).continuous_focus_bool
    SuperMDA.mm.setXYZ(xyz);
    myflag = true;
    while myflag
        if ~SuperMDA.mm.core.deviceBusy(SuperMDA.mm.xyStageDevice)
            myflag = false;
        end
    end
    if strcmp(SuperMDA.mm.core.getProperty(SuperMDA.mm.AutoFocusStatusDevice,'State'),'Off')
        SuperMDA.mm.core.setProperty(SuperMDA.mm.AutoFocusStatusDevice,'State','On');
        SuperMDA.mm.core.waitForDevice(SuperMDA.mm.AutoFocusDevice);
        SuperMDA.mm.core.setProperty(SuperMDA.mm.AutoFocusDevice,'Position',SuperMDA.group(i).position(j).continuous_focus_offset);
    elseif strcmp(SuperMDA.mm.core.getProperty(SuperMDA.mm.AutoFocusStatusDevice,'State'),'On')...
            && strcmp(SuperMDA.mm.core.getProperty(SuperMDA.mm.AutoFocusStatusDevice,'Status'),'Locked in Focus')
        %PFS is already On
        SuperMDA.mm.core.setProperty(SuperMDA.mm.AutoFocusDevice,'Position',SuperMDA.group(i).position(j).continuous_focus_offset);
    elseif strcmp(SuperMDA.mm.core.getProperty(SuperMDA.mm.AutoFocusStatusDevice,'Status'),'Out of focus search range')
        SuperMDA.mm.core.setProperty(SuperMDA.mm.AutoFocusStatusDevice,'State','Off');
        SuperMDA.mm.setXYZ(xyz(3),'direction','z');
        %PFS is out of range
    elseif strcmp(SuperMDA.mm.core.getProperty(SuperMDA.mm.AutoFocusStatusDevice,'Status'),'Focus lock failed')
        SuperMDA.mm.core.setProperty(SuperMDA.mm.AutoFocusStatusDevice,'State','Off');
        SuperMDA.mm.setXYZ(xyz(3),'direction','z');
    end
    SuperMDA.mm.core.waitForDevice(SuperMDA.mm.FocusDevice);
else
    SuperMDA.mm.setXYZ(xyz);
    myflag = true;
    while myflag
        if ~SuperMDA.mm.core.deviceBusy(SuperMDA.mm.xyStageDevice)
            myflag = false;
        end
    end
    SuperMDA.mm.core.waitForDevice(SuperMDA.mm.FocusDevice);
end