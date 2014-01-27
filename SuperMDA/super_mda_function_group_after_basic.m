%%
%
function [mmhandle] = super_mda_function_group_after_basic(mmhandle,SuperMDA)
%%
%
i = SuperMDA.runtime_index(2);
if SuperMDA.group(i).travel_offset_bool
    travel_with_offset;
end


%% Nested Functions
%
    function [] = travel_with_offset()
        %% lower objective
        pos_next = mmhandle.pos + [0,0,SuperMDA.group(i).travel_offset];
        mmhandle = Core_general_setXYZ(mmhandle,pos_next(3),'direction','z');
        %% find and travel to next position
        if length(SuperMDA.group) == 1 || i == SuperMDA.my_length
            pos_next = SuperMDA.group(1).position(1).xyz;
        else
            pos_next = SuperMDA.group(i+1).position(1).xyz;
        end
        mmhandle = Core_general_setXYZ(mmhandle,pos_next(1:2));
    end
end