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
    %% Properties
    properties
        %%% General
        %
        % * channel_names
        % * database_filenamePNG
        % * gps
        % * gps_logical
        % * mm
        % * orderVector
        % * output_directory
        % * png_path
        
        channel_names;
        database_filenamePNG;
        gps;
        gps_logical;
        mm;
        orderVector;
        output_directory = fullfile(pwd,'SuperMDA');
        png_path;
        
        %%% Group
        %
        % * group_function_after
        % * group_function_before
        % * group_label
        % * group_logical
        
        group_function_after;
        group_function_before;
        group_label;
        group_logical;
        
        %%% Indices
        %
        % * ind_first_group
        % * ind_group
        % * ind_last_group
        % * ind_next_gps
        % * ind_next_group
        % * ind_next_position
        % * ind_next_settings
        % * ind_position
        % * ind_settings
        
        ind_first_group; % as many rows as groups. each row holds the gps row where the group begins
        ind_group; % a single row with the indices of the groups
        ind_last_group; % as many rows as groups. each row holds the gps row where the group ends
        ind_next_gps;
        ind_next_group;
        ind_next_position;
        ind_next_settings;
        ind_position; % as many rows as groups. each row with the indices of positions within that group.
        ind_settings; % as many rows as positions. each row has the indices of settings at that position.
        
        %%% Number
        % Each number refers to the number of active elements. An active
        % element is defined by the corresponding value within the logical
        % arrays for the group, position, and settings.
        %
        % * number_group: the number of groups.
        % * number_position: as many rows as groups. each row with the
        % number of positions within that group.
        % * number_settings: as many rows as positions. each row has the
        % number of settings at that position.
        
        number_group;
        number_position;
        number_settings;
        
        %%% Order
        %
        % * order_group
        % * order_position
        % * order_settings
        
        order_group; % a single row with the order of the groups
        order_position; % as many rows as groups. each row with the order of positions within that group.
        order_settings; % as many rows as positions. each row has the order of settings at that position.
        
        %%% Position
        %
        % * position_continuous_focus_offset
        % * position_continuous_focus_bool
        % * position_function_after
        % * position_function_before
        % * position_label
        % * position_logical
        % * position_xyz
        
        position_continuous_focus_offset;
        position_continuous_focus_bool;
        position_function_after;
        position_function_before;
        position_label;
        position_logical;
        position_xyz;
        
        %%% Settings
        % * settings_binning
        % * settings_channel
        % * settings_exposure
        % * settings_function
        % * settings_logical
        % * settings_period_multiplier
        % * settings_timepoints
        % * settings_z_origin_offset
        % * settings_z_stack_lower_offset
        % * settings_z_stack_upper_offset
        % * settings_z_step_size
        
        settings_binning;
        settings_channel;
        settings_exposure;
        settings_function;
        settings_logical;
        settings_period_multiplier;
        settings_timepoints;
        settings_z_origin_offset;
        settings_z_stack_lower_offset;
        settings_z_stack_upper_offset;
        settings_z_step_size;
    end
    %% Properties (private)
    %
    properties (SetAccess = private)
        %%% Time
        % The time related properties were made private, because they are
        % co-dependent, e.g. changing the _duration_ will change the
        % _number_of_timepoints_. Special methods were created to change
        % the time properties while also updating the co-dependent
        % properties. The units for the time properties are seconds.
        %
        % * duration
        % * fundamental_period
        % * clock_relative
        % * number_of_timepoints
        
        duration = 0;
        fundamental_period = 600; %The units are seconds. 600 is 10 minutes.
        clock_relative = 0;
        number_of_timepoints = 1;
    end
    %% Methods
    % In general each method was created to help construct a valid,
    % self-consistent itinerary. An itinerary can be constructed without
    % the use of any of these methods, but there are no guaruntees that a
    % logical error may not be present. By using these methods to construct
    % an itinerary there will be no doubt about its logic and validity.
    %
    % * addPosition2Group
    % * addSettings2Position
    % * addSettings2AllPosition
    % * dropGroup
    % * dropPosition
    % * dropSettings
    % * export
    % * find_ind_last_group
    % * find_ind_next
    % * import
    % * indOfGroup
    % * indOfPosition
    % * indOfSettings
    % * mirrorSettings
    % * newDuration
    % * newFundamentalPeriod
    % * newGroup
    % * newNumberOfTimepoints
    % * newPosition
    % * newPositionNewSettings
    % * newSettings
    % * numberOfGroup
    % * numberOfPosition
    % * numberOfSettings
    % * orderOfGroup
    % * orderOfPosition
    % * orderOfSettings
    % * orderVectorInsert
    % * orderVectorMove
    % * orderVectorRemove
    % * organize
    % * refreshIndAndOrder
    
    methods
        %% The constructor method
        %
        function obj = SuperMDAItineraryTimeFixed_object(mm)
            if ~isdir(obj.output_directory)
                mkdir(obj.output_directory)
            end
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
            obj.group_function_after{1} = 'SuperMDAItineraryTimeFixed_group_function_after';
            obj.group_function_before{1} = 'SuperMDAItineraryTimeFixed_group_function_before';
            obj.group_label{1} = 'group1';
            obj.group_logical = true;
            %% initialize the prototype_position
            %
            obj.position_continuous_focus_offset = str2double(mm.core.getProperty(mm.AutoFocusDevice,'Position'));
            obj.position_continuous_focus_bool = true;
            obj.position_function_after{1} = 'SuperMDAItineraryTimeFixed_position_function_after';
            obj.position_function_before{1} = 'SuperMDAItineraryTimeFixed_position_function_before';
            obj.position_label{1} = 'position1';
            obj.position_logical = true;
            obj.position_xyz = mm.getXYZ; %This is a customizable array
            %% initialize the prototype_settings
            %
            obj.settings_binning = 1;
            obj.settings_channel = 1;
            obj.settings_exposure = 1; %This is a customizable arrray
            obj.settings_function{1} = 'SuperMDAItineraryTimeFixed_settings_function';
            obj.settings_logical = true;
            obj.settings_period_multiplier = 1;
            obj.settings_timepoints = 1; %This is a customizable array
            obj.settings_z_origin_offset = 0;
            obj.settings_z_stack_lower_offset = 0;
            obj.settings_z_stack_upper_offset = 0;
            obj.settings_z_step_size = 0.3;
            %% initialize the indices and order
            % the next group, position, and settings
            obj.ind_first_group = 1;
            obj.ind_last_group = 1;
            obj.ind_group = 1;
            obj.ind_next_gps = 2;
            obj.ind_next_group = 2;
            obj.ind_next_position = 2;
            obj.ind_next_settings = 2;
            obj.ind_position = 1;
            obj.ind_settings = 1;
            obj.order_group = 1;
            obj.order_position = 1;
            obj.order_settings = 1;
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
        % "forgotten". It is assumed that groups do not share positions or
        % settings.
        function obj = dropGroup(obj,gInd)
            % determine if this is the only group
            if obj.numberOfGroup == 1
                % if there is only a single group do not remove it
                return;
            end
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
        % if the settings in the position that is dropped is unique to that
        % position, those settings are removed. The last position in a
        % group cannot be removed.
        function obj = dropPosition(obj,pInd)
            % determine if this is the only position in the group
            myInd = find(obj.gps(:,2) == pInd,1,'first');
            gInd = obj.gps(myInd,1);
            myPInd = obj.indOfPosition(gInd);
            if numel(myPInd) == 1
                return;
            end
            % the drop action is reflected in the corresponding logical
            % vector
            mySIndPosition = obj.indOfSettings(gInd,pInd); %this must be obtained before the position is removed
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
            % if the settings are unique to that position, delete them
            mySIndGroup = obj.indOfSettings(gInd);
            for i = mySIndPosition
                if ~ismember(i,mySIndGroup)
                    %then there were settings unique to that position that
                    %must be "forgotten"
                    obj.settings_logical(i) = false;
                end
            end
            obj.find_ind_next('settings');
        end
        %%
        % remove this settings from every position of the group where the
        % settings is located. If there is only one settings in the group
        % do not delete it.
        function obj = dropSettings(obj,sInd)
            % determine if this is the only position in the group
            myInd = find(obj.gps(:,3) == sInd,1,'first');
            gInd = obj.gps(myInd,1);
            mySInd = obj.indOfSettings(gInd);
            if numel(mySInd) == 1
                return;
            end
            myPIndBefore = obj.indOfPosition(gInd);
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
            % if any positions were removed outright this must be reflected
            % in the position_logical
            myPIndAfter = obj.indOfPosition(gInd);
            myRemovedPosition = myPIndBefore(~ismember(myPIndBefore,myPIndAfter));
            if ~isempty(myRemovedPosition)
                obj.position_logical(myRemovedPosition) = false;
                obj.find_ind_next('position');
            end
        end
        %%
        %
        function obj = export(obj)
            SuperMDAItineraryTimeFixed_method_export(obj);
        end
        %%
        %
        function obj = find_ind_last_group(obj,varargin)
            if numel(varargin) == 1
                gInd = varargin{1};
                myPOrder = obj.orderOfPosition(gInd);
                mySOrder = obj.orderOfSettings(gInd,myPOrder(end));
                [~,myInd] = ismember([gInd,myPOrder(end),mySOrder(end)],obj.gps,'rows');
                obj.ind_last_group(gInd) = find(obj.orderVector == myInd,1,'first');
            else
                gInd = obj.indOfGroup;
                for i = 1:length(gInd)
                    myPOrder = obj.orderOfPosition(gInd(i));
                    mySOrder = obj.orderOfSettings(gInd(i),myPOrder(end));
                    [~,myInd] = ismember([gInd(i),myPOrder(end),mySOrder(end)],obj.gps,'rows');
                    obj.ind_last_group(gInd(i)) = find(obj.orderVector == myInd,1,'first');
                end
            end
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
        function obj = import(obj,filename)
            SuperMDAItineraryTimeFixed_method_import(obj,filename);
        end
        %%
        % returns the inds of "active" groups
        function n = indOfGroup(obj)
            n = transpose(1:length(obj.group_logical)); %outputs a column
            n = n(obj.group_logical);
        end
        %%
        % returns the positions found in a group
        function n = indOfPosition(obj,gNum)
            myGpsPosition = obj.gps(:,2);
            myPositionsInGNum = myGpsPosition((obj.gps(:,1) == gNum) & transpose(obj.gps_logical));
            n = unique(myPositionsInGNum); %outputs a column
        end
        %%
        % returns all the settings found in a group if the group number is
        % input. returns all the settings for a position if the group and
        % position number are input
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
        %%
        % Take all the settings for a given position, _sInd_, and mirror
        % these settings across all positions
        function obj = mirrorSettings(obj,sInd)
            mySettings = obj.order_settings{sInd};
            myGPS = zeros(sum(obj.position_logical)*length(mySettings),3);
            counter = 0;
            for i = obj.order_group
                for j = obj.order_position{i}
                    for k = mySettings
                        counter = counter + 1;
                        myGPS(counter,:) = [i,j,k];
                    end
                end
            end
            obj.gps = myGPS;
            obj.gps_logical = ones(size(myGPS,1));
            obj.orderVector = 1:size(myGPS,1);
            obj.ind_next_gps = size(myGPS,1)+1;
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
        function obj = newPositionNewSettings(obj,gInd,varargin)
            if isempty(varargin)
                obj = SuperMDAItineraryTimeFixed_method_newPositionNewSettings(obj,gInd);
            else
                obj = SuperMDAItineraryTimeFixed_method_newPositionNewSettings(obj,gInd,varargin{:});
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
        function obj = organize(obj)
            SuperMDAItineraryTimeFixed_method_organize(obj);
        end
        %%
        %
        function obj = refreshIndAndOrder(obj)
            SuperMDAItineraryTimeFixed_method_refreshIndAndOrder(obj);
        end
    end
    %%
    %
    methods (Static)
        
    end
end