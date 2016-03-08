%% sda
% The root class of sda (Super Dimensional Acquisition). This object can
% be used to initialize the core components of sda in an object-oriented
% programming style. This object also serves to index the functionality
% of sda through its methods. It is a wrapper-like script meant to
% create more readable code.

classdef sda < handle
    methods (Static)
        function [itinerary_object] = itinerary(varargin)
            itinerary_object = itinerary_class(varargin{:});
        end
        function [microscope_object] = microscope()
            microscope_object = microscope_class();
        end
        function [pilot_object] = pilot(varargin)
            pilot_object = pilot_class(varargin{:});
        end
        function [travelagent_object] = travelagent(varargin)
            travelagent_object = travelagent_class(varargin{:});
        end
    end
end