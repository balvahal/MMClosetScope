%%
%
function [mmhandle] = super_mda_function_position_before_basic(mmhandle,SuperMDA)
%% Tell the scope to move to the position
%
t = SuperMDA.runtime_index(1);
i = SuperMDA.runtime_index(2);
j = SuperMDA.runtime_index(3);
mmhandle = Core_general_setXYZ(mmhandle,SuperMDA.group(i).position(j).xyz(t,:));
end