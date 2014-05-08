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
                obj.itinerary.prototype_settings.exposure = ones(obj.itinerary.number_of_timepoints,1);
                obj.itinerary.prototype_settings.timepoints = ones(obj.itinerary.number_of_timepoints,1);
                obj.mm.getXYZ;
                obj.itinerary.prototype_position.xyz = ones(obj.itinerary.number_of_timepoints,3);
                obj.itinerary.prototype_position.xyz(:,1) = obj.mm.pos(1);
                obj.itinerary.prototype_position.xyz(:,2) = obj.mm.pos(2);
                obj.itinerary.prototype_position.xyz(:,3) = obj.mm.pos(3);
                obj.itinerary.prototype_position.settings = obj.itinerary.prototype_settings;
                obj.itinerary.prototype_group.position = obj.itinerary.prototype_position;
                %%
                % create a new group
                obj.itinerary.group(end+1) = obj.itinerary.prototype_group;
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
        function obj = dropGroup(obj,dropInd)
            %%
            % dropInd can be a vector of indices...
            %
            % First, remove the groups and the corresponding indices in the
            % group_order.
            obj.itinerary.group(dropInd) = [];
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