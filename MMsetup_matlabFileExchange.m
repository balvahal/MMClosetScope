[mfilepath,~,~] = fileparts(mfilename('fullpath')); %finds the path to this script
if ~isdir(fullfile(mfilepath,'matlab_file_exchange'))
    mkdir(fullfile(mfilepath,'matlab_file_exchange'));
end

%% Download files from the MATLAB FILE EXCHANGE
% # JSONlab - a toolbox to encode/decode JSON files in MATLAB/Octave
%%% JSONlab
%
filename = fullfile(mfilepath,'matlab_file_exchange','JSONlab.zip');
url = 'http://www.mathworks.com/matlabcentral/fileexchange/downloads/58936';
websave(filename,url);
unzip(fullfile(mfilepath,'matlab_file_exchange','JSONlab.zip'),...
    fullfile(mfilepath,'matlab_file_exchange','JSONlab')...
    );
delete(filename);
