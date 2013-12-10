%%
% It is assumed that the origin is in the ULC and x increases due east and
% y increases due south when the stage is viewed from above.
function [mmhandle,NOI,ULC,LRC] = super_mda_grid_maker(mmhandle,varargin)
p = inputParser;
addRequired(p, 'mmhandle', @isstruct);
addParameter(p, 'number_of_images', 'undefined', @(x) mod(x,1)==0);
addParameter(p, 'number_of_columns', 'undefined', @(x) mod(x,1)==0);
addParameter(p, 'number_of_rows', 'undefined', @(x) mod(x,1)==0);
addParameter(p, 'centroid', 'undefined', @(x) numel(x) == 3);
addParameter(p, 'upper_left_corner', 'undefined', @(x) numel(x) == 3);
addParameter(p, 'lower_right_corner', 'undefined', @(x) numel(x) == 3);
addParameter(p, 'overlap', 0, @isnumeric);
addParameter(p, 'overlap_x', 'undefined', @isnumeric);
addParameter(p, 'overlap_y', 'undefined', @isnumeric);
addParameter(p, 'overlap_units','px',@(x) any(strcmp(x,{'px', 'um'})));

parse(p,mmhandle,varargin{:});
%% the units of overlap must be pixels for the ensuing calculations
%
if strcmp(p.Results.overlap_units,'um')
    overlap = round(p.Results.overlap/mmhandle.core.getPixelSizeUm);
    if strcmp(p.Results.overlap_x,'undefined')
        overlap_x = overlap;
    else
        overlap_x = round(p.Results.overlap_x/mmhandle.core.getPixelSizeUm);
    end
    if strcmp(p.Results.overlap_y,'undefined')
        overlap_y = overlap;
    else
        overlap_y = round(p.Results.overlap_y/mmhandle.core.getPixelSizeUm);
    end
elseif strcmp(p.Results.overlap_units,'px')
    overlap = round(p.Results.overlap);
    if strcmp(p.Results.overlap_x,'undefined')
        overlap_x = overlap;
    else
        overlap_x = round(p.Results.overlap_x);
    end
    if strcmp(p.Results.overlap_y,'undefined')
        overlap_y = overlap;
    else
        overlap_y = round(p.Results.overlap_y);
    end
end
%% Test for conflicts in parameters
%
if (~strcmp(p.Results.number_of_images, 'undefined')) && (~strcmp(p.Results.number_of_columns, 'undefined')) && (~strcmp(p.Results.number_of_rows, 'undefined'))
    if p.Results.number_of_columns*p.Results.number_of_rows ~= p.Results.number_of_images
        error('GridMake:bad_rowCol','The number of rows and columns does not agree with the number of images');
    end
end
%%
% Is the upper-left corner above and to the left of the lower-right? Any
% two points can be converted into the proper upper-left and lower-right.
if (~strcmp(p.Results.upper_left_corner,'undefined')) && (~strcmp(p.Results.lower_right_corner,'undefined'))
    temp_1 = p.Results.upper_left_corner;
    temp_2 = p.Results.lower_right_corner;
    if p.Results.upper_left_corner(1)>p.Results.lower_right_corner(1) && p.Results.upper_left_corner(2)>p.Results.lower_right_corner(2)
        p.Results.upper_left_corner = temp_2;
        p.Results.lower_right_corner = temp_1;
    elseif p.Results.upper_left_corner(1)>p.Results.lower_right_corner(1) && p.Results.upper_left_corner(2)<p.Results.lower_right_corner(2)
        p.Results.upper_left_corner(1) = temp_2(1);
        p.Results.lower_right_corner(1) = temp_1(1);
    elseif p.Results.upper_left_corner(1)<p.Results.lower_right_corner(1) && p.Results.upper_left_corner(2)>p.Results.lower_right_corner(2)
        p.Results.upper_left_corner(2) = temp_2(2);
        p.Results.lower_right_corner(2) = temp_1(2);
    end
end
%%
% The grid to be made depends upon the collection of parameters that were
% specified when the function was called. Specifically, the parameters that
% default to the string 'undefined' determine the type of grid to be made.
% A boolean array identifies which of the 'undefined' parameters were
% specified with a logical 1. The 'undefined' parameters were defined first
% followed by other parameters that do not influence the type of grid.
% These other parameters are ignored in the decision array. The decision
% array is then converted into a number that is input in a switch/case code
% block.
fields = {'number_of_images','number_of_columns','number_of_rows','centroid','upper_left_corner','lower_right_corner'};
decision_array = ones(1,numel(fields));
for i = 1:(numel(fields))
    if strcmp(p.Results.(fields{i}),'undefined')
        decision_array(i) = 0;
    end
end
decision_number = bin2dec(int2str(decision_array));

switch decision_number
    case 36 %centroid + number_of_images
        %% Specify upper-left and lower-right corners
        %
        % The rectangular shape of the image will be automatically
        % generated. The number of images may not match the input number of
        % images.
        pixWidth = mmhandle.core.getImageWidth;
        pixHeight = mmhandle.core.getImageHeight;
        widthCandidates = floor(sqrt(p.Results.number_of_images./(linspace(0.5625,1,10)*pixWidth/pixHeight)));
        objectiveArray = mod(p.Results.number_of_images,widthCandidates);
        [~,ind] = min(objectiveArray);
        width = widthCandidates(ind);
        height = floor(p.Results.number_of_images/width);
        NOI = width*height;
        %% update the coordinates for the upper-left and lower-right
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
        ULC = ...
            [p.Results.centroid(1) - (width-1)/2*(pixWidth-overlap_x)*mmhandle.core.getPixelSizeUm,...
            p.Results.centroid(2) - (height-1)/2*(pixHeight-overlap_y)*mmhandle.core.getPixelSizeUm,...
            p.Results.centroid(3)];
        LRC = ...
            [p.Results.centroid(1) + (width-1)/2*(pixWidth-overlap_x)*mmhandle.core.getPixelSizeUm,...
            p.Results.centroid(2) + (height-1)/2*(pixHeight-overlap_y)*mmhandle.core.getPixelSizeUm,...
            p.Results.centroid(3)];
    case 35 %upper-left, lower-right, and number of images
        % Use when you want a given number of images to fill a given space.
        % This means the overlap (or underlap?) between images must be
        % calculated
        pixWidth = mmhandle.core.getImageWidth;
        pixHeight = mmhandle.core.getImageHeight;
        a = p.Results.lower_right_corner(1) - p.Results.upper_left_corner(1);
        b = p.Results.lower_right_corner(2) - p.Results.upper_left_corner(2);
        width = sqrt(p.Results.number_of_images*a/b);
        height = p.Results.number_of_images/width;
        width = round(width);
        height = round(height);
        NOI = width*height;
        %%
        overlap_x = (p.Results.lower_right_corner(1) - p.Results.upper_left_corner(1))/mmhandle.core.getPixelSizeUm/width-pixWidth;
        overlap_y = (p.Results.lower_right_corner(2) - p.Results.upper_left_corner(2))/mmhandle.core.getPixelSizeUm/height-pixHeight;
        ULC = p.Results.upper_left_corner;
        LRC = ...
            [ULC(1)+(width-1)*(pixWidth-overlap_x),...
            ULC(1)+(height-1)*(pixHeight-overlap_y),...
            p.Results.lower_right_corner(3)];
    case 4 %upper-left and lower-right
    otherwise
        error('GridMake:bad_param','The set parameters entered cannot be interpreted. Please specify a valid set of parameters');
end
end
