%%
%
function [smdaPilot] = SuperMDA_function_runtime_timer_stopfcn(~,~,smdaPilot)
if now < smdaPilot.itinerary.mda_clock_absolute(smdaPilot.mda_clock_pointer)
    startat(smdaPilot.runtime_timer,smdaPilot.mda_clock_absolute(smdaPilot.mda_clock_pointer));
else
    smdaPilot.mda_clock_pointer = find(smdaPilot.mda_clock_absolute > now,1,'first');
    startat(smdaPilot.runtime_timer,smdaPilot.mda_clock_absolute(smdaPilot.mda_clock_pointer));
end