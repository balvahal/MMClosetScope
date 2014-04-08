%%
%
function [smdaPilot] = SuperMDA_function_settings_basic(smdaPilot)


%% Set all microscope settings for the image acquisition
% Set the microscope settings according to the settings at this position
t = smdaPilot.runtime_index(1); %time
i = smdaPilot.runtime_index(2); %group
j = smdaPilot.runtime_index(3); %position
k = smdaPilot.runtime_index(4); %settings
%%
% if the timepoints array states that no action should be taken then do
% nothing and return to the execution loop
if smdaPilot.itinerary.group(i).position(j).settings(k).timepoints(smdaPilot.mda_clock_pointer) == false
    return
end
%%
% else continue with capturing of the image
smdaPilot.mm.core.setConfig('Channel',smdaPilot.itinerary.channel_names{smdaPilot.itinerary.group(i).position(j).settings(k).channel});
smdaPilot.mm.core.setExposure(smdaPilot.mm.CameraDevice,smdaPilot.itinerary.group(i).position(j).settings(k).exposure(t));
smdaPilot.mm.core.waitForSystem();
%% Check to make sure the directory tree exists to store image files
%
pngpath = fullfile(smdaPilot.itinerary.output_directory,'RAW_DATA');
if ~isdir(pngpath)
    mkdir(pngpath);
end
%% Set PFS
%
if strcmp(smdaPilot.mm.core.getProperty(smdaPilot.mm.AutoFocusStatusDevice,'State'),'On')
    %% For each z-position
    %
    for h = 1:length(smdaPilot.itinerary.group(i).position(j).settings(k).z_stack)
        smdaPilot.runtime_index(5) = h;
        %% Move the z-position
        %
        pos_z = smdaPilot.itinerary.group(i).position(j).settings(k).z_origin_offset + smdaPilot.itinerary.group(i).position(j).settings(k).z_stack(h)+smdaPilot.itinerary.group(i).position(j).continuous_focus_offset;
        smdaPilot.mm.core.setProperty(smdaPilot.mm.AutoFocusDevice,'Position',pos_z);
        %% Snap and Image
        %
        smdaPilot.snap;
        smdaPilot.itinerary.database_filenamePNG = sprintf('%s_s%d_w%d%s_t%d_z%d.png',smdaPilot.itinerary.group(i).label,j,smdaPilot.itinerary.group(i).position(j).settings(k).channel,smdaPilot.itinerary.channel_names{smdaPilot.itinerary.group(i).position(j).settings(k).channel},smdaPilot.runtime_index(1),smdaPilot.runtime_index(5));
        imwrite(smdaPilot.mm.I,fullfile(pngpath,smdaPilot.itinerary.database_filenamePNG),'png','bitdepth',16);
        %% Update the database
        %
        smdaPilot.update_database;
    end
else
    %% For each z-position
    %
    for h = 1:length(smdaPilot.itinerary.group(i).position(j).settings(k).z_stack)
        smdaPilot.runtime_index(5) = h;
        %% Move the z-position
        %
        pos_z = smdaPilot.itinerary.group(i).position(j).settings(k).z_origin_offset + smdaPilot.itinerary.group(i).position(j).settings(k).z_stack(h)+smdaPilot.itinerary.group(i).position(j).xyz(t,3);
        smdaPilot.mm.setXYZ(pos_z,'direction','z');
        smdaPilot.mm.core.waitForDevice(smdaPilot.mm.FocusDevice);
        %% Snap and Image
        %
        smdaPilot.snap;
        smdaPilot.itinerary.database_filenamePNG = sprintf('%s_s%d_w%d%s_t%d_z%d.png',smdaPilot.itinerary.group(i).label,j,smdaPilot.itinerary.group(i).position(j).settings(k).channel,smdaPilot.itinerary.channel_names{smdaPilot.itinerary.group(i).position(j).settings(k).channel},smdaPilot.runtime_index(1),smdaPilot.runtime_index(5));
        imwrite(smdaPilot.mm.I,fullfile(pngpath,smdaPilot.itinerary.database_filenamePNG),'png','bitdepth',16);
        %% Update the database
        %
        smdaPilot.update_database;
    end
end