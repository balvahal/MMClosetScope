%% The SuperMDAItinerary
% The SuperMDA allows multiple multi-dimensional-acquisitions to be run
% simulataneously. Each group consists of 1 or more positions. Each
% position consists of 1 or more settings.
classdef SuperMDAItineraryTimeFixed_object < handle
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
        gps_logical;
        mm;
        orderVector;
        output_directory = fullfile(pwd,'RAWDATA');
        
        group_function_after;
        group_function_before;
        group_label;
        group_logical;
        group_scratchpad;
        
        ind_next_gps;
        ind_next_group;
        ind_next_position;
        ind_next_settings;
        
        position_continuous_focus_offset;
        position_continuous_focus_bool;
        position_function_after;
        position_function_before;
        position_label;
        position_logical;
        position_scratchpad;
        position_xyz;
        
        settings_binning;
        settings_channel;
        settings_exposure;
        settings_function;
        settings_gain;
        settings_logical;
        settings_period_multiplier;
        settings_scratchpad;
        settings_timepoints;
        settings_z_origin_offset;
        settings_z_stack_lower_offset;
        settings_z_stack_upper_offset;
        settings_z_step_size;
    end
    properties (SetAccess = private)
        duration = 0;
        fundamental_period = 600; %The units are seconds. 600 is 10 minutes.
        clock_relative = 0;
        number_of_timepoints = 1;
    end
    %%
    %
    methods
        %% The constructor method
        % The first argument is always mm
        function obj = SuperMDAItineraryTimeFixed_object(mm)
            if ~isa(mm,'Core_MicroManagerHandle')
                error('smdaITF:input','The input was not a Core_MicroManagerHandle_object');
            end
            obj.channel_names = mm.Channel;
            obj.gps = [1,1,1];
            obj.gps_logical = true;
            obj.mm = mm;
            obj.orderVector = 1;
            
            %% initialize the prototype_group
            %
            obj.group_function_after{1} = 'SuperMDA_function_group_after_basic';
            obj.group_function_before{1} = 'SuperMDA_function_group_before_basic';
            obj.group_label{1} = 'group1';
            obj.group_logical = true;
            obj.group_scratchpad = {};
            %% initialize the prototype_position
            %
            obj.position_continuous_focus_offset = str2double(mm.core.getProperty(mm.AutoFocusDevice,'Position'));
            obj.position_continuous_focus_bool = true;
            obj.position_function_after{1} = 'SuperMDA_function_position_after_basic';
            obj.position_function_before{1} = 'SuperMDA_function_position_before_basic';
            obj.position_label{1} = 'position1';
            obj.position_logical = true;
            obj.position_scratchpad = {};
            obj.position_xyz = mm.getXYZ; %This is a customizable array
            %% initialize the prototype_settings
            %
            obj.settings_binning = 1;
            obj.settings_channel = 1;
            obj.settings_exposure = 1; %This is a customizable arrray
            obj.settings_function{1} = 'SuperMDA_function_settings_timeFixed';
            obj.settings_gain = 0; % [0-255] for ORCA R2
            obj.settings_logical = true;
            obj.settings_period_multiplier = 1;
            obj.settings_timepoints = 1; %This is a customizable array
            obj.settings_scratchpad = {};
            obj.settings_z_origin_offset = 0;
            obj.settings_z_stack_lower_offset = 0;
            obj.settings_z_stack_upper_offset = 0;
            obj.settings_z_step_size = 0.3;
            %% initialize the indices
            % the next group, position, and settings
            obj.ind_next_gps = 2;
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
        %% Update child objects to reflect number of timepoints
        % The highly customizable features of the mda include exposure,
        % xyz, and timepoints. These properties must have the same length.
        % This function will ensure they all have the same length.
        function obj = update_number_of_timepoints(obj)
            SuperMDA_method_update_number_of_timepoints(obj);
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
        %%
        %
        function obj = addPosition2Group(obj,gInd,pInd,varargin)
            if isempty(varargin)
                obj = SuperMDAItineraryTimeFixed_method_addPosition2Group(obj,gInd,pInd);
            else
                obj = SuperMDAItineraryTimeFixed_method_addPosition2Group(obj,gInd,pInd,varargin{:});
            end
        end
        %%
        %
        function obj = addSettings2Position(obj,gInd,pInd,sInd,varargin)
            if isempty(varargin)
                obj = SuperMDAItineraryTimeFixed_method_addSettings2Position(obj,gInd,pInd,sInd);
            else
                obj = SuperMDAItineraryTimeFixed_method_addSettings2Position(obj,gInd,pInd,sInd,varargin{:});
            end
        end
        %%
        %
        function obj = addSettings2AllPosition(obj,gInd,varargin)
            if isempty(varargin)
                obj = SuperMDAItineraryTimeFixed_method_addSettings2AllPosition(obj,gInd);
            else
                obj = SuperMDAItineraryTimeFixed_method_addSettings2AllPosition(obj,gInd,varargin{:});
            end
        end
        %%
        % a group and all the positions and settings therin shall be
        % "forgotten".
        function obj = dropGroup(obj,gInd)
            % the drop action is reflected in the corresponding logical
            % vector
            myPInd = obj.indOfPosition(gInd);
            mySInd = obj.indOfSettings(gInd);           
            obj.group_logical(gInd) = false;
            obj.find_ind_next('group');
            % update the gps to reflect these changes
            myGpsGroup = obj.gps(:,1);
            obj.gps_logical(myGpsGroup == gInd) = false;
            myGpsRows = find(myGpsGroup == gInd);
            if ~isempty(myGpsRows)
                for i = 1:length(myGpsRows)
                    obj.orderVectorRemove(myGpsRows(i));
                end
            end
            obj.position_logical(myPInd) = false;
            obj.settings_logical(mySInd) = false;
            obj.find_ind_next('gps');
            obj.find_ind_next('position');
            obj.find_ind_next('settings');
        end
        %%
        %
        function obj = dropPosition(obj,pInd)
            % the drop action is reflected in the corresponding logical
            % vector
            obj.position_logical(pInd) = false;
            obj.find_ind_next('position');
            % update the gps to reflect these changes
            myGpsPosition = obj.gps(:,2);
            obj.gps_logical(myGpsPosition == pInd) = false;
            myGpsRows = find(myGpsPosition == pInd);
            if ~isempty(myGpsRows)
                for i = 1:length(myGpsRows)
                    obj.orderVectorRemove(myGpsRows(i));
                end
            end
            obj.find_ind_next('gps');
        end
        %%
        %
        function obj = dropSettings(obj,sInd)
            % the drop action is reflected in the corresponding logical
            % vector
            obj.settings_logical(sInd) = false;
            obj.find_ind_next('settings');
            % update the gps to reflect these changes
            myGpsSettings = obj.gps(:,3);
            obj.gps_logical(myGpsSettings == sInd) = false;
            myGpsRows = find(myGpsSettings == sInd);
            if ~isempty(myGpsRows)
                for i = 1:length(myGpsRows)
                    obj.orderVectorRemove(myGpsRows(i));
                end
            end
            obj.find_ind_next('gps');
        end
        %%
        %
        function obj = find_ind_next(obj,mystr)
            p = inputParser;
            addRequired(p,mystr,@(x) any(strcmp(x,{'gps','group','position','settings'})));
            parse(p,mystr);
            
            switch mystr
                case 'gps'
                    if any(~obj.gps_logical)
                        obj.ind_next_gps = find(~obj.gps_logical,1,'first');
                    else
                        obj.ind_next_gps = length(obj.gps_logical) + 1;
                    end
                case 'group'
                    if any(~obj.group_logical)
                        obj.ind_next_group = find(~obj.group_logical,1,'first');
                    else
                        obj.ind_next_group = length(obj.group_logical) + 1;
                    end
                case 'position'
                    if any(~obj.position_logical)
                        obj.ind_next_position = find(~obj.position_logical,1,'first');
                    else
                        obj.ind_next_position = length(obj.position_logical) + 1;
                    end
                case 'settings'
                    if any(~obj.settings_logical)
                        obj.ind_next_settings = find(~obj.settings_logical,1,'first');
                    else
                        obj.ind_next_settings = length(obj.settings_logical) + 1;
                    end
            end
        end
        %%
        %
        function n = indOfGroup(obj)
            n = transpose(1:length(obj.group_logical)); %outputs a column
            n = n(obj.group_logical);
        end
        %%
        %
        function n = indOfPosition(obj,gNum)
            myGpsPosition = obj.gps(:,2);
            myPositionsInGNum = myGpsPosition((obj.gps(:,1) == gNum) & transpose(obj.gps_logical));
            n = unique(myPositionsInGNum); %outputs a column
        end
        %%
        %
        function n = indOfSettings(obj,varargin)
            if numel(varargin) == 2
                gNum = varargin{1};
                pNum = varargin{2};
                myGpsSettings = obj.gps(:,3);
                n = myGpsSettings((obj.gps(:,1) == gNum) & (obj.gps(:,2) == pNum) & transpose(obj.gps_logical)); %outputs a column
            else
                gNum = varargin{1};
                myGpsSettings = obj.gps(:,3);
                mySettingsInGNum = myGpsSettings((obj.gps(:,1) == gNum) & transpose(obj.gps_logical));
                n = unique(mySettingsInGNum); %outputs a column
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
            obj.clock_relative = 0:obj.fundamental_period:obj.duration;
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
            obj.clock_relative = 0:obj.fundamental_period:obj.duration;
        end
        %%
        % a group has been designed such that no two groups will share any
        % positions or settings.
        function obj = newGroup(obj,varargin)
            if isempty(varargin)
                obj = SuperMDAItineraryTimeFixed_method_newGroup(obj);
            else
                obj = SuperMDAItineraryTimeFixed_method_newGroup(obj,varargin{:});
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
            obj.clock_relative = 0:obj.fundamental_period:obj.duration;
        end
        %%
        %
        function obj = newPosition(obj,gInd,varargin)
            if isempty(varargin)
                obj = SuperMDAItineraryTimeFixed_method_newPosition(obj,gInd);
            else
                obj = SuperMDAItineraryTimeFixed_method_newPosition(obj,gInd,varargin{:});
            end
        end
        %%
        %
        function obj = newSettings(obj,gInd,pInd,varargin)
            if isempty(varargin)
                obj = SuperMDAItineraryTimeFixed_method_newSettings(obj,gInd,pInd);
            else
                obj = SuperMDAItineraryTimeFixed_method_newSettings(obj,gInd,pInd,varargin{:});
            end
        end
        %%
        % computes the number of groups in the itinerary
        function n = numberOfGroup(obj)
            n = sum(obj.group_logical);
        end
        %%
        % computes the number of positions in a give group
        function n = numberOfPosition(obj,gNum)
            myGpsPosition = obj.gps(:,2);
            myPositionsInGNum = myGpsPosition(obj.gps(:,1) == gNum);
            n = sum(obj.position_logical((unique(myPositionsInGNum))));
        end
        %%
        % computes the number of settings in a given position and group
        function n = numberOfSettings(obj,gNum,pNum)
            myGpsSettings = obj.gps(:,3);
            mySettingsInGNumPNum = myGpsSettings((obj.gps(:,1) == gNum) & (obj.gps(:,2) == pNum));
            n = sum(obj.settings_logical((mySettingsInGNumPNum)));
        end
        %%
        %
        function n = orderOfGroup(obj)
            myGpsGroup = obj.gps(:,1);
            myGpsGroupOrder = myGpsGroup(obj.orderVector);
            groupInds = obj.indOfGroup;
            indicesOfFirstAppearance = zeros(size(groupInds));
            for i = 1:length(indicesOfFirstAppearance)
                indicesOfFirstAppearance(i) = find(myGpsGroupOrder == groupInds(i),1,'first');
            end
            n = sortrows(horzcat(groupInds,indicesOfFirstAppearance),2);
            n = transpose(n(:,1)); %outputs a row
        end
        %%
        %
        function n = orderOfPosition(obj,gNum)
            myGpsPosition = obj.gps(:,2);
            myGpsPositionOrder = myGpsPosition(obj.orderVector);
            positionInds = obj.indOfPosition(gNum);
            indicesOfFirstAppearance = zeros(size(positionInds));
            for i = 1:length(indicesOfFirstAppearance)
                indicesOfFirstAppearance(i) = find(myGpsPositionOrder == positionInds(i),1,'first');
            end
            n = sortrows(horzcat(positionInds,indicesOfFirstAppearance),2);
            n = transpose(n(:,1)); %outputs a row
        end
        %%
        %
        function n = orderOfSettings(obj,gNum,pNum)
            myGpsSettings = obj.gps(:,3);
            myGpsSettingsOrder = myGpsSettings(obj.orderVector);
            settingsInds = obj.indOfSettings(gNum,pNum);
            indicesOfFirstAppearance = zeros(size(settingsInds));
            for i = 1:length(indicesOfFirstAppearance)
                indicesOfFirstAppearance(i) = find(myGpsSettingsOrder == settingsInds(i),1,'first');
            end
            n = sortrows(horzcat(settingsInds,indicesOfFirstAppearance),2);
            n = transpose(n(:,1)); %outputs a row
        end
        %%
        %
        function obj = orderVectorInsert(obj,varargin)
            p = inputParser;
            addOptional(p, 'OVrow',length(obj.orderVector)+1, @(x) ismember(x,(1:length(obj.orderVector)+1)));
            parse(p,varargin{:});
            obj.orderVector(end+1) = obj.ind_next_gps;
            if p.Results.OVrow ~= length(obj.orderVector)+1
                obj.orderVectorMove(p.Results.OVrow,obj.ind_next_gps);
            end
        end
        %%
        %
        function obj = orderVectorMove(obj,OVrow,GPSrow)
            %find the current position of the GPSrow
            myInd = find(obj.orderVector == GPSrow,1,'first');
            if myInd == OVrow
                return
            elseif myInd > OVrow
                %create the array that will rearrange the orderVector
                moveArray = 1:length(obj.orderVector);
                moveArray2Move = moveArray(OVrow:end);
                moveArray2Move(myInd-OVrow+1) = [];
                moveArray(OVrow) = myInd;
                moveArray((OVrow+1):end) = moveArray2Move;
            else
                moveArray = 1:length(obj.orderVector);
                moveArray2Move = moveArray(1:OVrow);
                moveArray2Move(myInd) = [];
                moveArray(OVrow) = myInd;
                moveArray(1:(OVrow-1)) = moveArray2Move;
            end
            obj.orderVector = obj.orderVector(moveArray);
        end
        %%
        %
        function obj = orderVectorRemove(obj,GPSrow)
            myInd = find(obj.orderVector == GPSrow,1,'first');
            obj.orderVector(myInd) = [];
        end
        %%
        %
        function obj = removeZeroRows(obj)
            
        end
    end
    %%
    %
    methods (Static)
        
    end
end