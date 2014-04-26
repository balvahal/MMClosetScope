%%
%
function [smdaPilot] = SuperMDA_method_start_acquisition(smdaPilot)
%%
%
if ~smdaPilot.running_bool
    smdaPilot.itinerary.finalize_MDA;
    %% Estimate the total memory requirement
    % and verify enough room is on the hard drive (assuming the largest
    % images will be taken)
    smdaPilot.mm.core.setProperty(smdaPilot.mm.CameraDevice,'Binning','1x1');
    sizeOfBinaryImage = smdaPilot.mm.core.getImageWidth*smdaPilot.mm.core.getImageHeight*16/8; %16 for 16 bit image and 8 for 8 bits in a byte
    sizeOfAllImages = sizeOfBinaryImage*smdaPilot.itinerary.total_number_images/1024/1024; %in megabytes
    str = sprintf('Images may take up to %0.6g MB of disk spaces.\nDo you want to proceed?',sizeOfAllImages);
    choice = questdlg(str,'Continue','Yes','No','No');
    switch choice
        case 'No'
            return
        case 'Yes'
            disp('all systems go');
        otherwise
            return
    end
    %%
    %
    smdaPilot.runtime_index = [1,1,1,1,1];
    smdaPilot.mda_clock_pointer = 1;
    %% Configure the absolute clock
    % Convert the MDA smdaPilotect unit of time (seconds) to the MATLAB unit of time
    % (days) for the serial date numbers, i.e. the number of days that have
    % passed since January 1, 0000.
    smdaPilot.mda_clock_absolute = now + smdaPilot.itinerary.mda_clock_relative/86400;
    smdaPilot.runtime_timer.StopFcn = {@SuperMDA_function_runtime_timer_stopfcn,smdaPilot};
    smdaPilot.running_bool = true;
    start(smdaPilot.wait_timer);
    smdaPilot.runtime_timer.StartDelay = 0; %this value must be reset after stopping it b/c it holds time left on timer.
    start(smdaPilot.runtime_timer);
end