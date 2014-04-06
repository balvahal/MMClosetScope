%%
%
function [obj] = SuperMDA_method_resume_acquisition(obj)
%%
% The operation of pause is different depending on whether or not the
% runtime_timer is executing or not. If it is not, then the future
% triggering should be prevented. If it is running then the operation of
% the timer function should be paused. The execution can be paused because
% it consists of exploring a large tree structure and code has been added
% at each branch node to pause there if need be.
obj.pause_bool = false;
if strcmp(obj.runtime_timer.Running,'off')
    obj.mda_clock_pointer = find(obj.mda_clock_absolute > now,1,'first');
    obj.runtime_timer.StopFcn = {@SuperMDA_function_runtime_timer_stopfcn,obj};
    startat(obj.runtime_timer,obj.mda_clock_absolute(obj.mda_clock_pointer));
end