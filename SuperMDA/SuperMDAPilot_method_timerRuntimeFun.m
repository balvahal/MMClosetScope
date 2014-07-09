%%
%
function smdaP = SuperMDAPilot_method_timerRuntimeFun(smdaP)
%%
% update the gui_pause_stop_resume
handles_gui_pause_stop_resume = guidata(smdaPilot.gui_pause_stop_resume);
set(handles_gui_pause_stop_resume.textTime,'String','RUNNING');
%%
% increase the time counter. the timer begins at 0, so the the first
% timepoint will be 1.
smdaP.t = smdaP.t + 1;
%%
% loop through the multi-dimensional acquisition
smdaP.oneLoop;
%%
% determine if this is the last loop through the MDA
if smdaP.t == smdaP.itinerary.number_of_timepoints
    smdaP.stop_acquisition;
end
end