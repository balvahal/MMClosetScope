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
end