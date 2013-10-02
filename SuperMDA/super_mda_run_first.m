%%
%
function mmhandle = super_mda_run_first(mmhandle)
%% Initialize the fundamental MDA
%

mmhandle.SuperMDA = SuperMDAGroup(mmhandle);
disp('hello');