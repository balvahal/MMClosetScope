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
dirLogic1 = cellfun(@(x) ~isempty(regexp(x,'.+_w\d+.+_s\d+_t\d+\.TIF', 'once')),{mydir(:).name});
dirLogic2 = cellfun(@(x) ~isempty(regexp(x,'.+_w\d+.+_s\d+.TIF', 'once')),{mydir(:).name});
if any(dirLogic1)
    % The metamorph file names have channel, position, and time.
    mycase = 1;
    mynames = mynames(dirLogic1);
    mytimes = mytimes(dirLogic1);
elseif any(dirLogic2)
    % The metamorph file names have channel and position.
    mycase = 2;
    mynames = mynames(dirLogic2);
    mytimes = mytimes(dirLogic2);
else
    error('smdaM2D:nofile','No Metamorph image files were found within the ''RAW_DATA'' sub-folder');
end

%%
% create the file and header for the database
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
%% parse images from metamorph
%
myTable = cell(length(mytimes),length(varNames));
for i = 1:length(mytimes)
    %%% extract data from the filename
    %
    switch mycase
        case 1
            mytokens = regexp(mynames{i},'(?<group_label>.+)_w(?<s>\d+)(?<channel_name>.+)_s(?<p>\d+)_t(?<t>\d+)\.TIF','names');
        case 2
            mytokens = regexp(mynames{i},'(?<group_label>.+)_w(?<s>\d+)(?<channel_name>.+)_s(?<p>\d+)\.TIF','names');
            mytokens.t = 1;
    end
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
    fprintf('%1.2f\n',i/length(mytimes));
end
%%
%
delete(fullfile(mypath,'t3mp.xml'));
myTable = cell2table(myTable,'VariableNames',varNames);
writetable(myTable,fullfile(mypath,'smda_database.txt'),'Delimiter','\t');
end