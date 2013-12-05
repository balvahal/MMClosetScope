%%
%
function [mmhandle,NOI,ULC,LRC] = super_mda_grid_maker(mmhandle,varargin)
p = inputParser;
addRequired(p, 'mmhandle', @isstruct);
addParameter(p, 'number_of_images', 'undefined', @(x) mod(101,1)==0);
addParameter(p, 'centroid', 'undefined', @(x) numel(x) == 3);
addParameter(p, 'upper_left_corner', 'undefined', @(x) numel(x) == 3);
addParameter(p, 'lower_right_corner', 'undefined', @(x) numel(x) == 3);
addParameter(p, 'overlap', 0, @isnumeric);

parse(p,mmhandle,varargin{:});

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
    %ULC = ...
        %[p.Results.centroid(1) - handles.imageWidth*width/2),...
        %(handles.sampleInfo(handles.sampleIndex).center(2) - handles.imageHeight*height/2)];
    handles.sampleInfo(handles.sampleIndex).lowerRightCorner = ...
        [(handles.sampleInfo(handles.sampleIndex).center(1) + handles.imageWidth*width/2),...
        (handles.sampleInfo(handles.sampleIndex).center(2) + handles.imageHeight*height/2)];
elseif (~strcmp(p.Results.upper_left_corner, 'undefined')) && (~strcmp(p.Results.lower_right_corner, 'undefined'))
    %% Adjust upper-left and lower-right corners if necessary
    %
else
    error('GridMake:bad_param','The parameters entered are insufficiently defined. Please specify a valid set of parameters');
end

end