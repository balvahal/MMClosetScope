%%
%
function [smdaITF] = SuperMDAItineraryTimeFixed_method_export(smdaITF)

%%
%
jsonStrings = {};
n = 1;
%%
%
jsonStrings{n} = micrographIOT_array2json('orderVector',smdaITF.orderVector); n = n + 1;
%%
% group
jsonStrings{n} = micrographIOT_cellStringArray2json('group_function_after',smdaITF.group_function_after); n = n + 1;
jsonStrings{n} = micrographIOT_cellStringArray2json('group_function_before',smdaITF.group_function_before); n = n + 1;
jsonStrings{n} = micrographIOT_cellStringArray2json('group_label',smdaITF.group_label); n = n + 1;
jsonStrings{n} = micrographIOT_array2json('group_logical',smdaITF.group_logical); n = n + 1;
%%
% navigation indices
jsonStrings{n} = micrographIOT_array2json('ind_first_group',smdaITF.ind_first_group); n = n + 1;
jsonStrings{n} = micrographIOT_array2json('ind_last_group',smdaITF.ind_last_group); n = n + 1;
jsonStrings{n} = micrographIOT_array2json('ind_next_gps',smdaITF.ind_next_gps); n = n + 1;
jsonStrings{n} = micrographIOT_array2json('ind_next_group',smdaITF.ind_next_group); n = n + 1;
jsonStrings{n} = micrographIOT_array2json('ind_next_position',smdaITF.ind_next_position); n = n + 1;
jsonStrings{n} = micrographIOT_array2json('ind_next_settings',smdaITF.ind_next_settings); n = n + 1;
%%
% position
jsonStrings{n} = micrographIOT_array2json('position_continuous_focus_offset',smdaITF.position_continuous_focus_offset); n = n + 1;
jsonStrings{n} = micrographIOT_array2json('position_continuous_focus_bool',smdaITF.position_continuous_focus_bool); n = n + 1;
jsonStrings{n} = micrographIOT_cellStringArray2json('position_function_after',smdaITF.position_function_after); n = n + 1;
jsonStrings{n} = micrographIOT_cellStringArray2json('position_function_before',smdaITF.position_function_before); n = n + 1;
jsonStrings{n} = micrographIOT_cellStringArray2json('position_label',smdaITF.position_label); n = n + 1;
jsonStrings{n} = micrographIOT_array2json('position_logical',smdaITF.position_logical); n = n + 1;
jsonStrings{n} = micrographIOT_2dmatrix2json('position_xyz',smdaITF.position_xyz); n = n + 1;
%%
% settings
jsonStrings{n} = micrographIOT_array2json('settings_binning',smdaITF.settings_binning); n = n + 1;
jsonStrings{n} = micrographIOT_array2json('settings_channel',smdaITF.settings_channel); n = n + 1;
jsonStrings{n} = micrographIOT_array2json('settings_exposure',smdaITF.settings_exposure); n = n + 1;
jsonStrings{n} = micrographIOT_cellStringArray2json('settings_function',smdaITF.settings_function); n = n + 1;
jsonStrings{n} = micrographIOT_array2json('settings_gain',smdaITF.settings_gain); n = n + 1;
jsonStrings{n} = micrographIOT_array2json('settings_logical',smdaITF.settings_logical); n = n + 1;
jsonStrings{n} = micrographIOT_array2json('settings_period_multiplier',smdaITF.settings_period_multiplier); n = n + 1;
jsonStrings{n} = micrographIOT_array2json('settings_timepoints',smdaITF.settings_timepoints); n = n + 1;
jsonStrings{n} = micrographIOT_array2json('settings_z_origin_offset',smdaITF.settings_z_origin_offset); n = n + 1;
jsonStrings{n} = micrographIOT_array2json('settings_z_stack_lower_offset',smdaITF.settings_z_stack_lower_offset); n = n + 1;
jsonStrings{n} = micrographIOT_array2json('settings_z_stack_upper_offset',smdaITF.settings_z_stack_upper_offset); n = n + 1;
jsonStrings{n} = micrographIOT_array2json('settings_z_step_size',smdaITF.settings_z_step_size); n = n + 1;
%%
%
myjson = micrographIOT_jsonStrings2Object(jsonStrings);
fid = fopen(fullfile(smdaITF.output_directory,'smdaITF.txt'),'w');
if fid == -1
    error('smdaITF:badfile','Cannot open the file, preventing the export of the smdaITF.');
end
fprintf(fid,myjson);
fclose(fid);
%%
%
myjson = micrographIOT_autoIndentJson(fullfile(smdaITF.output_directory,'smdaITF.txt'));
fid = fopen(fullfile(smdaITF.output_directory,'smdaITF.txt'),'w');
if fid == -1
    error('smdaITF:badfile','Cannot open the file, preventing the export of the smdaITF.');
end
fprintf(fid,myjson);
fclose(fid);
end

