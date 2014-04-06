%%
%
function [smdaPilot] = SuperMDA_method_wait(smdaPilot)
if smdaPilot.pause_bool
    %%
    % update the gui_pause_stop_resume
    handles_gui_pause_stop_resume = guidata(obj.gui_pause_stop_resume);
    set(handles_gui_pause_stop_resume.textTime,'String','PAUSED');
else
    time_difference = smdaPilot.mda_clock_absolute(smdaPilot.mda_clock_pointer) - now; %in MATLAB serial datenumber format
    mydatestr = datestr(time_difference,13);
    mystr = sprintf('HH:MM:SS\n%s',mydatestr);
    %%
    % update the gui_pause_stop_resume
    handles_gui_pause_stop_resume = guidata(obj.gui_pause_stop_resume);
    set(handles_gui_pause_stop_resume.textTime,'String',mystr);
end