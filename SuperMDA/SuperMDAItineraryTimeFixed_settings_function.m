%%
%
function [smdaPilot] = SuperMDAItineraryTimeFixed_settings_function(smdaPilot)
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
smdaPilot.mm.binningfun(smdaPilot.mm,smdaPilot.itinerary.settings_binning(k));
smdaPilot.mm.core.waitForSystem();
%% Z origin offset
%
currentZ = smdaPilot.mm.pos(3);
currentPFS = smdaPilot.mm.core.getProperty(smdaPilot.mm.AutoFocusDevice,'Position');
if smdaPilot.itinerary.settings_z_origin_offset(k) ~= 0
    move_z(smdaPilot.itinerary.settings_z_origin_offset(k));
end
%% Z stack (Y/N?)
%
currentZ = smdaPilot.mm.pos(3);
currentPFS = smdaPilot.mm.core.getProperty(smdaPilot.mm.AutoFocusDevice,'Position');
if smdaPilot.itinerary.settings_z_stack_upper_offset(k) - smdaPilot.itinerary.settings_z_stack_lower_offset(k) > 0
    z_stack = smdaPilot.itinerary.settings_z_stack_lower_offset(k):smdaPilot.itinerary.settings_z_step_size(k):smdaPilot.itinerary.settings_z_stack_upper_offset(k);
    smdaPilot.itinerary.settings_z_stack_upper_offset(k) = z_stack(end);
    for a = 1:length(z_stack)
        smdaPilot.database_z_number = a;
        move_z(z_stack(a));
        smdaPilot.snap;
        smdaPilot.itinerary.database_filenamePNG = sprintf('g%d_%s_s%d_%s_w%d_%s_t%d_z%d.tiff',i,smdaPilot.itinerary.group_label{i},j,strcat(smdaPilot.itinerary.position_label{j},''),k,smdaPilot.itinerary.channel_names{smdaPilot.itinerary.settings_channel(k)},smdaPilot.t,smdaPilot.database_z_number);
        smdaPilot.mm.core.waitForSystem();
        try
            imwrite(smdaPilot.mm.I,fullfile(smdaPilot.itinerary.png_path,smdaPilot.itinerary.database_filenamePNG),'tiff','Compression','none','WriteMode','overwrite');
        catch
            if obj.twitter.active
                    obj.twitter.update_status(sprintf('Error in writing image to disk from the %s microscope.',obj.computerName));
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
else
    %% Snap and Image if there is no z-stack
    %
    smdaPilot.database_z_number = 1;
    smdaPilot.snap;
    smdaPilot.itinerary.database_filenamePNG = sprintf('g%d_%s_s%d_%s_w%d_%s_t%d_z%d.tiff',i,smdaPilot.itinerary.group_label{i},j,strcat(smdaPilot.itinerary.position_label{j},''),k,smdaPilot.itinerary.channel_names{smdaPilot.itinerary.settings_channel(k)},smdaPilot.t,smdaPilot.database_z_number);
    smdaPilot.mm.core.waitForSystem();
    try
        imwrite(smdaPilot.mm.I,fullfile(smdaPilot.itinerary.png_path,smdaPilot.itinerary.database_filenamePNG),'tiff','Compression','none','WriteMode','overwrite');
    catch
        if obj.twitter.active
                obj.twitter.update_status(sprintf('Error in writing image to disk from the %s microscope.',obj.computerName));
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
%%
%
    function move_z(my_offset)
        if smdaPilot.itinerary.position_continuous_focus_bool(j)
            smdaPilot.mm.core.setProperty(smdaPilot.mm.AutoFocusDevice,'Position',str2double(currentPFS) + my_offset);
            smdaPilot.mm.core.fullFocus(); % PFS will remain |ON|
        else
            %% PFS will not be utilized
            %
            smdaPilot.mm.setXYZ(currentZ + my_offset,'direction','z');
            smdaPilot.mm.core.waitForDevice(smdaPilot.mm.FocusDevice);
        end
    end
end