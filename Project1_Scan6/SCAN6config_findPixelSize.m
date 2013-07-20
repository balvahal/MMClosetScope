%% Command Line User Interface to collect 6-well spatial information
% The goal is to identify the center of each plate. Determine if the plate
% is flat. Collect a reference image.
%% Inputs
% * mmhandle
%% Outputs
% * pcell = a 2 x 3 cell that contains the perimeter data for the 6-well
% format
function [pxlsize] = SCAN6config_findPixelSize(mmhandle)
