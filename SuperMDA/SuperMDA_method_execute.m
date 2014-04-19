%%
% The MDA tree is explored and executed a single time
function [smdaPilot] = SuperMDA_method_execute(smdaPilot)
%%
% update the gui_pause_stop_resume
handles_gui_pause_stop_resume = guidata(smdaPilot.gui_pause_stop_resume);
set(handles_gui_pause_stop_resume.textTime,'String','RUNNING');
%%
%
smdaPilot.runtime_index(1) = smdaPilot.mda_clock_pointer;
for i = smdaPilot.itinerary.group_order
    %%
    % detect pause event and refresh guis
    smdaPilot.runtime_index(2) = i;
    drawnow;
    while smdaPilot.pause_bool
        pause(1);
        disp('i am paused');
        if smdaPilot.running_bool == false
            return;
        end
    end
    %%
    % execute group_function_before
    smdaPilot.itinerary.group(i).group_function_before_handle(smdaPilot);
    for j = smdaPilot.itinerary.group(i).position_order
        tic
        %%
        % detect pause event and refresh guis
        smdaPilot.runtime_index(3) = j;
        drawnow;
        while smdaPilot.pause_bool
            pause(1);
            disp('i am paused');
            if smdaPilot.running_bool == false
                return;
            end
        end
        %%
        % execute position_function_before
        smdaPilot.itinerary.group(i).position(j).position_function_before_handle(smdaPilot);
        for k = smdaPilot.itinerary.group(i).position(j).settings_order
            %%
            % detect pause event and refresh guis
            smdaPilot.runtime_index(4) = k;
            drawnow;
            while smdaPilot.pause_bool
                pause(1);
                disp('i am paused');
                if smdaPilot.running_bool == false
                    return;
                end
            end
            %%
            % execute settings_function_before
            smdaPilot.itinerary.group(i).position(j).settings(k).settings_function_before_handle(smdaPilot);
            %%
            % Execute the function that will snap and save an image
            smdaPilot.itinerary.group(i).position(j).settings(k).settings_function_handle(smdaPilot);
            %%
            % execute settings_function_after
            smdaPilot.itinerary.group(i).position(j).settings(k).settings_function_after_handle(smdaPilot);
        end
        %%
        % execute position_function_after
        smdaPilot.itinerary.group(i).position(j).position_function_after_handle(smdaPilot);
        toc
    end
    %%
    % execute group_function_after
    smdaPilot.itinerary.group(i).group_function_after_handle(smdaPilot);
end
smdaPilot.mda_clock_pointer = smdaPilot.mda_clock_pointer + 1;
%% Determine if this loop through the MDA is the last
%
if smdaPilot.mda_clock_pointer > smdaPilot.itinerary.number_of_timepoints
    SuperMDAtable = cell2table(smdaPilot.itinerary.database,'VariableNames',{'channel_name','filename','group_label','position_label','binning','channel_number','continuous_focus_offset','continuous_focus_bool','exposure','group_number','group_order','matlab_serial_date_number','position_number','position_order','settings_number','settings_order','timepoint','x','y','z','z_order','image_description'});
    writetable(SuperMDAtable,fullfile(smdaPilot.itinerary.output_directory,'smda_database_redundant.txt'),'Delimiter','\t');
    smdaPilot.stop_acquisition;
end