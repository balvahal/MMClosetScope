%%
%
function [smda] = super_mda_function_runtime_timer_stopfcn(~,~,smda)
if now < smda.mda_clock_absolute(smda.mda_clock_pointer)
    startat(smda.runtime_timer,smda.mda_clock_absolute(smda.mda_clock_pointer));
else
    start(smda.runtime_timer)
end