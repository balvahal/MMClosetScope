%% core_jsonparser
%
% How to configure Python in MATLAB 2015b (on a Windows Box):
%
% # Download Python 3.4 from <python.org/downloads/>. Ensure that the
% 32-bit or 64-bit version of Python is consistent with MATLAB.
% # Update the Windows Path Environment Variable to include the Python path
% and the _PythonXX\Scripts_ path.
%
% Notes: 
%
% # Numerical data stored in a manner that represents more than
% 2-dimensions will be flattened into a 2D matrix when imported into
% MATLAB.
% # Data structures that are more than 2 dimensions cannot be exported into
% a JSON file. Add this to the feature wishlist :)
%% Methods Summary
% * *import_json*: Import a JSON file into MATLAB. Specify the path to the
% JSON file as the input _mypath_.
% * *export_json*: Export MATLAB data to a JSON file. The first input is
% the MATLAB data. The second input is the path to the file that will
% become the JSON file, e.g. |C:\someFolder\anotherFolder\myJSON.txt|
classdef core_jsonparser < handle
    %%
    %
    properties
        
    end
    
    methods
        %% The constructor
        %
        function obj = core_jsonparser()
            %%%
            % Is Python installed?
            [~,~,pyIs] = pyversion;
            if ~pyIs
                error('crjson:nopy','MATLAB is not configured for python.');
            end
        end
    end
    
    methods (Static)
        %% import_json
        % Import a JSON file into MATLAB
        function matlabData = import_json(mypath)
            %%%
            % import the JSON file into MATLAB
            myjsonFile = py.open(mypath);
            if double(py.os.stat(mypath).st_size) == 0
                error('crjson:empty','The file specified by the input path is empty.');
            end
            %%%
            % convert JSON into Python
            pyData = py.json.load(myjsonFile);
            myjsonFile.close;
            %%%
            % convert Python into MATLAB
            matlabData = core_py2matlab(pyData);
        end
        %% export_json
        % Export a JSON file from MATLAB
        function [] = export_json(matlabData,mypath)
            %%%
            % convert MATLAB into Python
            pyData = core_matlab2py(matlabData);
            %%%
            % export JSON file
            pyFile = py.open(mypath,'w');
            %py.json.dump(pyData,pyFile,pyargs('indent',int32(4),'sort_keys',true));
            py.json.dump(pyData,pyFile,pyargs('sort_keys',true));
            pyFile.close;
        end
    end
end