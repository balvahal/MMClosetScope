%%
%
function [smda] = super_mda_function_settings_jose_grid_2x2(smda)
%% Set all microscope settings for the image acquisition
% Set the microscope settings according to the settings at this position
t = smda.runtime_index(1); %time
i = smda.runtime_index(2); %group
j = smda.runtime_index(3); %position
k = smda.runtime_index(4); %settings
smda.mm.core.setConfig('Channel',smda.channel_names{smda.group(i).position(j).settings(k).channel});
smda.mm.core.setExposure(smda.mm.CameraDevice,smda.group(i).position(j).settings(k).exposure(t));
%% Check to make sure the directory tree exists to store image files
%
pngpath = fullfile(smda.output_directory,'RAW_DATA');
if ~isdir(pngpath)
    mkdir(pngpath);
end
%% Jose's loop for a 2x2 grid
%
[grid] = super_mda_grid_maker(smda.mm,'upper_left_corner',smda.group(i).position(j).xyz(t,:),'number_of_columns',2,'number_of_rows',2,'overlap',40);
%% Set PFS
%
for m=1:length(grid.positions)
    smda.mm.setXYZ(grid.positions(m,1:2));
    if strcmp(smda.mm.core.getProperty(smda.mm.AutoFocusStatusDevice,'State'),'On')
        %% For each z-position
        %
        for h = 1:length(smda.group(i).position(j).settings(k).z_stack)
            smda.runtime_index(5) = h;
            %% Move the z-position
            %
            pos_z = smda.group(i).position(j).settings(k).z_origin_offset + smda.group(i).position(j).settings(k).z_stack(h)+smda.group(i).position(j).continuous_focus_offset;
            smda.mm.core.setProperty(smda.mm.AutoFocusDevice,'Position',pos_z);
            %% Snap and Image
            %
            smda.mm = Core_general_snapImage(smda.mm);
            filenamePNG = sprintf('%s_s%d_w%d%s_t%d_z%d_%d.png',smda.group(i).label,j,smda.group(i).position(j).settings(k).channel,smda.channel_names{smda.group(i).position(j).settings(k).channel},smda.runtime_index(1),smda.runtime_index(5),m);
            imwrite(smda.mm.I,fullfile(pngpath,filenamePNG),'png','bitdepth',16);
            %% Update the database
            %
            image_description = '';
            smda.update_database(filenamePNG,image_description);
        end
    else
        %% For each z-position
        %
        for h = 1:length(smda.group(i).position(j).settings(k).z_stack)
            smda.runtime_index(5) = h;
            %% Move the z-position
            %
            pos_z = smda.group(i).position(j).settings(k).z_origin_offset + smda.group(i).position(j).settings(k).z_stack(h)+smda.group(i).position(j).xyz(t,3);
            smda.mm = Core_general_setXYZ(smda.mm,pos_z,'direction','z');
            %% Snap and Image
            %
            smda.mm = Core_general_snapImage(smda.mm);
            filenamePNG = sprintf('%s_s%d_w%d%s_t%d_z%d_%d.png',smda.group(i).label,j,smda.group(i).position(j).settings(k).channel,smda.channel_names{smda.group(i).position(j).settings(k).channel},smda.runtime_index(1),smda.runtime_index(5),m);
            imwrite(smda.mm.I,fullfile(pngpath,filenamePNG),'png','bitdepth',16);
            %% Update the database
            %
            image_description = '';
            smda.update_database(filenamePNG,image_description);
        end
    end
    writetable(smda.database,fullfile(smda.output_directory,'SuperMDA_database.txt'),'Delimiter','\t');
end