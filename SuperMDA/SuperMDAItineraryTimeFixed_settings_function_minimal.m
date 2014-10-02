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
if strcmp(smdaPilot.mm.computerName,'KISHONYWAB111A')||strcmp(smdaPilot.mm.computerName,'LAHAVSCOPE002')||strcmp(smdaPilot.mm.computerName,'LAHAVSCOPE0001')
    switch smdaPilot.itinerary.settings_binning(k)
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
smdaPilot.mm.core.setProperty(smdaPilot.mm.CameraDevice,'Gain',smdaPilot.itinerary.settings_gain(k))
smdaPilot.mm.core.waitForSystem();

%% Snap and Image
%
smdaPilot.database_z_number = 1;
smdaPilot.snap;
smdaPilot.itinerary.database_filenamePNG = sprintf('g%d_%s_s%d_%s_w%d_%s_t%d_z%d.tiff',i,smdaPilot.itinerary.group_label{i},j,strcat(smdaPilot.itinerary.position_label{j},''),smdaPilot.itinerary.settings_channel(k),smdaPilot.itinerary.channel_names{smdaPilot.itinerary.settings_channel(k)},smdaPilot.t,smdaPilot.database_z_number);
imwrite(smdaPilot.mm.I,fullfile(smdaPilot.itinerary.png_path,smdaPilot.itinerary.database_filenamePNG),'tiff');
%% Update the database
%
smdaPilot.update_database;
end
