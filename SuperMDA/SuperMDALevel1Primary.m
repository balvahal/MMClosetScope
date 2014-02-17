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
        function obj = update_children_to_reflect_number_of_timepoints(obj)
            obj.configure_clock_relative;
            for i = 1:obj.my_length
                for j = 1:obj.group(i).my_length
                    % xyz
                    mydiff = obj.number_of_timepoints - size(obj.group(i).position(j).xyz,1);
                    if mydiff < 0
                        mydiff2 = obj.number_of_timepoints+1;
                        obj.group(i).position(j).xyz(mydiff2:end,:) = [];
                    elseif mydiff > 0
                        obj.group(i).position(j).xyz(end+1:obj.number_of_timepoints,:) = bsxfun(@times,ones(mydiff,3),obj.group(i).position(j).xyz(end,:));
                    end
                    for k = 1:obj.group(i).position(j).my_length
                        % timepoints
                        mydiff = obj.number_of_timepoints - length(obj.group(i).position(j).settings(k).timepoints);
                        if mydiff < 0
                            mydiff2 = obj.number_of_timepoints+1;
                            obj.group(i).position(j).settings(k).timepoints(mydiff2:end) = [];
                        elseif mydiff > 0
                            obj.group(i).position(j).settings(k).timepoints(end+1:obj.number_of_timepoints) = 1;
                        end
                        % exposure
                        mydiff = obj.number_of_timepoints - length(obj.group(i).position(j).settings(k).exposure);
                        if mydiff < 0
                            mydiff2 = obj.number_of_timepoints+1;
                            obj.group(i).position(j).settings(k).exposure(mydiff2:end) = [];
                        elseif mydiff > 0
                            obj.group(i).position(j).settings(k).exposure(end+1:obj.number_of_timepoints) = obj.group(i).position(j).settings(k).exposure(end);
                        end
                    end
                end
            end
        end
        %% finalize_MDA
        %
        function obj = finalize_MDA(obj)
            %%
            % initialize the table that will store the history of
            % the MDA.
            obj.database = table;
            
            SuperMDAtable = table(...
                obj.number_of_timepoints,...
                {obj.output_directory},...
                obj.duration,...
                obj.fundamental_period,...
                'VariableNames',{'number_of_timepoints','output_directory','duration','fundamental_period'});
            writetable(SuperMDAtable,fullfile(obj.output_directory,'SuperMDA_config.txt'),'Delimiter','\t');
            %% Update the dependent parameters in the MDA object
            % Some parameters in the MDA object are dependent on others.
            % This dependency came about from combining parameters that are
            % easy to configure by a user interface into data structures
            % that are convenient to code with.
            if isempty(obj.group_order) || ...
                    ~isempty(setdiff(obj.group_order,(1:obj.my_length))) || ...
                    length(obj.group_order)~=obj.my_length
                obj.group_order = (1:obj.my_length);
            end
            for i = 1:obj.my_length
                obj.group(i).group_function_before_handle = str2func(obj.group(i).group_function_before_name);
                if isempty(obj.group(i).position_order) || ...
                        ~isempty(setdiff(obj.group(i).position_order,(1:obj.group(i).my_length))) || ...
                        length(obj.group(i).position_order)~=obj.group(i).my_length
                    obj.group(i).position_order = (1:obj.group(i).my_length);
                end
                if isempty(obj.group(i).label)
                    mystr = sprintf('group%d',i);
                    obj.group(i).label = mystr;
                end
                for j = 1:max(size(obj.group(i).position))
                    obj.group(i).position(j).position_function_before_handle = str2func(obj.group(i).position(j).position_function_before_name);
                    for k = 1:max(size(obj.group(i).position(j).settings))
                        obj.group(i).position(j).settings(k).create_z_stack_list;
                        obj.group(i).position(j).settings(k).settings_function_handle = str2func(obj.group(i).position(j).settings(k).settings_function_name);
                    end
                    obj.group(i).position(j).position_function_after_handle = str2func(obj.group(i).position(j).position_function_after_name);
                    if isempty(obj.group(i).position(j).settings_order) || ...
                            ~isempty(setdiff(obj.group(i).position(j).settings_order,(1:obj.group(i).position(j).my_length))) || ...
                            length(obj.group(i).position(j).settings_order)~=obj.group(i).position(j).my_length
                        obj.group(i).position(j).settings_order = (1:obj.group(i).position(j).my_length);
                    end
                end
                obj.group(i).group_function_after_handle = str2func(obj.group(i).group_function_after_name);
            end
            obj.update_children_to_reflect_number_of_timepoints;
        end
        %% update_database
        %
        function obj = update_database(obj,filename,image_description)
            runtime_index2 = num2cell(obj.runtime_index); % a quirk about assigning the contents or a vector to multiple variables means the vector must first be made into a cell.
            [t,g,p,s,z] = deal(runtime_index2{:}); %[timepoint,group,position,settings,z_stack]
            my_dataset = table(...
                cellstr(obj.channel_names{obj.group(g).position(p).settings(s).channel}),...
                cellstr(filename),...
                cellstr(obj.group(g).label),...
                cellstr(obj.group(g).position(p).label),...
                obj.group(g).position(p).settings(s).binning,...
                obj.group(g).position(p).settings(s).channel,...
                obj.group(g).position(p).continuous_focus_offset,...
                obj.group(g).position(p).continuous_focus_bool,...
                obj.group(g).position(p).settings(s).exposure(t),...
                g,...
                obj.group_order(g),...
                now,...
                p,...
                obj.group(g).position_order(p),...
                obj.group(g).position(p).settings_order(s),...
                t,...
                obj.group(g).position(p).xyz(t,1),...
                obj.group(g).position(p).xyz(t,2),...
                obj.group(g).position(p).settings(s).z_origin_offset + ...
                obj.group(g).position(p).settings(s).z_stack(z) + ...
                obj.group(g).position(p).xyz(t,3),...
                z,... %the order of zstack from bottom to top
                cellstr(image_description),...
                'VariableNames',{'channel_name','filename','group_label','position_label','binning','channel_number','continous_focus_offset','continuous_focus_bool','exposure','group_number','group_order','matlab_serial_date_number','position_number','position_order','settings_order','timepoint','x','y','z','z_order','image_description'});
            obj.database = [obj.database;my_dataset]; %add a new row to the dataset
            notify(obj,'database_updated',SuperMDA_event_database_updated(obj.mm));
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