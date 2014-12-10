%%
% Before using this function make sure the data is in a folder named
% "RAW_DATA" and the the RAW_DATA folder is the project folder, which at
% this point probably only contains the RAW_DATA with maybe flatfield
% images. _mypath_ is the project directory.
%
% The goal of this function is to create a database file using images
% collected by Metamorph.
function [] = SuperMDA_Metamorph2database(mypath)
%%
% get the image filenames and datenum
mydir = dir(fullfile(mypath,'RAW_DATA'));
mynames = {mydir(:).name};
mytimes = [mydir(:).datenum];
dirLogic = cellfun(@(x) ~isempty(regexp(x,'.+_w\d+.+_s\d+_t\d+\.TIF', 'once')),{mydir(:).name});
mynames = mynames(dirLogic);
mytimes = mytimes(dirLogic);
%%
% create the file and header for the database
%fileID = fopen(fullfile(mypath,'smda_database.txt'),'w');
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
    '%s\r\n'); %image_description

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
    '%1.15g\t',...%smdaP.itinerary.group(g).position(p).xyz(t,1),... %x
    '%1.15g\t',...%smdaP.itinerary.group(g).position(p).xyz(t,2),... %y
    '%1.20g\t',...%     smdaP.itinerary.group(g).position(p).settings(s).z_origin_offset + ...%     smdaP.itinerary.group(g).position(p).settings(s).z_stack(z) + ...%     smdaP.itinerary.group(g).position(p).xyz(t,3),... %z
    '%d\t',... %the order of zstack from bottom to top
    '%s\r\n'); %image_description

%fprintf(fileID,formatSpecHeader,varNames{:});
%% parse images from metamorph
%
myTable = cell(length(mytimes),length(varNames));
for i = 1:length(mytimes)
    %%% extract data from the filename
    %
    mytokens = regexp(mynames{i},'(?<group_label>.+)_w(?<s>\d+)(?<channel_name>.+)_s(?<p>\d+)_t(?<t>\d+)\.TIF','names');
    %%%
    % use information from the Tiff metadata
    I = Tiff(fullfile(mypath,'RAW_DATA',mynames{i}));
    metadata = I.getTag('ImageDescription');
    fid = fopen(fullfile(mypath,'t3mp.xml'),'w');
    fprintf(fid,'%s',metadata);
    fclose(fid);
    xdoc = xmlread(fullfile(mypath,'t3mp.xml'));
    node_root = xdoc.getDocumentElement;
    my_list = node_root.getElementsByTagName('prop');
    for j = 0:my_list.getLength - 1
        if strcmp('stage-label',my_list.item(j).getAttribute('id'))
            position_label = my_list.item(j).getAttribute('value').toCharArray';
        end
        if strcmp('camera-binning-x',my_list.item(j).getAttribute('id'))
            binning = str2double(my_list.item(j).getAttribute('value'));
        end
        if strcmp('Description',my_list.item(j).getAttribute('id'))
            exposure = regexp(my_list.item(j).getAttribute('value').toCharArray','Exposure: (\d+)','tokens');
            exposure = str2double(exposure{1});
        end
        if strcmp('stage-position-x',my_list.item(j).getAttribute('id'))
            x = str2double(my_list.item(j).getAttribute('value'));
        end
        if strcmp('stage-position-y',my_list.item(j).getAttribute('id'))
            y = str2double(my_list.item(j).getAttribute('value'));
        end
        if strcmp('z-position',my_list.item(j).getAttribute('id'))
            z = str2double(my_list.item(j).getAttribute('value'));
        end
    end
    I.close;
    %%
    %
    myNewDatabaseRow = {...
        mytokens.channel_name,... %channel_name
        mynames{i},... %filename
        mytokens.group_label,... %group_label
        position_label,... %position_label
        binning,... %binning
        mytokens.s,... %channel_number
        0,... %continuous_focus_offset
        1,... %continuous_focus_bool
        exposure,... %exposure
        1,... %group_number
        1,... %group_order
        mytimes(i),... %matlab_serial_date_number
        mytokens.p,... %position_number
        mytokens.p,... %position_order,
        mytokens.s,... %settings_number
        0,... %settings_order
        mytokens.t,... %timepoint
        x,...%smdaP.itinerary.group(g).position(p).xyz(t,1),... %x
        y,...%smdaP.itinerary.group(g).position(p).xyz(t,2),... %y
        z,...%     smdaP.itinerary.group(g).position(p).settings(s).z_origin_offset + ...%     smdaP.itinerary.group(g).position(p).settings(s).z_stack(z) + ...%     smdaP.itinerary.group(g).position(p).xyz(t,3),... %z
        1,... %the order of zstack from bottom to top
        ''}; %image_description
    myTable(i,:) = myNewDatabaseRow;
    %fprintf(fileID,formatSpecDatabaseRow,myNewDatabaseRow{:});
    fprintf('%1.2f\n',i/length(mytimes));
end
%%
% close the file
%fclose(fileID);
myTable = cell2table(myTable,'VariableNames',varNames);
writetable(myTable,fullfile(mypath,'smda_database.txt'),'Delimiter','\t');
end