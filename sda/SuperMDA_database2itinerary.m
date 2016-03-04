%%
%
function [] = SuperMDA_database2itinerary(moviePath)
%%
% import the smda database
smda = readtable(fullfile(moviePath,'smda_database.txt'),'Delimiter','\t');
%%
%
channel_number = transpose(unique(smda.channel_number));
myexportStruct.channel_names = repmat({'unknown'},1,max(channel_number));
for i = channel_number
    myexportStruct.channel_names{i} = smda.channel_name{find(smda.channel_number == i,1)};
end

myexportStruct.gps = [smda.group_number,smda.position_number,smda.settings_number,smda.group_order,smda.position_order,smda.settings_order];
myexportStruct.gps = unique(myexportStruct.gps,'rows');
myexportStruct.gps = sortrows(myexportStruct.gps,[4,5,6]);
myexportStruct.gps = myexportStruct.gps(:,1:3);

myexportStruct.gps_logical = ones(size(myexportStruct.gps,1),1);

myexportStruct.orderVector = 1:length(myexportStruct.gps_logical);

myexportStruct.output_directory = strsplit(moviePath,filesep);

myI = imread(fullfile(moviePath,'RAW_DATA',smda.filename{1}));
myBinning = smda.binning(1);
myexportStruct.imageHeightNoBin = size(myI,1)*myBinning;
myexportStruct.imageWidthNoBin = size(myI,2)*myBinning;
%%
% group
groupNum = transpose(unique(myexportStruct.gps(:,1)));
myexportStruct.group_function_after = repmat({'SuperMDAItineraryTimeFixed_group_function_after'},1,length(groupNum));
myexportStruct.group_function_before = repmat({'SuperMDAItineraryTimeFixed_group_function_before'},1,length(groupNum));

myexportStruct.group_label = repmat({'unknown'},1,max(groupNum));
for i = groupNum
    myexportStruct.group_label{i} = smda.group_label{find(smda.group_number == i,1)};
end

myexportStruct.group_logical = zeros(max(groupNum),1);
myexportStruct.group_logical(groupNum) = 1;
%%
% position
posNum = transpose(unique(myexportStruct.gps(:,2)));

myexportStruct.position_continuous_focus_offset = zeros(max(posNum),1);
for i = posNum
    myexportStruct.position_continuous_focus_offset(i) = smda.continuous_focus_offset(find(smda.position_number == i,1));
end

myexportStruct.position_continuous_focus_bool = zeros(max(posNum),1);
for i = posNum
    myexportStruct.position_continuous_focus_bool(i) = smda.continuous_focus_bool(find(smda.position_number == i,1));
end

myexportStruct.position_function_after = repmat({'SuperMDAItineraryTimeFixed_position_function_after'},1,length(posNum));
myexportStruct.position_function_before = repmat({'SuperMDAItineraryTimeFixed_position_function_before'},1,length(posNum));


myexportStruct.position_label = repmat({'unknown'},1,max(posNum));
for i = posNum
    myexportStruct.position_label{i} = smda.position_label{find(smda.position_number == i,1)};
end

myexportStruct.position_logical = zeros(max(posNum),1);
myexportStruct.position_logical(posNum) = 1;

myexportStruct.position_xyz = zeros(max(posNum),3);
for i = posNum %loop 1
    indlp1 = find(smda.position_number == i,1);
    myexportStruct.position_xyz(i,:) = [smda.x(indlp1),smda.y(indlp1),smda.z(indlp1)];
end
%%
% settings
setNum = transpose(unique(myexportStruct.gps(:,3)));

myexportStruct.settings_binning = zeros(max(setNum),1);
for i = setNum
    myexportStruct.settings_binning(i) = smda.binning(find(smda.settings_number == i,1));
end

myexportStruct.settings_channel = zeros(max(setNum),1);
for i = setNum
    myexportStruct.settings_channel(i) = smda.channel_number(find(smda.settings_number == i,1));
end

myexportStruct.settings_exposure = zeros(max(setNum),1);
for i = setNum
    myexportStruct.settings_exposure(i) = smda.exposure(find(smda.settings_number == i,1));
end
myexportStruct.settings_function = repmat({'SuperMDAItineraryTimeFixed_settings_function'},1,length(setNum));

myexportStruct.settings_logical = zeros(max(setNum),1);
myexportStruct.settings_logical(setNum) = 1;

myexportStruct.settings_period_multiplier = ones(max(setNum),1);

myexportStruct.settings_timepoints = ones(max(setNum),1);

myexportStruct.settings_z_origin_offset = zeros(max(setNum),1);

myexportStruct.settings_z_stack_lower_offset = zeros(max(setNum),1);

myexportStruct.settings_z_stack_upper_offset = zeros(max(setNum),1);

myexportStruct.settings_z_step_size = ones(max(setNum),1)*0.3;
%%
% navigation indices
myexportStruct.ind_first_group = zeros(max(groupNum),1);
for i = groupNum
    myexportStruct.ind_first_group(i) = find(myexportStruct.gps(:,1) == i,1);
end

myexportStruct.ind_last_group = zeros(max(groupNum),1);
for i = groupNum
    myexportStruct.ind_last_group(i) = find(myexportStruct.gps(:,1) == i,1,'last');
end

myexportStruct.ind_next_gps = size(gps,1)+1;

myexportStruct.ind_nextX = find(~group_logical,1);
if isempty(myexportStruct.ind_nextX)
    myexportStruct.ind_nextX = length(group_logical)+1;
end

myexportStruct.ind_nextX = find(~position_logical,1);
if isempty(myexportStruct.ind_nextX)
    myexportStruct.ind_nextX = length(position_logical)+1;
end

myexportStruct.ind_nextX = find(~settings_logical,1);
if isempty(myexportStruct.ind_nextX)
    myexportStruct.ind_nextX = length(settings_logical)+1;
end
%%
%
myexportStruct.pointer_next_group = 0;
myexportStruct.pointer_next_position = 6000;
myexportStruct.pointer_next_settings = 0;
%%
%
myexportStruct.duration = 0;
myexportStruct.fundamental_period = 6000;
myexportStruct.clock_relative = 0;
myexportStruct.number_of_timepoints = max(smda.timepoint);
%%
%
Core_jsonparser.export_json(myexportStruct,fullfile(moviePath,'smdaITF.txt'));
end