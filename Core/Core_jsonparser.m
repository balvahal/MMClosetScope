%% Core_jsonparser
%
% How to configure Python in MATLAB 2015b (on a Windows Box):
%
% # Download Python 3.4 from <python.org/downloads/>. Ensure that the
% 32-bit or 64-bit version of Python is consistent with MATLAB.
% # Update the Windows Path Environment Variable to include the Python path
% and the _PythonXX\Scripts_ path.
%
% Note: Numerical data stored in a manner than represents more than
% 2-dimensions will be flattened into a 2D matrix when imported into
% MATLAB.
%% Methods Summary
% * *import_json*: Import a JSON file into MATLAB
classdef Core_jsonparser < handle
    %%
    %
    properties
        
    end
    
    methods
        %% The constructor
        %
        function obj = Core_jsonparser()
            %%%
            % Is Python installed?
            [~,~,pyIs] = pyversion;
            if ~pyIs
                error('crtwt:nopy','MATLAB is not configured for python.');
            end
        end
    end
    
    methods (Static)
        %% import_json
        % Import a JSON file into MATLAB
        function myjson = import_json(mypath)
            %%%
            % import the JSON file into MATLAB
            myjsonFile = py.open(mypath);
            %%%
            % convert JSON into Python
            pyjson = py.json.load(myjsonFile);
            %%%
            % convert Python into MATLAB
            myjson = recursiveFunConversion(pyjson);
            %%%
            % Matrices of numbers are converted into cells, so another
            % function will reformat these into matrices.
            myjson = recursiveFunCell2MatCheck(myjson);
            %% pythonConversion
            % <matlab:doc('handling-data-returned-from-python') data from
            % Python>
            function matlabData = pythonConversion(pyData)
                pyType = class(pyData);
                switch pyType
                    case {'py.str','py.unicode'}
                        matlabData = char(pyData);
                    case 'py.bytes'
                        matlabData = uint8(pyData);
                    case {'py.int','py.long','py.array.array'}
                        matlabData = double(pyData);
                    case {'py.list','py.tuple'}
                        matlabData = cell(pyData);
                    case 'py.dict'
                        matlabData = struct(pyData);
                    otherwise
                        matlabData = pyData;
                end
            end
            %% recursiveFunConversion
            % Loops through the JSON object turning Python data types into
            % MATLAB data types
            function matlabData = recursiveFunConversion(pyData)
                matlabData = pythonConversion(pyData);
                matlabType = class(matlabData);
                mynum = numel(matlabData);
                switch matlabType
                    case 'cell'
                        for i = 1:mynum
                            matlabData{i} = recursiveFunConversion(matlabData{i});
                        end
                    case 'struct'
                        for i = 1:mynum
                            myfields = fieldnames(matlabData(i));
                            for j = 1:numel(myfields)
                                matlabData(i).(myfields{j}) = recursiveFunConversion(matlabData(i).(myfields{j}));
                            end
                        end
                end
            end
            %% recursiveFunCell2MatCheck
            % A second loop through the JSON data structure to identify
            % numeric matrices stored as cells
            function mydata = recursiveFunCell2MatCheck(mydata)
                myType = class(mydata);
                mynum = numel(mydata);
                switch myType
                    case 'cell'
                        if iscellstr(mydata)
                            return
                        elseif all(cellfun(@isnumeric,mydata(:)))
                            % This is the key condition. A cell full of
                            % numbers will be converted into a matrix.
                            try
                                mydata = cell2mat(mydata);
                            catch
                                %do nothing
                            end
                        else
                            for i = 1:mynum
                                mydata{i} = recursiveFunCell2MatCheck(mydata{i});
                            end
                            if all(cellfun(@isnumeric,mydata(:)))
                                % This is to handle 2D matrices. Anything
                                % that has more than 2 dimensions will be
                                % flattened to 2D.
                                try
                                    mydata = cell2mat(transpose(mydata));
                                catch
                                    %do nothing
                                end
                            end
                        end
                    case 'struct'
                        for i = 1:numel(mydata)
                            myfields = fieldnames(mydata(i));
                            for j = 1:numel(myfields)
                                mydata(i).(myfields{j}) = recursiveFunCell2MatCheck(mydata(i).(myfields{j}));
                            end
                        end
                end
            end
        end
    end
end