%%
%
classdef SuperMDALevel3Position < handle
    %%
    % * xyz: the location of the position in an array *[x, y, z]*. The
    % units are micrometers.
    properties
        continuous_focus_offset;
        continuous_focus_bool = true;
        label = '';
        Parent_MDAGroup;
        position_function_after_name = 'super_mda_function_position_after_basic';
        position_function_after_handle;
        position_function_before_name = 'super_mda_function_position_before_basic';
        position_function_before_handle;
        settings_order;
        settings;
        xyz;
        xyz_custom_bool = false;
    end
    %%
    %
    methods
        %% The constructor method
        % The constructor method was designed to only be called by its
        % parent object. The idea is to have a hierarchy of objects to
        % provide structure to the configuration of an MDA without
        % sacraficing to much customization. After the creation of the
        % SuperMDA tiered-object use the new_position method to add another
        % position object.
        function obj = SuperMDALevel3Position(mmhandle, my_Parent)
            if nargin == 0
                return
            elseif nargin == 2
                obj.Parent_MDAGroup = my_Parent;
                obj.xyz = mmhandle.pos;
                obj.continuous_focus_offset = mmhandle.core.getProperty(mmhandle.AutoFocusDevice,'Position');
                obj.settings = SuperMDALevel4Settings(mmhandle, obj);
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
                if strcmp('settings',p{i})
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
                    if strcmp('settings',p{i})
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
        %% create new settings object for this position
        %
        function obj = new_settings(obj)
            %first, borrow the properties from the last settings to provide
            %a starting point and make sure the parent object is consistent
            obj.settings(end+1) = obj.settings(end).copy;
        end
        %%
        % Find the number of settings objects for this position.
        function len = my_length(obj)
            obj_array = obj.settings;
            len = length(obj_array);
        end
        
        %% change the same property for all settings
        %
        function obj = change_all_settings(obj,my_property_name,my_var)
            switch(lower(my_property_name))
                case 'timepoints'
                    if isnumeric(my_var)
                        for i=1:obj.my_length
                            obj.settings(i).timepoints = my_var;
                        end
                    end
                case 'binning'
                    if isnumeric(my_var) && length(my_var) == 1
                        for i=1:obj.my_length
                            obj.settings(i).binning = my_var;
                        end
                    end
                case 'timepoints_custom_bool'
                    if islogical(my_var) && length(my_var) == 1
                        for i=1:obj.my_length
                            obj.settings(i).timepoints_custom_bool = my_var;
                        end
                    end
                case 'snap_function_name'
                    if ischar(my_var)
                        for i=1:obj.my_length
                            obj.settings(i).snap_function_name = my_var;
                        end
                    end
                case 'Channel'
                    if isnumeric(my_var) && length(my_var) == 1
                        for i=1:obj.my_length
                            obj.settings(i).Channel = my_var;
                        end
                    end
                case 'exposure'
                    if isnumeric(my_var)
                        for i=1:obj.my_length
                            obj.settings(i).exposure = my_var;
                        end
                    end
                case 'exposure_custom_bool'
                    if islogical(my_var) && length(my_var) == 1
                        for i=1:obj.my_length
                            obj.settings(i).exposure_custom_bool = my_var;
                        end
                    end
                case 'parent_mdaposition'
                    %This really shouldn't ever need to be called, because
                    %by definition every child shares the same parent
                    if isa(my_var,'SuperMDALevel3Position')
                        for i=1:obj.my_length
                            obj.settings(i).Parent_MDAPosition = my_var;
                        end
                    end
                case 'period_multiplier'
                    if isnumeric(my_var) && length(my_var) == 1
                        for i=1:obj.my_length
                            obj.settings(i).period_multiplier = my_var;
                        end
                    end
                case 'z_origin_offset'
                    if isnumeric(my_var) && length(my_var) == 1
                        for i=1:obj.my_length
                            obj.settings(i).z_origin_offset = my_var;
                        end
                    end
                case 'z_step_size'
                    if isnumeric(my_var) && length(my_var) == 1
                        for i=1:obj.my_length
                            obj.settings(i).z_step_size = my_var;
                        end
                    end
                case 'z_stack'
                    if isnumeric(my_var)
                        for i=1:obj.my_length
                            obj.settings(i).z_stack = my_var;
                        end
                    end
                case 'z_stack_upper_offset'
                    if isnumeric(my_var) && length(my_var) == 1
                        for i=1:obj.my_length
                            obj.settings(i).z_stack_upper_offset = my_var;
                        end
                    end
                case 'z_stack_lower_offset'
                    if isnumeric(my_var) && length(my_var) == 1
                        for i=1:obj.my_length
                            obj.settings(i).z_stack_lower_offset = my_var;
                        end
                    end
                case 'z_stack_bool'
                    if islogical(my_var) && length(my_var) == 1
                        for i=1:obj.my_length
                            obj.settings(i).z_stack_bool = my_var;
                        end
                    end
                otherwise
                    warning('settings:chg_all','The property entered was not recognized');
            end
        end
    end
end