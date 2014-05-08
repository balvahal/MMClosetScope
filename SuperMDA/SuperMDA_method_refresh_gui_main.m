%%
%
function smdaTA = SuperMDA_method_refresh_gui_main(smdaTA)
handles = guidata(smdaTA.gui_main);
%% Region 1
%
%% Time elements
%
set(handles.editFundamentalPeriod,'String',num2str(smdaTA.itinerary.fundamental_period/smdaTA.uot_conversion));
set(handles.editDuration,'String',num2str(smdaTA.itinerary.duration/smdaTA.uot_conversion));
set(handles.editNumberOfTimepoints,'String',num2str(smdaTA.itinerary.number_of_timepoints));
%% Output Directory
%
set(handles.editOutputDirectory,'String',smdaTA.itinerary.output_directory);
%% Region 2
%
%% Group Table
% Show the data in the itinerary |group_order| property
tableGroupData = cell(length(smdaTA.itinerary.group_order),...
    length(get(handles.tableGroup,'ColumnName')));
n=1;
for i = smdaTA.itinerary.group_order
        tableGroupData{n,1} = smdaTA.itinerary.group(i).label;
        tableGroupData{n,2} = i;
        tableGroupData{n,3} = length(smdaTA.itinerary.group(i).position_order);
        tableGroupData{n,4} = smdaTA.itinerary.group(i).group_function_before_name;
        tableGroupData{n,5} = smdaTA.itinerary.group(i).group_function_after_name;
        n = n + 1;
end
set(handles.tableGroup,'Data',tableGroupData);
%% Region 3
%
%% Position Table
% Show the data in the itinerary |position_order| property for a given
% group
gInd = smdaTA.pointerGroup(1);
tablePositionData = cell(length(smdaTA.itinerary.group(gInd).position_order),...
    length(get(handles.tablePosition,'ColumnName')));
n=1;
for i = smdaTA.itinerary.group(gInd).position_order
    tablePositionData{n,1} = smdaTA.itinerary.group(gInd).position(i).label;
    tablePositionData{n,2} = i;
    tablePositionData{n,3} = smdaTA.itinerary.group(gInd).position(i).xyz(1,1);
    tablePositionData{n,4} = smdaTA.itinerary.group(gInd).position(i).xyz(1,2);
    tablePositionData{n,5} = smdaTA.itinerary.group(gInd).position(i).xyz(1,3);
    if smdaTA.itinerary.group(gInd).position(i).continuous_focus_bool
        tablePositionData{n,6} = 'yes';
    else
        tablePositionData{n,6} = 'no';
    end
    tablePositionData{n,7} = smdaTA.itinerary.group(gInd).position(i).continuous_focus_offset;
    tablePositionData{n,8} = smdaTA.itinerary.group(gInd).position(i).position_function_before_name;
    tablePositionData{n,9} = smdaTA.itinerary.group(gInd).position(i).position_function_after_name;
    tablePositionData{n,10} = length(smdaTA.itinerary.group(gInd).position(i).settings);
    n = n + 1;
end
set(handles.tablePosition,'Data',tablePositionData);
%% Region 4
%
%% Settings Table
%
end