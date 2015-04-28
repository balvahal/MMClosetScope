%%
% does not act on any z-position information
function [smdaPilot] = SuperMDAItineraryTimeFixed_settings_function_minimal(smdaPilot)
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

%% Snap and Image
%
smdaPilot.database_z_number = 1;
smdaPilot.snap;
smdaPilot.itinerary.database_filenamePNG = sprintf('g%d_%s_s%d_%s_w%d_%s_t%d_z%d.tiff',i,smdaPilot.itinerary.group_label{i},j,strcat(smdaPilot.itinerary.position_label{j},''),k,smdaPilot.itinerary.channel_names{smdaPilot.itinerary.settings_channel(k)},smdaPilot.t,smdaPilot.database_z_number);
smdaPilot.mm.core.waitForSystem();
try
    imwrite(smdaPilot.mm.I,fullfile(smdaPilot.itinerary.png_path,smdaPilot.itinerary.database_filenamePNG),'tiff','Compression','none','WriteMode','overwrite');
catch
    if obj.twitterBool
        try
            obj.twitter.updateStatus(sprintf('Error in writing image to disk from the %s microscope.',obj.computerName));
        catch
            disp('Twitter Error!');
        end
    end
    smdaPilot.snap;
    smdaPilot.mm.core.waitForSystem();
    imwrite(smdaPilot.mm.I,fullfile(smdaPilot.itinerary.png_path,smdaPilot.itinerary.database_filenamePNG),'tiff','Compression','none','WriteMode','overwrite');
end
%% Update the database
%
smdaPilot.update_database;
smdaPilot.mm.core.waitForSystem();
end
