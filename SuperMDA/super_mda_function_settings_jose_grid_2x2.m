%%
%
function [smdaPilot] = super_mda_function_settings_jose_grid_2x2(smdaPilot)

%% Set all microscope settings for the image acquisition
% Set the microscope settings according to the settings at this position
t = smdaPilot.runtime_index(1); %time
i = smdaPilot.runtime_index(2); %group
j = smdaPilot.runtime_index(3); %position
k = smdaPilot.runtime_index(4); %settings
%% if the timepoints array states that no action should be taken then do
% do nothing and return to the execution loop
if smdaPilot.itinerary.group(i).position(j).settings(k).timepoints(smdaPilot.mda_clock_pointer) == false
    return
end
%%
% else continue with capturing of the image
smdaPilot.mm.core.setConfig('Channel',smdaPilot.itinerary.channel_names{smdaPilot.itinerary.group(i).position(j).settings(k).channel});
smdaPilot.mm.core.setExposure(smdaPilot.mm.CameraDevice,smdaPilot.itinerary.group(i).position(j).settings(k).exposure(t));
if strcmp(smdaPilot.mm.computerName,'LB89-6A-45FA') %Closet Scope
    switch smdaPilot.itinerary.group(i).position(j).settings(k).binning
        case 1
            smdaPilot.mm.core.setProperty(smdaPilot.mm.CameraDevice,'Binning','1');
        case 2
            smdaPilot.mm.core.setProperty(smdaPilot.mm.CameraDevice,'Binning','2');
        case 3
            smdaPilot.mm.core.setProperty(smdaPilot.mm.CameraDevice,'Binning','3');
        case 4
            smdaPilot.mm.core.setProperty(smdaPilot.mm.CameraDevice,'Binning','4');
        otherwise
            smdaPilot.mm.core.setProperty(smdaPilot.mm.CameraDevice,'Binning','1');
    end
elseif strcmp(smdaPilot.mm.computerName,'KISHONYWAB111A')
    switch smdaPilot.itinerary.group(i).position(j).settings(k).binning
        case 1
            smdaPilot.mm.core.setProperty(smdaPilot.mm.CameraDevice,'Binning','1x1');
        case 2
            smdaPilot.mm.core.setProperty(smdaPilot.mm.CameraDevice,'Binning','2x2');
        case 3
            smdaPilot.mm.core.setProperty(smdaPilot.mm.CameraDevice,'Binning','3x3');
        case 4
            smdaPilot.mm.core.setProperty(smdaPilot.mm.CameraDevice,'Binning','4x4');
        otherwise
            smdaPilot.mm.core.setProperty(smdaPilot.mm.CameraDevice,'Binning','1x1');
    end
end
smdaPilot.mm.core.setProperty(smdaPilot.mm.CameraDevice,'Gain',smdaPilot.itinerary.group(i).position(j).settings(k).gain)
smdaPilot.mm.core.waitForSystem();
%% Jose's loop for a 2x2 grid
%
[grid] = super_mda_grid_maker(smdaPilot.mm,'upper_left_corner',smdaPilot.itinerary.group(i).position(j).xyz(t,:),'number_of_columns',2,'number_of_rows',2,'overlap',0);
%% Set PFS
%
for m=1:length(grid.positions)
    smdaPilot.mm.setXYZ(grid.positions(m,1:2));
    smdaPilot.mm.core.waitForDevice(smdaPilot.mm.xyStageDevice);
    smdaPilot.mm.getXYZ;
    %% Snap and Image
    %
    smdaPilot.snap;
    smdaPilot.itinerary.database_filenamePNG = sprintf('%s%s_s%d_w%d%s_t%d_z%d.tiff',smdaPilot.itinerary.group(i).label,strcat('_',smdaPilot.itinerary.group(i).position(j).label,sprintf('tile%d',m)),j,smdaPilot.itinerary.group(i).position(j).settings(k).channel,smdaPilot.itinerary.channel_names{smdaPilot.itinerary.group(i).position(j).settings(k).channel},smdaPilot.runtime_index(1),smdaPilot.runtime_index(5));
    %         fid =
    %         fopen(fullfile(smdaPilot.itinerary.png_path,smdaPilot.itinerary.database_filenamePNG),'w');
    %         fwrite(fid,smdaPilot.mm.I,'uint16'); fclose(fid);
    imwrite(smdaPilot.mm.I,fullfile(smdaPilot.itinerary.png_path,smdaPilot.itinerary.database_filenamePNG),'tiff');
    %% Update the database
    %
    smdaPilot.update_database;
end