%%
%
function [smdaP] = SuperMDA_method_stop_acquisition(smdaP)
%%
%
if smdaP.running_bool
    smdaP.running_bool = false;
    smdaP.pause_bool = true;
    smdaP.timer_runtime.StopFcn = '';
    stop(smdaP.timer_runtime);
    stop(smdaP.timer_wait);
    handles = guidata(smdaP.gui_pause_stop_resume);
    set(handles.textTime,'String','No Acquisition');
    smdaP.pause_bool = false;
    fclose(smdaP.databasefid);
    disp('All Done!')
end