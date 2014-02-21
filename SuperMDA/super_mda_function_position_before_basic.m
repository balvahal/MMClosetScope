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
    myflag = true;
    while myflag
        if ~SuperMDA.mm.core.deviceBusy(SuperMDA.mm.xyStageDevice)
            myflag = false;
        end
    end
    if strcmp(SuperMDA.mm.core.getProperty(SuperMDA.mm.AutoFocusStatusDevice,'State'),'Off')...
            && strcmp(SuperMDA.mm.core.getProperty(SuperMDA.mm.AutoFocusStatusDevice,'Status'),'Within range of focus search')
        %PFS is Off and in range
        SuperMDA.mm.setXYZ(xyz(3),'direction','z');
        SuperMDA.mm.core.setProperty(SuperMDA.mm.AutoFocusStatusDevice,'State','On');
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
    myflag = true;
    while myflag
        mypos2 = SuperMDA.mm.getXYZ;
        mystr = sprintf('1st : %d',mypos2(3));
        disp(mystr);
        pause(0.1);
        mypos = SuperMDA.mm.getXYZ;
        mystr = sprintf('2nd : %d',mypos(3));
        disp(mystr);
        if mypos2(3) ~= mypos(3)
            myflag = false;
        end
    end
else
    SuperMDA.mm.setXYZ(xyz);
    myflag = true;
    while myflag
        if ~SuperMDA.mm.core.deviceBusy(SuperMDA.mm.xyStageDevice)
            myflag = false;
        end
    end
    myflag = true;
    while myflag
        mypos2 = SuperMDA.mm.getXYZ;
        pause(0.1);
        mypos = SuperMDA.mm.getXYZ;
        if mypos2(3) ~= mypos(3)
            myflag = false;
        end
    end
end