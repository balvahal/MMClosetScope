%% sda
% The root class of sda (Super Dimensional Acquisition). This object can
% be used to initialize the core components of sda in an object-oriented
% programming style. This object also serves to index the functionality
% of sda through its methods. It is a wrapper-like script meant to
% create more readable code.

classdef sda < handle
    methods (Static)
        function [microscope_object] = microscope()
            microscope_object = microscope_class();
        end
    end
end