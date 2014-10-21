%% Snap an image
% 
%% Inputs
% * mmhandle, the struct that contains micro-manager objects
% * channel, a string naming the preset/config that should be used with
% this snap image; an optional parameter
%% Outputs
% * mmhandle.I, the image snapped
function I = Core_method_snapImage(mm, varargin)
%% Snap the image
%
p = inputParser;
addRequired(p, 'mmhandle', @(x) isa(x,'Core_MicroManagerHandle'));
addOptional(p, 'Channel', 'noinput', @isstr);
addOptional(p, 'Exposure', -1, @isinteger);
addOptional(p, 'Gain', -1, @isinteger);
addOptional(p, 'Binning', -1, @isinteger);
parse(p,mm, varargin{:});
if ~strcmp(p.Results.Channel,'noinput')
    mm.core.setConfig('Channel',p.Results.channel);
    % Did the config load correctly?
    % |core.getProperty('TIFilterBlock1','Label')
    % |core.getProperty(mm.ShutterDevice,'Name')|
end
if p.Results.Exposure >= 0
    mm.core.setExposure(mm.CameraDevice,p.Results.Exposure);
end
% if p.Results.Gain >= 0
%     mm.core.setProperty(mm.CameraDevice,'Gain',p.Results.Gain);
% end
if p.Results.Binning >= 0
    mm.core.setProperty(mm.CameraDevice,'Binning',p.Results.Binning);
end
%%
%
% snapImage cannot be called twice in a row or an error will be thrown.
% getImage must be called inbetween uses of snapImage.
mm.core.snapImage; %MATLAB will wait for this method to finish, unlike XYZ movement.
I = mm.core.getImage;
width = mm.core.getImageWidth;
height = mm.core.getImageHeight;
if mm.core.getBytesPerPixel == 1 %this indicates an 8bit image
    I = typecast(I,'uint8');
elseif mm.core.getBytesPerPixel == 2 %this indicates a 16bit image
    I = typecast(I,'uint16');
    %% Check the bit-depth of the camera
    % If the bit-depth is less than 16-bits, then shift the raw image data
    % to fill the 16-bits.
%     bitdepth = str2double(mm.core.getProperty(mm.CameraDevice,'Bits per Channel').toCharArray');
%     if bitdepth < 16
%         I = bitshift(I,16-bitdepth);
%     end
end
mm.I = transpose(reshape(I,[width,height]));
I = mm.I;
