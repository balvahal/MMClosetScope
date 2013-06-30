%% Initialize communication between MATLAB, uManager, and the microscope
% Run this script to startup the app, sort of like an ignition starts and
% engine. Hopefully, from here there will be a gui to help facilitate
% interaction with the microscope.
%% Inputs
% NONE
%% Outputs
% NONE
function [] = SCAN6startup_main
%% Initialize
%
[mmcore, mmgui] = SCAN6startup_initialize;
