%%
%
classdef SuperMDATravelAgent < handle
    properties
        itinerary;
        gui_main;
        mm;
        itin_pointer;
        uot_conversion = 1;
    end
    %%
    %
    methods
        %% The constructor method
        % The first argument is always mm
        function obj = SuperMDATravelAgent(smdai)
            %%
            %
            if nargin == 0
                return
            elseif nargin == 1
                %% Initialzing the SuperMDA object
                %
                obj.itinerary = smdai;
                obj.mm = smdai.mm;
                %% Create a simple gui to enable pausing and stopping
                %
                obj.gui_main = SuperMDA_gui_main2(obj);
            end           
        end
        %%
        %
        function obj = refresh_gui_main(obj)
            SuperMDA_method_refresh_gui_main(obj);
        end
                %% delete (make sure its child objects are also deleted)
        % for a clean delete
        function delete(obj)
            delete(obj.gui_main);
        end
    end
    %%
    %
    methods (Static)
        
    end
end