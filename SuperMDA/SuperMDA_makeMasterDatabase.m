%% SuperMDAPilot_method_makeMasterDatabase
% Each image file has a metadata tab delimited text file. When processing
% this data it is convenient to store it all in a single file. This
% function consolidates the data within the individual metadata files into
% a single tab delimited text file named _smda_database.txt_.
%
% Metadata is initially stored in its own text file for performance and
% speed during image acquisition.
function [] = SuperMDA_makeMasterDatabase(path)
mydir = dir(fullfile(path,'RAW_DATA'));
%%%
% find all of the text files
mydir = mydir(cellfun(@(x) ~isempty(regexp(x,'.txt$','start')),{mydir(:).name}));
mylength = length(mydir);
mytable = readtable(fullfile(path,'RAW_DATA',mydir(1).name),'Delimiter','\t');
if length(mydir) > 1
    for i = 2:length(mydir)
        mytable = vertcat(mytable,readtable(fullfile(path,'RAW_DATA',mydir(i).name),'Delimiter','\t')); %#ok<AGROW>
        fprintf('%2.2f: %s\r\n',i/mylength*100,mydir(i).name);
    end
end
databasefilename = fullfile(path,'smda_database.txt');
writetable(mytable,databasefilename,'Delimiter','tab');
end