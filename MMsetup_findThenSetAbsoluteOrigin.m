%% Find and set the origin for the x, y, and z positions of the device
% After testing this function I found it to be of little value. It is
% easier to choose a relative origin and then define a coordinate system
% from there. This is especially true, because of stage drift and subtle
% movements in the sample. Anchor the relative origin to an image of a
% particular spot of the sample and then later redefine the relative origin
% using this image.
%
% Initially I found, the x and y origin in the lower-right corner for the
% closet-scope stage; I thought it was installed 180 degrees incorrectly,
% because traditionally the upper-left is the origin. However, I later
% discovered the origin can be relocated using hardware settings
% |TransposeMirrorX| and |TransposeMirrorY|.
%
% Normally the upper-left is preferred, because this will reflect the
% origin of matlab matrices and 3D axes traditionally drawn on paper. The
% origin z position is the lowest position the scope can achieve.
%
% The corner of origin is determined by repeatedly subtracting a distance
% from x, y, and z components until the stage no longer moves.
%
% Having looked at this function again, I still feel it has very little
% value; it serves best as an example of simple micromanager code use.
%% Inputs
% mmhandle
%% Outputs
% mmhandle
function [mmhandle] = MMsetup_findThenSetAbsoluteOrigin(mmhandle)
%% Move the objective to its lower limit
%
mmhandle = SCAN6general_getXYZ(mmhandle);
z0 = mmhandle.pos(3);
stepsize = 50; 
deltaZ = stepsize; %initialize deltaZ
timer = 0;
deltaUpperTolerance = 50; %50 microns or 150 xy-pixels at 20x
deltaLowerLimit = 10; %10 micron or 30 xy-pixels at 20x
timerlength = 2;
%%
% attempt to reach a 10 micron tolerance or try |timerLength| times with the
% delta less than 50 microns.
while deltaZ > deltaLowerLimit || timer < timerlength
    mmhandle = SCAN6general_setXYZ(mmhandle,z0-stepsize,'z');
    deltaZ = abs(mmhandle.pos(3)-z0);
    if deltaZ < deltaUpperTolerance
        timer = timer + 1;
    end
    z0 = mmhandle.pos(3);
end
fprintf('z origin found, z=%d \n',mmhandle.pos(3));

mmhandle = SCAN6general_getXYZ(mmhandle);
y0 = mmhandle.pos(2);
stepsize = 1000; %move in 1000 micrometer steps, this value was chosen arbitrarily as not too big and not too small, though it doesn't really matter in the end.
deltaY = stepsize; %initialize deltaZ
timer = 0;
while deltaY > deltaLowerLimit || timer < timerlength
    mmhandle = SCAN6general_setXYZ(mmhandle,y0-stepsize,'y');
    deltaY = abs(mmhandle.pos(2)-y0);
    if deltaY < deltaUpperTolerance
        timer = timer + 1;
    end
    y0 = mmhandle.pos(2);
end
fprintf('y origin found, y=%2.3e \n',mmhandle.pos(2));

mmhandle = SCAN6general_getXYZ(mmhandle);
x0 = mmhandle.pos(1);
stepsize = 1000; %move in 1000 micrometer steps, this value was chosen arbitrarily as not too big and not too small, though it doesn't really matter in the end.
deltaX = stepsize; %initialize deltaZ
timer = 0;
while deltaX > deltaLowerLimit || timer < timerlength
    mmhandle = SCAN6general_setXYZ(mmhandle,x0-stepsize,'x');
    deltaX = abs(mmhandle.pos(1)-x0);
    if deltaX < deltaUpperTolerance
        timer = timer + 1;
    end
    x0 = mmhandle.pos(1);
end
fprintf('x origin found, x=%2.3e \n',mmhandle.pos(1));


%% Set the origin
%
mmhandle.core.setOrigin(mmhandle.FocusDevice);
mmhandle.core.setOriginXY(mmhandle.xyStageDevice);
mmhandle = SCAN6general_getXYZ(mmhandle);