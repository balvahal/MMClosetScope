%%
% Before using this function make sure the data is in a folder named
% "RAW_DATA" and the the RAW_DATA folder is the project folder, which at
% this point probably only contains the RAW_DATA with maybe flatfield
% images. _mypath_ is the project directory.
%
% The goal of this function is to create a database file using images
% collected by Metamorph.
function [] = SuperMDA_SpotCamera2database(mypath)
%%
% get the image filenames and datenum
mydir = dir(fullfile(mypath,'RAW_DATA'));
mynames = {mydir(:).name};
mytimes = [mydir(:).datenum];
dirLogic1 = cellfun(@(x) ~isempty(regexp(x,'Image\d+\.tif', 'once')),{mydir(:).name});
if any(dirLogic1)
    % The metamorph file names have channel, position, and time.
    mycase = 1;
    mynames = mynames(dirLogic1);
    mytimes = mytimes(dirLogic1);
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
            mytokens = regexp(mynames{i},'Image(?<p>\d+)\.tif','names');
    end
    
            position_label = sprintf('Pos%d',mytokens.p);
        
            binning = 1;
        
            exposure = 0;
        
            x = 0;
        
            y = 0;
        
            z = 0;
    %%
    %
    myNewDatabaseRow = {...
        'color',... %channel_name
        mynames{i},... %filename
        'colorCamera',... %group_label
        position_label,... %position_label
        binning,... %binning
        1,... %channel_number
        0,... %continuous_focus_offset
        1,... %continuous_focus_bool
        exposure,... %exposure
        1,... %group_number
        1,... %group_order
        mytimes(i),... %matlab_serial_date_number
        mytokens.p,... %position_number
        mytokens.p,... %position_order,
        1,... %settings_number
        0,... %settings_order
        1,... %timepoint
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
myTable = cell2table(myTable,'VariableNames',varNames);
writetable(myTable,fullfile(mypath,'smda_database.txt'),'Delimiter','\t');
end