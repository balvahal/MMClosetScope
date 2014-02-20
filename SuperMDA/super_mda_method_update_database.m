%%
%
function [obj] = super_mda_method_update_database(obj,filename,image_description)
runtime_index2 = num2cell(obj.runtime_index); % a quirk about assigning the contents or a vector to multiple variables means the vector must first be made into a cell.
[t,g,p,s,z] = deal(runtime_index2{:}); %[timepoint,group,position,settings,z_stack]
my_dataset = table(...
    cellstr(obj.channel_names{obj.group(g).position(p).settings(s).channel}),... %channel_name
    cellstr(filename),... %filename
    cellstr(obj.group(g).label),... %group_label
    cellstr(obj.group(g).position(p).label),... %position_label
    obj.group(g).position(p).settings(s).binning,... %binning
    obj.group(g).position(p).settings(s).channel,... %channel_number
    obj.group(g).position(p).continuous_focus_offset,... %continuous_focus_offset
    obj.group(g).position(p).continuous_focus_bool,... %continuous_focus_bool
    obj.group(g).position(p).settings(s).exposure(t),... %exposure
    g,... %group_number
    obj.group_order(g),... %group_order
    now,... %matlab_serial_date_number
    p,... %position_number
    obj.group(g).position_order(p),... %position_order,
    s,... %settings_number
    obj.group(g).position(p).settings_order(s),... %settings_order
    t,... %timepoint
    obj.group(g).position(p).xyz(t,1),... %x
    obj.group(g).position(p).xyz(t,2),... %y
    obj.group(g).position(p).settings(s).z_origin_offset + ...
    obj.group(g).position(p).settings(s).z_stack(z) + ...
    obj.group(g).position(p).xyz(t,3),... %z
    z,... %the order of zstack from bottom to top
    cellstr(image_description),... %image_description
    'VariableNames',{'channel_name','filename','group_label','position_label','binning','channel_number','continuous_focus_offset','continuous_focus_bool','exposure','group_number','group_order','matlab_serial_date_number','position_number','position_order','settings_number','settings_order','timepoint','x','y','z','z_order','image_description'});
obj.database = [obj.database;my_dataset]; %add a new row to the dataset
notify(obj,'database_updated',SuperMDA_event_database_updated(obj.mm));