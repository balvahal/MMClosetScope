%% Find and set the origin for the (X,Y) of a motorized stage
% It can be useful to set the absolute origin consistently to serve as a
% point of reference. A natural reference is the upper-left corner of the
% stage, because this will reflect the origin of matlab matrices and 3D
% axes traditionally drawn on paper. The origin z position is the lowest
% position the scope can achieve.
%
% If the x and y origin is in the lower-right corner of the stage and
% positive movement is to the left and away from the face of the
% microscope, then the origin can be relocated using hardware settings
% |TransposeMirrorX| and |TransposeMirrorY|.
%
% The microscope and stage have mechanisms built-in that will detect when
% their limits have been reached. Sending a command to the microscope to
% move to a position it cannot reach will only cause the scope to move to
% its limit where a hardware signal will tell the microscope to stop,
% without doing harm to the scope. This function was designed for use with
% a Prior ProScan II stage. It is not guarunteed to work on this stage or
% any other stage, so consider the risk before using it. The ProScan II is
% a 4 inch x 3 inch rectangle and the objective cannot travel more than 1cm
% vertically. The numbers that will be used to reach the limits are
% arbitrarily chosen to be greater than the limits mentioned above assuming
% the origin is chosen to be within the accessible regions of the hardware.
% The units of movement are micro-meters.
%% Inputs
% * microscope: the object that utilizes the uManager API.
%% Outputs
% * microscope: the object that utilizes the uManager API.
function [microscope] = microscope_findThenSetAbsoluteOriginXY(microscope)
% Construct a questdlg with three options
str = sprintf('Remove anything that could obstruct the objective, including any stage plates, to ensure safe exploration of the microscope movement limitations.\n\nDo you wish to proceed?');
choice = questdlg(str, ...
    'Warning! Do you wish to proceed?', ...
    'Yes','No','No');
% Handle response
if strcmp(choice,'No')
    return;
end

str = sprintf('Please be aware that damage to the objective or microscope could cost thousands of dollars (circa 2016) and this app offers no guarantees.\n\nDo you still wish to proceed?');
choice = questdlg(str, ...
    'Warning! Do you still wish to proceed?', ...
    'Yes','No','No');
% Handle response
if strcmp(choice,'No')
    return;
end
%%
% import the configuration file that will be updated.
[mfilepath,~,~] = fileparts(mfilename('fullpath'));
mystr = sprintf('microscope_json_%s.txt',microscope.computerName);
if exist(fullfile(mfilepath,'user',mystr),'file')
    myjson = core_jsonparser.import_json(fullfile(mfilepath,'user',mystr));
else
    myjson = core_jsonparser.import_json(fullfile(mfilepath,'user','microscope_json_NOSCOPE.txt'));
end
%% Z: Move the objective to a low level to avoid obstructions
% 
mypos = microscope.getXYZ;
microscope.setXYZ([mypos(1:2),1000]);
microscope.core.waitForDevice(microscope.FocusDevice);
%% XY: Move the stage to its upper-left most corner
%
microscope.setXYZ([-1000000,-1000000]);
microscope.core.waitForDevice(microscope.xyStageDevice);
microscope.core.setOriginXY(microscope.xyStageDevice);
mypos = microscope.getXYZ;
myjson.xlim1 = mypos(1);
myjson.ylim1 = mypos(2);
%% XY: Move the stage to the lower-right corner
%
microscope.setXYZ([1000000,1000000]);
microscope.core.waitForDevice(microscope.xyStageDevice);
mypos = microscope.getXYZ;
myjson.xlim2 = mypos(1);
myjson.ylim2 = mypos(2);
%% update the configuration file with the new information
%
core_jsonparser.export_json(myjson,fullfile(mfilepath,'user',mystr));
microscope.xyStageLimits = [myjson.xlim1,myjson.xlim2,myjson.ylim1,myjson.ylim2];