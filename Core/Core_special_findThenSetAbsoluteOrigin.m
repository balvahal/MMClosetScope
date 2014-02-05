%% Find and set the origin for the x, y, and z positions of the device
% It is important to not entirely rely upon the absolute origin, but it can
% be useful to set the absolute origin consistently to serve as a point of
% reference. The best system would have a consistent enough absolute origin
% that is further refined using the a relative origin that is defined by a
% visual landmark in the sample that is being imaged in case that sample
% needs to be imaged again or is being imaged over long lengths of time
% where stage drift is a concern. This is especially true, because of stage
% drift and subtle movements in the sample. Anchor the relative origin to
% an image of a particular spot of the sample and then later redefine the
% relative origin using this image.
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
% The microscope and stage have mechanisms built-in that will detect when
% their limits have been reached. Sending a command to the microscope to
% move to a position it cannot reach will only cause the scope to move to
% its limit where a hardware signal will tell the microscope to stop,
% without doing harm to the scope. Therefore, the easiest way to reach a
% limit is to send the scope to a position it cannot possibly reach. We
% know something about the limits beforehand. The stage is a 4 inch x 3
% inch rectangle and the objective cannot travel more than 1cm. The numbers
% that will be used to reach the limits are arbitrarily chosen to be
% greater than the limits mentioned above assuming the origin is chosen to
% be within the accessible regions of the hardware.
%% Inputs
% mmhandle
%% Outputs
% mmhandle
function [mmhandle] = Core_special_findThenSetAbsoluteOrigin(mmhandle)
hmsg = msgbox('Please remove anything currently in the stage holder to ensure safe exploration of the microscope movement limitations.','Warning');
uiwait(hmsg);
[mfilepath,~,~] = fileparts(mfilename('fullpath'));
mytable = readtable(fullfile(mfilepath,'settings_LB89-6A-45FA.txt'));
%% Z: Move the objective to its lower limit
%
mmhandle.setXYZ(mmhandle.pos + [0,0,-100000]);
myflag = true;
while myflag
if ~mmhandle.core.deviceBusy(mmhandle.FocusDevice)
    myflag = false;
end
end
%% XY: Move the stage to its upper-left most corner
%
mmhandle.setXYZ(mmhandle.pos + [-1000000,-1000000,0]);
myflag = true;
while myflag
if ~mmhandle.core.deviceBusy(mmhandle.xyStageDevice)
    myflag = false;
end
end
mmhandle.core.setOriginXY(mmhandle.xyStageDevice);
mmhandle.getXYZ;
mytable.xlim1 = mmhandle.pos(1);
mytable.ylim1 = mmhandle.pos(2);
%% XY: Move the stage to the lower-right corner
%
mmhandle.setXYZ(mmhandle.pos + [1000000,1000000,0]);
myflag = true;
while myflag
if ~mmhandle.core.deviceBusy(mmhandle.xyStageDevice)
    myflag = false;
end
end
mmhandle.getXYZ;
mytable.xlim2 = mmhandle.pos(1);
mytable.ylim2 = mmhandle.pos(2);
%% update the settings file with the new information
%
writetable(mytable,fullfile(mfilepath,'settings_LB89-6A-45FA.txt'));
mmhandle.xyStageLimits = [mytable.xlim1,mytable.xlim2,mytable.ylim1,mytable.ylim2];