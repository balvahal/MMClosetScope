%% SuperMDAPilot_method_makeMasterDatabase
% Each image file has a metadata tab delimited text file. When processing
% this data it is convenient to store it all in a single file. This
% function consolidates the data within the individual metadata files into
% a single tab delimited text file named _smda_database.txt_.
%
% Metadata is initially stored in its own text file for performance and
% speed during image acquisition.
function smdaP = SuperMDAPilot_method_makeMasterDatabase(smdaP)
mydir = dir(smdaP.itinerary.png_path);
%%%
% find all of the text files
mydir = mydir(cellfun(@(x) ~isempty(regexp(x,'.txt$','start')),{mydir(:).name}));
mytable = readtable(fullfile(smdaP.itinerary.png_path,mydir(1).name),'Delimiter','\t');
if length(mydir) > 1
    for i = 2:length(mydir)
        mytable = vertcat(mytable,readtable(fullfile(smdaP.itinerary.png_path,mydir(i).name),'Delimiter','\t')); %#ok<AGROW>
    end
end
smdaP.databasefilename = fullfile(smdaP.itinerary.output_directory,'smda_database.txt');
writetable(mytable,smdaP.databasefilename,'Delimiter','tab');
end