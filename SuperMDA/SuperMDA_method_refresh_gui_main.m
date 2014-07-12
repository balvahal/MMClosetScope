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
tableGroupData = cell(smdaTA.itinerary.numberOfGroup,...
    length(get(handles.tableGroup,'ColumnName')));
n=1;
for i = 1:smdaTA.itinerary.numberOfGroup
        tableGroupData{n,1} = smdaTA.itinerary.group_label{i};
        tableGroupData{n,2} = i;
        tableGroupData{n,3} = smdaTA.itinerary.numberOfPosition(i);
        tableGroupData{n,4} = smdaTA.itinerary.group_function_before{i};
        tableGroupData{n,5} = smdaTA.itinerary.group_function_after{i};
        n = n + 1;
end
set(handles.tableGroup,'Data',tableGroupData);
%% Region 3
%
%% Position Table
% Show the data in the itinerary |position_order| property for a given
% group
myGroupOrder = smdaTA.itinerary.orderOfGroup;
gInd = myGroupOrder(smdaTA.pointerGroup(1));
myPositionOrder = smdaTA.itinerary.orderOfPosition(gInd);
tablePositionData = cell(length(myPositionOrder),...
    length(get(handles.tablePosition,'ColumnName')));
n=1;
for i = myPositionOrder
    tablePositionData{n,1} = smdaTA.itinerary.position_label{i};
    tablePositionData{n,2} = i;
    tablePositionData{n,3} = smdaTA.itinerary.position_xyz(i,1);
    tablePositionData{n,4} = smdaTA.itinerary.position_xyz(i,2);
    tablePositionData{n,5} = smdaTA.itinerary.position_xyz(i,3);
    if smdaTA.itinerary.position_continuous_focus_bool(i)
        tablePositionData{n,6} = 'yes';
    else
        tablePositionData{n,6} = 'no';
    end
    tablePositionData{n,7} = smdaTA.itinerary.position_continuous_focus_offset(i);
    tablePositionData{n,8} = smdaTA.itinerary.position_function_before{i};
    tablePositionData{n,9} = smdaTA.itinerary.position_function_after{i};
    tablePositionData{n,10} = smdaTA.itinerary.numberOfSettings(gInd,i);
    n = n + 1;
end
set(handles.tablePosition,'Data',tablePositionData);
%% Region 4
%
%% Settings Table
% Show the prototype_settings
pInd = smdaTA.itinerary.indOfPosition(gInd);
pInd = pInd(1);
mySettingsOrder = smdaTA.itinerary.orderOfSettings(gInd,pInd);
tableSettingsData = cell(length(mySettingsOrder),...
    length(get(handles.tableSettings,'ColumnName')));
n=1;
for i = mySettingsOrder
    tableSettingsData{n,1} = smdaTA.mm.Channel{smdaTA.itinerary.settings_channel(i)};
    tableSettingsData{n,2} = smdaTA.itinerary.settings_exposure(i);
    tableSettingsData{n,3} = smdaTA.itinerary.settings_binning(i);
    tableSettingsData{n,4} = smdaTA.itinerary.settings_gain(i);
    tableSettingsData{n,5} = smdaTA.itinerary.settings_z_step_size(i);
    tableSettingsData{n,6} = smdaTA.itinerary.settings_z_stack_upper_offset(i);
    tableSettingsData{n,7} = smdaTA.itinerary.settings_z_stack_lower_offset(i);
    tableSettingsData{n,8} = length(smdaTA.itinerary.settings_z_stack_lower_offset(i)...
        :smdaTA.itinerary.settings_z_step_size(i)...
        :smdaTA.itinerary.settings_z_stack_upper_offset(i));
    tableSettingsData{n,9} = smdaTA.itinerary.settings_z_origin_offset(i);
    tableSettingsData{n,10} = smdaTA.itinerary.settings_period_multiplier(i);
    tableSettingsData{n,11} = smdaTA.itinerary.settings_function{i};
    tableSettingsData{n,12} = i;
    n = n + 1;
end
set(handles.tableSettings,'Data',tableSettingsData);
end