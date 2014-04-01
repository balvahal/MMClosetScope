%%
%
function [smdaPilot] = super_mda_function_runtime_timer_stopfcn(~,~,smdaPilot)
if now < smdaPilot.itinerary.mda_clock_absolute(smdaPilot.mda_clock_pointer)
    startat(smdaPilot.runtime_timer,smdaPilot.itinerary.mda_clock_absolute(smdaPilot.mda_clock_pointer));
else
    start(smdaPilot.runtime_timer)
end