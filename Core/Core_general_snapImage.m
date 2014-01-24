%% Snap an image
% 
%% Inputs
% * mmhandle, the struct that contains micro-manager objects
% * channel, a string naming the preset/config that should be used with
% this snap image; an optional parameter
%% Outputs
% * mmhandle.I, the image snapped
function mmhandle = Core_general_snapImage(mmhandle, varargin)
%% Snap the image
%
p = inputParser;
addRequired(p, 'mmhandle', @isstruct);
addOptional(p, 'Channel', 'noinput', @isstr);
addOptional(p, 'Exposure', -1, @isinteger);
parse(p,mmhandle, varargin{:});
if ~strcmp(p.Results.Channel,'noinput')
    mmhandle.core.setConfig('Channel',p.Results.channel);
    % Did the config load correctly?
    % |core.getProperty('TIFilterBlock1','Label')
    % |core.getProperty(mmhandle.ShutterDevice,'Name')|
end
if p.Results.Exposure >= 0
    mmhandle.core.setExposure(p.Results.Exposure);
end
%%
%
% snapImage cannot be called twice in a row or an error will be thrown.
% getImage must be called inbetween uses of snapImage.
mmhandle.core.snapImage; %MATLAB will wait for this method to finish, unlike XYZ movement.
I = mmhandle.core.getImage;
width = mmhandle.core.getImageWidth;
height = mmhandle.core.getImageHeight;
if mmhandle.core.getBytesPerPixel == 1 %this indicates an 8bit image
    I = typecast(I,'uint8');
elseif mmhandle.core.getBytesPerPixel == 2 %this indicates a 16bit image
    I = typecast(I,'uint16');
    %% Check the bit-depth of the camera
    % If the bit-depth is less than 16-bits, then shift the raw image data
    % to fill the 16-bits.
    bitdepth = str2double(mmhandle.core.getProperty(mmhandle.CameraDevice,'Bits per Channel').toCharArray');
    if bitdepth < 16
        I = bitshift(I,16-bitdepth);
    end
end
mmhandle.I = transpose(reshape(I,[width,height]));
