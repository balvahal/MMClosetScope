%% The SuperMDA
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
classdef SuperMDA < handle
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
        database_filenamePNG = '';
        database_imagedescription = '';
        group;
        group_order = 1;
        mda_clock_absolute;
        mda_clock_pointer = 1;
        mda_clock_relative = 0;
        mm;
        output_directory = pwd;
        prototype_group; %The prototype_group serves as a template for the creation or additon of new groups to the SuperMDA object.
        prototype_position; %The prototype_position serves as a template for the creation or additon of new groups to the SuperMDA object.
        prototype_settings; %The prototype_settings serves as a template for the creation or additon of new groups to the SuperMDA object.
        runtime_imagecounter = 0;
        runtime_index = [1,1,1,1,1]; %when looping through the MDA object, this will keep track of where it is in the loop. [timepoint,group,position,settings,z_stack]
        runtime_timer;
    end
    properties (SetAccess = private)
        duration = 0;
        fundamental_period = 600; %The units are seconds. 600 is 10 minutes.
        number_of_timepoints = 1;
    end
    %%
    %
    events
        
    end
    %%
    %
    methods
        %% The constructor method
        % The first argument is always mm
        function obj = SuperMDA(mm)
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
                obj.channel_names = mm.Channel;
                %% initialize the prototype_group
                %
                obj.prototype_group.label = '';
                obj.prototype_position.group_function_after_name = 'SuperMDA_function_group_after_basic';
                obj.prototype_position.group_function_after_handle = str2func(obj.prototype_settings.group_function_after_name);
                obj.prototype_position.group_function_before_name = 'SuperMDA_function_group_before_basic';
                obj.prototype_position.group_function_before_handle = str2func(obj.prototype_settings.group_function_before_name);
                obj.prototype_group.position_order = 1;
                obj.prototype_group.user_data = [];
                obj.prototype_group.position = [];
                %% initialize the prototype_position
                %
                obj.prototype_position.continuous_focus_offset = str2double(obj.mm.core.getProperty(obj.mm.AutoFocusDevice,'Position'));
                obj.prototype_position.continuous_focus_bool = true;
                obj.prototype_position.label = '';
                obj.prototype_position.position_function_after_name = 'SuperMDA_function_position_after_basic';
                obj.prototype_position.position_function_after_handle = str2func(obj.prototype_settings.position_function_after_name);
                obj.prototype_position.position_function_before_name = 'SuperMDA_function_position_before_basic';
                obj.prototype_position.position_function_before_handle = str2func(obj.prototype_settings.position_function_before_name);
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
                obj.prototype_settings.exposure = 1; %This is a customizable arrray
                obj.prototype_settings.period_multiplier = 1;
                obj.prototype_settings.timepoints = 1; %This is a customizable array
                obj.prototype_settings.user_data = [];
                obj.prototype_settings.z_origin_offset = 0;
                obj.prototype_settings.z_stack = 0;
                obj.prototype_settings.z_stack_upper_offset = 0;
                obj.prototype_settings.z_stack_lower_offset = 0;
                obj.prototype_settings.z_step_size = 0.3;
            end
        end
        %% Method to change the duration
        %
        function obj = newDuration(mynum)
            if mynum < 0
                return
            end
            obj.duration = mynum;
            obj.number_of_timepoints = floor(obj.duration/obj.fundamental_period)+1; %ensures fundamental period and duration are consistent with each other
            obj.duration = obj.fundamental_period*(obj.number_of_timepoints-1);
            if isempty(obj.group)
                return
            else
                super_mda_method_reflect_number_of_timepoints(obj);
            end
        end
        %% Method to change the fundamental period (units in seconds)
        %
        function obj = newFundamentalPeriod(mynum)
            if mynum <= 0
                return
            end
            obj.fundamental_period = mynum;
            obj.number_of_timepoints = floor(obj.duration/obj.fundamental_period)+1; %ensures fundamental period and duration are consistent with each other
            obj.duration = obj.fundamental_period*(obj.number_of_timepoints-1);
            if isempty(obj.group)
                return
            else
                super_mda_method_reflect_number_of_timepoints(obj);
            end
        end
                %% Method to change the number of timepoints
        %
        function obj = newNumberOfTimepoints(mynum)
            if mynum < 1
                return
            end
            obj.number_of_timepoints = round(mynum);
            obj.duration = obj.fundamental_period*(obj.number_of_timepoints-1);
            if isempty(obj.group)
                return
            else
                super_mda_method_reflect_number_of_timepoints(obj);
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
        function obj = preAllocateMemoryAndInitialize(obj, myDuration, myFundamental_period, myNumberOfGroups, myNumberOfPositions, myNumberOfSettings)
            p = inputParser;
            addRequired(p, 'obj', @(x) isa(x,'SuperMDA'));
            addRequired(p, 'myDuration', @(x) isnumeric(x) && (x>0)); %in seconds
            addRequired(p, 'myFundamental_period', @(x) isnumeric(x) && (x>0)); %in seconds
            addRequired(p, 'myNumberOfGroups', @(x) isinteger(x) && (x>0));
            addRequired(p, 'myNumberOfPositions', @(x) isinteger(x) && (x>0));
            addRequired(p, 'myNumberOfSettings', @(x) isinteger(x) && (x>0));
            parse(p, myDuration, myFundamental_period, myNumberOfGroups, myNumberOfPositions, myNumberOfSettings);
            %% Calculate the number of timepoints
            % and check that duration and the fundamental period are
            % consistent.
            obj.fundamental_period = p.myFundamental_period;
            obj.number_of_timepoints = floor(p.myDuration/obj.fundamental_period)+1; %ensures fundamental period and duration are consistent with each other
            obj.duration = obj.fundamental_period*(obj.number_of_timepoints-1);
            obj.mda_clock_relative = 0:obj.fundamental_period:obj.duration;
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
            obj.group = obj.prototype_group;
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
        function obj = update_database(obj)
            super_mda_method_update_database(obj);
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
            obj.runtime_index = [1,1,1,1,1];
            obj.mda_clock_pointer = 1;
            obj.configure_clock_absolute;
            obj.runtime_timer.StopFcn = {@super_mda_function_runtime_timer_stopfcn,obj};
            start(obj.runtime_timer);
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
        %%
        %
        function obj = snap(obj)
            Core_general_snapImage(obj.mm);
            obj.runtime_imagecounter = obj.runtime_imagecounter + 1;
        end
    end
    %%
    %
    methods (Static)
        
    end
end