%%
%
classdef SuperMDALevel3Position
    %%
    % * xyz: the location of the position in an array *[x, y, z]*. The
    % units are micrometers.
    properties
        continuous_focus_offset = 0;
        continuous_focus_bool = true;
        label = 'pos';
        object_type = 'position';
        Parent_MDAGroup;
        position_order = 1;
        position_function_after_name = 'super_mda_position_function_after_basic';
        position_function_after_handle;
        position_function_before_name = 'super_mda_position_function_before_basic';
        position_function_before_handle;
        settings;
        xyz;
    end
    %%
    %
    methods
        %% The constructor method
        % The first argument is always mmhandle
        function obj = SuperMDALevel3Position(mmhandle, my_Parent, my_xyz, my_settings)
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
    end
end