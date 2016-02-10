function mm = Core_microscopeFcn_LAHAVSCOPE0001(mm)
%%
% Closet Scope
mm.xyStageDevice = mm.core.getXYStageDevice;
mm.core.setFocusDevice('TIZDrive'); %this is specific to the Nikon TI that we use
mm.FocusDevice = mm.core.getFocusDevice;
mm.core.setFocusDevice('TIPFSOffset'); %this is specific to the Nikon TI that we use
mm.AutoFocusDevice = mm.core.getFocusDevice;
mm.AutoFocusStatusDevice = mm.core.getAutoFocusDevice;
%% The directionality of the XY Stage (Closet Scope)
% The directionality of the stage on the closet scope is opposite to what
% it should be in both the x and y direction. Perhaps when the stage was
% installed it was rotated by 180 degrees. Whatever the cause, to set the
% origin to be the upper-left corner and have the x increase to the right
% and y to increase downwards the following command must be made.
mm.core.setProperty(mm.xyStageDevice,'TransposeMirrorX',1);
mm.core.setProperty(mm.xyStageDevice,'TransposeMirrorY',1);
[mfilepath,~,~] = fileparts(mfilename('fullpath'));
%% The size of the XY Stage (Closet Scope)
% The following piece of information was collected manually. First, the xy
% origin was set by moving the objective to its limit in one corner. Then,
% the objective was moved to the opposite corner and its coordinates were
% retrieved. These coordinates represent the height and width of the area
% that the objective can travel. Beware that this information is relevant
% if the absolute origin of the stage is known. Unfortunately, the stage is
% typically navigated with reference to a relative origin, so this
% information may be of limited use. For the record...
%
% * x = 116328 microns
% * y = 76260 microns
mytable = readtable(fullfile(mfilepath,'settings_LAHAVSCOPE0001.txt'));
mm.xyStageLimits = [mytable.xlim1,mytable.xlim2,mytable.ylim1,mytable.ylim2];
mm.zLimits = [mytable.zmin,mytable.zmax];
mm.calibrationAngle = mytable.calibrationAngle;
mm.core.setProperty(mm.xyStageDevice,'MaxSpeed',100); % 'MaxSpeed' range of [0,100].
mm.stageport = 'COM1';
mm.binningfun = @binningfun_HAMAMATSU;
end