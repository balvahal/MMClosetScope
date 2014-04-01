%%
%
function [obj] = SuperMDA_method_pause_acquisition(obj)
%%
%
obj.pause_bool = true;
if strcmp(obj.runtime_timer.Running,'off')
    obj.runtime_timer.StopFcn = '';
    stop(obj.runtime_timer);
end
