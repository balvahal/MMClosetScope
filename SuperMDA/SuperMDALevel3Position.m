%%
%
classdef SuperMDALevel3Position
    %%
    % * xyz: the location of the position in an array *[x, y, z]*. The
    % units are micrometers.
    properties
        continuous_focus_offset = 0;
        continuous_focus_bool = false;
        label = 'position';
        Parent_MDAGroup;
        position_order = 1;
        position_function_name = 'super_mda_position_basic';
        position_function_handle;
        settings;
        xyz;
    end
    %%
    %
    methods
        %% The constructor method
        % The first argument is always mmhandle
        function obj = SuperMDAPosition(mmhandle, my_Parent, my_xyz, my_settings)
            if nargin == 0
                return
            elseif nargin == 2
                obj.Parent_MDAGroup = my_Parent;
                obj.xyz = mmhandle.pos;
                obj.settings = SuperMDAPositionSettings(mmhandle, obj);
                return
            end
        end
    end
end