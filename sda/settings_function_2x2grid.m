%%
%
function [pilot] = settings_function_2x2grid(pilot)
%% Set all microscope settings for the image acquisition
% Set the microscope settings according to the settings at this position
t = pilot.t; %time
i = pilot.gps_current(1); %group
j = pilot.gps_current(2); %position
k = pilot.gps_current(3); %settings
%% if the timepoints array states that no action should be taken then do
% do nothing and return to the execution loop
if mod((t-1),pilot.itinerary.settings_period_multiplier(k)) ~= 0
    return
end
if ~pilot.itinerary.settings_timepoints(k,t)
    return
end
%%
% else continue with capturing of the image
pilot.microscope.core.setConfig('Channel',pilot.itinerary.channel_names{pilot.itinerary.settings_channel(k)});
pilot.microscope.core.setExposure(pilot.microscope.CameraDevice,pilot.itinerary.settings_exposure(k));
pilot.microscope.binningfun(mm,pilot.itinerary.settings_binning(k));
pilot.microscope.core.waitForSystem();
%% Jose's loop for a 2x2 grid
%
[grid] = SuperMDA_grid_maker(pilot.microscope,'centroid',pilot.itinerary.position_xyz(j,:),'number_of_columns',2,'number_of_rows',2,'overlap',0.05);
%% Set PFS
%
for m=1:length(grid.positions)
    pilot.microscope.setXYZ(grid.positions(m,1:2));
    pilot.microscope.core.waitForDevice(pilot.microscope.xyStageDevice);
    pilot.microscope.getXYZ;
    %% Snap and Image
    %
    pilot.database_z_number = 1;
    pilot.snap;
    imagefilename = sprintf('g%d_%s_s%d_%s_w%d_%s_t%d_z%d.tiff',i,pilot.itinerary.group_label{i},j,strcat(pilot.itinerary.position_label{j},sprintf('tile%d',m)),k,pilot.itinerary.channel_names{pilot.itinerary.settings_channel(k)},pilot.t,pilot.database_z_number);
    %         fid =
    %         fopen(fullfile(pilot.datapath,imagefilename),'w');
    %         fwrite(fid,pilot.microscope.I,'uint16'); fclose(fid);
    pilot.microscope.core.waitForSystem();
    try
        imwrite(pilot.microscope.I,fullfile(pilot.datapath,imagefilename),'tiff','Compression','none','WriteMode','overwrite');
    catch
        if obj.twitter.active
                obj.twitter.update_status(sprintf('Error in writing image to disk from the %s microscope. %s',obj.computerName, datetime('now','Format','hh:mm:ss a')));                
        end
        fprintf('Error in writing image to disk from the %s microscope. %s',obj.computerName, datetime('now','Format','hh:mm:ss a'));
        pilot.snap;
        pilot.microscope.core.waitForSystem();
        imwrite(pilot.microscope.I,fullfile(pilot.datapath,imagefilename),'tiff','Compression','none','WriteMode','overwrite');
    end
    %% Update the database
    %
    pilot.update_database;
    pilot.microscope.core.waitForSystem();
end