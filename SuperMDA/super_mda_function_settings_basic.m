%%
%
function [mmhandle] = super_mda_function_settings_basic(mmhandle,SuperMDA)
%% Set all microscope settings for the image acquisition
% Set the microscope settings according to the settings at this position
t = SuperMDA.runtime_index(1);
i = SuperMDA.runtime_index(2);
j = SuperMDA.runtime_index(3);
k = SuperMDA.runtime_index(4);
mmhandle.core.setConfig('Channel',SuperMDA.channel_names{SuperMDA.group(i).position(j).settings(k).channel});
%% Check to make sure the directory tree exists to store image files
%
pngpath = fullfile(SuperMDA.output_directory,SuperMDA.group(i).label);
if ~isdir(pngpath)
    mkdir(pngpath);
end

%% For each z-position
%
for h = 1:length(SuperMDA.group(i).position(j).settings(k).z_stack)
    SuperMDA.runtime_index(5) = h;
    %% Move the z-position
    %
    pos_z = SuperMDA.group(i).position(j).settings(k).z_origin_offset + SuperMDA.group(i).position(j).settings(k).z_stack(h)+SuperMDA.group(i).position(j).xyz(t,3);
    mmhandle = Core_general_setXYZ(mmhandle,pos_z,'direction','z');
    %% Snap and Image
    %
    mmhandle = Core_general_snapImage(mmhandle);
    filenamePNG = sprintf('%s_s%d_w%d%s_t%d_z%d.png',SuperMDA.group(i).label,j,SuperMDA.group(i).position(j).settings(k).channel,SuperMDA.channel_names{SuperMDA.group(i).position(j).settings(k).channel},SuperMDA.runtime_index(1),SuperMDA.runtime_index(5));
    imwrite(mmhandle.I,fullfile(pngpath,filenamePNG),'png','bitdepth',16);
	%% Update the database
    %
    image_description = '';
    SuperMDA.update_database(filenamePNG,image_description);
    disp(filenamePNG);
end