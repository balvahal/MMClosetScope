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
        duration = 0;
        filename_prefix = 'mda';
        fundamental_period = 300; %5 minutes is the default. The units are seconds.
        label = 'group';
        output_directory;
        groups
        travel_offset = -800; %-800 micrometers in the z direction to avoid scraping the objective on the plate. We've always used 800 micrometers.
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
                obj.groups = SuperMDALevel2Group(mmhandle, obj);
                return
            end
        end
    end
end