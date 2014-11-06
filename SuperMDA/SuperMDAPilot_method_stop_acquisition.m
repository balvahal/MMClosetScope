%%
%
function [smdaP] = SuperMDAPilot_method_stop_acquisition(smdaP)
%%
%
if smdaP.running_bool
    smdaP.running_bool = false;
else
    smdaP.gps_previous = [0,0,0]; %reset the gps_previous pointer
    smdaP.timer_runtime.StopFcn = '';
    stop(smdaP.timer_runtime);
    %stop(smdaP.timer_wait);
    handles = guidata(smdaP.gui_pause_stop_resume);
    set(handles.textTime,'String','No Acquisition');
    smdaP.pause_bool = false;
    disp('All Done!')
end
end