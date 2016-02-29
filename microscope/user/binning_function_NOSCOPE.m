%% binning function, default setup
% Between a Hamamatsu camera and a non-Hamamatsu camera the syntax is
% different, to change the binning of an image. I.e., '1x1' and '1'. To
% avoid hard coding either, a function handle specific to a device is
% assigned to a microscope property, acting in practice like a method.
%% Inputs
% * microscope: the object that utilizes the uManager API.
% * binNum: the binning number. The choices are limited to 1, 2, or 4. This
% true for the Hamamatsu Flash 4.0.
%% Outputs
% * microscope: the object that utilizes the uManager API.
function [microscope] = binning_function_NOSCOPE(microscope,binNum)
    switch binNum
        case 1
            microscope.core.setProperty(microscope.CameraDevice,'Binning',1);
        case 2
            microscope.core.setProperty(microscope.CameraDevice,'Binning',2);
        case 4
            microscope.core.setProperty(microscope.CameraDevice,'Binning',4);
        otherwise
            microscope.core.setProperty(microscope.CameraDevice,'Binning',1);
    end
end