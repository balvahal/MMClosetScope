%%
%
function [smdaP] = SuperMDAPilot_method_startAcquisitionContinuousCapture(smdaP)
%%
%
if smdaP.running_bool
    display('SuperMDA is already running!');
    return
end

smdaP.itinerary.organize;
smdaP.itinerary.export;
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
% Convert the smdaP.itinerary.clock_relative unit of time (seconds) to
% the MATLAB unit of time (days) for the serial date numbers, i.e. the
% number of days that have passed since January 1, 0000.
smdaP.clock_absolute = now + smdaP.itinerary.clock_relative/86400;
smdaP.running_bool = true;
while now < smdaP.clock_absolute(end)
    tic
    smdaP.oneLoop
    smdaP.t = smdaP.t + 1;
    fprintf('Loop-');
    toc
    if smdaP.running_bool == false
        %%%
        % if acquisition was stopped during the loop
        smdaP.stop_acquisition;
        return
    end
end
smdaP.stop_acquisition;
end