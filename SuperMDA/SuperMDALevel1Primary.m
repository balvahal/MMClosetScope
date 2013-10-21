%% The SuperMDAGroup is the highest level object in MDA
% The SuperMDAGroup allows multiple multi-dimensional-acquisitions to be
% run simulataneously. Each group consists of 1 or more positions. The
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
        groups;
        label = 'primary';
        mda_clock_absolute;
        mda_clock_relative = 0;
        output_directory;
    end
    %%
    %
    methods
        %% The constructor method
        % The first argument is always mmhandle
        function obj = SuperMDAGroup(mmhandle, my_positions,my_fundamental_period)
            if nargin == 0
                return
            elseif nargin == 1
                obj.groups = SuperMDALevel2Group(mmhandle, obj); %#ok<NODEF>
                return
            end
        end
        %% Configure the relative clock
        %
        function obj = configure_clock_relative(obj)
            obj.mda_clock_relative = 0:obj.fundamental_period:obj.duration;
        end
        %% Configure the absolute clock
        % Convert the MDA object unit of time (seconds) to the
        % MATLAB unit of time (days) for the serial date numbers, i.e. the
        % number of days that have passed since January 1, 0000.
        function obj = configure_clock_absolute(obj)
            obj.mda_clock_absolute = now + obj.mda_clock_relative/86400;
        end
        %%
        %
    end
end