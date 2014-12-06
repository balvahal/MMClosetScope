%%
%
function [smdaP] = SuperMDAPilot_method_startAcquisition(smdaP)
%%
%
if smdaP.running_bool
    display('SuperMDA is already running!');
    return
end
smdaP.itinerary.organize;
smdaP.itinerary.export; %save the itinerary for future reference
%% Establish folder tree that will store images
%
if ~isdir(smdaP.itinerary.output_directory)
    mkdir(smdaP.itinerary.output_directory);
end
smdaP.itinerary.png_path = fullfile(smdaP.itinerary.output_directory,'RAW_DATA');
if ~isdir(smdaP.itinerary.png_path)
    mkdir(smdaP.itinerary.png_path);
end
%%
% initialize key variables
smdaP.t = 1;
smdaP.runtime_imagecounter = 0;
smdaP.gps_previous = [0,0,0];
%% Configure the absolute clock
% Convert the MDA smdaPect unit of time (seconds) to the MATLAB unit of
% time (days) for the serial date numbers, i.e. the number of days that
% have passed since January 1, 0000.
smdaP.clock_absolute = now + smdaP.itinerary.clock_relative/86400;
smdaP.running_bool = true;
%% Looping
%
handles_gui_pause_stop_resume = guidata(smdaP.gui_pause_stop_resume);
if length(smdaP.itinerary.clock_relative) == 1
    %%%
    % only a single pass through the smda is required
    tic
    smdaP.oneLoop
    fprintf('Loop-');
    toc
else
    %%%
    % there is more than one time point to collect data
    while smdaP.t < length(smdaP.itinerary.clock_absolute)
        tic
        smdaP.oneLoop
        fprintf('Loop-');
        toc
        if smdaP.running_bool == false
            %%%
            % if acquisition was stopped during the loop
            smdaP.stop_acquisition;
            return
        end
        %%% Determine wait time for the next timepoint
        %
        if now < smdaP.itinerary.clock_absolute(smdaP.t)
            smdaP.t = smdaP.t+1;
        else
            smdaP.t = find(smdaP.itinerary.clock_absolute > now,1,'first');
            if isempty(smdaP.t)
                %%%
                % if the _finish_acq_ button was pressed then this is the
                % logical conclusion.
                smdaP.stop_acquisition
                return
            end
        end
        %%%
        % update the gui_pause_stop_resume
        while now < smdaP.itinerary.clock_absolute(smdaP.t)
            pause(1)
            myWait = smdaP.itinerary.clock_absolute(smdaP.t)-now;
            set(handles_gui_pause_stop_resume.textTime,'String',sprintf('HH:MM:SS\n%s',datestr(myWait,13)));
            if smdaP.running_bool == false
                %%%
                % if acquisition was stopped during the pause
                smdaP.stop_acquisition;
                return
            end
            while smdaP.pause_bool
                %%%
                % this loop is entered if the process is paused in the time
                % between acquisitions
                pause(1);
                if smdaP.itinerary.clock_absolute(smdaP.t) > now
                    %%%
                    % if the smda is still paused and a time to start a new
                    % acquisition passes, then that acquisition will be
                    % skipped.
                    smdaP.t = find(smdaP.itinerary.clock_absolute > now,1,'first');
                end
                set(handles_gui_pause_stop_resume.textTime,'String','PAUSED');
                if smdaP.running_bool == false
                    smdaP.stop_acquisition;
                    return;
                end
            end
        end
    end
    %%%
    % execute the last loop
    tic
    smdaP.oneLoop
    fprintf('Loop-');
    toc
end
smdaP.stop_acquisition;
end