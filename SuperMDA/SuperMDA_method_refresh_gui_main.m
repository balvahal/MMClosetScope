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
end