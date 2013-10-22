%%
%
function [mmhandle] = super_mda_snap_function_basic(mmhandle,SuperMDA,i,j,k)
%% Set all microscope settings for the image acquisition
% Set the microscope settings according to the settings at this position
mmhandle.core.setConfig('Channel',mmhandle.Channels{SuperMDA.groups(i).positions(j).settings(k).Channel});
%% For each z-position
%
for h = 1:length(SuperMDA.groups(i).positions(j).settings(k).z_stack)
    %% Move the z-position
    %
    pos_z = SuperMDA.groups(i).positions(j).settings(k).z_origin_offset + SuperMDA.groups(i).positions(j).settings(k).z_stack(h);
    mmhandle = Core_general_setXYZ(mmhandle,pos_z,'direction','z');
    %% Snap and Image
    %
    mmhandle = Core_general_snapImage(mmhandle);
    pngpath = fullfile(SuperMDA.output_directory,SuperMDA.groups(i).label);
    filenamePNG = sprintf('%s_s%d_w%d%s_t%d_z%d.png',SuperMDA.group(i).label,j,SuperMDA.groups(i).positions(j).settings(k).Channel,mmhandle.Channel{SuperMDA.groups(i).positions(j).settings(k).Channel},SuperMDA.mda_clock_pointer,h);
    imwrite(mmhandle.I,fullfile(pngpath,filenamePNG),'png','bitdepth',16);
	%% Update the database
    %
end