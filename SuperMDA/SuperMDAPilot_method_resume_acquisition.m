%%
%
function [smdaPilot] = SuperMDAPilot_method_resume_acquisition(smdaPilot)
if smdaPilot.running_bool
    smdaPilot.pause_bool = false;
end