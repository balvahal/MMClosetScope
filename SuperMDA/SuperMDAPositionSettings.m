%%
%
classdef SuperMDAPositionSettings < hgsetget
    %%
    % * exposure: in milliseconds
    % * wavelength: an integer that specifies a Channel group preset
    % * z_offset: a distance in micrometers away from the position z-value
    % * z_stack: a list of z-value offsets in micrometers. Images will be
    % acquired at each value offset in this list.
    properties
        wavelength = 1;
        exposure = 100;
        z_origin_offset = 0;
        z_step_size = 0.3;
        z_stack_upper_offset = 0;
        z_stack_lower_offset = 0;
        z_stack;
        z_stack_bool = false;
        period_multiplier = 1;
        snap_function = @super_mda_snap_basic;
    end
    %%
    %
    methods
        %% The constructor method
        % The first argument is always mmhandle
        function obj = SuperMDAPositionSettings(mmhandle,my_wavelength,my_exposure,my_z_offset,my_z_stack,my_z_stack_bool,my_period_multiplier,my_snap_function)
            if nargin == 0
                return
            elseif nargin == 1
                % make z_stack
                return
            end
        end
        %% Make z_stack list
        % The z_stack list is generated using the step_size, upper_offset,
        % and lower_offset;
        function obj = create_z_stack_list(obj)
            range = obj.z_stack_upper_offset - obj.z_stack_lower_offset;
            if range<=0
                obj.z_stack_upper_offset = 0;
                obj.z_stack_lower_offset = 0;
                obj.z_stack = 0;
            else
                obj.z_stack = obj.z_stack_lower_limit:obj.z_step_size:obj.z_stack_upper_limit;
                obj.z_stack_upper_limit = obj.z_stack(end);
            end
        end
    end
end