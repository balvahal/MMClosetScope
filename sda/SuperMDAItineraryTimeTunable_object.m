%% The SuperMDAItinerary
% The SuperMDA allows multiple multi-dimensional-acquisitions to be run
% simulataneously. Each group consists of 1 or more positions. Each
% position consists of 1 or more settings.
classdef SuperMDAItineraryTimeTunable_object < SuperMDAItineraryTimeFixed_object
    %%
    % * channel_names: the names of the channels group in the current
    % session of uManager.
    % * gps: a matrix that contains the groups, positions, and settings
    % information. As the SuperMDA processes through orderVector it will
    % keep track of which index is changing and execute a function based on
    % this change.
    % * orderVector: a vector with the number of rows of the GPS matrix. It
    % contains the sequence of natural numbers from 1 to the number of
    % rows. The SuperMDA will follow the numbers in the orderVector as they
    % increase and the row that contains the current number corresponds to
    % the next row in the GPS to be executed.
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
        gps;
        mm;
        orderVector;
        
        group_function_after;
        group_function_before;
        group_label;
        
        ind_next_group;
        ind_next_position;
        ind_next_settings;
        
        position_continuous_focus_offset;
        position_continuous_focus_bool;
        position_function_after;
        position_function_before;
        position_label;
        position_xyz;
        
        settings_binning;
        settings_channel;
        settings_exposure;
        settings_function;
        settings_period_multiplier;
        settings_timepoints;
        settings_z_origin_offset;
        settings_z_stack_lower_offset;
        settings_z_stack_upper_offset;
        settings_z_step_size;
    end
    properties (SetAccess = private)
        duration
        fundamental_period %The units are seconds.
        clock_relative
        number_of_timepoints
    end
    %%
    %
    methods
        %% The constructor method
        % The first argument is always mm
        function obj = SuperMDAItineraryTimeTunable_object(smdaITF)
            if ~isa(smdaITF,'SuperMDATravelAgentTimeFixed_object')
                error('smdaITT:input','The input was not a SuperMDATravelAgentTimeFixed_object');
            end
            
            obj.channel_names = smdaITF.channel_names;
            obj.gps = [1,1,1];
            obj.mm = smdaITF.mm;
            obj.orderVector = 1;
            
            %% initialize the prototype_group
            %
            obj.group_function_after = '';
            obj.group_function_before = '';
            obj.group_label{1} = '';
            %% initialize the prototype_position
            %
            obj.position_continuous_focus_offset = str2double(smdaITF.mm.core.getProperty(smdaITF.mm.AutoFocusDevice,'Position'));
            obj.position_continuous_focus_bool = true;
            obj.position_function_after = '';
            obj.position_function_before = '';
            obj.position_label{1} = '';
            obj.position_xyz = smdaITF.mm.getXYZ; %This is a customizable array
            %% initialize the prototype_settings
            %
            obj.settings_binning = 1;
            obj.settings_channel = 1;
            obj.settings_exposure = 1; %This is a customizable arrray
            obj.settings_function = '';
            obj.settings_period_multiplier = 1;
            obj.settings_timepoints = 1; %This is a customizable array
            obj.settings_z_origin_offset = 0;
            obj.settings_z_stack_lower_offset = 0;
            obj.settings_z_stack_upper_offset = 0;
            obj.settings_z_step_size = 0.3;
            %% initialize the indices
            % the next group, position, and settings
            obj.ind_next_group = 2;
            obj.ind_next_position = 2;
            obj.ind_next_settings = 2;
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
            obj.group(1).position(1).settings(1).exposure = ones(obj.number_of_timepoints,1);
            obj.group(1).position(1).settings(1).timepoints = ones(obj.number_of_timepoints,1);
            obj.mm.getXYZ;
            obj.group(1).position(1).xyz = ones(obj.number_of_timepoints,3);
            obj.group(1).position(1).xyz(:,1) = obj.mm.pos(1);
            obj.group(1).position(1).xyz(:,2) = obj.mm.pos(2);
            obj.group(1).position(1).xyz(:,3) = obj.mm.pos(3);
            %% Fill the SuperMDA with this preallocated information
            %
            obj.group.position.settings = repmat(obj.group(1).position(1).settings(1),myNumberOfSettings,1);
            obj.group.position = repmat(obj.group(1).position(1),myNumberOfPositions,1);
            obj.group = repmat(obj.group(1),myNumberOfGroups,1);
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
                        obj.total_number_images = obj.total_number_images + obj.group(i).position(j).tileNumber*sum(obj.group(i).position(j).settings(k).timepoints)*length(obj.group(i).position(j).settings(k).z_stack);
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