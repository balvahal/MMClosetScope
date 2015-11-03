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
%% Z origin offset
%
currentZ = smdaPilot.mm.pos(3);
currentPFS = smdaPilot.mm.core.getProperty(smdaPilot.mm.AutoFocusDevice,'Position');
if smdaPilot.itinerary.settings_z_origin_offset(k) ~= 0
    move_z(smdaPilot.itinerary.settings_z_origin_offset(k));
end
%% Adrian's loop for a 3x3 grid with z-stack
%
[grid] = SuperMDA_grid_maker(smdaPilot.mm,'centroid',smdaPilot.itinerary.position_xyz(j,:),'number_of_columns',3,'number_of_rows',3,'overlap',0.15);
%% Set PFS
%
for m=1:length(grid.positions)
    smdaPilot.mm.setXYZ(grid.positions(m,1:2));
    smdaPilot.mm.core.waitForDevice(smdaPilot.mm.xyStageDevice);
    smdaPilot.mm.getXYZ;
    %% Snap and Image
    %
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
        end
        %% Update the database
        %
        smdaPilot.update_database;
        smdaPilot.mm.core.waitForSystem();
    else
        smdaPilot.database_z_number = 1;
        smdaPilot.snap;
        smdaPilot.itinerary.database_filenamePNG = sprintf('g%d_%s_s%d_%s_w%d_%s_t%d_z%d.tiff',i,smdaPilot.itinerary.group_label{i},j,strcat(smdaPilot.itinerary.position_label{j},sprintf('tile%d',m)),k,smdaPilot.itinerary.channel_names{smdaPilot.itinerary.settings_channel(k)},smdaPilot.t,smdaPilot.database_z_number);
        %         fid =
        %         fopen(fullfile(smdaPilot.itinerary.png_path,smdaPilot.itinerary.database_filenamePNG),'w');
        %         fwrite(fid,smdaPilot.mm.I,'uint16'); fclose(fid);
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