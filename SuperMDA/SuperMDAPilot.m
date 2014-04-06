%% The SuperMDAPilot
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
classdef SuperMDAPilot < handle
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
        itinerary;
        mda_clock_pointer = 1;
        mda_clock_absolute;
        mm;
        pause_bool = false;
        runtime_imagecounter = 0;
        runtime_index = [1,1,1,1,1]; %when looping through the MDA object, this will keep track of where it is in the loop. [timepoint,group,position,settings,z_stack]
        runtime_timer;
        wait_timer;
        gui_pause_stop_resume;
        gui_lastImage;
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
        function obj = SuperMDAPilot(smdai)
            %%
            %
            if nargin == 0
                return
            elseif nargin == 1
                %% Initialzing the SuperMDA object
                %
                obj.itinerary = smdai;
                obj.mm = smdai.mm;
                obj.runtime_timer = timer('TimerFcn',@(~,~) obj.execute,'BusyMode','queue','Name','runtime_timer');
                obj.wait_timer = timer('TimerFcn',@(~,~) obj.wait,'ExecutionMode','fixedSpacing',...
                    'Period',1,'Name','wait_timer');
                %% Create a simple gui to enable pausing and stopping
                %
                obj.gui_pause_stop_resume = SuperMDA_gui_pause_stop_resume(obj);
            end
        end
        %% start acquisition
        %
        function obj = start_acquisition(obj)
            SuperMDA_method_start_acquisition(obj);
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
            SuperMDA_method_pause_acquisition(obj);
        end
        %% resume acquisition
        %
        function obj = resume_acquisition(obj)
            SuperMDA_method_resume_acquisition(obj);
        end
        %% execute 1 round of acquisition
        %
        function obj = execute(obj)
            SuperMDA_method_execute(obj);
        end
        %%
        %
        function obj = wait(obj)
            SuperMDA_method_wait(obj);
        end
        %%
        %
        function obj = snap(obj)
            Core_general_snapImage(obj.mm);
            obj.runtime_imagecounter = obj.runtime_imagecounter + 1;
        end
        %% delete (make sure its child objects are also deleted)
        % for a clean delete
        function delete(obj)
            delete(obj.runtime_timer);
            delete(obj.wait_timer);
            delete(obj.gui_pause_stop_resume);
            delete(obj.gui_lastImage);
        end
        %% database to CellProfiler CSV
        %
        function obj = database2CellProfilerCSV(obj)
            SuperMDA_method_database2CellProfilerCSV(obj);
        end
        %% update_database
        %
        function obj = update_database(obj)
            SuperMDA_method_update_database(obj);
        end
    end
    %%
    %
    methods (Static)
        
    end
end