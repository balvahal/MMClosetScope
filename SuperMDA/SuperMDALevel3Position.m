%%
%
classdef SuperMDALevel3Position
    %%
    % * xyz: the location of the position in an array *[x, y, z]*. The
    % units are micrometers.
    properties
        continuous_focus_offset;
        continuous_focus_bool = true;
        label = 'position';
        Parent_MDAGroup;
        position_order = 1;
        position_function_after_name = 'super_mda_position_function_after_basic';
        position_function_after_handle;
        position_function_before_name = 'super_mda_position_function_before_basic';
        position_function_before_handle;
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
        %% copy this position
        %
        function obj = copy_position(obj)
        end
        %% create new settings
        %
        function obj = new_settings(obj)
            %first, borrow the properties from the last settings to provide
            %a starting point and make sure the parent object is consistent
            obj.settings(end+1) = obj.settings(end).copy_settings;
            %second, change the position order to reflect the position of
            %this object in the object array
            obj.settings(end).settings_order = length(obj.settings);
        end
        %% change the same property for all settings
        %
        function obj = change_all_settings(obj,my_property_name,my_var)
            switch(lower(my_property_name))
                case 'timepoints'
                    if isnumeric(my_var)
                        for i=1:length(obj.settings)
                            obj.settings(i).timepoints = my_var;
                        end
                    end
                case 'binning'
                    if isnumeric(my_var) && length(my_var) == 1
                        for i=1:length(obj.settings)
                            obj.settings(i).binning = my_var;
                        end
                    end
                case 'timepoints_custom_bool'
                    if islogical(my_var) && length(my_var) == 1
                        for i=1:length(obj.settings)
                            obj.settings(i).timepoints_custom_bool = my_var;
                        end
                    end
                case 'snap_function_name'
                    if ischar(my_var)
                        for i=1:length(obj.settings)
                            obj.settings(i).snap_function_name = my_var;
                        end
                    end
                case 'Channel'
                    if isnumeric(my_var) && length(my_var) == 1
                        for i=1:length(obj.settings)
                            obj.settings(i).Channel = my_var;
                        end
                    end
                case 'exposure'
                    if isnumeric(my_var)
                        for i=1:length(obj.settings)
                            obj.settings(i).exposure = my_var;
                        end
                    end
                case 'exposure_custom_bool'
                    if islogical(my_var) && length(my_var) == 1
                        for i=1:length(obj.settings)
                            obj.settings(i).exposure_custom_bool = my_var;
                        end
                    end
                case 'parent_mdaposition'
                    %This really shouldn't ever need to be called, because
                    %by definition every child shares the same parent
                    if isa(my_var,'SuperMDALevel3Position')
                        for i=1:length(obj.settings)
                            obj.settings(i).Parent_MDAPosition = my_var;
                        end
                    end
                case 'period_multiplier'
                    if isnumeric(my_var) && length(my_var) == 1
                        for i=1:length(obj.settings)
                            obj.settings(i).period_multiplier = my_var;
                        end
                    end
                case 'z_origin_offset'
                    if isnumeric(my_var) && length(my_var) == 1
                        for i=1:length(obj.settings)
                            obj.settings(i).z_origin_offset = my_var;
                        end
                    end
                case 'z_step_size'
                    if isnumeric(my_var) && length(my_var) == 1
                        for i=1:length(obj.settings)
                            obj.settings(i).z_step_size = my_var;
                        end
                    end
                case 'z_stack'
                    if isnumeric(my_var)
                        for i=1:length(obj.settings)
                            obj.settings(i).z_stack = my_var;
                        end
                    end
                case 'z_stack_upper_offset'
                    if isnumeric(my_var) && length(my_var) == 1
                        for i=1:length(obj.settings)
                            obj.settings(i).z_stack_upper_offset = my_var;
                        end
                    end
                case 'z_stack_lower_offset'
                    if isnumeric(my_var) && length(my_var) == 1
                        for i=1:length(obj.settings)
                            obj.settings(i).z_stack_lower_offset = my_var;
                        end
                    end
                case 'z_stack_bool'
                    if islogical(my_var) && length(my_var) == 1
                        for i=1:length(obj.settings)
                            obj.settings(i).z_stack_bool = my_var;
                        end
                    end
                otherwise
                    warning('settings:chg_all','The property entered was not recognized');
            end
        end
    end
end