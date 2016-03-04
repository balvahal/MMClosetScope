%%
% The thumbnail image size is chosen hueristically. The thumbnails are
% desired to make viewing them fast while manually annotating or tracking
% the dataset. In our lab the image sizes are either *2048 x 2048* or
% *1024 x 1344*. A good compromise between detail and size for these two image
% sizes are *512 x 512* and *256 x 336*.
%
% In addition to the size the bit-depth will also be reduced from 16-bit to
% 8-bit.
function [] = SuperMDA_makeThumb(moviePath,thumbSize, varargin)
p = inputParser;
addRequired(p, 'moviePath', @(x) isdir(x));
addRequired(p, 'thumbsize', @(x) numel(x)==2 & isnumeric(x));
addOptional(p, 'bitdepth', 16, @(x) isnumeric(x));
parse(p,moviePath,thumbSize, varargin{:});

if ~isdir(fullfile(moviePath,'thumb'))
    mkdir(fullfile(moviePath,'thumb'));
end
%% load the database file
%
smda = readtable(fullfile(moviePath,'smda_database.txt'),'Delimiter','\t');
mycell = cell(height(smda),1);
%% create a thumbnail for each image
%
filename = smda.filename;
I = imread(fullfile(moviePath,'PROCESSED_DATA',filename{1}));
iType = class(I);
switch iType
    case 'uint16'
        bitdiff = 16 - p.Results.bitdepth;
        if bitdiff > 0
            myfun = @(x) bitshift(x,bitdiff);
        else
            myfun = @(x) x;
        end
    otherwise
        myfun = @(x) x;
end
parfor i = 1:height(smda)
    %%% read the image
    %
    I = imread(fullfile(moviePath,'PROCESSED_DATA',filename{i}));
    %%% scale the image
    %
    I = imresize(I,thumbSize);
    %%% convert image to uint8
    %
    I = myfun(I);
    I = gray2ind(I,256);
    %%% create filename
    %
    mycell{i} = regexprep(filename{i},'\..*','.png');
    mycell{i} = regexprep(mycell{i},'\s','');
    %%% save the new image
    %
    imwrite(I,fullfile(moviePath,'thumb',mycell{i}),'png');
    disp(mycell{i});
end
%% create filename database for the thumbnails
%
mytable = cell2table(mycell,'VariableNames',{'filename'});
mytable2 = smda(:,{'group_number','position_number','settings_number','timepoint','z_order'});
mytable = horzcat(mytable,mytable2);
writetable(mytable,fullfile(moviePath,'thumb_database.txt'),'Delimiter','\t');
%% Save a badge to the _moviePath_
%
myexportStruct.date = mydate;
myexportStruct.thumbSize = thumbSize;
Core_jsonparser.export_json(myexportStruct,fullfile(moviePath,'BADGE_thumb.txt'));
% jsonStrings = {};
% n = 1;
% jsonStrings{n} = micrographIOT_array2json('thumbSize',thumbSize); n = n + 1;
% mydate = datestr(now,31);
% jsonStrings{n} = micrographIOT_string2json('date',mydate);
% myjson = micrographIOT_jsonStrings2Object(jsonStrings);
% fid = fopen(fullfile(moviePath,'BADGE_thumb.txt'),'w');
% if fid == -1
%     error('cGPSFF:badfile','Cannot open the file, preventing the export of the background subtraction badge badge.');
% end
% fprintf(fid,myjson);
% fclose(fid);
% %%%
% %
% myjson = micrographIOT_autoIndentJson(fullfile(moviePath,'BADGE_thumb.txt'));
% fid = fopen(fullfile(moviePath,'BADGE_thumb.txt'),'w');
% if fid == -1
%     error('cGPSFF:badfile','Cannot open the file, preventing the export of the background subtraction badge.');
% end
% fprintf(fid,myjson);
% fclose(fid);
end