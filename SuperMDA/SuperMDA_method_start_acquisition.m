%%
%
function [obj] = SuperMDA_method_start_acquisition(obj)
%%
%
obj.itinerary.finalize_MDA;
obj.runtime_index = [1,1,1,1,1];
obj.mda_clock_pointer = 1;
%% Configure the absolute clock
% Convert the MDA object unit of time (seconds) to the MATLAB unit of time
% (days) for the serial date numbers, i.e. the number of days that have
% passed since January 1, 0000.
obj.itinerary.mda_clock_absolute = now + obj.itinerary.mda_clock_relative/86400;
obj.runtime_timer.StopFcn = {@super_mda_function_runtime_timer_stopfcn,obj};
start(obj.runtime_timer);
%%
%
while obj.runtime_timer <= obj.itinerary.number_of_timepoints
    
    if obj.pause_bool
        continue
    end
    
end

function runtime_timer2_fcn(obj)

end