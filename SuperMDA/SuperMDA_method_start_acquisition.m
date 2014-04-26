%%
%
function [obj] = SuperMDA_method_start_acquisition(obj)
%%
%
if ~obj.running_bool
    obj.itinerary.finalize_MDA;
    %% Estimate the total memory requirement
    % and verify enough room is on the hard drive (assuming the largest
    % images will be taken)
    obj.mm.core.setProperty(smdaPilot.mm.CameraDevice,'Binning','1x1');
    sizeOfBinaryImage = smdaPilot.mm.core.getImageWidth*smdaPilot.mm.core.getImageHeight*16/8; %16 for 16 bit image and 8 for 8 bits in a byte
    sizeOfAllImages = sizeOfBinaryImage*obj.itinerary.total_number_images; %in bytes
    disp(sizeOfAllImages);
    waitforbuttonpress;
    %%
    %
    obj.runtime_index = [1,1,1,1,1];
    obj.mda_clock_pointer = 1;
    %% Configure the absolute clock
    % Convert the MDA object unit of time (seconds) to the MATLAB unit of time
    % (days) for the serial date numbers, i.e. the number of days that have
    % passed since January 1, 0000.
    obj.mda_clock_absolute = now + obj.itinerary.mda_clock_relative/86400;
    obj.runtime_timer.StopFcn = {@SuperMDA_function_runtime_timer_stopfcn,obj};
    obj.running_bool = true;
    start(obj.wait_timer);
    obj.runtime_timer.StartDelay = 0; %this value must be reset after stopping it b/c it holds time left on timer.
    start(obj.runtime_timer);
end