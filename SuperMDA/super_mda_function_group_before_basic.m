%%
%
function [mmhandle] = super_mda_function_group_before_basic(mmhandle,SuperMDA)
%%
%
t = SuperMDA.runtime_index(1); %time
i = SuperMDA.runtime_index(2); %group
j = SuperMDA.runtime_index(3); %position
k = SuperMDA.runtime_index(4); %settings
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
        pos_next = SuperMDA.group(i).position(1).xyz(t,:);
        mmhandle = Core_general_setXYZ(mmhandle,pos_next(1:2));
    end
end