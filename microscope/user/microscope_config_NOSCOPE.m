function microscope = microscope_config_NOSCOPE(microscope)
microscope.xyStageDevice = microscope.core.getXYStageDevice;
microscope.FocusDevice = microscope.core.getFocusDevice;
microscope.AutoFocusDevice = microscope.core.getFocusDevice;
microscope.AutoFocusStatusDevice = microscope.core.getAutoFocusDevice;
customFileName = sprintf('settings_%s',microscope.computerName);
if exist(customFileName,'file')
    microscope.binningfun = str2func(customFileName);
else
    microscope.binningfun = @binningfun_NOSCOPE;
end
microscope.zLimits = [0,10000];
microscope.xyStageLimits = [0,150000,0,100000];
microscope.calibrationAngle = 0;
microscope.stageport = 'COM1';
customFileName = sprintf('binningfun_%s',microscope.computerName);
if exist(customFileName,'file')
    microscope.binningfun = str2func(customFileName);
else
    microscope.binningfun = @binningfun_NOSCOPE;
end
end