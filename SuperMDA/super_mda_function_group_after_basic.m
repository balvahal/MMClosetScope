%%
%
function [mmhandle] = super_mda_function_group_after_basic(mmhandle,SuperMDA)
%%
%
if SuperMDA.groups(i).travel_offset_bool
    travel_with_offset;
end


%% Nested Functions
%
    function [] = travel_with_offset()
        %% lower objective
        pos_next = mmhandle.pos + [0,0,SuperMDA.groups(i).travel_offset];
        mmhandle = Core_general_setXYZ(mmhandle,pos_next(3),'direction','z');
        %% find and travel to next position
        if length(SuperMDA.groups) == 1 || i == length(SuperMDA.groups)
            pos_next = SuperMDA.groups(1).positions(1).xyz;
        else
            pos_next = SuperMDA.groups(i+1).positions(1).xyz;
        end
        mmhandle = Core_general_setXYZ(mmhandle,pos_next(1:2));
    end
end