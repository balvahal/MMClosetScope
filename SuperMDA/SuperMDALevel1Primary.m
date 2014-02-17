%% The SuperMDAGroup is the highest level object in MDA
% The SuperMDAGroup allows multiple multi-dimensional-acquisitions to be
% run simulataneously. Each group consists of 1 or more position. The
% settings at each position are coordinated in a group by having each
% additional position duplicate the first defined position. The settings at
% each position can be customized within each group if desired.
classdef SuperMDALevel1Primary < handle
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
        channel_names;
        database;
        group;
        group_order = 1;
        mda_clock_absolute;
        mda_clock_pointer = 1;
        mda_clock_relative = 0;
        number_of_timepoints = 1;
        output_directory;
        runtime_imagecounter = 0;
        runtime_index = [1,1,1,1,1]; %when looping through the MDA object, this will keep track of where it is in the loop. [timepoint,group,position,settings,z_stack]
        runtime_timer;
        mm
    end
    properties (SetObservable)
        duration = 0;
        fundamental_period = 300; %5 minutes is the default. The units are seconds.
    end
    %%
    %
    events
        database_updated;
    end
    %%
    %
    methods
        %% The constructor method
        % The first argument is always mmhandle
        function obj = SuperMDALevel1Primary(mmhandle)
            %%
            %
            if nargin == 0
                return
            elseif nargin == 1
                obj.mm = mmhandle;
                obj.channel_names = mmhandle.Channel;
                obj.group = SuperMDALevel2Group(obj);
                addlistener(obj,'duration','PostSet',@SuperMDALevel1Primary.updateCustomizables);
                addlistener(obj,'fundamental_period','PostSet',@SuperMDALevel1Primary.updateCustomizables);
                runtime_timer = timer('TimerFcn',@(~,~) obj.execute);
                return
            end
        end
        %% Copy
        %
        % Make a copy of a handle object.
        function new = copy(obj)
            % Instantiate new object of the same class.
            new = feval(class(obj));
            
            % Copy all non-hidden properties.
            p = properties(obj);
            for i = 1:length(p)
                if strcmp('group',p{i})
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
                    if strcmp('group',p{i})
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
        %% create a new group
        %
        function obj = new_group(obj)
            %first, borrow the properties from the last group to provide a
            %starting point and make sure the parent object is consistent
            obj.group(end+1) = obj.group(end).copy;
            obj.group_order(end+1) = obj.my_length;
        end
        %% Find the number of group objects.
        %
        function len = my_length(obj)
            obj_array = obj.group;
            len = length(obj_array);
        end
        %% change the same property for all group
        %
        function obj = change_all_group(obj,my_property_name,my_var)
            switch(lower(my_property_name))
                case 'travel_offset'
                    if isnumeric(my_var) && length(my_var) == 1
                        for i=1:obj.my_length
                            obj.group(i).travel_offset = my_var;
                        end
                    end
                case 'travel_offset_bool'
                    if islogical(my_var) && length(my_var) == 1
                        for i=1:obj.my_length
                            obj.group(i).travel_offset_bool = my_var;
                        end
                    end
                case 'group_function_after_name'
                    if ischar(my_var)
                        for i=1:obj.my_length
                            obj.group(i).group_function_after_name = my_var;
                        end
                    end
                case 'group_function_before_name'
                    if ischar(my_var)
                        for i=1:obj.my_length
                            obj.group(i).group_function_before_name = my_var;
                        end
                    end
                case 'parent_mdaprimary'
                    %This really shouldn't ever need to be called, because
                    %by definition every child shares the same parent
                    if isa(my_var,'SuperMDALevel2Group')
                        for i=1:max(size(obj.position))
                            obj.group(i).Parent_MDAGroup = my_var;
                        end
                    end
                case 'position'
                    if isa(my_var,'SuperMDALevel3Position')
                        for i=1:obj.my_length
                            obj.group(i).position = [];
                            for j=1:length(my_var)
                                if j == 1
                                    obj.group(i).position = my_var(j).copy;
                                else
                                    obj.group(i).position(j) = my_var(j).copy;
                                end
                            end
                        end
                    end
                case 'position_order'
                    if isnumeric(my_var)
                        for i=1:obj.my_length
                            obj.group(i).position_order = my_var;
                        end
                    end
                case 'label'
                    if ischar(my_var)
                        for i=1:obj.my_length
                            obj.group(i).label = my_var;
                        end
                    end
                otherwise
                    warning('primary:chg_all','The property entered was not recognized');
            end
        end
        %% Configure the relative clock
        %
        function obj = configure_clock_relative(obj)
            obj.mda_clock_relative = 0:obj.fundamental_period:obj.duration;
            obj.number_of_timepoints = length(obj.mda_clock_relative);
        end
        %% Configure the absolute clock
        % Convert the MDA object unit of time (seconds) to the MATLAB unit
        % of time (days) for the serial date numbers, i.e. the number of
        % days that have passed since January 1, 0000.
        function obj = configure_clock_absolute(obj)
            obj.mda_clock_absolute = now + obj.mda_clock_relative/86400;
        end
        %% Update child objects to reflect number of timepoints
        % The highly customizable features of the mda include exposure,
        % xyz, and timepoints. These properties must have the same length.
        % This function will ensure they all have the same length.
        function obj = reflect_number_of_timepoints(obj)
            super_mda_method_reflect_number_of_timepoints(obj);
        end
        %% finalize_MDA
        %
        function obj = finalize_MDA(obj)
            super_mda_method_finalize_MDA(obj);
        end
        %% update_database
        %
        function obj = update_database(obj,filename,image_description)
            super_mda_method_update_database(obj,filename,image_description);
        end
        %% database to CellProfiler CSV
        %
        function obj = database2CellProfilerCSV(obj)
            super_mda_method_database2CellProfilerCSV(obj);
        end
        %% start acquisition
        %
        function obj = start_acquisition(obj)
            obj.finalize_MDA;
            obj.configure_clock_absolute;
            obj.runtime_timer.StopFcn = @(~,~,obj) super_mda_function_runtime_timer_stopfcn(obj);
            startat(obj.runtime_timer,obj.mda_clock_absolute(obj.mda_clock_pointer));
        end
        %% stop acquisition
        %
        function obj = stop_acquisition(obj)
            obj.runtime_timer.StopFcn = '';
            stop(obj.runtime_timer);
        end
        %% pause acquisition
        %
        function obj = pause_acquisition(obj)
            
        end
        %% resume acquisition
        %
        function obj = resume_acquisition(obj)
            
        end
        %% execute 1 round of acquisition
        %
        function obj = execute(obj)
            super_mda_method_execute(obj);
        end
    end
    %%
    %
    methods (Static)
        %% update array length of customizables
        % The customizables are xyz, exposure, and timepoints
        function updateCustomizables(~,evtdata)
            evtdata.AffectedObject.update_children_to_reflect_number_of_timepoints;
            switch evtdata.Source.Name
                case 'duration'
                    evtdata.AffectedObject.duration = evtdata.AffectedObject.mda_clock_relative(end);
                case 'fundamental_period'
                    evtdata.AffectedObject.duration = evtdata.AffectedObject.mda_clock_relative(end);
            end
        end
    end
end