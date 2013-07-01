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
%   import mmcorej.*; 
%   mmc=CMMCore; 
%   path = 'C:\path\to\config\config.cfg';
%   mmc.loadSystemConfiguration(path);
%% Inputs
% NONE
%% Outputs
% mmcore
% mmgui
function [mmhandle] = SCAN6startup_initialize()
%% Create the GUI and the core API object
%
import org.micromanager.MMStudioMainFrame;
mmhandle.gui = MMStudioMainFrame(false);
mmhandle.gui.show;
pause(40); % This is very hackish. You have 40 seconds to load the configuration file.
mmhandle.core = mmhandle.gui.getCore;
%%
% Wait for the gui object to finish initialization and then create the core
% object.
% mmhandle.core = [];
% while ~isa(mmhandle.core,'mmcorej.CMMCore')
%     class(mmhandle.core)
%     mmhandle.core = mmhandle.gui.getCore;
% end
% disp('before');
% mmhandle.core.waitForConfig;
% disp('after');
%% Obtain the object that represents multi-dimensional-acquisition
%
mmhandle.mda = mmhandle.gui.getAcquisitionEngine();
%% Find the xy device and the focus device
%
mmhandle.xyStageDevice = mmhandle.core.getXYStageDevice;
mmhandle.FocusDevice = mmhandle.core.getFocusDevice;
