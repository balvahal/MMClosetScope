%%
% This script is part of the initial setup of SuperMDA. However, since its
% creation it is no longer necessary. However, in case it becomes useful
% again the code is being left as commented for future reference.

[mfilepath,~,~] = fileparts(mfilename('fullpath')); %finds the path to this script
if ~isdir(fullfile(mfilepath,'matlab_file_exchange'))
    mkdir(fullfile(mfilepath,'matlab_file_exchange'));
end

%% Download files from the MATLAB FILE EXCHANGE
% # json_parser - the preferred JSON parser of twitty
% # twitty - Interface-class to access the Twitter REST API v1.1.
%%% twitty
%
% filename = fullfile(mfilepath,'matlab_file_exchange','twitty.zip');
% url = 'http://www.mathworks.com/matlabcentral/fileexchange/submissions/34837/v/6/download/zip';
% websave(filename,url);
% unzip(fullfile(mfilepath,'matlab_file_exchange','twitty.zip'),...
%     fullfile(mfilepath,'matlab_file_exchange','twitty')...
%     );
% delete(filename);
% %%% json_parser
% %
% filename = fullfile(mfilepath,'matlab_file_exchange','json_parser.zip');
% url = 'http://www.mathworks.com/matlabcentral/fileexchange/submissions/20565/v/3/download/zip';
% websave(filename,url);
% unzip(fullfile(mfilepath,'matlab_file_exchange','json_parser.zip'),...
%     fullfile(mfilepath,'matlab_file_exchange','json_parser')...
%     );
% delete(filename);
