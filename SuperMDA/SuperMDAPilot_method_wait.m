%%
%
function [smdaP] = SuperMDAPilot_method_wait(smdaP)
if smdaP.pause_bool
    %%
    % update the gui_pause_stop_resume
    handles_gui_pause_stop_resume = guidata(smdaP.gui_pause_stop_resume);
    set(handles_gui_pause_stop_resume.textTime,'String','PAUSED');
else
    time_difference = smdaP.clock_absolute(smdaP.t) - now; %in MATLAB serial datenumber format
    mydatestr = datestr(time_difference,13);
    mystr = sprintf('HH:MM:SS\n%s',mydatestr);
    %%
    % update the gui_pause_stop_resume
    handles_gui_pause_stop_resume = guidata(smdaP.gui_pause_stop_resume);
    set(handles_gui_pause_stop_resume.textTime,'String',mystr);
end