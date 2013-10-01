%%
%
classdef SuperMDAPositionSettings < hgsetget
    %%
    %
    properties
        wavelength
        exposure
        z_offset
        z_stack
        z_stack_bool
        period_multiplier
        snap_function
    end
    %%
    %
    methods
        function obj = SuperMDAPositionSettings(my_wavelength,my_exposure,my_z_offset,my_z_stack,my_z_stack_bool,my_period_multiplier,my_snap_function)
            
        end
    end
end