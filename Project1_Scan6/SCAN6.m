%%
%
classdef SCAN6 < handle
    properties
        smdaI;
        smdaTA;
        mm;
        rowcol;
        gui_main;
    end
    %%
    %
    methods
        %% The constructor method
        % |smdai| is the itinerary that has been initalized with the
        % micromanager core handler object
        function obj = SCAN6(mm,smdaI,smdaTA)
            %%
            %
            if nargin == 0
                return
            elseif nargin == 1
                %% Initialzing the SuperMDA object
                %
                obj.smdaI = smdaI;
                obj.mm = mm;
                obj.smdaTA = smdaTA;
                %% Create a simple gui to enable pausing and stopping
                %
                obj.gui_main = SCAN6_gui_main(obj);
                obj.refresh_gui_main;
            end
        end
    end
end