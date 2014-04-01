%%
%
function [obj] = super_mda_method_update_database(obj)
%% update the internal object database
%
runtime_index2 = num2cell(obj.runtime_index); % a quirk about assigning the contents or a vector to multiple variables means the vector must first be made into a cell.
[t,g,p,s,z] = deal(runtime_index2{:}); %[timepoint,group,position,settings,z_stack]
myNewDatabaseRow = {...
    obj.itinerary.channel_names{obj.itinerary.group(g).position(p).settings(s).channel},... %channel_name
    obj.itinerary.database_filenamePNG,... %filename
    obj.itinerary.group(g).label,... %group_label
    obj.itinerary.group(g).position(p).label,... %position_label
    obj.itinerary.group(g).position(p).settings(s).binning,... %binning
    obj.itinerary.group(g).position(p).settings(s).channel,... %channel_number
    obj.itinerary.group(g).position(p).continuous_focus_offset,... %continuous_focus_offset
    obj.itinerary.group(g).position(p).continuous_focus_bool,... %continuous_focus_bool
    obj.itinerary.group(g).position(p).settings(s).exposure(t),... %exposure
    g,... %group_number
    obj.itinerary.group_order(g),... %group_order
    now,... %matlab_serial_date_number
    p,... %position_number
    obj.itinerary.group(g).position_order(p),... %position_order,
    s,... %settings_number
    obj.itinerary.group(g).position(p).settings_order(s),... %settings_order
    t,... %timepoint
    obj.itinerary.group(g).position(p).xyz(t,1),... %x
    obj.itinerary.group(g).position(p).xyz(t,2),... %y
    obj.itinerary.group(g).position(p).settings(s).z_origin_offset + ...
    obj.itinerary.group(g).position(p).settings(s).z_stack(z) + ...
    obj.itinerary.group(g).position(p).xyz(t,3),... %z
    z,... %the order of zstack from bottom to top
    obj.itinerary.database_imagedescription}; %image_description
obj.itinerary.database(obj.runtime_imagecounter,:) = myNewDatatbaseRow;
%% Write this row to a text file
%
database_filename = fullfile(obj.itinerary.output_directory,'smda_database.txt');
myfid = fopen(database_filename,'a');
fprintf(myfid,'%s\t%s\t%s\t%s\t%d\t%d\t%f\t%d\t%f\t%d\t%d\t%f\t%d\t%d\t%d\t%d\t%d\t%f\t%f\t%f\t%d\t%s\r\n',myNewDatabaseRow{:});
fclose(myfid);
