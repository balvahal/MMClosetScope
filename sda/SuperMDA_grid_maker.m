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
% What is meant by ULC and LRC and the centroid? The ULC and LRC
% are positions on the stage and do not represent any particular
% pixel in an image. The position could represent any particular
% pixel in the image, so I like to imagine it as the upper-left
% corner pixel or the traditional first pixel in an image. When
% making a grid of images this means that the ULC will be the same
% as the first pixel in the first image, but the LRC will be the
% last pixel of the area covered by the grid offset by the length
% and height of a single image. The centroid could be the actual
% pixel that is the center of a grid or the first pixel of the
% image that is deemed to be the center image. This is the
% challenge of keeping track of regions with area using a point.
% However, to keep the convention of the first pixel in an image
% being represented by the stage position then the centroid shall
% represent the first pixel as well. This will make the math
% consistent. When images are abstracted as points the math will be
% performed with reference to the first pixel of each image.
function [grid] = SuperMDA_grid_maker(mmhandle,varargin)
%% Parse the input
% A grid of images can be defined by many combinations of its
% characteristics, but each combination must either directly or implicitly
% specify a point of reference, the number of rows and columns of the grid,
% and the spacing between images. This function will accept a variety of
% parameter combinations and a significant amount of code in this function
% deals with identifying and evaluating valid combinations. In addition,
% beyond combinations of grid characteristics, the path traveresed across
% can also be specified.
p = inputParser;
addRequired(p, 'mmhandle', @(x) isa(x,'Core_MicroManagerHandle'));
addParameter(p, 'number_of_images', 'undefined', @(x) mod(x,1)==0);
addParameter(p, 'number_of_columns', 'undefined', @(x) mod(x,1)==0);
addParameter(p, 'number_of_rows', 'undefined', @(x) mod(x,1)==0);
addParameter(p, 'centroid', 'undefined', @(x) numel(x) == 3);
addParameter(p, 'upper_left_corner', 'undefined', @(x) numel(x) == 3);
addParameter(p, 'lower_right_corner', 'undefined', @(x) numel(x) == 3);
addParameter(p, 'overlap', 0, @isnumeric);
addParameter(p, 'overlap_x', 'undefined', @isnumeric);
addParameter(p, 'overlap_y', 'undefined', @isnumeric);
addParameter(p, 'diameter', 'undefined', @isnumeric);
addParameter(p, 'overlap_units','fraction',@(x) any(strcmp(x,{'px', 'um', 'fraction'})));
addParameter(p, 'path_strategy','snake',@(x) any(strcmp(x,{'snake','CRLF','Jacob Pyramid'})));
parse(p,mmhandle,varargin{:});
%% Examine _overlap_units_ parameter
% This function requires the _overlap_units_ to be in the dimensions of
% pixels (|px|). Therefore, if the units have been specified as
% micro-meters (|um|), a conversion must be made. In addition, if the
% overlap in the x and y directions are not explicity defined, then the
% value chosen for _overlap_ parameter is used.
%
% If the units are micro-meters then a conversion is made. _overlap_x_ and
% _overlap_y_ are defined. The code ultimately depends on _overlap_x_ and
% _overlap_y_, not _overlap_.
pixWidth = mmhandle.core.getImageWidth;
pixHeight = mmhandle.core.getImageHeight;
if strcmp(p.Results.overlap_units,'fraction')
    if strcmp(p.Results.overlap_x,'undefined') %if 1_1
        overlap_x = round(p.Results.overlap*pixWidth);
    else
        overlap_x = round(p.Results.overlap_x*pixWidth);
    end
    if strcmp(p.Results.overlap_y,'undefined') %if 1_2
        overlap_y = round(p.Results.overlap*pixHeight);
    else
        overlap_y = round(p.Results.overlap_y*pixHeight);
    end
elseif strcmp(p.Results.overlap_units,'um') %if 1
    overlap = round(p.Results.overlap/mmhandle.core.getPixelSizeUm);
    if strcmp(p.Results.overlap_x,'undefined') %if 1_1
        overlap_x = overlap;
    else
        overlap_x = round(p.Results.overlap_x/mmhandle.core.getPixelSizeUm);
    end
    if strcmp(p.Results.overlap_y,'undefined') %if 1_2
        overlap_y = overlap;
    else
        overlap_y = round(p.Results.overlap_y/mmhandle.core.getPixelSizeUm);
    end
    %%%
    % If the units are pixels then no conversion is made and _overlap_x_
    % and _overlap_y_ are assessed.
elseif strcmp(p.Results.overlap_units,'px') %if 2
    overlap = round(p.Results.overlap);
    if strcmp(p.Results.overlap_x,'undefined') %if 2_1
        overlap_x = overlap;
    else
        overlap_x = round(p.Results.overlap_x);
    end
    if strcmp(p.Results.overlap_y,'undefined') %if 2_2
        overlap_y = overlap;
    else
        overlap_y = round(p.Results.overlap_y);
    end
end
%% Number of Images Conflict
% While there are many grid characteristics combinations that work there
% are many grid combintations that do not. The following code will identify
% bad combinations.
%
% If the number or images is defined in addition to the number of rows and
% columns, then there is the possibility that these do not agree. If the
% number of rows and columns are given, then the number of images should be
% equal to their product.
if (~strcmp(p.Results.number_of_images, 'undefined')) && (~strcmp(p.Results.number_of_columns, 'undefined')) && (~strcmp(p.Results.number_of_rows, 'undefined')) %if 3
    if p.Results.number_of_columns*p.Results.number_of_rows ~= p.Results.number_of_images %if 3_1
        error('GridMake:bad_rowCol','The number of rows and columns does not agree with the number of images');
    end
end
%% Number of Images Flag
% If the number of images has been defined explicity then a grid will be
% formed with exactly that number. However, when a grid is created and the
% rows and columns prodcut may not contain the correct number of images. In
% this case images from the last row are removed or and extra, partial row
% is added.
%
% a flag variable is created to store this particular event, so action can
% be taken later.
if ~strcmp(p.Results.number_of_images, 'undefined') %if 4
    wasNumOfImDefinedFlag = true;
else
    wasNumOfImDefinedFlag = false;
end
%% ULC and LRC Reversal Conflict
% Is the upper-left corner above and to the left of the lower-right corner?
% If not then the labels should be swapped, because between any two points
% one must be above and to the left. This function makes sure these points
% are labeled correctly.
if (~strcmp(p.Results.upper_left_corner,'undefined')) && (~strcmp(p.Results.lower_right_corner,'undefined')) %if 5
    if5Point1 = p.Results.upper_left_corner;
    if5Point2 = p.Results.lower_right_corner;
    upper_left_corner = if5Point1;
    lower_right_corner = if5Point2;
    if p.Results.upper_left_corner(1)>p.Results.lower_right_corner(1) && p.Results.upper_left_corner(2)>p.Results.lower_right_corner(2) %if 5_1
        upper_left_corner = if5Point2;
        lower_right_corner = if5Point1;
    elseif p.Results.upper_left_corner(1)>p.Results.lower_right_corner(1) && p.Results.upper_left_corner(2)<p.Results.lower_right_corner(2) %if 5_2
        upper_left_corner(1) = if5Point2(1);
        lower_right_corner(1) = if5Point1(1);
    elseif p.Results.upper_left_corner(1)<p.Results.lower_right_corner(1) && p.Results.upper_left_corner(2)>p.Results.lower_right_corner(2) %if 5_3
        upper_left_corner(2) = if5Point2(2);
        lower_right_corner(2) = if5Point1(2);
    else
        upper_left_corner = if5Point1;
        lower_right_corner = if5Point2;
    end
end
%% Parse valid combinations of grid characteristics
% The grid to be made depends upon the collection of parameters that were
% specified when the function was called. The parameters that default to
% the string 'undefined' determine the type of grid to be made. Like a
% barcode, a logical array is created, identifying which of the parameters
% were left undefined with a logical 1. User-specified parameters are
% logical 0.
%
% The parameters that do not default to 'undefined' are not part of the
% decision array. After the decision array is defined it is converted into
% a base 10 number.
barcodeParameters = {'diameter','number_of_images','number_of_columns','number_of_rows','centroid','upper_left_corner','lower_right_corner'};
decision_array = ones(1,numel(barcodeParameters));
for i = 1:(numel(barcodeParameters))
    if strcmp(p.Results.(barcodeParameters{i}),'undefined')
        decision_array(i) = 0;
    end
end
decision_number = bin2dec(int2str(decision_array));
%% Fill in the blanks
% From the user input several variables must be defined in order to
% calculate and define a grid.
%
% * im_num_col: number of columns
% * im_num_row: number of rows
% * NOI: number of images total
% * overlap_x: pixel overlap between images in the x direction (and already
% defined above).
% * overlap_y: pixel overlap between images in the y direction (and already
% defined above).
% * pixHeight: image height in pixels
% * pixWidth: image width in pixels
% * ULC: the upper lefthand corner of the grid.
%
% These variables are either directly defined by the user input or
% implicity defined. A switch case code block and the |decision_number|
% will determine the correct code to execute in order to "fill in any
% blanks" in the list of variables above.
%%%
% Valid Parameter combinations
%
% #
%
% The uManager core object can be queried for the height and width of the
% image, but for code readability these values are stored in separate
% variables and are necessary for defining the image grid.

%% The switch-case code block
%
switch decision_number
    %% _centroid_ and _diameter_
    % A circular area will be imaged. First, create a template grid that
    % is a square that covers the area of the circle. Then, going row by
    % row, determine which images are inside the circle, removing the rest.
    case 68 % centroid and diameter
        grid = findCircleGrid(mmhandle,p.Results.diameter,p.Results.centroid,overlap_x,overlap_y);
        return;
        %% _centroid_ and _number_of_images_
        % The _centroid_ and _number_of_images_ was defined by the user. In
        % this case the shape of the grid will be automatically determined.
    case 36 %centroid + number_of_images
        %%%
        % Specify upper-left and lower-right corners. The minRatio has been
        % given a value of 9/16 or 0.5625. The maxRatio is 1 o
        [NOI,im_num_row,im_num_col] = findGridSize(p.Results.number_of_images,pixWidth,pixHeight,overlap_x,overlap_y);
        %%%
        % update the coordinates for the upper-left and lower-right
        ULC = ...
            [p.Results.centroid(1) - (im_num_col-1)/2*(pixWidth-overlap_x)*mmhandle.core.getPixelSizeUm,...
            p.Results.centroid(2) - (im_num_row-1)/2*(pixHeight-overlap_y)*mmhandle.core.getPixelSizeUm,...
            p.Results.centroid(3)];
        LRC = ...
            [p.Results.centroid(1) + (im_num_col-1)/2*(pixWidth-overlap_x)*mmhandle.core.getPixelSizeUm,...
            p.Results.centroid(2) + (im_num_row-1)/2*(pixHeight-overlap_y)*mmhandle.core.getPixelSizeUm,...
            p.Results.centroid(3)];
        %% _upper_left_corner_, _lower_right_corner_, and _number of images_
        %
    case 35 %upper-left, lower-right, and number of images
        % Use when you want a given number of images to fill a given space.
        % This means the overlap (or underlap?) between images must be
        % calculated
        case35areaWidth = lower_right_corner(1) - upper_left_corner(1);
        case35areaHeight = lower_right_corner(2) - upper_left_corner(2);
        case35ImageInWidth = case35areaWidth/pixWidth;
        case35ImageInHeight = case35areaHeight/pixHeight;
        case35NOIInArea = case35ImageInWidth*case35ImageInHeight;
        case35ColumnReductionFactor = sqrt(case35NOIInArea/p.Results.number_of_images)*pixHeight/pixWidth;
        im_num_col = case35ImageInWidth/case35ColumnReductionFactor;
        im_num_row = p.Results.number_of_images/im_num_col;
        im_num_col = round(im_num_col);
        im_num_row = round(im_num_row);
        NOI = im_num_col*im_num_row;
        while NOI < p.Results.number_of_images
            if im_num_col < im_num_row
                im_num_col = im_num_col + 1;
            else
                im_num_row = im_num_row + 1;
            end
            NOI = im_num_col*im_num_row;
        end
        %%%
        % The overlap between images in the x and y direction are
        % determined.
        overlap_x = -(lower_right_corner(1) - upper_left_corner(1))/mmhandle.core.getPixelSizeUm/(im_num_col-1)+pixWidth;
        overlap_y = -(lower_right_corner(2) - upper_left_corner(2))/mmhandle.core.getPixelSizeUm/(im_num_row-1)+pixHeight;
        ULC = upper_left_corner;
        LRC = ...
            [ULC(1)+(im_num_col-1)*(pixWidth-overlap_x)*mmhandle.core.getPixelSizeUm,...
            ULC(2)+(im_num_row-1)*(pixHeight-overlap_y)*mmhandle.core.getPixelSizeUm,...
            lower_right_corner(3)];
        %% _upper_left_corner_ and _number_of_images_
        %
    case 34 %upper_left_corner and number_of_images
        [NOI,im_num_row,im_num_col] = findGridSize(p.Results.number_of_images,pixWidth,pixHeight,overlap_x,overlap_y);
        ULC = p.Results.upper_left_corner;
        LRC = ...
            [ULC(1) + (im_num_col-1)*(pixWidth-overlap_x)*mmhandle.core.getPixelSizeUm,...
            ULC(2) + (im_num_row-1)*(pixHeight-overlap_y)*mmhandle.core.getPixelSizeUm,...
            ULC(3)];
        %% _lower_right_corner_ and _number_of_images_
        %
    case 33 %lower_right_corner and number_of_images
        [NOI,im_num_row,im_num_col] = findGridSize(p.Results.number_of_images,pixWidth,pixHeight,overlap_x,overlap_y);
        LRC = p.Results.lower_right_corner;
        ULC = ...
            [LRC(1) - (im_num_col-1)*(pixWidth-overlap_x)*mmhandle.core.getPixelSizeUm,...
            LRC(2) - (im_num_row-1)*(pixHeight-overlap_y)*mmhandle.core.getPixelSizeUm,...
            LRC(3)];
        %% _number_of_columns_, _number_of_rows_, and _centroid_
        %
    case 28 %number_of_columns, number_of_rows, and centroid
        im_num_col = p.Results.number_of_columns;
        im_num_row = p.Results.number_of_rows;
        NOI = im_num_col*im_num_row;
        ULC = ...
            [p.Results.centroid(1) - (im_num_col-1)/2*(pixWidth-overlap_x)*mmhandle.core.getPixelSizeUm,...
            p.Results.centroid(2) - (im_num_row-1)/2*(pixHeight-overlap_y)*mmhandle.core.getPixelSizeUm,...
            p.Results.centroid(3)];
        LRC = ...
            [p.Results.centroid(1) + (im_num_col-1)/2*(pixWidth-overlap_x)*mmhandle.core.getPixelSizeUm,...
            p.Results.centroid(2) + (im_num_row-1)/2*(pixHeight-overlap_y)*mmhandle.core.getPixelSizeUm,...
            p.Results.centroid(3)];
        %% _number_of_rows_, _number_of_columns_, and _upper_left_corner_
        %
    case 26 %number_of_rows, number_of_columns, and upper_left_corner
        im_num_col = p.Results.number_of_columns;
        im_num_row = p.Results.number_of_rows;
        NOI = im_num_col*im_num_row;
        ULC = p.Results.upper_left_corner;
        LRC = ...
            [ULC(1) + (im_num_col-1)*(pixWidth+overlap_x)*mmhandle.core.getPixelSizeUm,...
            ULC(2) + (im_num_row-1)*(pixHeight-overlap_y)*mmhandle.core.getPixelSizeUm,...
            ULC(3)];
        %% _number_of_rows_, _number_of_columns_, and _lower_right_corner_
        %
    case 25 %number_of_rows, number_of_columns, and upper_left_corner
        im_num_col = p.Results.number_of_columns;
        im_num_row = p.Results.number_of_rows;
        NOI = im_num_col*im_num_row;
        LRC = p.Results.lower_right_corner;
        ULC = ...
            [LRC(1) - (im_num_col-1)*(pixWidth-overlap_x)*mmhandle.core.getPixelSizeUm,...
            LRC(2) - (im_num_row-1)*(pixHeight-overlap_y)*mmhandle.core.getPixelSizeUm,...
            LRC(3)];
        %% _upper_left_corner_ and _lower_right_corner_
        %
    case 3 %upper_left_corner and lower_right_corner
        im_num_col = ceil((p.Results.lower_right_corner(1) - p.Results.upper_left_corner(1))/mmhandle.core.getPixelSizeUm/(pixWidth-overlap_x));
        im_num_row = ceil((p.Results.lower_right_corner(2) - p.Results.upper_left_corner(2))/mmhandle.core.getPixelSizeUm/(pixHeight-overlap_y));
        NOI = im_num_col*im_num_row;
        ULC = p.Results.upper_left_corner;
        LRC = ...
            [ULC(1)+(im_num_col-1)*(pixWidth-overlap_x)*mmhandle.core.getPixelSizeUm,...
            ULC(2)+(im_num_row-1)*(pixHeight-overlap_y)*mmhandle.core.getPixelSizeUm,...
            p.Results.lower_right_corner(3)];
    otherwise
        error('GridMake:bad_param','The set parameters entered cannot be interpreted. Please specify a valid set of parameters');
end

%% Create a list of positions that consist of the grid
% This section of code depends on the following variables being properly
% defined:
%
% * im_num_col
% * im_num_row
% * NOI
% * overlap_x
% * overlap_y
% * pixHeight
% * pixWidth
% * ULC
if ~isfinite(NOI)
    error('GridMake:badNOI','The number of images requested led to ambiguous calculations.');
end
positions = zeros(NOI,3);
position_labels = cell(NOI,1);
rowNumber = zeros(NOI,1);
columnNumber = zeros(NOI,1);
if strcmp(p.Results.path_strategy,'CRLF')
    for i=1:im_num_row
        for j=1:im_num_col
            ind = (i-1)*im_num_col+j;
            positions(ind,:) = [...
                ULC(1)+(j-1)*mmhandle.core.getPixelSizeUm*(pixWidth-overlap_x),...
                ULC(2)+(i-1)*mmhandle.core.getPixelSizeUm*(pixHeight-overlap_y),...
                ULC(3)];
            position_labels{ind} = sprintf('pos%d_x%d_y%d',ind,j,i);
            rowNumber(ind) = i;
            columnNumber(ind) = j;
        end
    end
elseif strcmp(p.Results.path_strategy,'snake')
    ind = 0;
    for i=1:im_num_row
        if mod(i,2)==1
            for j=1:im_num_col
                ind = ind+1;
                positions(ind,:) = [...
                    ULC(1)+(j-1)*mmhandle.core.getPixelSizeUm*(pixWidth+overlap_x),...
                    ULC(2)+(i-1)*mmhandle.core.getPixelSizeUm*(pixHeight-overlap_y),...
                    ULC(3)];
                position_labels{ind} = sprintf('pos%d_x%d_y%d',ind,j,i);
                rowNumber(ind) = i;
                columnNumber(ind) = j;
            end
        else
            for j=im_num_col:-1:1
                ind = ind+1;
                positions(ind,:) = [...
                    ULC(1)+(j-1)*mmhandle.core.getPixelSizeUm*(pixWidth-overlap_x),...
                    ULC(2)+(i-1)*mmhandle.core.getPixelSizeUm*(pixHeight-overlap_y),...
                    ULC(3)];
                position_labels{ind} = sprintf('pos%d_x%d_y%d',ind,j,i);
                rowNumber(ind) = i;
                columnNumber(ind) = j;
            end
        end
    end
elseif strcmp(p.Results.path_strategy,'Jacob Pyramid')
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
                    ULC(1)+(j-1)*mmhandle.core.getPixelSizeUm*(pixWidth-overlap_x),...
                    ULC(2)+(i-1)*mmhandle.core.getPixelSizeUm*(pixHeight-overlap_y),...
                    ULC(3)];
                position_labels{ind} = sprintf('pos%d_x%d_y%d',ind,j,i);
                rowNumber(ind) = i;
                columnNumber(ind) = j;
            end
        else
            for j=my_cols(i):-1:1
                ind = ind+1;
                positions(ind,:) = [...
                    ULC(1)+(j-1)*mmhandle.core.getPixelSizeUm*(pixWidth-overlap_x),...
                    ULC(2)+(i-1)*mmhandle.core.getPixelSizeUm*(pixHeight-overlap_y),...
                    ULC(3)];
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
                    ULC(1)+(j-1)*mmhandle.core.getPixelSizeUm*(pixWidth-overlap_x),...
                    ULC(2)+(i-1)*mmhandle.core.getPixelSizeUm*(pixHeight-overlap_y),...
                    ULC(3)];
                position_labels{ind} = sprintf('pos%d_x%d_y%d',ind,j,i);
                rowNumber(ind) = i;
                columnNumber(ind) = j;
            end
        else
            for j=my_cols2(i):-1:1
                ind = ind+1;
                positions(ind,:) = [...
                    ULC(1)+(j-1)*mmhandle.core.getPixelSizeUm*(pixWidth-overlap_x),...
                    ULC(2)+(i-1)*mmhandle.core.getPixelSizeUm*(pixHeight-overlap_y),...
                    ULC(3)];
                position_labels{ind} = sprintf('pos%d_x%d_y%d',ind,j,i);
                rowNumber(ind) = i;
                columnNumber(ind) = j;
            end
        end
    end
end
if wasNumOfImDefinedFlag
    if NOI > p.Results.number_of_images
        positions(end-(NOI - p.Results.number_of_images - 1):end,:) = [];
        position_labels(end-(NOI - p.Results.number_of_images - 1):end) = [];
        rowNumber(end-(NOI - p.Results.number_of_images - 1):end) = [];
        columnNumber(end-(NOI - p.Results.number_of_images - 1):end) = [];
        NOI = length(position_labels);
    end
end

%% Update positions with calibration angle
% * subtract the _centerOfMass_ from each point.
% * rotate all points with the rotation matrix using the calibration angle
% * add the _centerOfMass_ back to every position
if size(positions,1) > 1
    rotatedPositions = positions;
    centerOfMass = repmat(mean(positions),[size(positions,1),1]);
    centerOfMass(:,3) = [];
    rotatedPositions(:,1:2) = rotatedPositions(:,1:2) - centerOfMass;
    rotationMatrix = [cosd(mmhandle.calibrationAngle), -sind(mmhandle.calibrationAngle); sind(mmhandle.calibrationAngle), cosd(mmhandle.calibrationAngle)];
    rotatedPositions(:,1:2) = (rotationMatrix * rotatedPositions(:,1:2)')';
    rotatedPositions(:,1:2) = rotatedPositions(:,1:2) + centerOfMass;
    positions = rotatedPositions;
end
%% package the output in a struct
%
grid.positions = positions;
grid.position_labels = position_labels;
grid.rowNumber = rowNumber;
grid.columnNumber = columnNumber;
grid.NOI = NOI;
grid.ULC = ULC;
grid.LRC = LRC;
grid.im_num_col = im_num_col;
grid.im_num_row = im_num_row;
grid.overlap_x = overlap_x;
grid.overlap_y = overlap_y;
end

%% findGridSize
% It is suprising to find that the dimensions of a grid are not trivially
% determined when only given the number of images to collect, because an
% arbitrary constraint is required. An algorithm was created to find the
% _most square_ grid that comes closest to the desired number of images
% without going beyond a height to width ratio with a lower bound of
% _minRatio_ and an upper bound of _maxRatio_. If the suggested dimensions
% contain fewer images then the desired amount, an extra row or column is
% added until the grid contains more images than the desired amount. Later
% on, the final row is trimmed to match the exact of images requested.
%
% The size of the image must also be taken into consideration. For example,
% if the height to with ratio is 2/3 a square imaging space would consist
% of subgrids with 3 rows and 2 columns. Also, for this reason, the overlap
% is taken into consideration.
%
% Finally, the minimum aspect ratio is set to be 9:16 and the width of the
% grid will always have more length than the height.
function [NOI,im_num_row,im_num_col] = findGridSize(numberOfImages,pixWidth,pixHeight,overlap_x,overlap_y)
imageRatio = (pixHeight - overlap_y)/(pixWidth-overlap_x); %height/width
widthCandidates = floor((sqrt(numberOfImages*imageRatio./(linspace(0.5625/imageRatio,1,10))))/imageRatio);
objectiveArray = mod(numberOfImages,widthCandidates);
[~,ind] = min(objectiveArray);
im_num_col = floor(widthCandidates(ind)/imageRatio); %un-adjust for the size of a non-square image
im_num_row = floor(numberOfImages/im_num_col);
NOI = im_num_col*im_num_row;
while NOI < numberOfImages
    if im_num_col < im_num_row
        im_num_col = im_num_col + 1;
    else
        im_num_row = im_num_row + 1;
    end
    NOI = im_num_col*im_num_row;
end
end
%% findCircleGrid
% This function is not nearly as cool as I thought it would be when I set
% out to create it. The motivation was to capture the entirety of a round
% glass surface and ensuring that the objective would always be centered
% underneath the glass, which is not guarunteed if the area being imaged is
% a sqaure that encompasses the glass. As it turns out it, a square fits
% rather neatly inside of a circle. It looks like for large, round glass
% surfaces the best benefit might be a 150% increase in image coverage. For
% smaller circles this improvement decreases.
function [grid] = findCircleGrid(mmhandle,diameter,centroid,overlap_x,overlap_y)
imageWidthOffset = mmhandle.core.getImageWidth*mmhandle.core.getPixelSizeUm*cosd(mmhandle.calibrationAngle);
myRadius = (diameter+imageWidthOffset)/2;
upperLeftCorner = [centroid(1)-myRadius,centroid(2)-myRadius,centroid(3)];
lowerRightCorner = [centroid(1)+myRadius,centroid(2)+myRadius,centroid(3)];
templateGrid = SuperMDA_grid_maker(mmhandle,'overlap_x',overlap_x,'overlap_y',overlap_y,'upper_left_corner',upperLeftCorner,'lower_right_corner',lowerRightCorner,'overlap_units','px');
columnStart = zeros(templateGrid.im_num_row,1);
columnEnd = zeros(templateGrid.im_num_row,1);
for i = 1:templateGrid.im_num_row
    yMin = min(templateGrid.positions(templateGrid.rowNumber == i,2));
    if abs(centroid(2)-yMin) > myRadius
        columnStart(i) = templateGrid.im_num_col + 1;
        continue;
    end
    xCutoff = centroid(1) - sqrt(myRadius^2-(centroid(2)-yMin)^2) - imageWidthOffset/4;
    columnStart(i) = min(templateGrid.columnNumber(templateGrid.positions(:,1) > xCutoff & templateGrid.rowNumber == i));
end
for i = 1:templateGrid.im_num_row
    yMax = max(templateGrid.positions(templateGrid.rowNumber == i,2));
    if abs(centroid(2)-yMax) > myRadius
        columnEnd(i) = 0;
        continue;
    end
    xCutoff = centroid(1) + sqrt(myRadius^2-(centroid(2)-yMax)^2) - imageWidthOffset/4;
    columnEnd(i) = max(templateGrid.columnNumber(templateGrid.positions(:,1) < xCutoff & templateGrid.rowNumber == i));
end
images2KeepLogical = false(templateGrid.NOI,1);
for i = 1:templateGrid.im_num_row
    myLogical = templateGrid.rowNumber == i & templateGrid.columnNumber >= columnStart(i) & templateGrid.columnNumber <= columnEnd(i);
    images2KeepLogical = images2KeepLogical | myLogical;
end
grid = templateGrid;
grid.positions = grid.positions(images2KeepLogical,:);
grid.position_labels = grid.position_labels(images2KeepLogical);
grid.rowNumber = grid.rowNumber(images2KeepLogical);
grid.columnNumber = grid.columnNumber(images2KeepLogical);
end