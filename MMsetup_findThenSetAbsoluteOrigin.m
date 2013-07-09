%% Find and set the origin for the x, y, and z positions of the device
% The x and y origin is the lower-right corner for the closet-scope
% stage(so perhaps it was installed 180 degrees incorrectly);
%
% Normally the upper-left is preferred, because this will reflect the
% origin of matlab matrices and 3D axes traditionally drawn on paper. The
% origin z position is the lowest position the scope can achieve.
%% Inputs
% mmhandle
%% Outputs
% mmhandle
function [mmhandle] = MMsetup_findThenSetAbsoluteOrigin(mmhandle)
%% Move the objective to its lower limit
%
mmhandle = SCAN6general_getXYZ(mmhandle);
z0 = mmhandle.pos(3);
stepsize = 1000; %move in 1000 micrometer steps, this value was chosen arbitrarily as not too big and not too small, though it doesn't really matter in the end.
deltaZ = stepsize; %initialize deltaZ
timer = 0;
deltaUpperTolerance = 10; %10 microns
deltaLowerLimit = 1; %1 micron
timerlength = 2;
%%
% attempt to reach a 1 micron tolerance or try |timerLength| times with the delta less
% than 10 microns.
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