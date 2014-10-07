%%
%
function [smdaP] = SuperMDAPilot_method_stop_acquisition(smdaP)
%%
%
if smdaP.running_bool
    smdaP.running_bool = false;
end