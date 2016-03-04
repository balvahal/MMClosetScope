%% SuperMDA_grid_maker
% A database text-file is created after using SuperMDA. If the images will
% be analyzed using cellprofiler.org software it is useful to have a
% cellprofiler.org-ready CSV file created. This function will create such a
% file.
%
%   [grid] = SuperMDA_grid_maker(mmhandle,varargin)
%
%%% Input
% * mmhandle: a string. The path to the SuperMDA database file.
% * varargin: a string. The path to the directory containing the image
% files.
%%% |varargin| Parameters
% * number_of_images: the number of images in a grid
% * number_of_columns: the number of columns in a grid
% * number_of_rows: the number of rows in a grid
% * centroid: the (x,y,z) position of the center of the grid.
% * upper_left_corner: the (x,y,z) position of the upper left corner of the
% grid
% * lower_right_corner: the (x,y,z) position of the lower right corner of
% the grid
% * overlap: the amount of overlap between images in both x and y. Negative
% distances represents the space between images.
% * overlap_x: overlap specific to the x-direction
% * overlap_y: overlap specific to the y-direction
% * diameter: the diameter of a circular area to image. Units of
% micro-meters.
% * overlap_units: pixels or micro-meters. |px| or |um|.
% * path_strategy: |snake|, |CRLF|, or |Jacob Pyramid|.
%
%%% Output:
% * grid: a struct. It contains string names and the (x,y,z) coordinates of
% the grid.
%
%%% Detailed Description
% There is no detailed description.
%
%%% Other Notes
% It is assumed that the origin is in the ULC and _x_ increases due east
% and _y_ increases due south when the stage is viewed from above.
%
% NOI means number of images. ULC means upper lefthand corner. LRC means
% lower righthand corner.
%
% What is meant by ULC and LRC and the centroid? The ULC and LRC are
% positions on the stage and do not represent any particular pixel in an
% image. The position could represent any particular pixel in the image, so
% I like to imagine it as the upper-left corner pixel or the traditional
% first pixel in an image. When making a grid of images this means that the
% ULC will be the same as the first pixel in the first image, but the LRC
% will be the last pixel of the area covered by the grid offset by the
% length and height of a single image. The centroid could be the actual
% pixel that is the center of a grid or the first pixel of the image that
% is deemed to be the center image. This is the challenge of keeping track
% of regions with area using a point. However, to keep the convention of
% the first pixel in an image being represented by the stage position then
% the centroid shall represent the first pixel as well. This will make the
% math consistent. When images are abstracted as points the math will be
% performed with reference to the first pixel of each image.
classdef SuperMDAGridMaker_object < handle
    properties
        mmhandle
        number_of_images
        number_of_columns
        number_of_rows
        centroid
        upper_left_corner
        lower_right_corner
        overlap = 0;
        overlap_x
        overlap_y
        diameter
        overlap_units = 'fraction';
        path_strategy = 'snake';
        pixWidth
        pixHeight
        grid
        number_of_images_flag = false;
        calibration_angle_flag = true;
    end
    methods
        %% Methods
        %   __  __     _   _            _
        %  |  \/  |___| |_| |_  ___  __| |___
        %  | |\/| / -_)  _| ' \/ _ \/ _` (_-< 
        %  |_|  |_\___|\__|_||_\___/\__,_/__/
        %
        %% The first method is the constructor
        %    ___             _               _
        %   / __|___ _ _  __| |_ _ _ _  _ __| |_ ___ _ _
        %  | (__/ _ \ ' \(_-<  _| '_| || / _|  _/ _ \ '_|
        %   \___\___/_||_/__/\__|_|  \_,_\__|\__\___/_|
        %
        function obj = SuperMDAGridMaker_object(mm)
            if nargin == 0
                return
            end
            if ~isa(mm,'Core_MicroManagerHandle')
                error('gdmkr:badinput','The input was not a Core_MicroManagerHandle_object');
            end
            obj.mmhandle = mm;
            obj.pixWidth = mm.core.getImageWidth;
            obj.pixHeight = mm.core.getImageHeight;
            
        end
        %%
        % Grid calculation requires the _overlap_units_ to be in the
        % dimensions of pixels (|px|). Therefore, if the units have been
        % specified as micro-meters (|um|), a conversion must be made. In
        % addition, if the overlap in the x and y directions are not
        % explicity defined, then the value chosen for _overlap_ parameter
        % is used.
        %
        % If the units are micro-meters then a conversion is made.
        % _overlap_x_ and _overlap_y_ are defined. Grid calculation uses
        % _overlap_x_ and _overlap_y_, not _overlap_.
        function obj = overlap2pixels(obj)
            %%%
            % Verify _overlap_units_ are valid
            if ~any(strcmp(obj.overlap_units,{'px', 'um', 'fraction'}))
                error('gdmkr:badUnits','The overlap_units are not valid. Choose ''px'', ''um'', or ''fraction''.');
            end
            if strcmp(obj.overlap_units,'fraction')
                if isempty(obj.overlap_x) %if 1_1
                    obj.overlap_x = round(obj.overlap*obj.pixWidth);
                else
                    obj.overlap_x = round(obj.overlap_x*obj.pixWidth);
                end
                if isempty(obj.overlap_y) %if 1_2
                    obj.overlap_y = round(obj.overlap*obj.pixHeight);
                else
                    obj.overlap_y = round(obj.overlap_y*obj.pixHeight);
                end
            elseif strcmp(obj.overlap_units,'um') %if 1
                obj.overlap = round(obj.overlap/obj.mmhandle.core.getPixelSizeUm);
                if isempty(obj.overlap_x) %if 1_1
                    obj.overlap_x = obj.overlap;
                else
                    obj.overlap_x = round(obj.overlap_x/obj.mmhandle.core.getPixelSizeUm);
                end
                if isempty(obj.overlap_y) %if 1_2
                    obj.overlap_y = obj.overlap;
                else
                    obj.overlap_y = round(obj.overlap_y/obj.mmhandle.core.getPixelSizeUm);
                end
                %%%
                % If the units are pixels then no conversion is made and
                % _overlap_x_ and _overlap_y_ are assessed.
            elseif strcmp(obj.overlap_units,'px') %if 2
                obj.overlap = round(obj.overlap);
                if isempty(obj.overlap_x) %if 2_1
                    obj.overlap_x = obj.overlap;
                else
                    obj.overlap_x = round(obj.overlap_x);
                end
                if isempty(obj.overlap_y) %if 2_2
                    obj.overlap_y = obj.overlap;
                else
                    obj.overlap_y = round(obj.overlap_y);
                end
            end
        end
        %%%
        % Is the upper-left corner above and to the left of the lower-right
        % corner? If not then the labels should be swapped, because between
        % any two points one must be above and to the left. This function
        % makes sure these points are labeled correctly.
        function obj = cornerCheck(obj)
            if ~isempty(obj.upper_left_corner) && ~isempty(obj.lower_right_corner)
                point1 = obj.upper_left_corner;
                point2 = obj.lower_right_corner;
                if obj.upper_left_corner(1)>obj.lower_right_corner(1) && obj.upper_left_corner(2)>obj.lower_right_corner(2)
                    obj.upper_left_corner = point2;
                    obj.lower_right_corner = point1;
                elseif obj.upper_left_corner(1)>obj.lower_right_corner(1) && obj.upper_left_corner(2)<obj.lower_right_corner(2)
                    obj.upper_left_corner(1) = point2(1);
                    obj.lower_right_corner(1) = point1(1);
                elseif obj.upper_left_corner(1)<obj.lower_right_corner(1) && obj.upper_left_corner(2)>obj.lower_right_corner(2)
                    obj.upper_left_corner(2) = point2(2);
                    obj.lower_right_corner(2) = point1(2);
                else
                    obj.upper_left_corner = point1;
                    obj.lower_right_corner = point2;
                end
            end
        end
        %%%
        %
        function obj = makeGrid(obj,gridType)
            obj.overlap2pixels;
            obj.cornerCheck;
            if ~isempty(obj.number_of_images)
                obj.number_of_images_flag = true;
                NOI_userinput = obj.number_of_images;
            end
            switch gridType
                case 'circle'
                    obj.findCircleGrid;
                    return
                case 'CEN-NOI'
                    %%%
                    % Specify upper-left and lower-right corners. The
                    % minRatio has been given a value of 9/16 or 0.5625.
                    % The maxRatio is 1 o
                    [NOI,im_num_row,im_num_col] = obj.findGridSize;
                    obj.number_of_images = NOI;
                    obj.number_of_columns = im_num_col;
                    obj.number_of_rows = im_num_row;
                    %%%
                    % update the coordinates for the upper-left and
                    % lower-right
                    obj.upper_left_corner = ...
                        [obj.centroid(1) - (im_num_col-1)/2*(obj.pixWidth-obj.overlap_x)*obj.mmhandle.core.getPixelSizeUm,...
                        obj.centroid(2) - (im_num_row-1)/2*(obj.pixHeight-obj.overlap_y)*obj.mmhandle.core.getPixelSizeUm,...
                        obj.centroid(3)];
                    obj.lower_right_corner = ...
                        [obj.centroid(1) + (im_num_col-1)/2*(obj.pixWidth-obj.overlap_x)*obj.mmhandle.core.getPixelSizeUm,...
                        obj.centroid(2) + (im_num_row-1)/2*(obj.pixHeight-obj.overlap_y)*obj.mmhandle.core.getPixelSizeUm,...
                        obj.centroid(3)];
                case 'LRC-NOI-ULC'
                    % Use when you want a given number of images to fill a
                    % given space. This means the overlap (or underlap?)
                    % between images must be calculated
                    areaWidth = obj.lower_right_corner(1) - obj.upper_left_corner(1);
                    areaHeight = obj.lower_right_corner(2) - obj.upper_left_corner(2);
                    ImageInWidth = areaWidth/obj.pixWidth;
                    ImageInHeight = areaHeight/obj.pixHeight;
                    NOIInArea = ImageInWidth*ImageInHeight;
                    ColumnReductionFactor = sqrt(NOIInArea/obj.number_of_images)*obj.pixHeight/obj.pixWidth;
                    im_num_col = ImageInWidth/ColumnReductionFactor;
                    im_num_row = obj.number_of_images/im_num_col;
                    im_num_col = round(im_num_col);
                    im_num_row = round(im_num_row);
                    NOI = im_num_col*im_num_row;
                    while NOI < obj.number_of_images
                        if im_num_col < im_num_row
                            im_num_col = im_num_col + 1;
                        else
                            im_num_row = im_num_row + 1;
                        end
                        NOI = im_num_col*im_num_row;
                    end
                    obj.number_of_images = NOI;
                    obj.number_of_columns = im_num_col;
                    obj.number_of_rows = im_num_row;
                    %%%
                    % The overlap between images in the x and y direction
                    % are determined.
                    obj.overlap_x = -(obj.lower_right_corner(1) - obj.upper_left_corner(1))/obj.mmhandle.core.getPixelSizeUm/(im_num_col-1)+obj.pixWidth;
                    obj.overlap_y = -(obj.lower_right_corner(2) - obj.upper_left_corner(2))/obj.mmhandle.core.getPixelSizeUm/(im_num_row-1)+obj.pixHeight;
                    obj.lower_right_corner = ...
                        [obj.upper_left_corner(1)+(im_num_col-1)*(obj.pixWidth-obj.overlap_x)*obj.mmhandle.core.getPixelSizeUm,...
                        obj.upper_left_corner(2)+(im_num_row-1)*(obj.pixHeight-obj.overlap_y)*obj.mmhandle.core.getPixelSizeUm,...
                        obj.lower_right_corner(3)];
                case 'NOI-ULC'
                    [NOI,im_num_row,im_num_col] = obj.findGridSize;
                    obj.number_of_images = NOI;
                    obj.number_of_columns = im_num_col;
                    obj.number_of_rows = im_num_row;
                    obj.lower_right_corner = ...
                        [obj.upper_left_corner(1) + (im_num_col-1)*(obj.pixWidth-obj.overlap_x)*obj.mmhandle.core.getPixelSizeUm,...
                        obj.upper_left_corner(2) + (im_num_row-1)*(obj.pixHeight-obj.overlap_y)*obj.mmhandle.core.getPixelSizeUm,...
                        obj.upper_left_corner(3)];
                case 'LRC-NOI'
                    [NOI,im_num_row,im_num_col] = obj.findGridSize;
                    obj.number_of_images = NOI;
                    obj.number_of_columns = im_num_col;
                    obj.number_of_rows = im_num_row;
                    obj.upper_left_corner = ...
                        [obj.lower_right_corner(1) - (im_num_col-1)*(obj.pixWidth-obj.overlap_x)*obj.mmhandle.core.getPixelSizeUm,...
                        obj.lower_right_corner(2) - (im_num_row-1)*(obj.pixHeight-obj.overlap_y)*obj.mmhandle.core.getPixelSizeUm,...
                        obj.lower_right_corner(3)];
                case 'CEN-NC-NR'
                    im_num_col = obj.number_of_columns;
                    im_num_row = obj.number_of_rows;
                    obj.number_of_images = im_num_col*im_num_row;
                    obj.upper_left_corner = ...
                        [obj.centroid(1) - (im_num_col-1)/2*(obj.pixWidth-obj.overlap_x)*obj.mmhandle.core.getPixelSizeUm,...
                        obj.centroid(2) - (im_num_row-1)/2*(obj.pixHeight-obj.overlap_y)*obj.mmhandle.core.getPixelSizeUm,...
                        pobj.centroid(3)];
                    obj.lower_right_corner = ...
                        [obj.centroid(1) + (im_num_col-1)/2*(obj.pixWidth-obj.overlap_x)*obj.mmhandle.core.getPixelSizeUm,...
                        obj.centroid(2) + (im_num_row-1)/2*(obj.pixHeight-obj.overlap_y)*obj.mmhandle.core.getPixelSizeUm,...
                        obj.centroid(3)];
                case 'NC-NR-ULC'
                    im_num_col = obj.number_of_columns;
                    im_num_row = obj.number_of_rows;
                    obj.number_of_images = im_num_col*im_num_row;
                    obj.lower_right_corner = ...
                        [obj.upper_left_corner(1) + (im_num_col-1)*(obj.pixWidth+obj.overlap_x)*obj.mmhandle.core.getPixelSizeUm,...
                        obj.upper_left_corner(2) + (im_num_row-1)*(obj.pixHeight-obj.overlap_y)*obj.mmhandle.core.getPixelSizeUm,...
                        obj.upper_left_corner(3)];
                case 'LRC-NC-NR'
                    im_num_col = obj.number_of_columns;
                    im_num_row = obj.number_of_rows;
                    obj.number_of_images = im_num_col*im_num_row;
                    obj.upper_left_corner = ...
                        [obj.lower_right_corner(1) - (im_num_col-1)*(obj.pixWidth-obj.overlap_x)*obj.mmhandle.core.getPixelSizeUm,...
                        obj.lower_right_corner(2) - (im_num_row-1)*(obj.pixHeight-obj.overlap_y)*obj.mmhandle.core.getPixelSizeUm,...
                        obj.lower_right_corner(3)];
                case 'LRC-ULC'
                    im_num_col = ceil((obj.lower_right_corner(1) - obj.upper_left_corner(1))/obj.mmhandle.core.getPixelSizeUm/(obj.pixWidth-obj.overlap_x));
                    im_num_row = ceil((obj.lower_right_corner(2) - obj.upper_left_corner(2))/obj.mmhandle.core.getPixelSizeUm/(obj.pixHeight-obj.overlap_y));
                    obj.number_of_images = im_num_col*im_num_row;
                    obj.number_of_columns = im_num_col;
                    obj.number_of_rows = im_num_row;
                    obj.lower_right_corner = ...
                        [obj.upper_left_corner(1)+(im_num_col-1)*(obj.pixWidth-obj.overlap_x)*obj.mmhandle.core.getPixelSizeUm,...
                        obj.upper_left_corner(2)+(im_num_row-1)*(obj.pixHeight-obj.overlap_y)*obj.mmhandle.core.getPixelSizeUm,...
                        obj.lower_right_corner(3)];
                otherwise
                    error('gdmkr:bad_param','The grid type entered cannot be interpreted. Please specify a valid grid type.');
            end
            
            %% create position list
            %
            %% Create a list of positions that consist of the grid
            % This section of code depends on the following variables being
            % properly defined:
            %
            % * im_num_col
            % * im_num_row
            % * NOI
            % * overlap_x
            % * overlap_y
            % * pixHeight
            % * pixWidth
            % * ULC
            if ~isfinite(obj.number_of_images)
                error('gdmkr:badNOI','The number of images requested led to ambiguous calculations.');
            end
            NOI = obj.number_of_images;
            positions = zeros(NOI,3);
            position_labels = cell(NOI,1);
            rowNumber = zeros(NOI,1);
            columnNumber = zeros(NOI,1);
            im_num_row = obj.number_of_rows;
            im_num_col = obj.number_of_columns;
            switch obj.path_strategy
                case 'CRLF'
                    for i=1:im_num_row
                        for j=1:im_num_col
                            ind = (i-1)*im_num_col+j;
                            positions(ind,:) = [...
                                obj.upper_left_corner(1)+(j-1)*obj.mmhandle.core.getPixelSizeUm*(obj.pixWidth-obj.overlap_x),...
                                obj.upper_left_corner(2)+(i-1)*obj.mmhandle.core.getPixelSizeUm*(obj.pixHeight-obj.overlap_y),...
                                obj.upper_left_corner(3)];
                            position_labels{ind} = sprintf('pos%d_x%d_y%d',ind,j,i);
                            rowNumber(ind) = i;
                            columnNumber(ind) = j;
                        end
                    end
                case 'snake'
                    ind = 0;
                    for i=1:im_num_row
                        if mod(i,2)==1
                            for j=1:im_num_col
                                ind = ind+1;
                                positions(ind,:) = [...
                                    obj.upper_left_corner(1)+(j-1)*obj.mmhandle.core.getPixelSizeUm*(obj.pixWidth+obj.overlap_x),...
                                    obj.upper_left_corner(2)+(i-1)*obj.mmhandle.core.getPixelSizeUm*(obj.pixHeight-obj.overlap_y),...
                                    obj.upper_left_corner(3)];
                                position_labels{ind} = sprintf('pos%d_x%d_y%d',ind,j,i);
                                rowNumber(ind) = i;
                                columnNumber(ind) = j;
                            end
                        else
                            for j=im_num_col:-1:1
                                ind = ind+1;
                                positions(ind,:) = [...
                                    obj.upper_left_corner(1)+(j-1)*obj.mmhandle.core.getPixelSizeUm*(obj.pixWidth-obj.overlap_x),...
                                    obj.upper_left_corner(2)+(i-1)*obj.mmhandle.core.getPixelSizeUm*(obj.pixHeight-obj.overlap_y),...
                                    obj.upper_left_corner(3)];
                                position_labels{ind} = sprintf('pos%d_x%d_y%d',ind,j,i);
                                rowNumber(ind) = i;
                                columnNumber(ind) = j;
                            end
                        end
                    end
                case 'Jacob Pyramid'
                    my_cols = 1:im_num_col/im_num_row:im_num_col;
                    my_cols = round(my_cols)-1;
                    my_cols2 = im_num_col - my_cols;
                    ind = 0;
                    for i=1:im_num_row
                        if my_cols(i) == 0
                            continue;
                        end
                        if mod(i,2)==1
                            for j=1:my_cols(i)
                                ind = ind+1;
                                positions(ind,:) = [...
                                    obj.upper_left_corner(1)+(j-1)*obj.mmhandle.core.getPixelSizeUm*(obj.pixWidth-obj.overlap_x),...
                                    obj.upper_left_corner(2)+(i-1)*obj.mmhandle.core.getPixelSizeUm*(obj.pixHeight-obj.overlap_y),...
                                    obj.upper_left_corner(3)];
                                position_labels{ind} = sprintf('pos%d_x%d_y%d',ind,j,i);
                                rowNumber(ind) = i;
                                columnNumber(ind) = j;
                            end
                        else
                            for j=my_cols(i):-1:1
                                ind = ind+1;
                                positions(ind,:) = [...
                                    obj.upper_left_corner(1)+(j-1)*obj.mmhandle.core.getPixelSizeUm*(obj.pixWidth-obj.overlap_x),...
                                    obj.upper_left_corner(2)+(i-1)*obj.mmhandle.core.getPixelSizeUm*(obj.pixHeight-obj.overlap_y),...
                                    obj.upper_left_corner(3)];
                                position_labels{ind} = sprintf('pos%d_x%d_y%d',ind,j,i);
                                rowNumber(ind) = i;
                                columnNumber(ind) = j;
                            end
                        end
                    end
                    for i=im_num_row:-1:1
                        if my_cols(i) == 0
                            continue;
                        end
                        if mod(i,2)==1
                            for j=1:my_cols2(i)
                                ind = ind+1;
                                positions(ind,:) = [...
                                    obj.upper_left_corner(1)+(j-1)*obj.mmhandle.core.getPixelSizeUm*(obj.pixWidth-obj.overlap_x),...
                                    obj.upper_left_corner(2)+(i-1)*obj.mmhandle.core.getPixelSizeUm*(obj.pixHeight-obj.overlap_y),...
                                    obj.upper_left_corner(3)];
                                position_labels{ind} = sprintf('pos%d_x%d_y%d',ind,j,i);
                                rowNumber(ind) = i;
                                columnNumber(ind) = j;
                            end
                        else
                            for j=my_cols2(i):-1:1
                                ind = ind+1;
                                positions(ind,:) = [...
                                    obj.upper_left_corner(1)+(j-1)*obj.mmhandle.core.getPixelSizeUm*(obj.pixWidth-obj.overlap_x),...
                                    obj.upper_left_corner(2)+(i-1)*obj.mmhandle.core.getPixelSizeUm*(obj.pixHeight-obj.overlap_y),...
                                    obj.upper_left_corner(3)];
                                position_labels{ind} = sprintf('pos%d_x%d_y%d',ind,j,i);
                                rowNumber(ind) = i;
                                columnNumber(ind) = j;
                            end
                        end
                    end
            end
            if obj.number_of_images_flag
                if NOI > NOI_userinput
                    positions(end-(NOI - NOI_userinput - 1):end,:) = [];
                    position_labels(end-(NOI - NOI_userinput - 1):end) = [];
                    rowNumber(end-(NOI - NOI_userinput - 1):end) = [];
                    columnNumber(end-(NOI - NOI_userinput - 1):end) = [];
                    NOI = length(position_labels);
                    obj.number_of_images = NOI;
                end
            end
            %%
            %
            if obj.calibration_angle_flag
                positions = obj.calibrationAngleCorrection(positions);
            end
            %% package the output in a struct
            %
            obj.grid.positions = positions;
            obj.grid.position_labels = position_labels;
            obj.grid.rowNumber = rowNumber;
            obj.grid.columnNumber = columnNumber;
            obj.grid.NOI = obj.number_of_images;
            obj.grid.ULC = obj.upper_left_corner;
            obj.grid.LRC = obj.lower_right_corner;
            obj.grid.im_num_col = obj.number_of_columns;
            obj.grid.im_num_row = obj.number_of_rows;
            obj.grid.overlap_x = obj.overlap_x;
            obj.grid.overlap_y = obj.overlap_y;
        end
        %% Update positions with calibration angle
        % * subtract the _centerOfMass_ from each point.
        % * rotate all points with the rotation matrix using the
        % calibration angle
        % * add the _centerOfMass_ back to every position
        function positions = calibrationAngleCorrection(obj,positions)
            if size(positions,1) > 1
                rotatedPositions = positions;
                centerOfMass = repmat(mean(positions),[size(positions,1),1]);
                centerOfMass(:,3) = [];
                rotatedPositions(:,1:2) = rotatedPositions(:,1:2) - centerOfMass;
                rotationMatrix = [cosd(obj.mmhandle.calibrationAngle), -sind(obj.mmhandle.calibrationAngle); sind(obj.mmhandle.calibrationAngle), cosd(obj.mmhandle.calibrationAngle)];
                rotatedPositions(:,1:2) = (rotationMatrix * rotatedPositions(:,1:2)')';
                rotatedPositions(:,1:2) = rotatedPositions(:,1:2) + centerOfMass;
                positions = rotatedPositions;
            end
        end
        %% findGridSize
        % It is suprising to find that the dimensions of a grid are not
        % trivially determined when only given the number of images to
        % collect, because an arbitrary constraint is required. An
        % algorithm was created to find the _most square_ grid that comes
        % closest to the desired number of images without going beyond a
        % height to width ratio with a lower bound of _minRatio_ and an
        % upper bound of _maxRatio_. If the suggested dimensions contain
        % fewer images then the desired amount, an extra row or column is
        % added until the grid contains more images than the desired
        % amount. Later on, the final row is trimmed to match the exact of
        % images requested.
        %
        % The size of the image must also be taken into consideration. For
        % example, if the height to with ratio is 2/3 a square imaging
        % space would consist of subgrids with 3 rows and 2 columns. Also,
        % for this reason, the overlap is taken into consideration.
        %
        % Finally, the minimum aspect ratio is set to be 9:16 and the width
        % of the grid will always have more length than the height.
        function [NOI,im_num_row,im_num_col] = findGridSize(obj)
            imageRatio = (obj.pixHeight - obj.overlap_y)/(obj.pixWidth-obj.overlap_x); %height/width
            widthCandidates = floor((sqrt(obj.number_of_images*imageRatio./(linspace(0.5625/imageRatio,1,10))))/imageRatio);
            objectiveArray = mod(obj.number_of_images,widthCandidates);
            [~,ind] = min(objectiveArray);
            im_num_col = floor(widthCandidates(ind)/imageRatio); %un-adjust for the size of a non-square image
            im_num_row = floor(obj.number_of_images/im_num_col);
            NOI = im_num_col*im_num_row;
            while NOI < obj.number_of_images
                if im_num_col < im_num_row
                    im_num_col = im_num_col + 1;
                else
                    im_num_row = im_num_row + 1;
                end
                NOI = im_num_col*im_num_row;
            end
        end
        %% findCircleGrid
        % This function is not nearly as cool as I thought it would be when
        % I set out to create it. The motivation was to capture the
        % entirety of a round glass surface and ensuring that the objective
        % would always be centered underneath the glass, which is not
        % guarunteed if the area being imaged is a sqaure that encompasses
        % the glass. As it turns out it, a square fits rather neatly inside
        % of a circle. It looks like for large, round glass surfaces the
        % best benefit might be a 150% increase in image coverage. For
        % smaller circles this improvement decreases.
        function [obj] = findCircleGrid(obj)
            imageWidthOffset = obj.mmhandle.core.getImageWidth*obj.mmhandle.core.getPixelSizeUm*cosd(obj.mmhandle.calibrationAngle);
            myRadius = (obj.diameter+imageWidthOffset)/2;
            upperLeftCorner = [obj.centroid-myRadius,obj.centroid-myRadius,obj.centroid];
            lowerRightCorner = [obj.centroid+myRadius,obj.centroid+myRadius,obj.centroid];
            templateGrid = SuperMDA_grid_maker(obj.mmhandle,'overlap_x',obj.overlap_x,'overlap_y',obj.overlap_y,'upper_left_corner',upperLeftCorner,'lower_right_corner',lowerRightCorner,'overlap_units','px');
            columnStart = zeros(templateGrid.im_num_row,1);
            columnEnd = zeros(templateGrid.im_num_row,1);
            for i = 1:templateGrid.im_num_row
                yMin = min(templateGrid.positions(templateGrid.rowNumber == i,2));
                if abs(obj.centroid-yMin) > myRadius
                    columnStart(i) = templateGrid.im_num_col + 1;
                    continue;
                end
                xCutoff = obj.centroid - sqrt(myRadius^2-(obj.centroid-yMin)^2) - imageWidthOffset/4;
                columnStart(i) = min(templateGrid.columnNumber(templateGrid.positions(:,1) > xCutoff & templateGrid.rowNumber == i));
            end
            for i = 1:templateGrid.im_num_row
                yMax = max(templateGrid.positions(templateGrid.rowNumber == i,2));
                if abs(obj.centroid-yMax) > myRadius
                    columnEnd(i) = 0;
                    continue;
                end
                xCutoff = obj.centroid + sqrt(myRadius^2-(obj.centroid-yMax)^2) - imageWidthOffset/4;
                columnEnd(i) = max(templateGrid.columnNumber(templateGrid.positions(:,1) < xCutoff & templateGrid.rowNumber == i));
            end
            images2KeepLogical = false(templateGrid.NOI,1);
            for i = 1:templateGrid.im_num_row
                myLogical = templateGrid.rowNumber == i & templateGrid.columnNumber >= columnStart(i) & templateGrid.columnNumber <= columnEnd(i);
                images2KeepLogical = images2KeepLogical | myLogical;
            end
            obj.grid = templateGrid;
            obj.grid.positions = obj.grid.positions(images2KeepLogical,:);
            obj.grid.position_labels = obj.grid.position_labels(images2KeepLogical);
            obj.grid.rowNumber = obj.grid.rowNumber(images2KeepLogical);
            obj.grid.columnNumber = obj.grid.columnNumber(images2KeepLogical);
        end
        %%
        %
        function obj = reset(obj)
            obj.number_of_images = '';
            obj.number_of_columns = '';
            obj.number_of_rows = '';
            obj.centroid = '';
            obj.upper_left_corner = '';
            obj.lower_right_corner = '';
            obj.overlap = 0;
            obj.overlap_x = '';
            obj.overlap_y = '';
            obj.diameter = '';
            obj.overlap_units = 'fraction';
            obj.path_strategy = 'snake';
            obj.pixWidth = '';
            obj.pixHeight = '';
            obj.grid = '';
            obj.number_of_images_flag = false;
            obj.calibration_angle_flag = true;
        end
    end
end
