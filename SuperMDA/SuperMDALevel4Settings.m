%%
%
classdef SuperMDALevel4Settings < handle
    %%
    % * Channel: an integer that specifies a Channel group preset
    % * exposure: in milliseconds
    % * z_offset: a distance in micrometers away from the position z-value
    % * z_stack: a list of z-value offsets in micrometers. Images will be
    % acquired at each value offset in this list.
    properties
        % Variables that can be adjusted on the fly for feedback
        timepoints = 1;
        timepoints_custom_bool = false;
        exposure = 100;
        exposure_custom_bool = false;
        % Variables that control what type of image will be captured
        binning = 1;
        Channel = 1;
        period_multiplier = 1;
        % Z-stack variables
        z_origin_offset = 0;
        z_step_size = 0.3;
        z_stack_upper_offset = 0;
        z_stack_lower_offset = 0;
        z_stack;
        z_stack_bool = false;
        % The function to be executed
        settings_function_name = 'super_mda_function_settings_basic';
        settings_function_handle;
        % Variables that define the relationship of this object to other
        % objects in the SuperMDA hierarchy
        Parent_MDAPosition;
    end
    %%
    %
    methods
        %% The constructor method
        % The constructor method was designed to only be called by its
        % parent object. The idea is to have a hierarchy of objects to
        % provide structure to the configuration of an MDA without
        % sacraficing to much customization. After the creation of the
        % SuperMDA tiered-object use the newSettings method to add another
        % settings object.
        function obj = SuperMDALevel4Settings(~,my_Parent)
            if nargin == 0
                return
            elseif nargin == 2
                obj.Parent_MDAPosition = my_Parent;
                obj.create_z_stack_list;
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
                new.(p{i}) = obj.(p{i});
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
                    obj.(p{i}) = obj2.(p{i});
                end
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
                obj.z_stack = obj.z_stack_lower_offset:obj.z_step_size:obj.z_stack_upper_offset;
                obj.z_stack_upper_offset = obj.z_stack(end);
            end
        end
        %% Calculate timepoints
        %
        function obj = calculate_timepoints(obj)
            if obj.timepoints_custom_bool
                return
            end
            obj.timepoints = zeros(size(obj.Parent_MDAPosition.Parent_MDAGroup.Parent_MDAPrimary.mda_clock_relative));
            obj.timepoints(1:obj.period_multiplier:length(obj.timepoints)) = 1;
        end
        %% Set exposures for all timepoints
        % The exposures for all timepoints will be set for the exposure of
        % the first timepoint
        function obj = set_exposures_for_all_timepoints(obj)
            if obj.exposure_custom_bool && length(obj.exposure) == length(obj.timepoints)
                return
            end
            obj.exposure = ones(size(obj.timepoints))*obj.exposure(1);
        end
        %%
        %
    end
end