%%
%
function [smdaP] = SuperMDAPilot_method_startAcquisitionContinuousCapture(smdaP)
%%
%
if ~smdaP.running_bool
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
    %% Configure the absolute clock
    % Convert the MDA smdaPect unit of time (seconds) to the MATLAB unit of time
    % (days) for the serial date numbers, i.e. the number of days that have
    % passed since January 1, 0000.
    smdaP.timer_runtime = timer('TimerFcn',@(~,~) smdaP.timerRuntimeFunContinuousCapture,'BusyMode','queue','Name','timer_runtime');
    smdaP.clock_absolute = now + smdaP.itinerary.clock_relative/86400;
    smdaP.timer_runtime.StopFcn = {@SuperMDAPilot_function_timerRuntimeStopFunContinuousCapture,smdaP};
    smdaP.running_bool = true;
    start(smdaP.timer_wait);
    smdaP.timer_runtime.StartDelay = 0; %this value must be reset after stopping it b/c it holds time left on timer.
    start(smdaP.timer_runtime);
end