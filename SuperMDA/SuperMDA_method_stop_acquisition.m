%%
%
function [smdaPilot] = SuperMDA_method_stop_acquisition(smdaPilot)
%%
%
if smdaPilot.running_bool
    smdaPilot.running_bool = false;
    smdaPilot.pause_bool = true;
    smdaPilot.runtime_timer.StopFcn = '';
    stop(smdaPilot.runtime_timer);
    stop(smdaPilot.wait_timer);
    handles = guidata(smdaPilot.gui_pause_stop_resume);
    set(handles.textTime,'String','No Acquisition');
    smdaPilot.pause_bool = false;
end