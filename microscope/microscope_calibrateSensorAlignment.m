%% calibrate the sensor alignment
% # Ask user to focus on some cells or other objects of high contrast in
% the center of the field of view. A brightfield image is suggested.
% # Uses a square in the center that is the inner 10% of the image to find
% cross correlation and x/y translation.
%% Inputs
% * microscope: the object that utilizes the uManager API.
%% Outputs
% * microscope: the object that utilizes the uManager API.
function [microscope] = microscope_calibrateSensorAlignment(microscope)
% Construct a questdlg with three options
str = sprintf('Place an object of high entropy in the center of the field of view.\n\nAre you ready to proceed?');
choice = questdlg(str, ...
    'Sensor Alignment Wizard', ...
    'Continue','Cancel','Cancel');
% Handle response
if strcmp(choice,'Cancel')
    return;
end
%%
%
pixWidth = microscope.core.getImageWidth;
pixHeight = microscope.core.getImageHeight;
pixSize = microscope.core.getPixelSizeUm;
microscope.getXYZ;
oldPos = microscope.pos;
%%%
% The high contrast image is in the center of the image. Move the stage 40
% percent of the viewing area to right in the _x_ direction. The high
% contrast object will still be in view.
microscope.setXYZ(microscope.pos(1) + pixSize*round((pixWidth*.4)),'x');
microscope.core.waitForDevice(microscope.xyStageDevice);
microscope.getXYZ;
%%%
% The pattern is the center, 10 percent width x 10 percent height, of the
% image.
fixed = microscope.snapImage;
innerWidth = round(0.1*pixWidth);
innerHeight = round(0.1*pixHeight);
innerTop = round((pixHeight*.5-innerHeight/2));
innerBottom = round((pixHeight*.5+innerHeight/2))-1;
innerLeft = round((pixWidth*.1-innerWidth/2));
innerRight = round((pixWidth*.1+innerWidth/2))-1;
pattern = fixed(innerTop:innerBottom,...
    innerLeft:innerRight);
%%%
% A large jump followed by smaller jumps of varying sides ensures the
% translation will not be a number close to zero and the calculated offset
% will not suffer from rounding errors when converting from um to pixels.
microscope.setXYZ(microscope.pos(1) - pixSize*round((pixWidth*.7)),'x');
microscope.core.waitForDevice(microscope.xyStageDevice);
moving = microscope.snapImage;
microscope.getXYZ;
myOffset = cc2translation(moving,pattern);

microscope.setXYZ(microscope.pos(1) - pixSize*round((pixWidth*.03)),'x');
microscope.core.waitForDevice(microscope.xyStageDevice);
moving = microscope.snapImage;
microscope.getXYZ;
myOffset(end+1,:) = cc2translation(moving,pattern);

microscope.setXYZ(microscope.pos(1) - pixSize*round((pixWidth*.035)),'x');
microscope.core.waitForDevice(microscope.xyStageDevice);
moving = microscope.snapImage;
microscope.getXYZ;
myOffset(end+1,:) = cc2translation(moving,pattern);

microscope.setXYZ(microscope.pos(1) - pixSize*round((pixWidth*.04)),'x');
microscope.core.waitForDevice(microscope.xyStageDevice);
moving = microscope.snapImage;
microscope.getXYZ;
myOffset(end+1,:) = cc2translation(moving,pattern);

microscope.setXYZ(microscope.pos(1) - pixSize*round((pixWidth*.045)),'x');
microscope.core.waitForDevice(microscope.xyStageDevice);
moving = microscope.snapImage;
microscope.getXYZ;
myOffset(end+1,:) = cc2translation(moving,pattern);

microscope.setXYZ(oldPos(1),'x');
microscope.core.waitForDevice(microscope.xyStageDevice);
microscope.getXYZ;

microscope.setXYZ(microscope.pos(2) + pixSize*round((pixHeight*.4)),'y');
microscope.core.waitForDevice(microscope.xyStageDevice);
microscope.getXYZ;

fixed = microscope.snapImage;
innerWidth = round(0.1*pixWidth);
innerHeight = round(0.1*pixHeight);
innerTop = round((pixHeight*.1-innerHeight/2));
innerBottom = round((pixHeight*.1+innerHeight/2))-1;
innerLeft = round((pixWidth*.5-innerWidth/2));
innerRight = round((pixWidth*.5+innerWidth/2))-1;
pattern = fixed(innerTop:innerBottom,...
    innerLeft:innerRight);

microscope.setXYZ(microscope.pos(2) - pixSize*round((pixHeight*.7)),'y');
microscope.core.waitForDevice(microscope.xyStageDevice);
moving = microscope.snapImage;
microscope.getXYZ;
myOffset(end+1,:) = fliplr(cc2translation(moving,pattern));

microscope.setXYZ(microscope.pos(2) - pixSize*round((pixHeight*.03)),'y');
microscope.core.waitForDevice(microscope.xyStageDevice);
moving = microscope.snapImage;
microscope.getXYZ;
myOffset(end+1,:) = fliplr(cc2translation(moving,pattern));

microscope.setXYZ(microscope.pos(2) - pixSize*round((pixHeight*.035)),'y');
microscope.core.waitForDevice(microscope.xyStageDevice);
moving = microscope.snapImage;
microscope.getXYZ;
myOffset(end+1,:) = fliplr(cc2translation(moving,pattern));

microscope.setXYZ(microscope.pos(2) - pixSize*round((pixHeight*.04)),'y');
microscope.core.waitForDevice(microscope.xyStageDevice);
moving = microscope.snapImage;
microscope.getXYZ;
myOffset(end+1,:) = fliplr(cc2translation(moving,pattern));

microscope.setXYZ(microscope.pos(2) - pixSize*round((pixHeight*.045)),'y');
microscope.core.waitForDevice(microscope.xyStageDevice);
moving = microscope.snapImage;
microscope.getXYZ;
myOffset(end+1,:) = fliplr(cc2translation(moving,pattern));

microscope.setXYZ(oldPos(2),'y');
microscope.core.waitForDevice(microscope.xyStageDevice);
microscope.getXYZ;

%% Calculate calibrationAngle
%
myOffsetMean = mean(myOffset,1);
microscope.calibrationAngle = atand(myOffsetMean(2)/myOffsetMean(1));
fprintf('\r\nThe calibration angle is...\r\n%f',microscope.calibrationAngle);
%% update the settings file with the new information
%

[mfilepath,~,~] = fileparts(mfilename('fullpath'));
my_comp_name = microscope.core.getHostName.toCharArray';
mystr = sprintf('settings_%s.txt',my_comp_name);
if exist(fullfile(mfilepath,mystr),'file')
    mytable = readtable(fullfile(mfilepath,mystr));
else
    mytable = table;
end

mytable.calibrationAngle = microscope.calibrationAngle;
writetable(mytable,fullfile(mfilepath,mystr));

    function [corr_offset] = cc2translation(mov,pattern)
        c = normxcorr2(pattern,mov);
        [~, imax] = max(abs(c(:)));
        [ypeak, xpeak] = ind2sub(size(c),imax);
        corr_offset = [(xpeak-size(pattern,2)+1-innerLeft),...
            (ypeak-size(pattern,1)+1-innerTop)];
        if corr_offset(1) < 0
            corr_offset(1) = -corr_offset(1);
            corr_offset(2) = -corr_offset(2);
        end
    end
end

