%%
%
function [smdaP] = SuperMDAPilot_method_stop_acquisition(smdaP)
%%
%
smdaP.running_bool = false;
smdaP.gps_previous = [0,0,0]; %reset the gps_previous pointer
handles = guidata(smdaP.gui_pause_stop_resume);
set(handles.textTime,'String','No Acquisition');
smdaP.pause_bool = false;
disp('All Done!')
end