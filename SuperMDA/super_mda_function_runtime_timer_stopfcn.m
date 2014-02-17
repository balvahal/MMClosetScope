%%
%
function [smda] = super_mda_function_runtime_timer_stopfcn(smda)
startat(smda.runtime_timer,smda.mda_clock_absolute(smda.mda_clock_pointer));