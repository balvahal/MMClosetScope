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
    SuperMDA.mm.setXYZ(xyz(1:2));
    SuperMDA.mm.core.waitForDevice(SuperMDA.mm.xyStageDevice);
    if strcmp(SuperMDA.mm.core.getProperty(SuperMDA.mm.AutoFocusStatusDevice,'State'),'Off')
        SuperMDA.mm.setXYZ(xyz(3),'direction','z');
        SuperMDA.mm.core.waitForDevice(SuperMDA.mm.FocusDevice);
        SuperMDA.mm.core.setProperty(SuperMDA.mm.AutoFocusDevice,'Position',SuperMDA.group(i).position(j).continuous_focus_offset);
        SuperMDA.mm.core.fullFocus();
    else
        SuperMDA.mm.core.setProperty(SuperMDA.mm.AutoFocusDevice,'Position',SuperMDA.group(i).position(j).continuous_focus_offset);
    end
else
    SuperMDA.mm.setXYZ(xyz);
    SuperMDA.mm.core.waitForDevice(SuperMDA.mm.FocusDevice);
    SuperMDA.mm.core.waitForDevice(SuperMDA.mm.xyStageDevice);
end