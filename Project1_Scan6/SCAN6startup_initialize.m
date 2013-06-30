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
function [mmcore, mmgui] = SCAN6startup_initialize()
import org.micromanager.MMStudioMainFrame;
mmgui = MMStudioMainFrame(false);
mmgui.show;
mmcore = mmgui.getCore;