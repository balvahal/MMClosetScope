%%
%
function super_mda_snap_basic(mmhandle,settings,group)
%% Set all microscope settings for the image acquisition
% Set the microscope settings according to the settings at this position
mmhandle.core.setConfig('Channel',mmhandle.Channels{settings.wavelength});