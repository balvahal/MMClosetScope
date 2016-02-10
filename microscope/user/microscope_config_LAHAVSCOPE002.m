function mm = Core_microscopeFcn_LAHAVSCOPE002(mm)
%%
% Curtain Scope
mm.xyStageDevice = mm.core.getXYStageDevice;
mm.core.setFocusDevice('TIZDrive'); %this is specific to the Nikon TI that we use
mm.FocusDevice = mm.core.getFocusDevice;
mm.core.setFocusDevice('TIPFSOffset'); %this is specific to the Nikon TI that we use
mm.AutoFocusDevice = mm.core.getFocusDevice;
mm.AutoFocusStatusDevice = mm.core.getAutoFocusDevice;
mm.core.setProperty(mm.xyStageDevice,'TransposeMirrorX',1);
mm.core.setProperty(mm.xyStageDevice,'TransposeMirrorY',1);
[mfilepath,~,~] = fileparts(mfilename('fullpath'));
mytable = readtable(fullfile(mfilepath,'settings_LAHAVSCOPE002.txt'));
mm.xyStageLimits = [mytable.xlim1,mytable.xlim2,mytable.ylim1,mytable.ylim2];
mm.zLimits = [mytable.zmin,mytable.zmax];
mm.calibrationAngle = mytable.calibrationAngle;
mm.core.setProperty(mm.xyStageDevice,'MaxSpeed',50); %There was concern of slippage and slowing the scope down was thought to be a solution to prevent this. 'MaxSpeed' range of [0,100].
mm.stageport = 'COM3';
mm.binningfun = @binningfun_HAMAMATSU;
end