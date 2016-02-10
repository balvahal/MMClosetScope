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
% microscope
%% Outputs
% microscope
function [microscope] = microscope_findThenSetAbsoluteOriginXYZ(microscope)
% Construct a questdlg with three options
str = sprintf('Remove anything that could obstruct the objective, including any stage plates, to ensure safe exploration of the microscope movement limitations.\n\nDo you wish to proceed?');
choice = questdlg(str, ...
    'Warning! Do you wish to proceed?', ...
    'Yes','No','No');
% Handle response
if strcmp(choice,'No')
    return;
end

str = sprintf('Please be aware that damage to the objective or microscope could cost thousands of dollars and this app offers no guarantees.\n\nDo you still wish to proceed?');
choice = questdlg(str, ...
    'Warning! Do you still wish to proceed?', ...
    'Yes','No','No');
% Handle response
if strcmp(choice,'No')
    return;
end
[mfilepath,~,~] = fileparts(mfilename('fullpath'));
mystr = sprintf('microscope_json_%s.txt',microscope.computerName);
if exist(fullfile(mfilepath,'user',mystr),'file')
    myjson = core_jsonparser.import_json(fullfile(mfilepath,'user',mystr));
end
%% Z: Move the objective to its upper and lower limit
% The FocusDevice that controls the Z movement does not update its position
% until after the objective reaches its final position.
%
% There is something broken about sending the TIZDrive to positions it
% cannot reach, which makes the waitForDevice() command not function
% properly. Therefore, the code that employs this strategy has been
% removed. An alternative is to have a dialog with the user to manually set
% the objective to highest and lowest position and then poll the microscope
% for its position value at each point.

% microscope.setXYZ(microscope.pos + [0,0,100000]);
% microscope.core.waitForDevice(microscope.FocusDevice);
% mypos = microscope.getXYZ;
myjson.zmax = 9500;

% microscope.setXYZ(mypos + [0,0,-100000]);
% microscope.core.waitForDevice(microscope.FocusDevice);
% mypos = microscope.getXYZ;
myjson.zmin = 0;

%% XY: Move the stage to its upper-left most corner
% microscope.core.waitForDevice(microscope.xyStageDevice); cannot be used here
% because it times out after 5 seconds and the stage takes longer than 5
% seconds to traverse its full range across the diagonal or X-axis.
microscope.setXYZ([-100,-100]);%microscope.setXYZ([-1000000,-1000000]);
% try
%     microscope.core.waitForDevice(microscope.xyStageDevice);
% catch
%     disp('timeout');
% end
microscope.core.setOriginXY(microscope.xyStageDevice);
mypos = microscope.getXYZ;
%pause(1); %A delay of this length ensures the position is updated.
myjson.xlim1 = mypos(1);
myjson.ylim1 = mypos(2);
%% XY: Move the stage to the lower-right corner
%
microscope.setXYZ([100,100]);%microscope.setXYZ([1000000,1000000]);
% try
%     microscope.core.waitForDevice(microscope.xyStageDevice);
% catch
%     disp('timeout');
% end
mypos = microscope.getXYZ;
%pause(1); %A delay of this length ensures the position is updated.
myjson.xlim2 = mypos(1);
myjson.ylim2 = mypos(2);
%% update the settings file with the new information
%
core_jsonparser.export_json(myjson,fullfile(mfilepath,'user',mystr));
microscope.xyStageLimits = [myjson.xlim1,myjson.xlim2,myjson.ylim1,myjson.ylim2];
microscope.zLimits = [myjson.zmin,myjson.zmax];