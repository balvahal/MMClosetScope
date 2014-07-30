%% The SuperMDAPilot
% The SuperMDA allows multiple multi-dimensional-acquisitions to be run
classdef SuperMDAPilot_object < handle
    %%
    % * database: 2^20 rows will be set aside to store image metadata. This
    % will represent a soft cap on the number of images that can be
    % collected by the SuperMDA. For images of size 2048x2048 this would be
    % 4 terabytes of image data, which seems like a reasonable upper limit
    % that will be relevant through the year 2016.
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
        database = {};
        databasefilename;
        database_imagedescription = '';
        itinerary;
        clock_absolute;
        mm;
        pause_bool = false;
        running_bool = false;
        runtime_imagecounter = 0;
        gps_previous = [0,0,0]; %when looping through the MDA object, this will keep track of where it is in the loop. [timepoint,group,position,settings,z_stack]
        gps_current;
        timer_runtime;
        timer_wait;
        gui_pause_stop_resume;
        gui_lastImage;
        t = 1;
        flag_group_before = false;
        flag_group_after = false;
        flag_position_before = false;
        flag_position_after = false;
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
        function obj = SuperMDAPilot_object(sdmaI)
            %%
            %
            if nargin == 0
                return
            elseif nargin == 1
                %% Initialzing the SuperMDA object
                %
                obj.itinerary = sdmaI;
                obj.mm = sdmaI.mm;
                obj.timer_runtime = timer('TimerFcn',@(~,~) obj.timerRuntimeFun,'BusyMode','queue','Name','timer_runtime');
                obj.timer_wait = timer('TimerFcn',@(~,~) obj.timerWaitFun,'ExecutionMode','fixedSpacing',...
                    'Period',1,'Name','timer_wait');
                %% Create a simple gui to enable pausing and stopping
                %
                obj.gui_pause_stop_resume = SuperMDAPilot_gui_pause_stop_resume(obj);
                obj.gui_lastImage = SuperMDAPilot_gui_lastImage(obj);
                obj.databasefilename = fullfile(obj.itinerary.output_directory,'smda_database.txt');
                fid = fopen(obj.databasefilename,'w');
                fclose(fid);
                %%
                % initialize the database to hold information on 1,000,000
                % images
                obj.database = repmat({'channel_name','filename','group_label',...
                    'position_label','binning','channel_number',...
                    'continuous_focus_offset','continuous_focus_bool','exposure',...
                    'group_number','group_order','matlab_serial_date_number',...
                    'position_number','position_order','settings_number',...
                    'settings_order','timepoint','x','y','z','z_order',...
                    'image_description'},2^20,1);
            end
        end
        %% start acquisition
        %
        function obj = startAcquisition(obj)
            SuperMDAPilot_method_startAcquisition(obj);
        end
        %% stop acquisition
        %
        function obj = stop_acquisition(obj)
            SuperMDA_method_stop_acquisition(obj);
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
        function obj = oneLoop(obj)
            SuperMDAPilot_method_oneLoop(obj);
        end
        %%
        %
        function obj = timerWaitFun(obj)
            SuperMDA_method_wait(obj);
        end
        %%
        %
        function obj = timerRuntimeFun(obj)
            SuperMDAPilot_method_timerRuntimeFun(obj);
        end
        %%
        %
        function obj = snap(obj)
            obj.mm.snapImage;
            SuperMDA_method_updateLastImage(obj);
            obj.runtime_imagecounter = obj.runtime_imagecounter + 1;
        end
        %% delete (make sure its child objects are also deleted)
        % for a clean delete
        function delete(obj)
            delete(obj.timer_runtime);
            delete(obj.timer_wait);
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
            SuperMDAPilot_method_update_database(obj);
        end
    end
    %%
    %
    methods (Static)
        
    end
end