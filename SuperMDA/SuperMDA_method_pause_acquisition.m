%%
%
function [obj] = SuperMDA_method_pause_acquisition(obj)
%%
% The operation of pause is different depending on whether or not the
% runtime_timer is executing or not. If it is not, then the future
% triggering should be prevented. If it is running then the operation of
% the timer function should be paused. The execution can be paused because
% it consists of exploring a large tree structure and code has been added
% at each branch node to pause there if need be.
obj.pause_bool = true;
if strcmp(obj.runtime_timer.Running,'off')
    obj.runtime_timer.StopFcn = '';
    stop(obj.runtime_timer);
end

