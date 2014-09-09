[mfilepath,~,~] = fileparts(mfilename('fullpath')); %finds the path to this script
publish(fullfile(mfilepath,'SuperMDA_readme.m'));
clear('options_doc');
options_doc.codeToEvaluate = 'SuperMDA_database2CellProfilerCSV(fullfile(mfilepath,''testfiles'',''example_database.txt''),fullfile(''some'',''path'',''some'',''where''),fullfile(mfilepath,''testfiles''))';
options_doc.maxOutputLines = 0;
publish(fullfile(mfilepath,'SuperMDA_database2CellProfilerCSV.m'),options_doc);