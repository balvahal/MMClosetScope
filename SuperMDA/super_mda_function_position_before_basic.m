%%
%
function [mmhandle] = super_mda_function_position_before_basic(mmhandle,SuperMDA)
%% Tell the scope to move to the position
%
mmhandle = Core_general_setXYZ(mmhandle,SuperMDA.groups(i).positions(j).xyz);