%%
% This function was designed to be called from within a *settings
% function*.
function [smdaP] = SuperMDAPilot_method_update_database(smdaP)
%% update the internal smdaPect database
%
t = smdaP.t; %time
g = smdaP.gps_current(1); %group
p = smdaP.gps_current(2); %position
s = smdaP.gps_current(3); %settings
z = smdaP.database_z_number;
smdaP.mm.getXYZ;
myGroupOrder = smdaP.itinerary.orderOfGroup;
myPositionOrder = smdaP.itinerary.orderOfPosition(g);
mySettingsOrder = smdaP.itinerary.orderOfSettings(g,p);
varNames = {'channel_name',...
    'filename',...
    'group_label',...
    'position_label',...
    'binning',...
    'channel_number',...
    'continuous_focus_offset',...
    'continuous_focus_bool',...
    'exposure',...
    'group_number',...
    'group_order',...
    'matlab_serial_date_number',...
    'position_number',...
    'position_order',...
    'settings_number',...
    'settings_order',...
    'timepoint',...
    'x',...
    'y',...
    'z',...
    'z_order',...
    'image_description'};
myNewDatabaseRow = {...
    smdaP.itinerary.channel_names{smdaP.itinerary.settings_channel(s)},... %channel_name
    smdaP.itinerary.database_filenamePNG,... %filename
    smdaP.itinerary.group_label{g},... %group_label
    smdaP.itinerary.position_label{p},... %position_label
    smdaP.itinerary.settings_binning(s),... %binning
    smdaP.itinerary.settings_channel(s),... %channel_number
    smdaP.itinerary.position_continuous_focus_offset(p),... %continuous_focus_offset
    smdaP.itinerary.position_continuous_focus_bool(p),... %continuous_focus_bool
    smdaP.itinerary.settings_exposure(s),... %exposure
    g,... %group_number
    find(myGroupOrder == g,1,'first'),... %group_order
    now,... %matlab_serial_date_number
    p,... %position_number
    find(myPositionOrder == p,1,'first'),... %position_order,
    s,... %settings_number
    find(mySettingsOrder == s,1,'first'),... %settings_order
    t,... %timepoint
    smdaP.mm.pos(1),...%smdaP.itinerary.group(g).position(p).xyz(t,1),... %x
    smdaP.mm.pos(2),...%smdaP.itinerary.group(g).position(p).xyz(t,2),... %y
    smdaP.mm.pos(3),...%     smdaP.itinerary.group(g).position(p).settings(s).z_origin_offset + ...%     smdaP.itinerary.group(g).position(p).settings(s).z_stack(z) + ...%     smdaP.itinerary.group(g).position(p).xyz(t,3),... %z
    z,... %the order of zstack from bottom to top
    smdaP.database_imagedescription}; %image_description
%%
%
metadataFilename = sprintf('g%d_s%d_w%d_t%d_z%d.txt',g,p,s,t,z);
fileID = fopen(fullfile(smdaP.itinerary.png_path,metadataFilename),'w');
formatSpecHeader = strcat(...
    '%s\t',... %channel_name
    '%s\t',... %filename
    '%s\t',... %group_label
    '%s\t',... %position_label
    '%s\t',... %binning
    '%s\t',... %channel_number
    '%s\t',... %continuous_focus_offset
    '%s\t',... %continuous_focus_bool
    '%s\t',... %exposure
    '%s\t',... %group_number
    '%s\t',... %group_order
    '%s\t',... %matlab_serial_date_number
    '%s\t',... %position_number
    '%s\t',... %position_order,
    '%s\t',... %settings_number
    '%s\t',... %settings_order
    '%s\t',... %timepoint
    '%s\t',...%smdaP.itinerary.group(g).position(p).xyz(t,1),... %x
    '%s\t',...%smdaP.itinerary.group(g).position(p).xyz(t,2),... %y
    '%s\t',...%     smdaP.itinerary.group(g).position(p).settings(s).z_origin_offset + ...%     smdaP.itinerary.group(g).position(p).settings(s).z_stack(z) + ...%     smdaP.itinerary.group(g).position(p).xyz(t,3),... %z
    '%s\t',... %the order of zstack from bottom to top
    '%s\n'); %image_description
formatSpecDatabaseRow = strcat(...
    '%s\t',... %channel_name
    '%s\t',... %filename
    '%s\t',... %group_label
    '%s\t',... %position_label
    '%d\t',... %binning
    '%d\t',... %channel_number
    '%f\t',... %continuous_focus_offset
    '%d\t',... %continuous_focus_bool
    '%f\t',... %exposure
    '%d\t',... %group_number
    '%d\t',... %group_order
    '%g\t',... %matlab_serial_date_number
    '%d\t',... %position_number
    '%d\t',... %position_order,
    '$d\t',... %settings_number
    '%d\t',... %settings_order
    '%d\t',... %timepoint
    '%f\t',...%smdaP.itinerary.group(g).position(p).xyz(t,1),... %x
    '%f\t',...%smdaP.itinerary.group(g).position(p).xyz(t,2),... %y
    '%f\t',...%     smdaP.itinerary.group(g).position(p).settings(s).z_origin_offset + ...%     smdaP.itinerary.group(g).position(p).settings(s).z_stack(z) + ...%     smdaP.itinerary.group(g).position(p).xyz(t,3),... %z
    '%d\t',... %the order of zstack from bottom to top
    '%s\n'); %image_description
fprintf(fileID,formatSpecHeader,varNames{:});
fprintf(fileID,formatSpecDatabaseRow,myNewDatabaseRow{:});
fclose(fileID);
