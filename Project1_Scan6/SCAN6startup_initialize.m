%% Initialize the Micro-manager gui and core objects
% The goal of this initialization is to create the Micro-manager gui and
% core object. These objects are the agents of the Micro-manger API. By
% interacting with these objects MATLAB can interact directly with the
% microscope.
%
% Please note that when using the gui object the core object is initialized
% after the gui is openned and the configuration file is selected. To
% initilize the core object alone the following code would suffice:
% 
%   import mmcorej.*; mmc=CMMCore; path = 'C:\path\to\config\config.cfg';
%   mmc.loadSystemConfiguration(path);
%% Inputs
% NONE
%% Outputs
% * mmcore
% * mmgui
function [mmhandle] = SCAN6startup_initialize()
%% Create the GUI and the core API object
%
hmsg = msgbox('Click ''OK'' after the micromanager configuration file has been loaded.','Wait For Configuration');
import org.micromanager.MMStudioMainFrame;
mmhandle.gui = MMStudioMainFrame(false);
mmhandle.gui.show;
uiwait(hmsg);
mmhandle.core = mmhandle.gui.getCore;
%%
% Wait for the gui object to finish initialization and then create the core
% object. mmhandle.core = []; while ~isa(mmhandle.core,'mmcorej.CMMCore')
%     class(mmhandle.core) mmhandle.core = mmhandle.gui.getCore;
% end disp('before'); mmhandle.core.waitForConfig; disp('after');
%% Obtain the object that represents multi-dimensional-acquisition
%
mmhandle.mda = mmhandle.gui.getAcquisitionEngine();
%% A NOTE ABOUT ALL DEVICES
% * |core.deviceBusy| = boolean that indicates if the device is in use.
% Very useful for handingshaking between MATLAB and the microscope. Without
% specifically telling MATLAB to wait for the microscope to finish a
% process, e.g. moving the stage or taking an image, the MATLAB code will
% continue running and will crash or cause to microscope to behavior
% erratically if the code depends upon the completion of the microscope
% process mentioned earlier. |core.deviceBusy| is a boolean that can be
% used as the key variable in a while loop that will pause MATLAB until the
% microscope process has completed. This is a very crucial command and
% hopefully this is reflected by the verbose explanation.
% * |core.getDevicePropertyNames(DeviceName).toArray| = if there is ever
% any question about what properties can be |set| or |get| by a device this
% handy command with print a list of all the possible properties.
% * |core.getProperty(DeviceName,'Property')| = For example, the see what
% the binning setting is for the camera:
% |core.getProperty(mmhandle.CameraDevice,'Binning')|.
% * |core.setProperty(DeviceName,'Property',x)| = For example, to set the
% binning setting for the camera to 2:
% |core.setProperty(mmhandle.CameraDevice,'Binning',2)|.
% * |core.getAllowedPropertyValues(DeviceName,'Property').toArray| = if
% there is ever a question about the set of values that can be assigned to
% a property, then this command will list this set. If a property can take
% on a range of values use
% |core.getPropertyLowerLimit(DeviceName,'Property'| and
% |core.getPropertyUpperLimit(DeviceName,'Property')|.
%% Find the xy device and the focus device
% Popular commands with (x,y,z) movement devices are:
% * core.setOrigin = sets an origin for z that is stored in the hardware
% * core.setOriginXY = sets an origin for (x,y) that is stored in the
% hardware
% * core.setXYPosition = sets the (x,y) position
% * core.setPosition = sets the z position
% * core.getXPosition
% * core.getYPosition
% * core.getPosition = reads the current z position
% * core.stop = stops (x,y) movement
mmhandle.xyStageDevice = mmhandle.core.getXYStageDevice;
mmhandle.FocusDevice = mmhandle.core.getFocusDevice;
mmhandle = SCAN6general_getXYZ(mmhandle);
%% Camera device
% * |'Gain'| = can be from 0 to 255.
% * |'ScanMode'| = 1 for normal scan speed and less noise. 2 for fast scan
% speed.
% * |'Binning'| = 1, 2, 4, or 8.
mmhandle.CameraDevice = mmhandle.core.getCameraDevice;
