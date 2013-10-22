%% The SuperMDAGroup is the highest level object in MDA
% The SuperMDAGroup allows multiple multi-dimensional-acquisitions to be
% run simulataneously. Each group consists of 1 or more position. The
% settings at each position are coordinated in a group by having each
% additional position duplicate the first defined position. The settings at
% each position can be customized within each group if desired.
classdef SuperMDALevel1Primary
    %%
    % * duration: the length of a time lapse experiment in seconds. A
    % duration of zero means only a single set of images are captured, e.g.
    % for a scan slide feature.
    % * filename_prefix: the string that is placed at the front of the
    % image filename.
    % * fundamental_period: the shortest period that images are taken
    % in seconds.
    % * output_directory: The directory where the output images are stored.
    %
    properties
        database_execution;
        database_filenames;
        database_counter = 0;
        duration = 0;
        fundamental_period = 300; %5 minutes is the default. The units are seconds.
        group;
        mda_clock_absolute;
        mda_clock_relative = 0;
        number_of_timepoints;
        output_directory;
    end
    %%
    %
    methods
        %% The constructor method
        % The first argument is always mmhandle
        function obj = SuperMDALevel1Primary(mmhandle)
            if nargin == 0
                return
            elseif nargin == 1
                obj.group = SuperMDALevel2Group(mmhandle, obj);
                return
            end
        end
        %% Configure the relative clock
        %
        function obj = configure_clock_relative(obj)
            obj.mda_clock_relative = 0:obj.fundamental_period:obj.duration;
            obj.number_of_timepoints = length(obj.mda_clock_relative);
        end
        %% Configure the absolute clock
        % Convert the MDA object unit of time (seconds) to the
        % MATLAB unit of time (days) for the serial date numbers, i.e. the
        % number of days that have passed since January 1, 0000.
        function obj = configure_clock_absolute(obj)
            obj.mda_clock_absolute = now + obj.mda_clock_relative/86400;
        end
        %% Update child objects to relfect number of timepoints
        % The highly customizable features of the mda include exposure, xyz
        % position, and timepoints. These properties must have the same
        % length. This function will ensure they all have the same length.
        function obj = update_children_to_reflect_number_of_timepoints(obj)
            obj.configure_clock_relative;
            for i = 1:length(obj.group)
                for j = 1:length(obj.group(i).position)
                    mydiff = obj.number_of_timepoints - size(obj.group(i).position(j).xyz,1);
                    if mydiff < 0
                        mydiff = abs(mydiff)+1;
                        obj.group(i).position(j).xyz(mydiff:end,:) = [];
                    elseif mydiff > 0
                        obj.group(i).position(j).xyz(end+1:obj.number_of_timepoints,:) = ones(mydiff,3).*obj.group(i).position(j).xyz(end,:);
                    end
                    for k = 1:length(obj.group(i).position(j).settings)
                        mydiff = obj.number_of_timepoints - length(obj.group(i).position(j).settings(k).timepoints);
                        if mydiff < 0
                            mydiff = abs(mydiff)+1;
                            obj.group(i).position(j).settings(k).timepoints(mydiff:end) = [];
                        elseif mydiff > 0
                            obj.group(i).position(j).settings(k).timepoints(end+1:obj.number_of_timepoints) = 1;
                        end
                        mydiff = obj.number_of_timepoints - length(obj.group(i).position(j).settings(k).exposure);
                        if mydiff < 0
                            mydiff = abs(mydiff)+1;
                            obj.group(i).position(j).settings(k).exposure(mydiff:end) = [];
                        elseif mydiff > 0
                            obj.group(i).position(j).settings(k).exposure(end+1:obj.number_of_timepoints) = obj.group(i).position(j).settings(k).exposure(end);
                        end
                    end
                end
            end
        end
        %% create a new group
        %
        function obj = new_group(obj)
            %first, borrow the properties from the last group to provide
            %a starting point and make sure the parent object is consistent
            obj.group(end+1) = obj.group(end).copy_group;
        end
        %% change the same property for all group
        %
        function obj = change_all_group(obj,my_property_name,my_var)
            switch(lower(my_property_name))
                case 'travel_offset'
                    if isnumeric(my_var) && length(my_var) == 1
                        for i=1:length(obj.group)
                            obj.group(i).travel_offset = my_var;
                        end
                    end
                case 'travel_offset_bool'
                    if islogical(my_var) && length(my_var) == 1
                        for i=1:length(obj.group)
                            obj.group(i).travel_offset_bool = my_var;
                        end
                    end
                case 'group_function_after_name'
                    if ischar(my_var)
                        for i=1:length(obj.group)
                            obj.group(i).group_function_after_name = my_var;
                        end
                    end
                case 'group_function_before_name'
                    if ischar(my_var)
                        for i=1:length(obj.group)
                            obj.group(i).group_function_before_name = my_var;
                        end
                    end
                case 'parent_mdaprimary'
                    %This really shouldn't ever need to be called, because
                    %by definition every child shares the same parent
                    if isa(my_var,'SuperMDALevel2Group')
                        for i=1:length(obj.position)
                            obj.group(i).Parent_MDAGroup = my_var;
                        end
                    end
                case 'label'
                    if ischar(my_var)
                        for i=1:length(obj.group)
                            obj.group(i).label = my_var;
                        end
                    end
                otherwise
                    warning('primary:chg_all','The property entered was not recognized');
            end
        end
    end
end