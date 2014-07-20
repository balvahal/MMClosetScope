%%
%
function [smdaP] = SuperMDAPilot_function_timerRuntimeStopFun(~,~,smdaP)
if now < smdaP.clock_absolute(smdaP.t)
    startat(smdaP.timer_runtime,smdaP.clock_absolute(smdaP.t));
else
    smdaP.t = find(smdaP.mda_clock_absolute > now,1,'first') - 1;
    startat(smdaP.timer_runtime,smdaP.clock_absolute(smdaP.t));
end