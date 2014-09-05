%% SuperMDA_database2CellProfilerCSV
% A database text-file is created after using SuperMDA. If the images will
% be analyzed using cellprofiler.org software it is useful to have the
% cellprofiler.org ready CSV file created. This function will create such a
% file.
%
%   [] = SuperMDA_database2CellProfilerCSV(path2database)
%
%%% Input
% * path: a char. The path where the image metadata is located.
%
%%% Output:
% There is no direct argument output. Rather, a CSV file the is compatible
% with Cell Profiler is created.
%
%%% Detailed Description
%
%
%%% Other Notes
%
function [] = SuperMDA_database2CellProfilerCSV(path2database)
%% Create the header to the CSV file
%
header = cell(1,2*imageMetadata.numbers.howManyW);
for i=1:imageMetadata.numbers.howManyW
    header{2*i-1} = sprintf('Image_FileName_%s',imageMetadata.wavelengthInfo{i+1,2});
    header{2*i} = sprintf('Image_PathName_%s',imageMetadata.wavelengthInfo{i+1,2});
end
%% Add the filenames to the CSV file
%
M = cell(10000,length(header));
for w=1:imageMetadata.numbers.howManyW
    for s=1:imageMetadata.numbers.howManyS
        if ~isempty(imageMetadata.filenames{s,w})
            M{s,2*w-1} = imageMetadata.filenames{s,w};
            M{s,2*w} = fullfile(path,'png');
        end
    end
end
%%
% Remove empty rows
isemptyM = cellfun(@isempty,M(:,1));
M(isemptyM,:) = [];
M = vertcat(header,M);
%% Create the CSV file
% The code below works, but does not seem to be the most elegant way of
% making the file.
fid=fopen(fullfile(path,'cpCSV.csv'),'w'); %create the file
csvFun = @(str)sprintf('%s,',str); %create a function that adds a comma after an input string
for i=1:size(M,1)
    xchar = cellfun(csvFun, M(i,:),'UniformOutput',false); %commas are added after each entry in a row
    xchar = strcat(xchar{:}); %the separate entries are combined into a single string
    fprintf(fid,'%s\r\n',xchar(1:end-1)); %this single string, which represents a row is added to the file. The last comma is left off
end
fclose(fid);
end