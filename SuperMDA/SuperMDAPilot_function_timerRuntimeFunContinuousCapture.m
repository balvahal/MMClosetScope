%%
%
function smdaP = SuperMDAPilot_function_timerRuntimeFunContinuousCapture(smdaP)
%%
% update the gui_pause_stop_resume
handles_gui_pause_stop_resume = guidata(smdaP.gui_pause_stop_resume);
set(handles_gui_pause_stop_resume.textTime,'String','RUNNING');

%%
% loop through the multi-dimensional acquisition
tic
smdaP.oneLoop;

fprintf('Loop-');
toc
%%
% increase the time counter. the timer begins at 0, so the the first
% timepoint will be 1.
smdaP.t = smdaP.t + 1;
%%
% determine if this is the last loop through the MDA
if now > smdaP.clock_absolute(end)
    smdaP.stop_acquisition;
end
end