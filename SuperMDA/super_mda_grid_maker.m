%%
% It is assumed that the origin is in the ULC and x increases due east and
% y increases due south when the stage is viewed from above.
function [mmhandle,NOI,ULC,LRC] = super_mda_grid_maker(mmhandle,varargin)
p = inputParser;
addRequired(p, 'mmhandle', @isstruct);
addParameter(p, 'number_of_images', 'undefined', @(x) mod(101,1)==0);
addParameter(p, 'centroid', 'undefined', @(x) numel(x) == 3);
addParameter(p, 'upper_left_corner', 'undefined', @(x) numel(x) == 3);
addParameter(p, 'lower_right_corner', 'undefined', @(x) numel(x) == 3);
addParameter(p, 'overlap', 0, @isnumeric);
addParameter(p, 'overlap_units','px',@(x) any(strcmp(x,{'px', 'um'})));

parse(p,mmhandle,varargin{:});
    if strcmp(p.Results.overlap_units,'um')
        overlap = round(p.Results.overlap/mmhandle.core.getPixelSizeUm);
    elseif strcmp(p.Results.overlap_units,'px')
        overlap = round(p.Results.overlap);
    end
%% Case 1: centroid + number_of_images
%
if (~strcmp(p.Results.centroid, 'undefined')) && (~strcmp(p.Results.number_of_images, 'undefined'))
    %% Specify upper-left and lower-right corners
    %
    % The rectangular shape of the image itself must be taken into account.
    pixWidth = mmhandle.core.getImageWidth;
    pixHeight = mmhandle.core.getImageHeight;
    widthCandidates = floor(sqrt(p.Results.number_of_images./(linspace(0.5625,1,10)*pixWidth/pixHeight)));
    objectiveArray = mod(p.Results.number_of_images,widthCandidates);
    [~,ind] = min(objectiveArray);
    width = widthCandidates(ind);
    height = floor(p.Results.number_of_images/width);
    NOI = width*height;
    % update the coordinates for the upper-left and lower-right
    ULC = ...
        [p.Results.centroid(1) - pixWidth*(width-overlap)/2*mmhandle.core.getPixelSizeUm,...
        p.Results.centroid(2) - pixHeight*(height-overlap)/2*mmhandle.core.getPixelSizeUm,...
        p.Results.centroid(3)];
    LRC = ...
        [p.Results.centroid(1) + pixWidth*(width-overlap)/2*mmhandle.core.getPixelSizeUm,...
        p.Results.centroid(2) + pixHeight*(height-overlap)/2*mmhandle.core.getPixelSizeUm,...
        p.Results.centroid(3)];
elseif (~strcmp(p.Results.number_of_images, 'undefined')) && (~strcmp(p.Results.upper_left_corner, 'undefined')) && (~strcmp(p.Results.lower_right_corner, 'undefined'))
    %% Adjust upper-left and lower-right corners if necessary
    %    
elseif (~strcmp(p.Results.upper_left_corner, 'undefined')) && (~strcmp(p.Results.lower_right_corner, 'undefined'))
    %% Adjust upper-left and lower-right corners if necessary
    %
else
    error('GridMake:bad_param','The parameters entered are insufficiently defined. Please specify a valid set of parameters');
end

end