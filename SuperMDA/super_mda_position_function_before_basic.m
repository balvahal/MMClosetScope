%%
%
function [mmhandle] = super_mda_position_function_before_basic(mmhandle,SuperMDA,i,j)
%% Tell the scope to move to the position
%
mmhandle = Core_general_setXYZ(SuperMDA.groups(i).positions(j).xyz);