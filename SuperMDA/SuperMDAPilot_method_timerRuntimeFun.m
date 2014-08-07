%%
%
function smdaP = SuperMDAPilot_method_timerRuntimeFun(smdaP)
%%
% update the gui_pause_stop_resume
handles_gui_pause_stop_resume = guidata(smdaP.gui_pause_stop_resume);
set(handles_gui_pause_stop_resume.textTime,'String','RUNNING');

%%
% loop through the multi-dimensional acquisition
tic
smdaP.oneLoop;
%% 
% Write the database to a text file
T = cell2table(smdaP.database(1:smdaP.runtime_imagecounter,:),...
    'VariableNames',{'channel_name','filename','group_label',...
    'position_label','binning','channel_number',...
    'continuous_focus_offset','continuous_focus_bool','exposure',...
    'group_number','group_order','matlab_serial_date_number',...
    'position_number','position_order','settings_number',...
    'settings_order','timepoint','x','y','z','z_order',...
    'image_description'});
smdaP.databasefilename = fullfile(smdaP.itinerary.output_directory,'smda_database.txt');
writetable(T,smdaP.databasefilename,'Delimiter','tab');
fprintf('Loop-');
toc
%%
% increase the time counter. the timer begins at 0, so the the first
% timepoint will be 1.
smdaP.t = smdaP.t + 1;
%%
% determine if this is the last loop through the MDA
if smdaP.t == smdaP.itinerary.number_of_timepoints + 1
    smdaP.stop_acquisition;
end
end