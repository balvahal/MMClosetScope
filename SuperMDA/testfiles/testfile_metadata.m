tic
%% update the internal smdaPect database
%
g = 1; %group
p = 2; %position
s = 3; %settings
z = 1;
%obj.microscope.getXYZ;
myGroupOrder = 1;
myPositionOrder = 2;
mySettingsOrder = 3;
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
    'blue',... %channel_name
    'file1',... %filename
    'group1',... %group_label
    'position1',... %position_label
    1,... %binning
    2,... %channel_number
    0.24235463,... %continuous_focus_offset
    1,... %continuous_focus_bool
    200,... %exposure
    1,... %group_number
    1,... %group_order
    now,... %matlab_serial_date_number
    2,... %position_number
    2,... %position_order,
    3,... %settings_number
    3,... %settings_order
    1,... %timepoint
    100,...%obj.itinerary.group(g).position(p).xyz(obj.t,1),... %x
    100,...%obj.itinerary.group(g).position(p).xyz(obj.t,2),... %y
    1000,...%     obj.itinerary.group(g).position(p).settings(s).z_origin_offset + ...%     obj.itinerary.group(g).position(p).settings(s).z_stack(z) + ...%     obj.itinerary.group(g).position(p).xyz(obj.t,3),... %z
    1,... %the order of zstack from bottom to top
    'foobar'}; %image_description
%%
%
metadataFilename = sprintf('g%d_s%d_w%d_t%d_z%d.txt',g,p,s,1,z);
try
    fileID = fopen(fullfile(pwd,metadataFilename),'w');
catch
    pause(1);
    warning('smdaP:metadata','%s may not have been written to disk',metadataFilename);
    fileID = fopen(fullfile(pwd,metadataFilename),'w');
end
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
    '%s\t',...%obj.itinerary.group(g).position(p).xyz(t,1),... %x
    '%s\t',...%obj.itinerary.group(g).position(p).xyz(t,2),... %y
    '%s\t',...%     obj.itinerary.group(g).position(p).settings(s).z_origin_offset + ...%     obj.itinerary.group(g).position(p).settings(s).z_stack(z) + ...%     obj.itinerary.group(g).position(p).xyz(t,3),... %z
    '%s\t',... %the order of zstack from bottom to top
    '%s\r\n'); %image_description
formatSpecDatabaseRow = strcat(...
    '%s\t',... %channel_name
    '%s\t',... %filename
    '%s\t',... %group_label
    '%s\t',... %position_label
    '%d\t',... %binning
    '%d\t',... %channel_number
    '%1.15g\t',... %continuous_focus_offset
    '%d\t',... %continuous_focus_bool
    '%1.15g\t',... %exposure
    '%d\t',... %group_number
    '%d\t',... %group_order
    '%1.30g\t',... %matlab_serial_date_number
    '%d\t',... %position_number
    '%d\t',... %position_order,
    '%d\t',... %settings_number
    '%d\t',... %settings_order
    '%d\t',... %timepoint
    '%1.15g\t',...%obj.itinerary.group(g).position(p).xyz(t,1),... %x
    '%1.15g\t',...%obj.itinerary.group(g).position(p).xyz(t,2),... %y
    '%1.20g\t',...%     obj.itinerary.group(g).position(p).settings(s).z_origin_offset + ...%     obj.itinerary.group(g).position(p).settings(s).z_stack(z) + ...%     obj.itinerary.group(g).position(p).xyz(t,3),... %z
    '%d\t',... %the order of zstack from bottom to top
    '%s\r\n'); %image_description
fprintf(fileID,formatSpecHeader,varNames{:});
fprintf(fileID,formatSpecDatabaseRow,myNewDatabaseRow{:});
fclose(fileID);
mytable = readtable(fullfile(pwd,metadataFilename),'Delimiter','\t');
toc
tic
metadataFilename = sprintf('g%d_s%d_w%d_t%d_z%d2.txt',g,p,s,1,z);
struct_out.channel_name = 'blue';
struct_out.filename = 'file1';
struct_out.group_label = 'group1';
struct_out.position_label = 'position1';
struct_out.binning = 1;
struct_out.channel_number = 2;
struct_out.continuous_focus_offset = 0.24235463;
struct_out.continuous_focus_bool = 1;
struct_out.exposure = 200;
struct_out.group_number = 1;
struct_out.group_order = 1;
struct_out.matlab_serial_date_number = now;
struct_out.position_number = 2;
struct_out.position_order = 2;
struct_out.settings_number = 3;
struct_out.settings_order = 3;
struct_out.timepoint = 1;
struct_out.x = 100;
struct_out.y = 100;
struct_out.z = 1000;
struct_out.z_order = 1;
struct_out.image_description = 'hello';
core_jsonparser.export_json(struct_out,fullfile(pwd,metadataFilename));
myimportStruct = core_jsonparser.import_json(fullfile(pwd,metadataFilename));
toc