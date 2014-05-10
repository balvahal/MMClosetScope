%%
%
function [smdaPilot] = SuperMDA_function_settings_basic(smdaPilot)


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
smdaPilot.mm.core.setProperty(smdaPilot.mm.CameraDevice,'Gain',smdaPilot.itinerary.group(i).position(j).settings(k).gain)
smdaPilot.mm.core.waitForSystem();
%% If there is no z-stack then just snap an image
%
if length(smdaPilot.itinerary.group(i).position(j).settings(k).z_stack) == 1
    %% Snap and Image
    %
    smdaPilot.snap;
    smdaPilot.itinerary.database_filenamePNG = sprintf('%s%s_s%d_w%d%s_t%d_z%d.png',smdaPilot.itinerary.group(i).label,strcat('_',smdaPilot.itinerary.group(i).position(j).label),j,smdaPilot.itinerary.group(i).position(j).settings(k).channel,smdaPilot.itinerary.channel_names{smdaPilot.itinerary.group(i).position(j).settings(k).channel},smdaPilot.runtime_index(1),smdaPilot.runtime_index(5));
    fid = fopen(fullfile(smdaPilot.itinerary.png_path,smdaPilot.itinerary.database_filenamePNG),'w');
    fwrite(fid,smdaPilot.mm.I,'uint16');
    fclose(fid);
    %imwrite(smdaPilot.mm.I,fullfile(smdaPilot.itinerary.png_path,smdaPilot.itinerary.database_filenamePNG),'png','bitdepth',16);
    %% Update the database
    %
    smdaPilot.update_database;
    return;
end
%% Set PFS for z-stacks
% There are three cases of PFS Status:
%
% * _Out of focus search range_
% * _Locked in focus_
% * _Within range of focus search_
if strcmp(smdaPilot.mm.core.getProperty(smdaPilot.mm.AutoFocusStatusDevice,'Status'),'Locked in focus')
    %% For each z-position use PFS offset
    %
    for h = 1:length(smdaPilot.itinerary.group(i).position(j).settings(k).z_stack)
        smdaPilot.runtime_index(5) = h;
        %% Move the z-position
        %
        pos_z = smdaPilot.itinerary.group(i).position(j).settings(k).z_origin_offset + smdaPilot.itinerary.group(i).position(j).settings(k).z_stack(h)+smdaPilot.itinerary.group(i).position(j).continuous_focus_offset;
        smdaPilot.mm.core.setProperty(smdaPilot.mm.AutoFocusDevice,'Position',pos_z);
        smdaPilot.mm.core.fullFocus();
        %% Snap and Image
        %
        smdaPilot.snap;
        smdaPilot.itinerary.database_filenamePNG = sprintf('%s%s_s%d_w%d%s_t%d_z%d.png',smdaPilot.itinerary.group(i).label,strcat('_',smdaPilot.itinerary.group(i).position(j).label),j,smdaPilot.itinerary.group(i).position(j).settings(k).channel,smdaPilot.itinerary.channel_names{smdaPilot.itinerary.group(i).position(j).settings(k).channel},smdaPilot.runtime_index(1),smdaPilot.runtime_index(5));
        imwrite(smdaPilot.mm.I,fullfile(smdaPilot.itinerary.png_path,smdaPilot.itinerary.database_filenamePNG),'png','bitdepth',16);
        %% Update the database
        %
        smdaPilot.update_database;
    end
elseif strcmp(smdaPilot.mm.core.getProperty(smdaPilot.mm.AutoFocusStatusDevice,'Status'),'Within range of focus search')
    %% For each z-position use PFS offset
    % but the PFS must be turned on first and then turned off to return the
    % PFS to the initial state
    smdaPilot.mm.core.setProperty(smdaPilot.mm.AutoFocusStatusDevice,'On');
    
    for h = 1:length(smdaPilot.itinerary.group(i).position(j).settings(k).z_stack)
        smdaPilot.runtime_index(5) = h;
        %% Move the z-position
        %
        pos_z = smdaPilot.itinerary.group(i).position(j).settings(k).z_origin_offset + smdaPilot.itinerary.group(i).position(j).settings(k).z_stack(h)+smdaPilot.itinerary.group(i).position(j).continuous_focus_offset;
        smdaPilot.mm.core.setProperty(smdaPilot.mm.AutoFocusDevice,'Position',pos_z);
        smdaPilot.mm.core.fullFocus();
        %% Snap and Image
        %
        smdaPilot.snap;
        smdaPilot.itinerary.database_filenamePNG = sprintf('%s%s_s%d_w%d%s_t%d_z%d.png',smdaPilot.itinerary.group(i).label,strcat('_',smdaPilot.itinerary.group(i).position(j).label),j,smdaPilot.itinerary.group(i).position(j).settings(k).channel,smdaPilot.itinerary.channel_names{smdaPilot.itinerary.group(i).position(j).settings(k).channel},smdaPilot.runtime_index(1),smdaPilot.runtime_index(5));
        imwrite(smdaPilot.mm.I,fullfile(smdaPilot.itinerary.png_path,smdaPilot.itinerary.database_filenamePNG),'png','bitdepth',16);
        %% Update the database
        %
        smdaPilot.update_database;
    end
    
    smdaPilot.mm.core.setProperty(smdaPilot.mm.AutoFocusStatusDevice,'Off');
else
    %% For each z-position use absolute z
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
        smdaPilot.itinerary.database_filenamePNG = sprintf('%s%s_s%d_w%d%s_t%d_z%d.png',smdaPilot.itinerary.group(i).label,strcat('_',smdaPilot.itinerary.group(i).position(j).label),j,smdaPilot.itinerary.group(i).position(j).settings(k).channel,smdaPilot.itinerary.channel_names{smdaPilot.itinerary.group(i).position(j).settings(k).channel},smdaPilot.runtime_index(1),smdaPilot.runtime_index(5));
        imwrite(smdaPilot.mm.I,fullfile(smdaPilot.itinerary.png_path,smdaPilot.itinerary.database_filenamePNG),'png','bitdepth',16);
        %% Update the database
        %
        smdaPilot.update_database;
    end
end