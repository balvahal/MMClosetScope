%% Core_jsonparser
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
                error('crjson:nopy','MATLAB is not configured for python.');
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
            if double(py.os.stat(mypath).st_size) == 0
                error('crjson:empty','The file specified by the input path is empty.');
            end
            %%%
            % convert JSON into Python
            pyjson = py.json.load(myjsonFile);
            myjsonFile.close;
            %%%
            % convert Python into MATLAB
            myjson = recursiveFunPy2Matlab(pyjson);
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
            %% recursiveFunPy2Matlab
            % Loops through the JSON object turning Python data types into
            % MATLAB data types
            function matlabData = recursiveFunPy2Matlab(pyData)
                matlabData = pythonConversion(pyData);
                matlabType = class(matlabData);
                mynum = numel(matlabData);
                switch matlabType
                    case 'cell'
                        for i = 1:mynum
                            matlabData{i} = recursiveFunPy2Matlab(matlabData{i});
                        end
                    case 'struct'
                        for i = 1:mynum
                            myfields = fieldnames(matlabData(i));
                            for j = 1:numel(myfields)
                                matlabData(i).(myfields{j}) = recursiveFunPy2Matlab(matlabData(i).(myfields{j}));
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
        %% export_json
        % Export a JSON file from MATLAB
        function [] = export_json(matlabData,mypath)
            %%%
            % convert MATLAB into Python
            myjson = recursiveFunMatlab2Py(matlabData);
            %%%
            % export JSON file
            pyFile = py.open(mypath,'w');
            py.json.dump(myjson,pyFile);
            pyFile.close;
            %% matlabConversion
            % <matlab:doc('handling-data-returned-from-python') data from
            % Python>
            function pyData = matlabConversion(matlabData)
                matlabType = class(matlabData);
                switch matlabType
                    case 'char'
                        if isrow(matlabData)
                            pyData = py.str(matlabData);
                        else
                            pyData = py.str(transpose(matlabData));
                        end
                    case {'double','single','int8','uint8','int16','uint16','int32','uint32','int64','uint64'}
                        mysize = size(matlabData);
                        if numel(mysize) > 2
                            % More than 2 dimensions can be translated by
                            % nestings lists. I'm sure this can be done
                            % using a recursive function; Add it to the
                            % feature wishlist.
                            error('crjson:tooManyDimNum','A matrix of numbers was found to have more than 2-dimensions, which this function cannot translate into Python.');
                        elseif all(mysize > 1)
                            % a two dimensional matrix
                            matlabData2 = num2cell(matlabData,2);
                            matlabData3 = cellfun(@py.list,matlabData2,'UniformOutput',false);
                            pyData = py.list(transpose(matlabData3));
                        elseif any(mysize > 1)
                            % an array of numbers
                            if isrow(matlabData)
                                pyData = py.list(matlabData);
                            else
                                pyData = py.list(transpose(matlabData));
                            end
                        else
                            % a number
                            pyData = py.float(matlabData);
                        end
                    case 'cell'
                        mysize = size(matlabData);
                        if numel(mysize) > 2
                            % More than 2 dimensions can be translated by
                            % nestings lists. I'm sure this can be done
                            % using a recursive function; Add it to the
                            % feature wishlist.
                            error('crjson:tooManyDimCell','A cell was found to have more than 2-dimensions, which this function cannot translate into Python.');
                        elseif all(mysize > 1)
                            % a two dimensional cell
                            matlabData2 = num2cell(matlabData,2); %Surprisingly useful when the input is a cell.
                            matlabData3 = cellfun(@py.list,matlabData2,'UniformOutput',false);
                            pyData = py.list(transpose(matlabData3));
                        elseif any(mysize > 1)
                            % a 1D cell
                            if isrow(matlabData)
                                pyData = py.list(matlabData);
                            else
                                pyData = py.list(transpose(matlabData));
                            end
                        else
                            % a 1x1 cell
                            pyData = py.list(matlabData);
                        end
                    case 'struct'
                        mysize = size(matlabData);
                        if numel(mysize) > 2
                            % More than 2 dimensions can be translated by
                            % nestings lists. I'm sure this can be done
                            % using a recursive function; Add it to the
                            % feature wishlist.
                            error('crjson:tooManyDimStruct','A struct was found to have more than 2-dimensions, which this function cannot translate into Python.');
                        elseif all(mysize > 1)
                            % a two dimensional struct
                            matlabData2 = num2cell(matlabData,2); %Surprisingly useful when the input is a struct, too.
                            for i = 1:numel(matlabData2)
                                matlabData2{i} = num2cell(matlabData2{i},1);
                                matlabData2{i} = cellfun(@py.dict,matlabData2{i},'UniformOutput',false);
                            end
                            matlabData3 = cellfun(@py.list,matlabData2,'UniformOutput',false);
                            pyData = py.list(transpose(matlabData3));
                        elseif any(mysize > 1)
                            % a 1D struct
                            if isrow(matlabData)
                                matlabData = num2cell(matlabData,1);
                                matlabData = cellfun(@py.dict,matlabData,'UniformOutput',false);
                            else
                                matlabData = num2cell(transpose(matlabData),1);
                                matlabData = cellfun(@py.dict,matlabData,'UniformOutput',false);
                            end
                            pyData = py.list(matlabData);
                        else
                            % a 1x1 struct
                            pyData = py.dict(matlabData);
                        end
                    otherwise
                        pyData = matlabData;
                end
            end
            %% recursiveFunMatlab2Py
            % Loops through the JSON object turning MATLAB data types into
            % Python data types
            function pyData = recursiveFunMatlab2Py(matlabData)
                matlabType = class(matlabData);
                mynum = numel(matlabData);
                switch matlabType
                    case 'cell'
                        if mynum == 1
                            if iscell(matlabData{1}) || isstruct(matlabData{1})
                                matlabData{1} = recursiveFunMatlab2Py(matlabData{1});
                            end
                        else
                            logicalIsCell = cellfun(@iscell,matlabData);
                            logicalIsStruct = cellfun(@isstruct,matlabData);
                            if any(logicalIsCell(:)) || any(logicalIsStruct(:))
                                for i = 1:mynum
                                    matlabData{i} = recursiveFunMatlab2Py(matlabData{i});
                                end
                            end
                        end
                    case 'struct'
                        for i = 1:mynum
                            myfields = fieldnames(matlabData(i));
                            for j = 1:numel(myfields)
                                matlabData(i).(myfields{j}) = recursiveFunMatlab2Py(matlabData(i).(myfields{j}));
                            end
                        end
                end
                pyData = matlabConversion(matlabData);
            end
        end
    end
end