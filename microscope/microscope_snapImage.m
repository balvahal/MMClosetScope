%% Snap an image
% This function takes an image and stores it in the microscope object. With
% the optional inputs an image can be captured using a specified _Channel_,
% _Exposure_, and _Binning_.
%% Inputs
% * microscope: the object that utilizes the uManager API.
% * Channel: a string naming the preset/config that should be used with
% this snap image. Optional.
% * Exposure: a number representing the length of image exposure in
% milliseconds.
% * Binning: a number 1, 2, or 4 that specifies the number of pixels on the
% sensor used to represent a single pixel in the saved image.
%% Outputs
% * I: the image snapped
function [I] = microscope_snapImage(microscope, varargin)
%% Snap the image
%
p = inputParser;
addRequired(p, 'microscope', @(x) isa(x,'microscope_class'));
addOptional(p, 'Channel', 'noinput', @isstr);
addOptional(p, 'Exposure', -1, @isinteger);
addOptional(p, 'Binning', -1, @isinteger);
parse(p, microscope, varargin{:});
if ~strcmp(p.Results.Channel,'noinput')
    microscope.core.setConfig('Channel',p.Results.channel);
    % Did the config load correctly?
    % |core.getProperty('TIFilterBlock1','Label')
    % |core.getProperty(microscope.ShutterDevice,'Name')|
end
if p.Results.Exposure >= 0
    microscope.core.setExposure(microscope.CameraDevice,p.Results.Exposure);
end
if p.Results.Binning >= 0
    microscope.binningfun(microscope,p.Results.Binning);
end
%%
%
% snapImage cannot be called twice in a row or an error will be thrown.
% getImage must be called inbetween uses of snapImage.
microscope.core.snapImage; %MATLAB will wait for this method to finish, unlike XYZ movement.
I = microscope.core.getImage;
width = microscope.core.getImageWidth;
height = microscope.core.getImageHeight;
if microscope.core.getBytesPerPixel == 1 %this indicates an 8bit image
    I = typecast(I,'uint8');
elseif microscope.core.getBytesPerPixel == 2 %this indicates a 16bit image
    I = typecast(I,'uint16');
end
microscope.I = transpose(reshape(I,[width,height]));
I = microscope.I;
