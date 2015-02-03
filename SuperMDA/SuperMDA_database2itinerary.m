%%
%
function [] = SuperMDA_database2itinerary(moviePath)
%%
% import the smda database
smda = readtable(fullfile(moviePath,'smda_database.txt'),'Delimiter','\t');
%%
%
jsonStrings = {};
n = 1;
%%
%
channel_number = transpose(unique(smda.channel_number));
channel_names = repmat({'unknown'},1,max(channel_number));
for i = channel_number
    channel_names{i} = smda.channel_name{find(smda.channel_number == i,1)};
end
jsonStrings{n} = micrographIOT_cellStringArray2json('channel_names',channel_names); n = n + 1;

gps = [smda.group_number,smda.position_number,smda.settings_number,smda.group_order,smda.position_order,smda.settings_order];
gps = unique(gps,'rows');
gps = sortrows(gps,[4,5,6]);
gps = gps(:,1:3);
jsonStrings{n} = micrographIOT_2dmatrix2json('gps',gps); n = n + 1;

gps_logical = ones(size(gps,1),1);
jsonStrings{n} = micrographIOT_array2json('gps_logical',gps_logical); n = n + 1;

orderVector = 1:length(gps_logical);
jsonStrings{n} = micrographIOT_array2json('orderVector',orderVector); n = n + 1;

jsonStrings{n} = micrographIOT_cellStringArray2json('output_directory',strsplit(moviePath,filesep)); n = n + 1;

myI = imread(fullfile(moviePath,'RAW_DATA',smda.filename{1}));
myBinning = smda.binning(1);
jsonStrings{n} = micrographIOT_array2json('imageHeightNoBin',size(myI,1)*myBinning); n = n + 1;
jsonStrings{n} = micrographIOT_array2json('imageWidthNoBin',size(myI,2)*myBinning);  n = n + 1;

%%
% group
groupNum = transpose(unique(gps(:,1)));

jsonStrings{n} = micrographIOT_cellStringArray2json('group_function_after',repmat({'SuperMDAItineraryTimeFixed_group_function_after'},1,length(groupNum))); n = n + 1;
jsonStrings{n} = micrographIOT_cellStringArray2json('group_function_before',repmat({'SuperMDAItineraryTimeFixed_group_function_before'},1,length(groupNum))); n = n + 1;

group_label = repmat({'unknown'},1,max(groupNum));
for i = groupNum
    group_label{i} = smda.group_label{find(smda.group_number == i,1)};
end
jsonStrings{n} = micrographIOT_cellStringArray2json('group_label',group_label); n = n + 1;

group_logical = zeros(max(groupNum),1);
group_logical(groupNum) = 1;
jsonStrings{n} = micrographIOT_array2json('group_logical',group_logical); n = n + 1;
%%
% position
posNum = transpose(unique(gps(:,2)));

position_continuous_focus_offset = zeros(max(posNum),1);
for i = posNum
    position_continuous_focus_offset(i) = smda.continuous_focus_offset(find(smda.position_number == i,1));
end
jsonStrings{n} = micrographIOT_array2json('position_continuous_focus_offset',position_continuous_focus_offset); n = n + 1;

position_continuous_focus_bool = zeros(max(posNum),1);
for i = posNum
    position_continuous_focus_bool(i) = smda.continuous_focus_bool(find(smda.position_number == i,1));
end
jsonStrings{n} = micrographIOT_array2json('position_continuous_focus_bool',position_continuous_focus_bool); n = n + 1;
jsonStrings{n} = micrographIOT_cellStringArray2json('position_function_after',repmat({'SuperMDAItineraryTimeFixed_position_function_after'},1,length(posNum))); n = n + 1;
jsonStrings{n} = micrographIOT_cellStringArray2json('position_function_before',repmat({'SuperMDAItineraryTimeFixed_position_function_before'},1,length(posNum))); n = n + 1;

position_label = repmat({'unknown'},1,max(posNum));
for i = posNum
    position_label{i} = smda.position_label{find(smda.position_number == i,1)};
end
jsonStrings{n} = micrographIOT_cellStringArray2json('position_label',position_label); n = n + 1;

position_logical = zeros(max(posNum),1);
position_logical(posNum) = 1;
jsonStrings{n} = micrographIOT_array2json('position_logical',position_logical); n = n + 1;

position_xyz = zeros(max(posNum),3);
for i = posNum %loop 1
    indlp1 = find(smda.position_number == i,1);
    position_xyz(i,:) = [smda.x(indlp1),smda.y(indlp1),smda.z(indlp1)];
end
jsonStrings{n} = micrographIOT_2dmatrix2json('position_xyz',position_xyz); n = n + 1;
%%
% settings
setNum = transpose(unique(gps(:,3)));

settings_binning = zeros(max(setNum),1);
for i = setNum
    settings_binning(i) = smda.binning(find(smda.settings_number == i,1));
end
jsonStrings{n} = micrographIOT_array2json('settings_binning',settings_binning); n = n + 1;

settings_channel = zeros(max(setNum),1);
for i = setNum
    settings_channel(i) = smda.channel_number(find(smda.settings_number == i,1));
end
jsonStrings{n} = micrographIOT_array2json('settings_channel',settings_channel); n = n + 1;

settings_exposure = zeros(max(setNum),1);
for i = setNum
    settings_exposure(i) = smda.exposure(find(smda.settings_number == i,1));
end
jsonStrings{n} = micrographIOT_array2json('settings_exposure',settings_exposure); n = n + 1;
jsonStrings{n} = micrographIOT_cellStringArray2json('settings_function',repmat({'SuperMDAItineraryTimeFixed_settings_function'},1,length(setNum))); n = n + 1;

settings_logical = zeros(max(setNum),1);
settings_logical(setNum) = 1;
jsonStrings{n} = micrographIOT_array2json('settings_logical',settings_logical); n = n + 1;

settings_period_multiplier = ones(max(setNum),1);
jsonStrings{n} = micrographIOT_array2json('settings_period_multiplier',settings_period_multiplier); n = n + 1;

settings_timepoints = ones(max(setNum),1);
jsonStrings{n} = micrographIOT_array2json('settings_timepoints',settings_timepoints); n = n + 1;

settings_z_origin_offset = zeros(max(setNum),1);
jsonStrings{n} = micrographIOT_array2json('settings_z_origin_offset',settings_z_origin_offset); n = n + 1;

settings_z_stack_lower_offset = zeros(max(setNum),1);
jsonStrings{n} = micrographIOT_array2json('settings_z_stack_lower_offset',settings_z_stack_lower_offset); n = n + 1;

settings_z_stack_upper_offset = zeros(max(setNum),1);
jsonStrings{n} = micrographIOT_array2json('settings_z_stack_upper_offset',settings_z_stack_upper_offset); n = n + 1;

settings_z_step_size = ones(max(setNum),1)*0.3;
jsonStrings{n} = micrographIOT_array2json('settings_z_step_size',settings_z_step_size); n = n + 1;
%%
% navigation indices
ind_first_group = zeros(max(groupNum),1);
for i = groupNum
    ind_first_group(i) = find(gps(:,1) == i,1);
end
jsonStrings{n} = micrographIOT_array2json('ind_first_group',ind_first_group); n = n + 1;

ind_last_group = zeros(max(groupNum),1);
for i = groupNum
    ind_last_group(i) = find(gps(:,1) == i,1,'last');
end
jsonStrings{n} = micrographIOT_array2json('ind_last_group',ind_last_group); n = n + 1;
jsonStrings{n} = micrographIOT_array2json('ind_next_gps',size(gps,1)+1); n = n + 1;

ind_nextX = find(~group_logical,1);
if isempty(ind_nextX)
    ind_nextX = length(group_logical)+1;
end
jsonStrings{n} = micrographIOT_array2json('ind_next_group',ind_nextX); n = n + 1;

ind_nextX = find(~position_logical,1);
if isempty(ind_nextX)
    ind_nextX = length(position_logical)+1;
end
jsonStrings{n} = micrographIOT_array2json('ind_next_position',ind_nextX); n = n + 1;

ind_nextX = find(~settings_logical,1);
if isempty(ind_nextX)
    ind_nextX = length(settings_logical)+1;
end
jsonStrings{n} = micrographIOT_array2json('ind_next_settings',ind_nextX); n = n + 1;
%%
%
jsonStrings{n} = micrographIOT_array2json('duration',0); n = n + 1;
jsonStrings{n} = micrographIOT_array2json('fundamental_period',6000); n = n + 1;
jsonStrings{n} = micrographIOT_array2json('clock_relative',0); n = n + 1;
jsonStrings{n} = micrographIOT_array2json('number_of_timepoints',max(smda.timepoint));
%%
%
myjson = micrographIOT_jsonStrings2Object(jsonStrings);
fid = fopen(fullfile(moviePath,'smdaITF.txt'),'w');
if fid == -1
    error('smdaITF:badfile','Cannot open the file, preventing the export of the smdaITF.');
end
fprintf(fid,myjson);
fclose(fid);
%%
%
myjson = micrographIOT_autoIndentJson(fullfile(moviePath,'smdaITF.txt'));
fid = fopen(fullfile(moviePath,'smdaITF.txt'),'w');
if fid == -1
    error('smdaITF:badfile','Cannot open the file, preventing the export of the smdaITF.');
end
fprintf(fid,myjson);
fclose(fid);
end