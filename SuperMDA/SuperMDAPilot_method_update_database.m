%%
%
function [smdaP] = SuperMDAPilot_method_update_database(smdaP)
%% update the internal smdaPect database
%
t = smdaP.t; %time
g = smdaP.gps_current(1); %group
p = smdaP.gps_current(2); %position
s = smdaP.gps_current(3); %settings
z = 1;
smdaP.runtime_imagecounter = smdaP.runtime_imagecounter + 1;
myGroupOrder = smdaP.itinerary.orderOfGroup;
myPositionOrder = smdaP.itinerary.orderOfPostion(g);
mySettingsOrder = smdaP.itinerary.orderOfSettings(g,p);
myNewDatabaseRow = {...
    smdaP.itinerary.channel_names{smdaP.settings_channel(s)},... %channel_name
    smdaP.itinerary.database_filenamePNG,... %filename
    smdaP.itinerary.group_label(g),... %group_label
    smdaP.itinerary.position_label(p),... %position_label
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
smdaP.database(smdaP.runtime_imagecounter,:) = myNewDatabaseRow;
%% Write this row to a text file
%
database_filename = fullfile(smdaP.itinerary.output_directory,'smda_database.txt');
myfid = fopen(database_filename,'a');
fprintf(myfid,'%s\t%s\t%s\t%s\t%d\t%d\t%f\t%d\t%f\t%d\t%d\t%f\t%d\t%d\t%d\t%d\t%d\t%f\t%f\t%f\t%d\t%s\r\n',myNewDatabaseRow{:});
fclose(myfid);
