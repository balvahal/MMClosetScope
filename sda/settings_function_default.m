%%
%
function [pilot] = settings_function_default(pilot)
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
pilot.microscope.binningfun(pilot.microscope,pilot.itinerary.settings_binning(k));
pilot.microscope.core.waitForSystem();
%% Z origin offset
%
currentZ = pilot.microscope.pos(3);
currentPFS = pilot.microscope.core.getProperty(pilot.microscope.AutoFocusDevice,'Position');
if pilot.itinerary.settings_z_origin_offset(k) ~= 0
    move_z(pilot.itinerary.settings_z_origin_offset(k));
end
%% Z stack (Y/N?)
%
currentZ = pilot.microscope.pos(3);
currentPFS = pilot.microscope.core.getProperty(pilot.microscope.AutoFocusDevice,'Position');
if pilot.itinerary.settings_z_stack_upper_offset(k) - pilot.itinerary.settings_z_stack_lower_offset(k) > 0
    z_stack = pilot.itinerary.settings_z_stack_lower_offset(k):pilot.itinerary.settings_z_step_size(k):pilot.itinerary.settings_z_stack_upper_offset(k);
    pilot.itinerary.settings_z_stack_upper_offset(k) = z_stack(end);
    for a = 1:length(z_stack)
        pilot.database_z_number = a;
        move_z(z_stack(a));
        pilot.snap;
        imagefilename = sprintf('g%d_%s_s%d_%s_w%d_%s_t%d_z%d.tiff',i,pilot.itinerary.group_label{i},j,pilot.itinerary.position_label{j},k,pilot.itinerary.channel_names{pilot.itinerary.settings_channel(k)},pilot.t,pilot.database_z_number);
        pilot.microscope.core.waitForSystem();
        try
            imwrite(pilot.microscope.I,fullfile(pilot.datapath,imagefilename),'tiff','Compression','none','WriteMode','overwrite');
        catch
            if obj.twitter.active
                    obj.twitter.update_status(sprintf('Error in writing image to disk from the %s microscope. %s',obj.computerName, datetime('now','Format','hh:mm:ss a')));                    
            end
            fprintf('Error in writing image to disk from the %s microscope. %s\n',obj.computerName, datetime('now','Format','hh:mm:ss a'));
            pilot.snap;
            pilot.microscope.core.waitForSystem();
            imwrite(pilot.microscope.I,fullfile(pilot.datapath,imagefilename),'tiff','Compression','none','WriteMode','overwrite');
        end
        %% Update the database
        %
        pilot.export_metadata(imagefilename);
        pilot.microscope.core.waitForSystem();
    end
else
    %% Snap and Image if there is no z-stack
    %
    pilot.database_z_number = 1;
    pilot.snap;
    imagefilename = sprintf('g%d_%s_s%d_%s_w%d_%s_t%d_z%d.tiff',i,pilot.itinerary.group_label{i},j,pilot.itinerary.position_label{j},k,pilot.itinerary.channel_names{pilot.itinerary.settings_channel(k)},pilot.t,pilot.database_z_number);
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
    pilot.export_metadata(imagefilename);
    pilot.microscope.core.waitForSystem();
end
%%
%
    function move_z(my_offset)
        if pilot.itinerary.position_continuous_focus_bool(j)
            pilot.microscope.core.setProperty(pilot.microscope.AutoFocusDevice,'Position',str2double(currentPFS) + my_offset);
            pilot.microscope.core.fullFocus(); % PFS will remain |ON|
        else
            %% PFS will not be utilized
            %
            pilot.microscope.setXYZ(currentZ + my_offset,'direction','z');
            pilot.microscope.core.waitForDevice(pilot.microscope.FocusDevice);
        end
    end
end