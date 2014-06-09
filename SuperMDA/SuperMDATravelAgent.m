%%
%
classdef SuperMDATravelAgent < handle
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
                obj.refresh_gui_main;
            end
        end
        %%
        %
        function obj = addGroup(obj)
            %%
            % Create a group by augmenting the group_order vector and
            % taking advantage of the the pre-allocation, or create a new
            % group built on the |Itinerary| prototypes.
            obj.itinerary.group_order(end+1) = length(obj.itinerary.group_order)+1;
            if length(obj.itinerary.group_order) < length(obj.itinerary.group)
                % First check to see if a group has been preallocated,
                % which means a new group does not need to be created, only
                % added to the group_order vector.
                return
            else
                %% Create a new group using the prototypes
                % update prototypes
                obj.mm.getXYZ;
                %%
                % create a new group
                obj.itinerary.group(end+1) = obj.itinerary.group(1);
                obj.itinerary.group(end).position_order = 1;
                obj.itinerary.group(end).position(1).xyz = ones(obj.itinerary.number_of_timepoints,3);
                obj.itinerary.group(end).position(1).xyz(:,1) = obj.mm.pos(1);
                obj.itinerary.group(end).position(1).xyz(:,2) = obj.mm.pos(2);
                obj.itinerary.group(end).position(1).xyz(:,3) = obj.mm.pos(3);
                obj.itinerary.group(end).position(1).continuous_focus_offset = str2double(obj.mm.core.getProperty(obj.mm.AutoFocusDevice,'Position'));
                %%
                % update the labels in this group
                mystr = sprintf('group%d',length(obj.itinerary.group));
                obj.itinerary.group(end).label = mystr;
                for i = 1:length(obj.itinerary.group(end).position)
                    mystr = sprintf('position%d',i);
                    obj.itinerary.group(end).position(i).label = mystr;
                end
            end
        end
        %%
        %
        function obj = addPosition(obj,gInd)
            %%
            % Create a position by augmenting the position_order vector and
            % taking advantage of the the pre-allocation, or create a new
            % position built on the |Itinerary| prototypes.
            obj.itinerary.group(gInd).position_order(end+1) = length(obj.itinerary.group(gInd).position_order)+1;
            pInd = obj.itinerary.group(gInd).position_order(end);
            if length(obj.itinerary.group(gInd).position_order) < length(obj.itinerary.group(gInd).position)
                % First check to see if a position has been preallocated,
                % which means a new position does not need to be created,
                % only added to the position_order vector.
                obj.mm.getXYZ;
                obj.itinerary.group(gInd).position(pInd).xyz = ones(obj.itinerary.number_of_timepoints,3);
                obj.itinerary.group(gInd).position(pInd).xyz(:,1) = obj.mm.pos(1);
                obj.itinerary.group(gInd).position(pInd).xyz(:,2) = obj.mm.pos(2);
                obj.itinerary.group(gInd).position(pInd).xyz(:,3) = obj.mm.pos(3);
                obj.itinerary.group(gInd).position(pInd).continuous_focus_offset = str2double(obj.mm.core.getProperty(obj.mm.AutoFocusDevice,'Position'));
                return
            else
                %% Create a new position using the prototypes
                % update prototypes
                obj.itinerary.group(gInd).position(pInd) = obj.itinerary.group(gInd).position(1);
                obj.mm.getXYZ;
                obj.itinerary.group(gInd).position(pInd).xyz = ones(obj.itinerary.number_of_timepoints,3);
                obj.itinerary.group(gInd).position(pInd).xyz(:,1) = obj.mm.pos(1);
                obj.itinerary.group(gInd).position(pInd).xyz(:,2) = obj.mm.pos(2);
                obj.itinerary.group(gInd).position(pInd).xyz(:,3) = obj.mm.pos(3);
                obj.itinerary.group(gInd).position(pInd).continuous_focus_offset = str2double(obj.mm.core.getProperty(obj.mm.AutoFocusDevice,'Position'));
                %%
                % update the labels in this postion
                mystr = sprintf('position%d',length(obj.itinerary.group(gInd).position));
                obj.itinerary.group(gInd).position(end).label = mystr;
            end
        end
        %%
        %
        function obj = addSettings(obj,gInd,pInd)
            %%
            % Create a position by augmenting the position_order vector and
            % taking advantage of the the pre-allocation, or create a new
            % position built on the |Itinerary| prototypes.
            obj.itinerary.group(gInd).position(pInd).settings_order(end+1) = length(obj.itinerary.group(gInd).position(pInd).settings_order)+1;
            if length(obj.itinerary.group(gInd).position(pInd).settings_order) < length(obj.itinerary.group(gInd).position(pInd).settings)
                return
            else
                obj.itinerary.group(gInd).position(pInd).settings(end+1) = obj.itinerary.group(gInd).position(pInd).settings(end);
            end
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
        function obj = changeAllSettings(obj,gInd,settingsProperty,settingsValue)
            %%
            % The change all method will change all the settings properties
            % for all positions in a given group, determined by gInd, to
            % the value in the settings prototype. If the settings
            % prototype is an array of structs then the property value in
            % the first struct is used.
            switch settingsProperty
                case 'binning'
                    for i = obj.itinerary.group(gInd).position_order
                        for j = obj.itinerary.group(gInd).position(i).settings_order
                            obj.itinerary.group(gInd).position(i).settings(j).binning = settingsValue;
                        end
                    end
                case 'z_stack'
                    for i = obj.itinerary.group(gInd).position_order
                        for j = obj.itinerary.group(gInd).position(i).settings_order
                            obj.itinerary.group(gInd).position(i).settings(j).z_stack = settingsValue;
                        end
                    end
                case 'settings_function_name'
                    for i=obj.itinerary.group(gInd).position_order
                        for j = obj.itinerary.group(gInd).position(i).settings_order
                            obj.itinerary.group(gInd).position(i).settings(j).settings_function_name = settingsValue;
                        end
                    end
            end
        end
        %%
        %
        function obj = dropGroup(obj,dropInd)
            %%
            % dropInd can be a vector of indices...
            %
            % First, remove the group(s) and the corresponding indices in
            % the group_order.
            dropInd2 = obj.itinerary.group_order(dropInd);
            obj.itinerary.group(dropInd2) = [];
            obj.itinerary.group_order(dropInd) = [];
            %%
            % Next, edit the group_order so that the numbers within are
            % sequential (although not necessarily in order).
            newNum = transpose(1:length(obj.itinerary.group_order));
            oldNum = transpose(obj.itinerary.group_order);
            funArray = [oldNum,newNum];
            funArray = sortrows(funArray,1);
            obj.itinerary.group_order = transpose(funArray(:,2)); % the group_order must remain a row so that it can be properly looped over.
        end
        %%
        %
        function obj = dropPosition(obj,gInd,dropInd)
            %%
            % dropInd can be a vector of indices...
            %
            % First, remove the position(s) and the corresponding indices
            % in the position_order.
            dropInd2 = obj.itinerary.group(gInd).position_order(dropInd);
            obj.itinerary.group(gInd).position(dropInd2) = [];
            obj.itinerary.group(gInd).position_order(dropInd) = [];
            %%
            % Next, edit the group_order so that the numbers within are
            % sequential (although not necessarily in order).
            newNum = transpose(1:length(obj.itinerary.group(gInd).position_order));
            oldNum = transpose(obj.itinerary.group(gInd).position_order);
            funArray = [oldNum,newNum];
            funArray = sortrows(funArray,1);
            obj.itinerary.group(gInd).position_order = transpose(funArray(:,2)); % the group_order must remain a row so that it can be properly looped over.
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