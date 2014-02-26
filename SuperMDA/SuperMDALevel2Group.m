%% The SuperMDAGroup is the highest level object in MDA
% The SuperMDAGroup allows multiple multi-dimensional-acquisitions to be
% run simulataneously. Each group consists of 1 or more positions. The
% settings at each position are coordinated in a group by having each
% additional position duplicate the first defined position. The settings at
% each position can be customized within each group if desired.
classdef SuperMDALevel2Group < handle
    %%
    % * duration: the length of a time lapse experiment in seconds. A
    % duration of zero means only a single set of images are captured, e.g.
    % for a scan slide feature.
    % * filename_prefix: the string that is placed at the front of the
    % image filename.
    % * fundamental_period: the shortest period that images are taken in
    % seconds.
    % * output_directory: The directory where the output images are stored.
    %
    properties
        label = '';
        Parent_MDAPrimary;
        position;
        group_function_after_name = 'super_mda_function_group_after_basic';
        group_function_after_handle;
        group_function_before_name = 'super_mda_function_group_before_basic';
        group_function_before_handle;
        mm
        position_order = 1;
        travel_offset = -2000; %-2000 micrometers in the z direction to avoid scraping the objective on the bottom of a plate holder.
        travel_offset_bool = true;
    end
    %%
    %
    methods
        %% The constructor method
        % The constructor method was designed to only be called by its
        % parent object. The idea is to have a hierarchy of objects to
        % provide structure to the configuration of an MDA without
        % sacraficing to much customization. After the creation of the
        % SuperMDA tiered-object use the new_group method to add another
        % group object.
        function obj = SuperMDALevel2Group(my_Parent)
            if nargin == 0
                return
            elseif nargin == 1
                obj.Parent_MDAPrimary = my_Parent;
                obj.mm = my_Parent.mm;
                obj.position = SuperMDALevel3Position(obj);
                return
            end
        end
        %%
        % Make a copy of a handle object.
        function new = copy(obj)
            % Instantiate new object of the same class.
            new = feval(class(obj));
            
            % Copy all non-hidden properties.
            p = properties(obj);
            for i = 1:length(p)
                if strcmp('position',p{i})
                    for j=1:length(obj.(p{i}))
                        if j==1
                            new.(p{i}) = obj.(p{i})(j).copy;
                        else
                            new.(p{i})(j) = obj.(p{i})(j).copy;
                        end
                    end
                else
                    new.(p{i}) = obj.(p{i});
                end
            end
        end
        %% clone
        %
        function obj = clone(obj,obj2)
            % Make sure objects are of the same type
            if class(obj) == class(obj2)
                % Copy all non-hidden properties.
                p = properties(obj);
                for i = 1:length(p)
                    if strcmp('position',p{i})
                        obj.(p{i}) = [];
                        for j=1:length(obj.(p{i}))
                            if j==1
                                obj.(p{i}) = obj2.(p{i})(j).copy;
                            else
                                obj.(p{i})(j) = obj2.(p{i})(j).copy;
                            end
                        end
                    else
                        obj.(p{i}) = obj2.(p{i});
                    end
                end
            end
        end
        %% create a new position
        %
        function obj = new_position(obj)
            %first, borrow the properties from the last position to provide
            %a starting point and make sure the parent object is consistent
            obj.position(end+1) = obj.position(end).copy;
            obj.position_order(end+1) = obj.my_length;
            obj.mm.getXYZ;
            obj.position(end).continuous_focus_offset = str2double(obj.mm.core.getProperty(obj.mm.AutoFocusDevice,'Position'));
            obj.position(end).xyz = obj.mm.pos;
        end
        %%
        % Find the number of position objects.
        function len = my_length(obj)
            obj_array = obj.position;
            len = length(obj_array);
        end
        %% change the same property for all positions
        %
        function obj = change_all_position(obj,my_property_name,my_var)
            switch(lower(my_property_name))
                case 'continuous_focus_offset'
                    if isnumeric(my_var) && length(my_var) == 1
                        for i=1:obj.my_length
                            obj.position(i).continuous_focus_offset = my_var;
                        end
                    end
                case 'continuous_focus_bool'
                    if islogical(my_var) && length(my_var) == 1
                        for i=1:obj.my_length
                            obj.position(i).continuous_focus_bool = my_var;
                        end
                    end
                case 'xyz'
                    if isnumeric(my_var)
                        for i=1:obj.my_length
                            obj.position(i).xyz = my_var;
                        end
                    end
                case 'position_function_after_name'
                    if ischar(my_var)
                        for i=1:obj.my_length
                            obj.position(i).position_function_after_name = my_var;
                        end
                    end
                case 'position_function_before_name'
                    if ischar(my_var)
                        for i=1:obj.my_length
                            obj.position(i).position_function_before_name = my_var;
                        end
                    end
                case 'settings'
                    if isa(my_var,'SuperMDALevel4Settings')
                        for i=1:obj.my_length
                            obj.position(i).settings = [];
                            for j=1:length(my_var)
                                if j == 1
                                    obj.position(i).settings = my_var(j).copy;
                                else
                                    obj.position(i).settings(j) = my_var(j).copy;
                                end
                            end
                        end
                    end
                case 'settings_order'
                    if isnumeric(my_var)
                        for i=1:obj.my_length
                            obj.position(i).settings_order = my_var;
                        end
                    end
                case 'parent_mdagroup'
                    %This really shouldn't ever need to be called, because
                    %by definition every child shares the same parent
                    if isa(my_var,'SuperMDALevel2Group')
                        for i=1:obj.my_length
                            obj.position(i).Parent_MDAGroup = my_var;
                        end
                    end
                case 'label'
                    if ischar(my_var)
                        for i=1:obj.my_length
                            obj.position(i).label = my_var;
                        end
                    end
                otherwise
                    warning('group:chg_all','The property entered was not recognized');
            end
        end
    end
end