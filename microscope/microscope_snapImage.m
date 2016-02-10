%% Snap an image
% 
%% Inputs
% * microscopehandle, the struct that contains micro-manager objects
% * channel, a string naming the preset/config that should be used with
% this snap image; an optional parameter
%% Outputs
% * I, the image snapped
function I = microscope_snapImage(microscope, varargin)
%% Snap the image
%
p = inputParser;
addRequired(p, 'microscope', @(x) isa(x,'microscope_class'));
addOptional(p, 'Channel', 'noinput', @isstr);
addOptional(p, 'Exposure', -1, @isinteger);
addOptional(p, 'Gain', -1, @isinteger);
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
    %% Check the bit-depth of the camera
    % If the bit-depth is less than 16-bits, then shift the raw image data
    % to fill the 16-bits.
%     bitdepth = str2double(microscope.core.getProperty(microscope.CameraDevice,'Bits per Channel').toCharArray');
%     if bitdepth < 16
%         I = bitshift(I,16-bitdepth);
%     end
end
microscope.I = transpose(reshape(I,[width,height]));
I = microscope.I;
