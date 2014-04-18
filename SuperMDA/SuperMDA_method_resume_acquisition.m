%%
%
function [smdaPilot] = SuperMDA_method_resume_acquisition(smdaPilot)
if obj.running_bool
    %%
    % The operation of pause is different depending on whether or not the
    % runtime_timer is executing or not. If it is not, then the future
    % triggering should be prevented. If it is running then the operation
    % of the timer function should be paused. The execution can be paused
    % because it consists of exploring a large tree structure and code has
    % been added at each branch node to pause there if need be.
    smdaPilot.pause_bool = false;
    if strcmp(smdaPilot.runtime_timer.Running,'off')
        smdaPilot.mda_clock_pointer = find(smdaPilot.mda_clock_absolute > now,1,'first');
        smdaPilot.runtime_timer.StopFcn = {@SuperMDA_function_runtime_timer_stopfcn,smdaPilot};
        startat(smdaPilot.runtime_timer,smdaPilot.mda_clock_absolute(smdaPilot.mda_clock_pointer));
    else
        %%
        % update the gui_pause_stop_resume
        handles_gui_pause_stop_resume = guidata(smdaPilot.gui_pause_stop_resume);
        set(handles_gui_pause_stop_resume.textTime,'String','RUNNING');
    end
end