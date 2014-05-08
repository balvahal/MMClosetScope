%% The SuperMDAItinerary
% The SuperMDA allows multiple multi-dimensional-acquisitions to be run
% simulataneously. Each group consists of 1 or more positions. Each
% position consists of 1 or more settings.
%
% One thing I have struggled with is redundancy in the SuperMDA. In the
% most common cases where no feedback is implemented much of the data
% stored in the SuperMDA is redundant. For example, if 1000 timepoints are
% taken at the same exposure should I keep an array of size 1000 that
% stores just that single number? Such an array might be termed _sparse_,
% because the information in the array is near nil. However, having such an
% array is convenient from a programming sense, because it is easy to
% iterate over without the need to parse through a set of rules that
% determine what will happen at a given timepoint; perhaps a rules-based
% MDA would be more compact, but its interpretation not as clear as a
% multi-dimensional lookup table. From a performance standpoint it is
% necessary to pre-allocate enough memory for the SuperMDA, but without
% going too far and running into the limits of memory in terms of size and
% speed, which are surprisingly easy to reach due to the combinatoric
% explosion of the number of settings.
%
% Regardless, At some point the information in the SuperMDA will become
% _full_ in a sense, because each picture that is captured and stored is
% saved with some metadata. The goal of the SuperMDA is on some level just
% creating all the metadata in advance, which represents a plan of action
% for the collection of images; so what's the harm in storing everything in
% centralized arrays if all this information will eventually be stored in a
% distributed manner anyways?
%
% Perhaps my frustraion is moot, because there is a limit to the number of
% images that can be captured in any given experiment based on the time it
% takes to acquire the images and the sensitivity of living cells to light.
% Also, this doesn't have to be the perfect system, it just has to work.
% Therefore, the array scheme will be kept even if it will be under
% utilized and wasteful; it is easy to implement and understand. The number
% of groups, positions, timepoints, and settings will change based on the
% nature of each experiment, but the maximum number of images acquired for
% each experiment will be roughly the same. For example. Scanning large
% surfaces will yield either a few groups with many positions in the case
% of slides, or many groups with few positions in the case of multi-well
% plates. There is a natural tradeoff between the frequency of imaging and
% the number of positions.
%
% In conclusion, there is a limit to the SuperMDA based upon its design
% where there are no rules and each where, what, and when has an explicit
% answer stored in memory (though the answers can be modified on the fly).
% SuperMDA would be not be appropriate for experiments that have an
% indefinite length of time involved. SuperMDA is |for loop| as opposed to
% a |while loop|. Memory concerns should not become apparent, because only
% so many images can be collected over the length of time in a typical
% experiment. However, the pre-allocation cannot account for all experiment
% types at once. Therefore, pre-allocation will be made with context in
% mind:
%
% * (groups,positions,settings,timepoints)
% * 384well plates for a movie: (384,8,6,192); approx 4TB of image data;
% the plate could be imaged twice an hour for 4 days.
% * 96well plates for a movie: (96,32,6,192); approx 4TB of image data; the
% plate could be imaged twice an hour for 4 days.
% * 24well plates for a movie: (24,128,6,192); approx 4TB of image data;
% the plate could be imaged twice an hour for 4 days.
% * 6x  dishes for a movie: (6,64,6,576); approx 2TB of image data; the
% plates can be imaged every 10 minutes for 4 days.
%
% Better yet, just have the user specify this information ahead of time.
classdef SuperMDAItinerary < handle
    %%
    % * duration: the length of a time lapse experiment in seconds. A
    % duration of zero means only a single set of images are captured, e.g.
    % for a scan slide feature.
    % * filename_prefix: the string that is placed at the front of the
    % image filename.
    % * fundamental_period: the shortest period that images are taken in
    % seconds.
    % * output_directory: The directory where the output images are stored.
    % * group_order: The group_order exists to deal with the issue of
    % pre-allocation. Performance suffers without pre-allocation. Groups
    % are only active if their index exists in the group_order. The
    % |TravelAgent| enforces the numbers within the group_order vector to
    % be sequential (though not necessarily in order).
    properties
        channel_names;
        database;
        database_filenamePNG = '';
        database_imagedescription = '';
        group;
        group_order = 1;
        mda_clock_relative = 0;
        mm;
        output_directory = pwd;
        png_path;
        prototype_group; %The prototype_group serves as a template for the creation or additon of new groups to the SuperMDA object.
        prototype_position; %The prototype_position serves as a template for the creation or additon of new groups to the SuperMDA object.
        prototype_settings; %The prototype_settings serves as a template for the creation or additon of new groups to the SuperMDA object.
    end
    properties (SetAccess = private)
        duration = 0;
        fundamental_period = 600; %The units are seconds. 600 is 10 minutes.
        number_of_timepoints = 1;
        total_number_images = 0;
    end
    %%
    %
    methods
        %% The constructor method
        % The first argument is always mm
        function obj = SuperMDAItinerary(mm)
            %%
            %
            if nargin == 0
                return
            elseif nargin == 1
                %% Initialzing the SuperMDA object
                % When creating this object it is helpful to create
                % prototypes of each group, position, and settings. These
                % MATLAB structs provide a template for the creation and
                % pre-allocation of a SuperMDA. Pre-allocation can be
                % important for performance, so a SuperMDA object of
                % (putatively) enormous size is created in this regard. The
                % user defined size of the SuperMDA is known by the length
                % of the _order_ properties.
                obj.mm = mm;
                obj.channel_names = obj.mm.Channel;
                %% initialize the prototype_group
                %
                obj.prototype_group.label = '';
                obj.prototype_group.group_function_after_name = 'SuperMDA_function_group_after_basic';
                obj.prototype_group.group_function_after_handle = str2func(obj.prototype_group.group_function_after_name);
                obj.prototype_group.group_function_before_name = 'SuperMDA_function_group_before_basic';
                obj.prototype_group.group_function_before_handle = str2func(obj.prototype_group.group_function_before_name);
                obj.prototype_group.position_order = 1;
                obj.prototype_group.user_data = [];
                obj.prototype_group.position = [];
                %% initialize the prototype_position
                %
                obj.prototype_position.continuous_focus_offset = str2double(obj.mm.core.getProperty(obj.mm.AutoFocusDevice,'Position'));
                obj.prototype_position.continuous_focus_bool = true;
                obj.prototype_position.label = '';
                obj.prototype_position.position_function_after_name = 'SuperMDA_function_position_after_basic';
                obj.prototype_position.position_function_after_handle = str2func(obj.prototype_position.position_function_after_name);
                obj.prototype_position.position_function_before_name = 'SuperMDA_function_position_before_basic';
                obj.prototype_position.position_function_before_handle = str2func(obj.prototype_position.position_function_before_name);
                obj.prototype_position.settings_order = 1;
                obj.prototype_position.user_data = [];
                obj.prototype_position.xyz = obj.mm.getXYZ; %This is a customizable array
                obj.prototype_position.settings = [];
                %% initialize the prototype_settings
                %
                obj.prototype_settings.binning = 1;
                obj.prototype_settings.channel = 1;
                obj.prototype_settings.gain = 1;
                obj.prototype_settings.settings_function_name = 'SuperMDA_function_settings_basic';
                obj.prototype_settings.settings_function_handle = str2func(obj.prototype_settings.settings_function_name);
                obj.prototype_settings.settings_function_after_name = 'SuperMDA_function_settings_after_basic';
                obj.prototype_settings.settings_function_after_handle = str2func(obj.prototype_position.position_function_after_name);
                obj.prototype_settings.settings_function_before_name = 'SuperMDA_function_settings_before_basic';
                obj.prototype_settings.settings_function_before_handle = str2func(obj.prototype_position.position_function_before_name);
                obj.prototype_settings.exposure = 1; %This is a customizable arrray
                obj.prototype_settings.period_multiplier = 1;
                obj.prototype_settings.timepoints = 1; %This is a customizable array
                obj.prototype_settings.user_data = [];
                obj.prototype_settings.z_origin_offset = 0;
                obj.prototype_settings.z_stack = 0;
                obj.prototype_settings.z_stack_upper_offset = 0;
                obj.prototype_settings.z_stack_lower_offset = 0;
                obj.prototype_settings.z_step_size = 0.3;
                %%
                % by default the Itinerary should always have at least 1
                % group with 1 position and 1 settings.
                obj.preAllocateMemoryAndInitialize(1,1,1);
            end
        end
        %% Method to change the duration
        %
        function obj = newDuration(obj,mynum)
            %%
            % check to see that number of timepoints is a reasonable number
            % , i.e. it must zero of greater
            if mynum < 0
                return
            end
            %%
            % update other dependent parameters
            obj.duration = mynum;
            obj.number_of_timepoints = floor(obj.duration/obj.fundamental_period)+1; %ensures fundamental period and duration are consistent with each other
            obj.duration = obj.fundamental_period*(obj.number_of_timepoints-1);
            obj.mda_clock_relative = 0:obj.fundamental_period:obj.duration;
            %%
            % This if-statement exists so the duration, fundamental period,
            % or duration can be set before a group has been
            % pre-allocated/initialized. Or so the customizable variables
            % within the MDA will have the same number of entries as the
            % number of timepoints
            if isempty(obj.group)
                return
            else
                SuperMDA_method_update_number_of_timepoints(obj);
            end
        end
        %% Method to change the fundamental period (units in seconds)
        %
        function obj = newFundamentalPeriod(obj,mynum)
            %%
            % check to see that number of timepoints is a reasonable number
            % , i.e. it must be greater than zero
            if mynum <= 0
                return
            end
            %%
            % update other dependent parameters
            obj.fundamental_period = mynum;
            obj.number_of_timepoints = floor(obj.duration/obj.fundamental_period)+1; %ensures fundamental period and duration are consistent with each other
            obj.duration = obj.fundamental_period*(obj.number_of_timepoints-1);
            obj.mda_clock_relative = 0:obj.fundamental_period:obj.duration;
            %%
            % This if-statement exists so the duration, fundamental period,
            % or duration can be set before a group has been
            % pre-allocated/initialized. Or so the customizable variables
            % within the MDA will have the same number of entries as the
            % number of timepoints
            if isempty(obj.group)
                return
            else
                SuperMDA_method_update_number_of_timepoints(obj);
            end
        end
        %% Method to change the number of timepoints
        %
        function obj = newNumberOfTimepoints(obj,mynum)
            %%
            % check to see that number of timepoints is a reasonable number
            % , i.e. it must be a positive integer
            if mynum < 1
                return
            end
            %%
            % update other dependent parameters
            obj.number_of_timepoints = round(mynum);
            obj.duration = obj.fundamental_period*(obj.number_of_timepoints-1);
            obj.mda_clock_relative = 0:obj.fundamental_period:obj.duration;
            %%
            % This if-statement exists so the duration, fundamental period,
            % or duration can be set before a group has been
            % pre-allocated/initialized. Or so the customizable variables
            % within the MDA will have the same number of entries as the
            % number of timepoints
            if isempty(obj.group)
                return
            else
                SuperMDA_method_update_number_of_timepoints(obj);
            end
        end
        %% preallocate memory to hold the SuperMDA information
        % This should always be done before and the largest number should
        % be used for the number of groups, positions, and settings
        %
        % Note that the |order| properties of group, position, and settings
        % remain initialized at 1. The |order| represents which groups,
        % positions, or settings from the preallocated data should be part
        % of the SuperMDA when acquisition begins. By manipulating the
        % |order| groups, positions, or settings can be skipped on the fly,
        % but remember this information will have to be added back to
        % revisit them.
        function obj = preAllocateMemoryAndInitialize(obj, myNumberOfGroups, myNumberOfPositions, myNumberOfSettings)
            p = inputParser;
            addRequired(p, 'obj', @(x) isa(x,'SuperMDAItinerary'));
            addRequired(p, 'myNumberOfGroups', @(x) (mod(x,1)==0) && (x>0));
            addRequired(p, 'myNumberOfPositions', @(x) (mod(x,1)==0) && (x>0));
            addRequired(p, 'myNumberOfSettings', @(x) (mod(x,1)==0) && (x>0));
            parse(p, obj, myNumberOfGroups, myNumberOfPositions, myNumberOfSettings);
            %% Update prototypes
            % * settings: exposure and timepoints
            % * position: xyz
            obj.prototype_settings.exposure = ones(obj.number_of_timepoints,1);
            obj.prototype_settings.timepoints = ones(obj.number_of_timepoints,1);
            obj.mm.getXYZ;
            obj.prototype_position.xyz = ones(obj.number_of_timepoints,3);
            obj.prototype_position.xyz(:,1) = obj.mm.pos(1);
            obj.prototype_position.xyz(:,2) = obj.mm.pos(2);
            obj.prototype_position.xyz(:,3) = obj.mm.pos(3);
            %% Fill the SuperMDA with this preallocated information
            %
            obj.prototype_position.settings = repmat(obj.prototype_settings,myNumberOfSettings,1);
            obj.prototype_group.position = repmat(obj.prototype_position,myNumberOfPositions,1);
            obj.group = repmat(obj.prototype_group,myNumberOfGroups,1);
            %% Create labels
            %
            for i = 1:length(obj.group)
                mystr = sprintf('group%d',i);
                obj.group(i).label = mystr;
                for j = 1:length(obj.group(i).position)
                    mystr = sprintf('position%d',j);
                    obj.group(i).position(j).label = mystr;
                end
            end
        end
        %% preAllocateDatabase
        %
        function obj = preAllocateDatabaseAndInitialize(obj)
            %% Calculate the number of images
            % The number of images will be used to pre-allocate memory for
            % the database. Without memory pre-allocation the SuperMDA will
            % grind to a halt.
            obj.total_number_images = 0;
            for i = obj.group_order
                for j = obj.group(i).position_order
                    for k = obj.group(i).position(j).settings_order
                        obj.total_number_images = obj.total_number_images + sum(obj.group(i).position(j).settings(k).timepoints)*length(obj.group(i).position(j).settings(k).z_stack);
                    end
                end
            end
            %% Pre-allocate the database
            %
            pre_allocation_cell = {'channel name','filename','group label','position label',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'image description'};
            obj.database = repmat(pre_allocation_cell,obj.total_number_images,1);
            database_filename = fullfile(obj.output_directory,'smda_database.txt');
            myfid = fopen(database_filename,'w');
            fprintf(myfid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n','channel_name','filename','group_label','position_label','binning','channel_number','continuous_focus_offset','continuous_focus_bool','exposure','group_number','group_order','matlab_serial_date_number','position_number','position_order','settings_number','settings_order','timepoint','x','y','z','z_order','image_description');
            fclose(myfid);
            %%
            % Save the SuperMDA in a text or xml format, so that it can be
            % reloaded later on. SuperMDA is an object and objects don't
            % necessarily load properly, especially if listeners are
            % involved.
            SuperMDAtable = cell2table(pre_allocation_cell,'VariableNames',{'channel_name','filename','group_label','position_label','binning','channel_number','continuous_focus_offset','continuous_focus_bool','exposure','group_number','group_order','matlab_serial_date_number','position_number','position_order','settings_number','settings_order','timepoint','x','y','z','z_order','image_description'});
            writetable(SuperMDAtable,fullfile(obj.output_directory,'smda_database_copy.txt'),'Delimiter','\t');
        end
        %% Update child objects to reflect number of timepoints
        % The highly customizable features of the mda include exposure,
        % xyz, and timepoints. These properties must have the same length.
        % This function will ensure they all have the same length.
        function obj = update_number_of_timepoints(obj)
            SuperMDA_method_update_number_of_timepoints(obj);
        end
        %% finalize_MDA
        % A method to be run just prior to take off. Think of it as a
        % pre-flight checklist.
        function obj = finalize_MDA(obj)
            SuperMDA_method_finalize_MDA(obj);
        end
        %% update_zstack
        %
        function obj = update_zstack(obj)
            for i = 1:length(obj.group)
                for j = 1:length(obj.group(i).position)
                    for k = 1:length(obj.group(i).position(j).settings)
                        range = obj.group(i).position(j).settings(k).z_stack_upper_offset - obj.group(i).position(j).settings(k).z_stack_lower_offset;
                        if range<=0
                            obj.group(i).position(j).settings(k).z_stack_upper_offset = 0;
                            obj.group(i).position(j).settings(k).z_stack_lower_offset = 0;
                            obj.group(i).position(j).settings(k).z_stack = 0;
                        else
                            obj.group(i).position(j).settings(k).z_stack = obj.group(i).position(j).settings(k).z_stack_lower_offset:obj.group(i).position(j).settings(k).z_step_size:obj.group(i).position(j).settings(k).z_stack_upper_offset;
                            obj.group(i).position(j).settings(k).z_stack_upper_offset = obj.group(i).position(j).settings(k).z_stack(end);
                        end
                    end
                end
            end
        end
        %% update_smdaFunctions
        %
        function obj = update_smdaFunctions(obj)
            for i = 1:length(obj.group)
                obj.group(i).group_function_before_handle = str2func(obj.group(i).group_function_before_name);
                for j = 1:length(obj.group(i).position)
                    obj.group(i).position(j).position_function_before_handle = str2func(obj.group(i).position(j).position_function_before_name);
                    for k = 1:length(obj.group(i).position(j).settings)
                        obj.group(i).position(j).settings(k).settings_function_after_handle = str2func(obj.group(i).position(j).settings(k).settings_function_after_name);
                        obj.group(i).position(j).settings(k).settings_function_handle = str2func(obj.group(i).position(j).settings(k).settings_function_name);
                        obj.group(i).position(j).settings(k).settings_function_before_handle = str2func(obj.group(i).position(j).settings(k).settings_function_before_name);
                    end
                    obj.group(i).position(j).position_function_after_handle = str2func(obj.group(i).position(j).position_function_after_name);
                end
                obj.group(i).group_function_after_handle = str2func(obj.group(i).group_function_after_name);
            end
        end
        %% update_timepoints_with_period_multiplier
        % Note that this will overwrite all information currently in the
        % timepoint arrays.
        function obj = update_timepoints_with_period_multiplier(obj)
            for i = 1:length(obj.group)
                for j = 1:length(obj.group(i).position)
                    for k = 1:length(obj.group(i).position(j).settings)
                        myNumbers = 1:obj.group(i).position(j).settings(k).period_multiplier:obj.number_of_timepoints;
                        obj.group(i).position(j).settings(k).timepoints = zeroes(obj.number_of_timepoints,1);
                        obj.group(i).position(j).settings(k).timepoints(myNumbers) = 1;
                    end
                end
            end
        end
    end
    %%
    %
    methods (Static)
        
    end
end