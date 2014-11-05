%%
%
function [smdaP] = SuperMDAPilot_function_timerWaitFun(smdaP)
if smdaP.pause_bool
    %%
    % update the gui_pause_stop_resume
    handles_gui_pause_stop_resume = guidata(smdaP.gui_pause_stop_resume);
    set(handles_gui_pause_stop_resume.textTime,'String','PAUSED');
elseif smdaP.t > smdaP.itinerary.number_of_timepoints
    %%
    % It appears this timer will trigger before the smda has time to finish
    % the last steps of operation. This else statement ensures the wait
    % timer does not prevent the runtime timer from concluding its final
    % steps of operation.
    return
else
    time_difference = smdaP.clock_absolute(smdaP.t) - now; %in MATLAB serial datenumber format
    mydatestr = datestr(time_difference,13);
    mystr = sprintf('HH:MM:SS\n%s',mydatestr);
    %%
    % update the gui_pause_stop_resume
    handles_gui_pause_stop_resume = guidata(smdaP.gui_pause_stop_resume);
    set(handles_gui_pause_stop_resume.textTime,'String',mystr);
end