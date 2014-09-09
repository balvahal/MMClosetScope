%% SuperMDA_database2CellProfilerCSV
% A database text-file is created after using SuperMDA. If the images will
% be analyzed using cellprofiler.org software it is useful to have a
% cellprofiler.org-ready CSV file created. This function will create such a
% file.
%
%   [] = SuperMDA_database2CellProfilerCSV(path2database,path2imagefiles,outputpath)
%
%%% Input
% * path2database: a string. The path to the SuperMDA database file.
% * path2imagefiles: a string. The path to the directory containing the
% image files.
% * outputpath: a string. The path to the directory where the CSV file will
% be saved.
%
%%% Output:
% There is no direct argument output. Rather, a CSV file that is compatible
% with cellprofiler.org is created and saved in the outputpath directory.
%
%%% Detailed Description
% There is no detailed description.
%
%%% Other Notes
% There are no other notes
function [] = SuperMDA_database2CellProfilerCSV(path2database,path2imagefiles,outputpath)
%% Import the SuperMDA database file
%
myDatabase = readtable(path2database,'Delimiter','\t');
%% Look into the database and find the channels
%
channelNumberColumn = myDatabase.channel_number;
channelNumberUnique = unique(channelNumberColumn);
channelNames = cell(size(channelNumberUnique));
for i = 1:length(channelNames) %floop 1
    floop1ChannelNumber = channelNumberUnique(i);
    floop1ChannelInd = find(channelNumberColumn == floop1ChannelNumber,1,'first');
    channelNames(i) = myDatabase.channel_name(floop1ChannelInd);
end
%% Check: each channel should have the same number of files
% cellprofiler.org expects each channel to have the same number of images.
% Since this is not a requirement in SuperMDA a test is made.
numberOfImagesInEachChannel = zeros(size(channelNumberUnique));
for i = 1:length(channelNumberUnique) %floop 2
    numberOfImagesInEachChannel(i) = sum(channelNumberColumn == channelNumberUnique(i));
end
%%
% The database will be reduced such that each channel will have
% corresponding images for the channel with the fewest images. This
% reduction will only take into account differences in image frequency and
% does not account for differences in tiling or z-stack; if these latter
% differences occur an error will not be thrown and a corrupt CSV file will
% be created.
if ~all(numberOfImagesInEachChannel == numberOfImagesInEachChannel(1)) %if 1
    [~,if1min] = min(numberOfImagesInEachChannel);
    if1MinLogical = strcmp(myDatabase.channel_name,channelNames{if1min});
    if1FinalLogical = ismember(myDatabase.timepoint,myDatabase.timepoint(if1MinLogical));
    myDatabase = myDatabase(if1FinalLogical,:);
end
%% Create a table variable to hold the CSV file data
% The table will have two columns for each channel_name
cellprofilerCSVheader = cell(1,2*length(channelNumberUnique));
cellprofilerdata = cell(1,2*length(channelNumberUnique));
%%
% cellprofiler.org wants a column of filenames and a column of paths for
% each channel.
for i = 1:length(channelNumberUnique) %floop 3
    cellprofilerCSVheader{2*i-1} = sprintf('Image_FileName_%s',channelNames{i});
    cellprofilerCSVheader{2*i} = sprintf('Image_PathName_%s',channelNames{i});
    floop3logical = strcmp(myDatabase.channel_name,channelNames{i});
    cellprofilerdata{2*i-1} = myDatabase.filename(floop3logical);
    cellprofilerdata{2*i} = repmat(path2imagefiles,[numberOfImagesInEachChannel(1),1]);
end
cellprofilerCSVTable = table(cellprofilerdata{:},'VariableNames',cellprofilerCSVheader);
writetable(cellprofilerCSVTable,fullfile(outputpath,'cellprofilerCSV.csv'),'Delimiter',',');