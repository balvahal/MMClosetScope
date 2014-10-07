%%
%
function [smdaP] = SuperMDAPilot_method_stop_acquisition(smdaP)
%%
%
if smdaP.running_bool
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
    %%
    %
    smdaP.gps_previous = [0,0,0]; %reset the gps_previous pointer
    smdaP.running_bool = false;
    smdaP.pause_bool = true;
    smdaP.timer_runtime.StopFcn = '';
    stop(smdaP.timer_runtime);
    stop(smdaP.timer_wait);
    handles = guidata(smdaP.gui_pause_stop_resume);
    set(handles.textTime,'String','No Acquisition');
    smdaP.pause_bool = false;
    disp('All Done!')
end