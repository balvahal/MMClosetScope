function mm = Core_microscopeFcn_NOSCOPE(mm)
mm.xyStageDevice = mm.core.getXYStageDevice;
mm.FocusDevice = mm.core.getFocusDevice;
mm.AutoFocusDevice = mm.core.getFocusDevice;
mm.AutoFocusStatusDevice = mm.core.getAutoFocusDevice;
mm.zLimits = [0,10000];
mm.xyStageLimits = [0,150000,0,100000];
mm.calibrationAngle = 2;
mm.stageport = 'COM1';
mm.binningfun = @binningfun_NOSCOPE;
end