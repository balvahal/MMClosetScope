%% Snap an image
% 
%% Inputs
% * mmhandle, the struct that contains micro-manager objects
% * channel, a string naming the preset/config that should be used with
% this snap image; an optional parameter
%% Outputs
% * mmhandle.I, the image snapped
function mmhandle = SCAN6general_snapImage(mmhandle, varargin)
%% Snap the image
%
p = inputParser;
addRequired(p, 'mmhandle', @isstruct);
addOptional(p, 'channel', 'noinput', @isstr);
parse(p,mmhandle, varargin{:});
if ~strcmp(p.Results.channel,'noinput')
    mmhandle.core.setConfig('Channel',p.Results.channel);
    % Did the config load correctly?
    % |core.getProperty('TIFilterBlock1','Label')
    % |core.getProperty(mmhandle.ShutterDevice,'Name')|
end
%%
%
mmhandle.core.snapImage; %MATLAB will wait for this method to finish, unlike XYZ movement.
I = mmhandle.core.getImage;
width = mmhandle.core.getImageWidth;
height = mmhandle.core.getImageHeight;
mmhandle.I = reshape(I,[height,width]);
