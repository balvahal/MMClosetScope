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
function [mmhandle] = Core_startup_initialize()
%% Create the GUI and the core API object
%
hmsg = msgbox('Click ''OK'' after the micromanager configuration file has been loaded.','Wait For Configuration');
import org.micromanager.MMStudioMainFrame;
mmhandle.gui = MMStudioMainFrame(false);
mmhandle.gui.show;
uiwait(hmsg);
mmhandle.core = mmhandle.gui.getMMCore;
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
mmhandle = Core_general_getXYZ(mmhandle);
%% Camera device
% * |'Gain'| = can be from 0 to 255.
% * |'ScanMode'| = 1 for normal scan speed and less noise. 2 for fast scan
% speed.
% * |'Binning'| = 1, 2, 4, or 8.
mmhandle.CameraDevice = mmhandle.core.getCameraDevice;
%% Channel Presets
% In micromanager, there are the concepts of "Groups" and "Presets". Groups
% are sets of parameters that are changed togther. For instance, a simple
% group would consist of a filter and a shutter. This is a fundamental
% pairing in Micromanager and a special group called *Channel* is reserved
% for this very purpose.
%
% Presets are values assigned to the parameters in a Group to make repeated
% changes easier.The YFP filter will always be paired with the shutter to
% the fluorescence lamp and a brightfield image will always be paired with
% the shutter to the brightfield lamp. Taking consecutive images between
% the brightfield channel and the YFP channel would consist of changing the
% presets in the *Channel* group from *YFP* to *BF* for instance.
%
% Apparently, this check can also be made using the method
% |core.getChannelGroup|.
%
% This function assumes the Channel group exists, but a check is made
% first...
groups = mmhandle.core.getAvailableConfigGroups.toArray; %the output is a java.lang.String[]
% Convert the java.lang.String[] to an cell array of strings.
groups = cell(groups);
% Confirm the group *Channel* is present
if ~any(strcmp('Channel',groups))
    error('CoreInit:noChannel','The group ''Channel'' could not be found.');
end
%%
% The *Presets* or *Configs* for the *Channel* group are identified.
%
% Should the closet scope and curtain scope have different names for their
% presets? The filters are physically different, yet are often the same
% part number. I am not certain what the best approach is.
%
% Configs can be check in MATLAB via the following commands (example given):
% # |a = core.getConfigData('Channel','Cy5');|
% # |b = a.getVerbose;|
% # |b = char(b);|
Channel = mmhandle.core.getAvailableConfigs('Channel').toArray;
mmhandle.Channel = cell(Channel);
%% Shutter Device
%
mmhandle.ShutterDevice = mmhandle.core.getShutterDevice;
%% Nikon TI specific devices
% The devices that are specific to the Nikon TI microscope can be
% determined by |core.getAvailableDevices('NikonTI').toArray;|. Available
% Devices and their properties can also be seen in the Property Browser
% from the micromanager gui. Default devices used by the *core*, e.g. those
% found from |core.getCameraDevice|, can also be seen and changed in the
% property browser.
%
% * |TIFilterBlock1| has the filters.
% * |TINosePiece| has the objectives. Check the _Label_ property.
%% The directionality of the XY Stage (Closet Scope)
% The directionality of the stage on the closet scope is opposite to what
% it should be in both the x and y direction. Perhaps when the stage was
% installed it was rotated by 180 degrees. Whatever the cause, to set the
% origin to be the upper-left corner and have the x increase to the right
% and y to increase downwards the following command must be made.
mmhandle.core.setProperty(mmhandle.xyStageDevice,'TransposeMirrorX',1);
mmhandle.core.setProperty(mmhandle.xyStageDevice,'TransposeMirrorY',1);
%% The size of the XY Stage (Closet Scope)
% The following piece of information was collected manually. First, the xy origin was set
% by moving the objective to its limit in one corner. Then, the objective
% was moved to the opposite corner and its coordinates were retrieved.
% These coordinates represent the height and width of the area that the
% objective can travel. Beware that this information is relevant if the
% absolute origin of the stage is known. Unfortunately, the stage is
% typically navigated with reference to a relative origin, so this
% information may be of limited use. For the record...
%
% * x = 116328 microns
% * y = 76260 microns
mmhandle.xyStageSize = [116328,76260];