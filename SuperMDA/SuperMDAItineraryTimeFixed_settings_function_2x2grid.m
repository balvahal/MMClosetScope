%%
%
function [smdaPilot] = SuperMDAItineraryTimeFixed_settings_function_2x2grid(smdaPilot)
%% Set all microscope settings for the image acquisition
% Set the microscope settings according to the settings at this position
t = smdaPilot.t; %time
i = smdaPilot.gps_current(1); %group
j = smdaPilot.gps_current(2); %position
k = smdaPilot.gps_current(3); %settings
%% if the timepoints array states that no action should be taken then do
% do nothing and return to the execution loop
if mod((t-1),smdaPilot.itinerary.settings_period_multiplier(k)) ~= 0
    return
end
%%
% else continue with capturing of the image
smdaPilot.mm.core.setConfig('Channel',smdaPilot.itinerary.channel_names{smdaPilot.itinerary.settings_channel(k)});
smdaPilot.mm.core.setExposure(smdaPilot.mm.CameraDevice,smdaPilot.itinerary.settings_exposure(k));
smdaPilot.mm.binningfun(mm,smdaPilot.itinerary.settings_binning(k));
smdaPilot.mm.core.waitForSystem();
%% Jose's loop for a 2x2 grid
%
[grid] = SuperMDA_grid_maker(smdaPilot.mm,'centroid',smdaPilot.itinerary.position_xyz(j,:),'number_of_columns',2,'number_of_rows',2,'overlap',0.05);
%% Set PFS
%
for m=1:length(grid.positions)
    smdaPilot.mm.setXYZ(grid.positions(m,1:2));
    smdaPilot.mm.core.waitForDevice(smdaPilot.mm.xyStageDevice);
    smdaPilot.mm.getXYZ;
    %% Snap and Image
    %
    smdaPilot.database_z_number = 1;
    smdaPilot.snap;
    smdaPilot.itinerary.database_filenamePNG = sprintf('g%d_%s_s%d_%s_w%d_%s_t%d_z%d.tiff',i,smdaPilot.itinerary.group_label{i},j,strcat(smdaPilot.itinerary.position_label{j},sprintf('tile%d',m)),k,smdaPilot.itinerary.channel_names{smdaPilot.itinerary.settings_channel(k)},smdaPilot.t,smdaPilot.database_z_number);
    %         fid =
    %         fopen(fullfile(smdaPilot.itinerary.png_path,smdaPilot.itinerary.database_filenamePNG),'w');
    %         fwrite(fid,smdaPilot.mm.I,'uint16'); fclose(fid);
    imwrite(smdaPilot.mm.I,fullfile(smdaPilot.itinerary.png_path,smdaPilot.itinerary.database_filenamePNG),'tiff');
    %% Update the database
    %
    smdaPilot.update_database;
    smdaPilot.mm.core.waitForSystem();
end