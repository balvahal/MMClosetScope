[mfilepath,~,~] = fileparts(mfilename('fullpath')); %finds the path to this script
publish(fullfile(mfilepath,'SuperMDA_readme.m'));
publish(fullfile(mfilepath,'SuperMDA_database2CellProfilerCSV.m'));