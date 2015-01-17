[mfilepath,~,~] = fileparts(mfilename('fullpath')); %finds the path to this script
if ~isdir(fullfile(mfilepath,'matlab_file_exchange'))
    mkdir(fullfile(mfilepath,'matlab_file_exchange'));
end

%% Download files from the MATLAB FILE EXCHANGE
% # JSONlab - a toolbox to encode/decode JSON files in MATLAB/Octave
% # twitty - Interface-class to access the Twitter REST API v1.1.
%%% JSONlab
%
filename = fullfile(mfilepath,'matlab_file_exchange','JSONlab.zip');
url = 'http://www.mathworks.com/matlabcentral/fileexchange/submissions/33381/v/16/download/zip';
websave(filename,url);
unzip(fullfile(mfilepath,'matlab_file_exchange','JSONlab.zip'),...
    fullfile(mfilepath,'matlab_file_exchange','JSONlab')...
    );
delete(filename);
%%% twitty
%
filename = fullfile(mfilepath,'matlab_file_exchange','twitty.zip');
url = 'http://www.mathworks.com/matlabcentral/fileexchange/submissions/34837/v/6/download/zip';
websave(filename,url);
unzip(fullfile(mfilepath,'matlab_file_exchange','twitty.zip'),...
    fullfile(mfilepath,'matlab_file_exchange','twitty')...
    );
delete(filename);