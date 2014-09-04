%%
%
function [smdaPilot] = SuperMDAPilot_method_pause_acquisition(smdaPilot)
if smdaPilot.running_bool
    %%
    % The operation of pause is different depending on whether or not the
    % runtime_timer is executing or not. If it is not, then the future
    % triggering should be prevented. If it is running then the operation
    % of the timer function should be paused. The execution can be paused
    % because it consists of exploring a large tree structure and code has
    % been added at each branch node to pause there if need be.
    smdaPilot.pause_bool = true;
    if strcmp(smdaPilot.timer_runtime.Running,'off')
        smdaPilot.timer_runtime.StopFcn = '';
        stop(smdaPilot.runtime_timer);
    else
        %%
        % update the gui_pause_stop_resume
        handles_gui_pause_stop_resume = guidata(smdaPilot.gui_pause_stop_resume);
        set(handles_gui_pause_stop_resume.textTime,'String','PAUSED');
    end
end
