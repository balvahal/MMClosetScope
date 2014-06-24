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
                obj.gui_main = SuperMDA_gui_main2(obj);
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
        function obj = addSettings(obj,gInd,pInd)
            obj = SuperMDATravelAgent_method_addSettings(obj,gInd,pInd);
        end
        %%
        %
        function obj = changeAllPosition(obj,gInd,positionProperty,positionValue)
            %%
            % The change all method will change all the position properties
            % in a given group, determined by gInd, to the value in the
            % position prototype.
            switch positionProperty
                case 'continuous_focus_bool'
                    for i=obj.itinerary.group(gInd).position_order
                        obj.itinerary.group(gInd).position(i).continuous_focus_bool = positionValue;
                    end
                case 'continuous_focus_offset'
                    for i=obj.itinerary.group(gInd).position_order
                        obj.itinerary.group(gInd).position(i).continuous_focus_offset = positionValue;
                    end
                case 'settings_order'
                    for i=obj.itinerary.group(gInd).position_order
                        obj.itinerary.group(gInd).position(i).settings_order = positionValue;
                    end
                case 'position_function_after_name'
                    for i=obj.itinerary.group(gInd).position_order
                        obj.itinerary.group(gInd).position(i).position_function_after_name = positionValue;
                    end
                case 'position_function_before_name'
                    for i=obj.itinerary.group(gInd).position_order
                        obj.itinerary.group(gInd).position(i).position_function_before_name = positionValue;
                    end
                case 'tileNumber'
                    for i=obj.itinerary.group(gInd).position_order
                        obj.itinerary.group(gInd).position(i).tileNumber = positionValue;
                    end
            end
        end
        %%
        %
        function obj = changeAllSettings(obj,varargin)
            if isempty(varargin)
                obj = SuperMDATravelAgent_method_changeAllSettings(obj);
            else
                obj = SuperMDATravelAgent_method_changeAllSettings(obj,varargin{:});
            end
            %%
            % The change all method will change all the settings properties
            % for all positions in a given group, determined by gInd, to
            % the value in the settings prototype. If the settings
            % prototype is an array of structs then the property value in
            % the first struct is used.
%             switch settingsProperty
%                 case 'binning'
%                     for i = obj.itinerary.group(gInd).position_order
%                         for j = obj.itinerary.group(gInd).position(i).settings_order
%                             obj.itinerary.group(gInd).position(i).settings(j).binning = settingsValue;
%                         end
%                     end
%                 case 'z_stack'
%                     for i = obj.itinerary.group(gInd).position_order
%                         for j = obj.itinerary.group(gInd).position(i).settings_order
%                             obj.itinerary.group(gInd).position(i).settings(j).z_stack = settingsValue;
%                         end
%                     end
%                 case 'settings_function_name'
%                     for i=obj.itinerary.group(gInd).position_order
%                         for j = obj.itinerary.group(gInd).position(i).settings_order
%                             obj.itinerary.group(gInd).position(i).settings(j).settings_function_name = settingsValue;
%                         end
%                     end
%             end
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