%% Initialize communication between MATLAB, uManager, and the microscope
% Run this script to startup the app, sort of like an ignition starts and
% engine. Hopefully, from here there will be a gui to help facilitate
% interaction with the microscope.
%% Inputs
% NONE
%% Outputs
% NONE

%% Initialize
%
mm = Core_MicroManagerHandle;
smdaITF = SuperMDAItineraryTimeFixed_object(mm);
smdaTA = SuperMDATravelAgent_object(smdaITF);
scan6 = SCAN6_object(mm,smdaITF,smdaTA);