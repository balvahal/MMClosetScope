%%
%
function [smdaP] = SuperMDAPilot_function_timerRuntimeStopFunContinuousCapture(~,~,smdaP)
if now < smdaP.clock_absolute(end)
    start(smdaP.timer_runtime);
end