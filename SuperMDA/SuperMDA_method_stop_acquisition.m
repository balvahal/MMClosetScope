%%
%
function [obj] = SuperMDA_method_stop_acquisition(obj)
%%
%
if obj.running_bool
    obj.runtime_timer.StopFcn = '';
    stop(obj.runtime_timer);
    stop(obj.wait_timer);
    handles = guidata(obj.gui_pause_stop_resume);
    set(handles.textTime,'String','No Acquisition');
    obj.running_bool = false;
end