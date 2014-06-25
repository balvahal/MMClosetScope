%%
%
classdef SuperMDATravelAgent_object < handle
    properties
        itinerary;
        gui_main;
        mm;
        pointerGroup = 1;
        pointerPosition = 1;
        pointerSettings = 1;
        uot_conversion = 1;
    end
    %%
    %
    methods
        %% The constructor method
        % |smdai| is the itinerary that has been initalized with the
        % micromanager core handler object
        function obj = SuperMDATravelAgent_object(smdai)
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
                obj.gui_main = SuperMDATravelAgent_gui_main(obj);
                obj.refresh_gui_main;
            end
        end
        %%
        %
        function obj = addGroup(obj)
            obj = SuperMDATravelAgent_method_addGroup(obj);
        end
        %%
        %
        function obj = addPosition(obj,gInd)
            obj = SuperMDATravelAgent_method_addPosition(obj,gInd);
        end
        %%
        %
        function obj = addPositionSet(obj,gInd,grid)
            obj = SuperMDATravelAgent_method_addPositionSet(obj,gInd,grid);
        end
        %%
        %
        function obj = addSettings(obj,gInd,pInd)
            obj = SuperMDATravelAgent_method_addSettings(obj,gInd,pInd);
        end
        %%
        %
        function obj = changeAllGroup(obj,param,val,varargin)
            if isempty(varargin)
                obj = SuperMDATravelAgent_method_changeAllGroup(obj,param,val);
            else
                obj = SuperMDATravelAgent_method_changeAllGroup(obj,param,val,varargin{:});
            end
        end
        %%
        %
        function obj = changeAllPosition(obj,param,val,varargin)
            if isempty(varargin)
                obj = SuperMDATravelAgent_method_changeAllPosition(obj,param,val);
            else
                obj = SuperMDATravelAgent_method_changeAllPosition(obj,param,val,varargin{:});
            end
        end
        %%
        %
        function obj = changeAllSettings(obj,param,val,varargin)
            if isempty(varargin)
                obj = SuperMDATravelAgent_method_changeAllSettings(obj,param,val);
            else
                obj = SuperMDATravelAgent_method_changeAllSettings(obj,param,val,varargin{:});
            end
        end
        %%
        %
        function obj = createOrdinalLabels(obj,varargin)
            if isempty(varargin)
                obj = SuperMDATravelAgent_method_createOrdinalLabels(obj);
            else
                obj = SuperMDATravelAgent_method_createOrdinalLabels(obj,varargin{:});
            end
        end
        %%
        %
        function obj = dropGroup(obj,dropInd)
            obj = SuperMDATravelAgent_method_dropGroup(obj,dropInd);
        end
        %%
        %
        function obj = dropGroupOrder(obj,dropInd)
            obj = SuperMDATravelAgent_method_dropGroupOrder(obj,dropInd);
        end
        %%
        %
        function obj = dropPosition(obj,gInd,dropInd)
            obj = SuperMDATravelAgent_method_dropPosition(obj,gInd,dropInd);
        end
        %%
        %
        function obj = dropPositionOrder(obj,gInd,dropInd)
            obj = SuperMDATravelAgent_method_dropPositionOrder(obj,gInd,dropInd);
        end
                %%
        %
        function obj = dropSettings(obj,gInd,pInd,dropInd)
            obj = SuperMDATravelAgent_method_dropSettings(obj,gInd,pInd,dropInd);
        end
        %%
        %
        function obj = dropSettingsOrder(obj,gInd,pInd,dropInd)
            obj = SuperMDATravelAgent_method_dropSettingsOrder(obj,gInd,pInd,dropInd);
        end
        %%
        function obj = pushSettings(obj,gInd)
            %%
            % Find the most efficient order of image acquisition, which
            % means the least movement of the filter turret. This can be
            % accomplished by moving the turret in sequential order.
            
            %%
            % Push the prototype settings to all positions in a group
            % determined by gInd
            for i = obj.itinerary.group(gInd).position_order
                obj.itinerary.group(gInd).position(i).settings = obj.itinerary.group(gInd).position(1).settings;
                obj.itinerary.group(gInd).position(i).settings_order = obj.itinerary.group(gInd).position(1).settings_order;
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