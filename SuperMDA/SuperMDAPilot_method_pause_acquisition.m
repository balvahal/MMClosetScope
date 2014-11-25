%%
%
function [smdaPilot] = SuperMDAPilot_method_pause_acquisition(smdaPilot)
if smdaPilot.running_bool
    smdaPilot.pause_bool = true;
end
