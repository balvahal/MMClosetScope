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
        % Variables that control what type of image will be captured
        binning = 1;
        channel = 1;
        % Z-stack variables
        z_origin_offset = 0;
        z_stack;
        % The function to be executed
        settings_function_name = 'super_mda_function_settings_basic';
        settings_function_handle;
        % Variables that define the relationship of this object to other
        % objects in the SuperMDA hierarchy
        Parent_MDAPosition;
    end
    properties (SetObservable)
        % Variables that can be adjusted on the fly for feedback
        exposure;
        period_multiplier;
        timepoints;
        z_step_size = 0.3;
        z_stack_upper_offset = 0;
        z_stack_lower_offset = 0;
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
                addlistener(obj,'exposure','PostSet',@SuperMDALevel4Settings.updateCustomizables);
                addlistener(obj,'timepoints','PostSet',@SuperMDALevel4Settings.updateCustomizables);
                addlistener(obj,'period_multiplier','PostSet',@SuperMDALevel4Settings.updateCustomizables);
                addlistener(obj,'z_step_size','PostSet',@SuperMDALevel4Settings.updateCustomizables);
                addlistener(obj,'z_stack_upper_offset','PostSet',@SuperMDALevel4Settings.updateCustomizables);
                addlistener(obj,'z_stack_lower_offset','PostSet',@SuperMDALevel4Settings.updateCustomizables);
                obj.Parent_MDAPosition = my_Parent;
                obj.create_z_stack_list;
                obj.exposure = 0;
                obj.timepoints = 1;
                obj.period_multiplier = 1;
                return
            end
        end
        %% copy
        % Makes a new instance of a settings object with the same info as
        % source object.
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
        % Copies the information from the second input object into the
        % first input object
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
    end
    %%
    %
    methods (Static)
        %% update array length of customizables
        % The customizables are xyz, exposure, and timepoints
        function updateCustomizables(~,evtdata)
            switch evtdata.Source.Name
                case 'exposure'
                    mydiff = evtdata.AffectedObject.Parent_MDAPosition.Parent_MDAGroup.Parent_MDAPrimary.number_of_timepoints - length(evtdata.AffectedObject.exposure);
                    if mydiff < 0
                        mydiff2 = evtdata.AffectedObject.Parent_MDAPosition.Parent_MDAGroup.Parent_MDAPrimary.number_of_timepoints+1;
                        evtdata.AffectedObject.exposure(mydiff2:end,:) = [];
                    elseif mydiff > 0
                        evtdata.AffectedObject.exposure(end+1:evtdata.AffectedObject.Parent_MDAPosition.Parent_MDAGroup.Parent_MDAPrimary.number_of_timepoints,:) = evtdata.AffectedObject.exposure(end);
                    end
                case 'timepoints'
                    mydiff = evtdata.AffectedObject.Parent_MDAPosition.Parent_MDAGroup.Parent_MDAPrimary.number_of_timepoints - length(evtdata.AffectedObject.timepoints);
                    if mydiff < 0
                        mydiff2 = evtdata.AffectedObject.Parent_MDAPosition.Parent_MDAGroup.Parent_MDAPrimary.number_of_timepoints+1;
                        evtdata.AffectedObject.timepoints(mydiff2:end,:) = [];
                    elseif mydiff > 0
                        %evtdata.AffectedObject.timepoints(end+1:evtdata.AffectedObject.Parent_MDAPosition.Parent_MDAGroup.Parent_MDAPrimary.number_of_timepoints,:)= 1;
                        evtdata.AffectedObject.timepoints = zeros(size(evtdata.AffectedObject.Parent_MDAPosition.Parent_MDAGroup.Parent_MDAPrimary.mda_clock_relative));
                        evtdata.AffectedObject.timepoints(1:evtdata.AffectedObject.period_multiplier:length(evtdata.AffectedObject.timepoints)) = 1;
                    end
                case 'period_multiplier'
                    evtdata.AffectedObject.timepoints = zeros(size(evtdata.AffectedObject.Parent_MDAPosition.Parent_MDAGroup.Parent_MDAPrimary.mda_clock_relative));
                    evtdata.AffectedObject.timepoints(1:evtdata.AffectedObject.period_multiplier:length(evtdata.AffectedObject.timepoints)) = 1;
                case 'z_step_size'
                    evtdata.AffectedObject.create_z_stack_list;
                case 'z_stack_upper_offset'
                    evtdata.AffectedObject.create_z_stack_list;
                case 'z_stack_lower_offset'
                    evtdata.AffectedObject.create_z_stack_list;
            end
        end
    end
end