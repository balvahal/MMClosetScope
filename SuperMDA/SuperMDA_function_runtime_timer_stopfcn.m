%%
%
function [smdaP] = SuperMDA_function_runtime_timer_stopfcn(~,~,smdaP)
if now < smdaP.mda_clock_absolute(smdaP.mda_clock_pointer)
    startat(smdaP.runtime_timer,smdaP.mda_clock_absolute(smdaP.t + 1));
else
    smdaP.t = find(smdaP.mda_clock_absolute > now,1,'first') - 1;
    startat(smdaP.runtime_timer,smdaP.mda_clock_absolute(smdaP.t + 1));
end