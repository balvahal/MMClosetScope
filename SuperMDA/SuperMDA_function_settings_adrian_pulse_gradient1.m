%%
%
function [smdaPilot] = SuperMDA_function_settings_adrian_pulse_gradient1(smdaPilot)

%% Set all microscope settings for the image acquisition
% Set the microscope settings according to the settings at this position
t = smdaPilot.t; %time
i = smdaPilot.gps_current(1); %group
j = smdaPilot.gps_current(2); %position
k = smdaPilot.gps_current(3); %settings
%%
%
if ismember(t,[2,4,103,151,199]) && k == 1
    if strcmp(smdaPilot.mm.computerName,'LAHAVSCOPE002')
        myChNum = 6;
        ShutterLabel = 'ShutterFluor';
    elseif strcmp(smdaPilot.mm.computerName,'KISHONYWAB111A')
        myChNum = 6;
        ShutterLabel = 'TIEpiShutter';
    end
    smdaPilot.mm.core.setConfig('Channel',smdaPilot.itinerary.channel_names{myChNum});
    smdaPilot.mm.core.waitForSystem();
    switch t
        case 2
            smdaPilot.mm.core.setShutterOpen(ShutterLabel,1);
            pause(20); % in seconds
            smdaPilot.mm.core.setShutterOpen(ShutterLabel,0);
        case 4
            smdaPilot.mm.core.setShutterOpen(ShutterLabel,1);
            pause(40); % in seconds
            smdaPilot.mm.core.setShutterOpen(ShutterLabel,0);
        case 103
            smdaPilot.mm.core.setShutterOpen(ShutterLabel,1);
            pause(60); % in seconds
            smdaPilot.mm.core.setShutterOpen(ShutterLabel,0);
        case 151
            smdaPilot.mm.core.setShutterOpen(ShutterLabel,1);
            pause(80); % in seconds
            smdaPilot.mm.core.setShutterOpen(ShutterLabel,0);
        case 199
            smdaPilot.mm.core.setShutterOpen(ShutterLabel,1);
            pause(100); % in seconds
            smdaPilot.mm.core.setShutterOpen(ShutterLabel,0);
    end
end
%% if the timepoints array states that no action should be taken then do
% do nothing and return to the execution loop
if mod((t-1),smdaPilot.itinerary.settings_period_multiplier(k)) ~= 0
    return
end
%%
% else continue with capturing of the image
smdaPilot.mm.core.setConfig('Channel',smdaPilot.itinerary.channel_names{smdaPilot.itinerary.settings_channel(k)});
smdaPilot.mm.core.setExposure(smdaPilot.mm.CameraDevice,smdaPilot.itinerary.settings_exposure(k));
if strcmp(smdaPilot.mm.computerName,'LAHAVSCOPE0001') %Closet Scope OR Curtain Scope
    switch smdaPilot.itinerary.settings_binning(k)
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
elseif strcmp(smdaPilot.mm.computerName,'KISHONYWAB111A')||strcmp(smdaPilot.mm.computerName,'LAHAVSCOPE002')
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
%% Jose's loop for a 2x2 grid
%
[grid] = super_mda_grid_maker(smdaPilot.mm,'centroid',smdaPilot.itinerary.position_xyz(j,:),'number_of_columns',2,'number_of_rows',2,'overlap',25);
%% Set PFS
%
for m=1:length(grid.positions)
    smdaPilot.mm.setXYZ(grid.positions(m,1:2));
    smdaPilot.mm.core.waitForDevice(smdaPilot.mm.xyStageDevice);
    smdaPilot.mm.getXYZ;
    %% Snap and Image
    %
    smdaPilot.snap;
    smdaPilot.itinerary.database_filenamePNG = sprintf('%s%s_s%d_w%d%s_t%d_z%d.tiff',smdaPilot.itinerary.group_label{i},strcat('_',smdaPilot.itinerary.position_label{j},sprintf('tile%d',m)),j,smdaPilot.itinerary.settings_channel(k),smdaPilot.itinerary.channel_names{smdaPilot.itinerary.settings_channel(k)},smdaPilot.t,1);
    %         fid =
    %         fopen(fullfile(smdaPilot.itinerary.png_path,smdaPilot.itinerary.database_filenamePNG),'w');
    %         fwrite(fid,smdaPilot.mm.I,'uint16'); fclose(fid);
    imwrite(smdaPilot.mm.I,fullfile(smdaPilot.itinerary.png_path,smdaPilot.itinerary.database_filenamePNG),'tiff');
    %% Update the database
    %
    smdaPilot.update_database;
end