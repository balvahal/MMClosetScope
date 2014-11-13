%%
%
function [smdaITF] = SuperMDAItineraryTimeFixed_method_import(smdaITF,filename)
%%
% check for the function _loadjson_ from the MATLAB File Exchange
data = loadjson(filename);
%%
%
if iscell(data.channel_names)
    smdaITF.channel_names = data.channel_names;
else
    smdaITF.channel_names = {data.channel_names};
end
smdaITF.gps = data.gps;
smdaITF.gps_logical = logical(data.gps_logical);
smdaITF.orderVector = data.orderVector;
if iscell(data.output_directory)
    smdaITF.output_directory = fullfile(data.output_directory{:});
else
    smdaITF.output_directory = data.output_directory;
end
%%
% group
if iscell(data.group_function_after)
    smdaITF.group_function_after = data.group_function_after;
else
    smdaITF.group_function_after = {data.group_function_after};
end
if iscell(data.group_function_before)
    smdaITF.group_function_before = data.group_function_before;
else
    smdaITF.group_function_before = {data.group_function_before};
end
if iscell(data.group_label)
    smdaITF.group_label = data.group_label;
else
    smdaITF.group_label = {data.group_label};
end
smdaITF.group_logical = logical(data.group_logical);
%%
% navigation indices
smdaITF.ind_first_group = data.ind_first_group;
smdaITF.ind_last_group = data.ind_last_group;
smdaITF.ind_next_gps = data.ind_next_gps;
smdaITF.ind_next_group = data.ind_next_group;
smdaITF.ind_next_position = data.ind_next_position;
smdaITF.ind_next_settings = data.ind_next_settings;
%%
% position
smdaITF.position_continuous_focus_offset = data.position_continuous_focus_offset;
smdaITF.position_continuous_focus_bool = logical(data.position_continuous_focus_bool);
if iscell(data.position_function_after)
    smdaITF.position_function_after = data.position_function_after;
else
    smdaITF.position_function_after = {data.position_function_after};
end
if iscell(data.position_function_before)
    smdaITF.position_function_before = data.position_function_before;
else
    smdaITF.position_function_before = {data.position_function_before};
end
if iscell(data.position_label)
    smdaITF.position_label = data.position_label;
else
    smdaITF.position_label = {data.position_label};
end
smdaITF.position_logical = logical(data.position_logical);
smdaITF.position_xyz = data.position_xyz;
%%
% settings
smdaITF.settings_binning = data.settings_binning;
smdaITF.settings_channel = data.settings_channel;
smdaITF.settings_exposure = data.settings_exposure;
if iscell(data.settings_function)
    smdaITF.settings_function = data.settings_function;
else
    smdaITF.settings_function = {data.settings_function};
end
smdaITF.settings_gain = data.settings_gain;
smdaITF.settings_logical = logical(data.settings_logical);
smdaITF.settings_period_multiplier = data.settings_period_multiplier;
smdaITF.settings_timepoints = data.settings_timepoints;
smdaITF.settings_z_origin_offset = data.settings_z_origin_offset;
smdaITF.settings_z_stack_lower_offset = data.settings_z_stack_lower_offset;
smdaITF.settings_z_stack_upper_offset = data.settings_z_stack_upper_offset;
smdaITF.settings_z_step_size = data.settings_z_step_size;
%%
%
smdaITF.newDuration(data.duration);
smdaITF.newFundamentalPeriod(data.fundamental_period);
smdaITF.newNumberOfTimepoints(data.number_of_timepoints);
end