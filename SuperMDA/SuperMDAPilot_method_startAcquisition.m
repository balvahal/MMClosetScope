%%
%
function [smdaP] = SuperMDAPilot_method_startAcquisition(smdaP)
%%
%
if ~smdaP.running_bool
    %% Establish folder tree that will store images
    %
    if ~isdir(obj.output_directory)
        mkdir(obj.output_directory);
    end
    obj.png_path = fullfile(obj.output_directory,'RAW_DATA');
    if ~isdir(obj.png_path)
        mkdir(obj.png_path);
    end
    %%
    % initialize key variables
    smdaP.t = 0;
    %% Configure the absolute clock
    % Convert the MDA smdaPect unit of time (seconds) to the MATLAB unit of time
    % (days) for the serial date numbers, i.e. the number of days that have
    % passed since January 1, 0000.
    smdaP.clock_absolute = now + smdaP.itinerary.clock_relative/86400;
    smdaP.runtime_timer.StopFcn = {@SuperMDAPilot_function_timerRuntimeStopFun,smdaP};
    smdaP.running_bool = true;
    start(smdaP.wait_timer);
    smdaP.runtime_timer.StartDelay = 0; %this value must be reset after stopping it b/c it holds time left on timer.
    start(smdaP.runtime_timer);
end