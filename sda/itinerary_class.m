%% itinerary, the class that contains multi-dimensional acquisition data 
%
%% Inputs
% None
%% Outputs
% * obj: the object that contains and manages the *itinerary*
classdef itinerary_class < handle
    %% Properties
    % 
    properties
        %%% General
        %
        % * channel_names
        % * gps
        % * gps_logical
        % * orderVector
        % * output_directory
        % * imageHeightNoBin
        % * imageWidthNoBin
        channel_names;
        gps;
        gps_logical;
        orderVector;
        output_directory;
        imageHeightNoBin
        imageWidthNoBin
        %%% Indices
        %
        % * ind_group
        % * ind_position
        % * ind_settings
        ind_group; % a single row with the indices of the groups
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
    %% Properties (protected)
    %
    properties (SetAccess = protected)
        %%% Time
        % The time related properties are protected, because they are
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
        %%% Pointers
        %
        pointer_next_gps;
        pointer_next_group;
        pointer_next_position;
        pointer_next_settings;
    end
    %% Methods
    % In general each method was created to help construct a valid,
    % self-consistent itinerary. An itinerary can be constructed without
    % the use of any of these methods, but there are no guaruntees that it
    % will be free of logical errors. By using these methods to construct
    % an itinerary there will be no doubt about its logic and validity.
    %
    % *CONSTRUCTOR*
    %
    % * itinerary_class
    %
    % *GENERAL*
    %
    % * connectGPS
    % * export
    % * gpsFromOrder
    % * import
    % * organizeByOrder
    % * newNumberOfTimepoints
    % * newFundamentalPeriod
    % * newDuration
    % * dropEmpty
    % * refreshIndAndOrder
    %
    % *GROUP*
    %
    % * newGroup
    % * dropGroup
    % * find_pointer_next_group
    %
    % *POSITION*
    %
    % * newPosition
    % * dropPosition
    % * find_pointer_next_position
    %
    % *SETTINGS*
    %
    % * newSettings
    % * dropSettings
    % * find_pointer_next_settings
    % * mirrorSettings
    
    methods
        %% The first method is the constructor
        %
        function obj = itinerary_class(microscope)
            %%%
            % If the microscope object is not provided, then do not follow
            % through with initialization. Itineraries can still be
            % imported, but some methods may throw errors.
            if nargin == 0
                return
            end
            %%% Initialization
            %
            if ~isa(microscope,'microscope_class')
                error('itn:input','The input was not a microscope_class');
            end
            pathstr = userpath; %userpath adds a semicolon at the end that must be removed
            obj.output_directory = fullfile(pathstr(1:end-1),'sda');
            if ~isdir(obj.output_directory)
                mkdir(obj.output_directory)
            end
            obj.channel_names = microscope.Channel;
            obj.gps = [1,1,1];
            obj.gps_logical = true;
            obj.orderVector = 1;
            microscope.binningfun(microscope,1);
            obj.imageHeightNoBin = microscope.core.getImageHeight;
            obj.imageWidthNoBin = microscope.core.getImageWidth;
            %%% initialize the prototype_group
            %
            obj.group_function_after{1} = 'group_function_after_default';
            obj.group_function_before{1} = 'group_function_before_default';
            obj.group_label{1} = 'group1';
            obj.group_logical = true;
            %%% initialize the prototype_position
            %
            obj.position_continuous_focus_offset = str2double(microscope.core.getProperty(microscope.AutoFocusDevice,'Position'));
            obj.position_continuous_focus_bool = true;
            obj.position_function_after{1} = 'position_function_after_default';
            obj.position_function_before{1} = 'position_function_before_default';
            obj.position_label{1} = 'position1';
            obj.position_logical = true;
            obj.position_xyz = microscope.getXYZ; %This is a customizable array
            %%% initialize the prototype_settings
            %
            obj.settings_binning = 1;
            obj.settings_channel = 1;
            obj.settings_exposure = 1; %This is a customizable arrray
            obj.settings_function{1} = 'settings_function_default';
            obj.settings_logical = true;
            obj.settings_period_multiplier = 1;
            obj.settings_timepoints = 1; %This is a customizable array
            obj.settings_z_origin_offset = 0;
            obj.settings_z_stack_lower_offset = 0;
            obj.settings_z_stack_upper_offset = 0;
            obj.settings_z_step_size = 0.3;
            %%% initialize the indices and order
            % the next group, position, and settings
            obj.pointer_next_group = 2;
            obj.pointer_next_position = 2;
            obj.pointer_next_settings = 2;
            obj.ind_group = 1;
            obj.ind_position = {1};
            obj.ind_settings = {1};
            obj.order_group = 1;
            obj.order_position = {1};
            obj.order_settings = {1};
            obj.number_group = 1;
            obj.number_position = 1;
            obj.number_settings = 1;
        end
        %% connectGPS
        %
        function obj = connectGPS(obj,varargin)
            %%%
            % parse the input
            q = inputParser;
            addRequired(q, 'obj', @(x) isa(x,'itinerary_class'));
            addParameter(q, 'g',0, @(x)validateattributes(x,{'numeric'},{'integer','positive'}));
            addParameter(q, 'p',0, @(x)validateattributes(x,{'numeric'},{'integer','positive'}));
            addParameter(q, 's',0, @(x)validateattributes(x,{'numeric'},{'integer','positive'}));
            parse(q,obj,varargin{:});
            g = q.Results.g;
            p = q.Results.p;
            s = q.Results.s;
            decisionString = '000'; %'gps'
            %%%
            % inputs should refer to existing groups, positions, and
            % settings.
            existingG = 1:numel(obj.group_logical);
            existingG = existingG(obj.group_logical);
            if all(ismember(g,existingG))
                decisionString(1) = '1';
                if iscolumn(g)
                    g = transpose(g);
                end
            end
            existingP = 1:numel(obj.position_logical);
            existingP = existingP(obj.position_logical);
            if all(ismember(p,existingP))
                decisionString(2) = '1';
                if iscolumn(p)
                    p = transpose(p);
                end
            end
            existingS = 1:numel(obj.settings_logical);
            existingS = existingS(obj.settings_logical);
            if all(ismember(s,existingS))
                decisionString(3) = '1';
                if iscolumn(s)
                    s = transpose(s);
                end
            end
            decisionNumber = bin2dec(decisionString);
            
            %%% Cases to consider
            % 3 of the 8 parameter choices are valid considerations and the
            % rest will throw an error.
            %
            % * case 3, '011', position and settings: The settings in the
            % _s_ array will be added to specified positions _p_.
            % * case 6, '110', group and position: The positions in the _p_
            % array will be added to specified groups _g_.
            % * case 7, '111', group and position and settings: The
            % settings in _s_ will be added to the positions in _p_. Then
            % the positions in _p_ will be added to the groups in _g_.
            switch decisionNumber
                case 3
                    for i = p
                        s2add = setdiff(s,obj.order_settings{p},'stable');
                        obj.order_settings{p} = horzcat(obj.order_settings{p},s2add);
                        obj.ind_settings{p} = sort(horzcat(obj.ind_settings{p},s2add));
                        obj.number_settings(p) = obj.number_settings(p) + numel(s2add);
                    end
                case 6
                    for i = g
                        p2add = setdiff(p,obj.order_position{g},'stable');
                        obj.order_position{g} = horzcat(obj.order_position{g},p2add);
                        obj.ind_position{g} = sort(horzcat(obj.ind_position{g},p2add));
                        obj.number_position(g) = obj.number_position(g) + numel(p2add);
                    end
                case 7
                    for i = p
                        s2add = setdiff(s,obj.order_settings{p},'stable');
                        obj.order_settings{p} = horzcat(obj.order_settings{p},s2add);
                        obj.ind_settings{p} = sort(horzcat(obj.ind_settings{p},s2add));
                        obj.number_settings(p) = obj.number_settings(p) + numel(s2add);
                    end
                    for i = g
                        p2add = setdiff(p,obj.order_position{g},'stable');
                        obj.order_position{g} = horzcat(obj.order_position{g},p2add);
                        obj.ind_position{g} = sort(horzcat(obj.ind_position{g},p2add));
                        obj.number_position(g) = obj.number_position(g) + numel(p2add);
                    end
                otherwise
                    error('smdaITF:conGPS','The input parameters were an invalid combination.');
            end
        end
        %% export
        % The object is saved in the JSON format. JSON is easy to read and
        % edit in a text editor.
        function obj = export(obj)
            %% organize and clean up the object
            % to ensure self-consistency
            obj.dropEmpty;
            obj.organizeByOrder;            
            %fieldnamesExclusionList = {'microscope'};
            myfields = fieldnames(obj);
            %myfields(ismember(myfields,fieldnamesExclusionList)) = [];
            for i = 1:numel(myfields)
                myexportStruct.(myfields{i}) = obj.(myfields{i});
            end
            core_jsonparser.export_json(myexportStruct,fullfile(obj.output_directory,'smdaITF.txt'));
        end
        %% gpsFromOrder
        %
        function obj = gpsFromOrder(obj)
            newGPS = zeros(sum(obj.number_settings),3);
            grpOrder = obj.order_group;
            mycount = 0;
            for i = grpOrder
                posOrder = obj.order_position{i};
                for j = posOrder
                    setOrder = obj.order_settings{j};
                    for k = setOrder
                        mycount = mycount + 1;
                        newGPS(mycount,:) = [i,j,k];
                    end
                end
            end
            obj.gps = newGPS;
            obj.orderVector = 1:size(newGPS,1);
            obj.gps_logical = true(size(newGPS,1),1);
        end
        %%
        %
        function [obj] = import(obj,filename)
            %%
            %
            myimportStruct = core_jsonparser.import_json(filename);
            myfields = fieldnames(myimportStruct);
            for i = 1:numel(myfields)
                obj.(myfields{i}) = myimportStruct.(myfields{i});
            end
            %% convert from arrays of numbers into arrays of logicals
            %
            obj.group_logical = logical(obj.group_logical);
            obj.position_logical = logical(obj.position_logical);
            obj.settings_logical = logical(obj.settings_logical);
            obj.gps_logical = logical(obj.gps_logical);
            obj.refreshIndAndOrder;
        end
        %%
        % To organize the itinerary is to have the order of the groups, positions,
        % and settings reflect the order of acquisition. After organization the
        % _orderVector_ will be strictly increasing. Unassigned groups, positions,
        % and settings will be removed.
        %
        % In otherwords, use the GPS _orderVector_ to rearrange the other
        % information within the itinerary in the order of acquisition. Afterwards,
        % update the _orderVector_ to reflect this change, which means it will be a
        % simple sequence of natural numbers.
        %
        % The strategy will be to organize the GPS by the _orderVector_ and then
        % use the logical vectors to remove the unused rows.
        function [obj] = organizeByOrder(obj)
            obj.gpsFromOrder;
            obj.refreshIndAndOrder;
            %% Sort the _gps_ by the orderVector
            %
            myGPS = obj.gps(obj.orderVector,:);
            
            %% Rearrange group
            %
            myGPS2 = myGPS;
            for i = 1:length(obj.order_group);
                myLogical = myGPS(:,1) == obj.order_group(i);
                myGPS2(myLogical,1) = i;
            end
            obj.group_function_after = obj.group_function_after(obj.order_group);
            obj.group_function_before = obj.group_function_before(obj.order_group);
            obj.group_label = obj.group_label(obj.order_group);
            obj.group_logical = obj.group_logical(obj.order_group);
            
            %% Rearrange position
            %
            superOrderPosition = zeros(sum(obj.position_logical),1);
            positionCounter = 1;
            for i = obj.order_group
                superOrderPosition(positionCounter:positionCounter-1+obj.number_position(i)) = ...
                    obj.order_position{i,:};
                positionCounter = positionCounter+obj.number_position(i);
            end
            for i = 1:length(superOrderPosition)
                myLogical = myGPS(:,2) == superOrderPosition(i);
                myGPS2(myLogical,2) = i;
            end
            obj.position_continuous_focus_offset = obj.position_continuous_focus_offset(superOrderPosition);
            obj.position_continuous_focus_bool = obj.position_continuous_focus_bool(superOrderPosition);
            obj.position_function_after = obj.position_function_after(superOrderPosition);
            obj.position_function_before = obj.position_function_before(superOrderPosition);
            obj.position_label = obj.position_label(superOrderPosition);
            obj.position_logical = obj.position_logical(superOrderPosition);
            obj.position_xyz = obj.position_xyz(superOrderPosition,:);
            %% Rearrange settings
            %
            superOrderSettings = obj.order_settings(superOrderPosition);
            superOrderSettings = horzcat(superOrderSettings{:});
            superOrderSettings = unique(superOrderSettings,'stable');
            for i = 1:length(superOrderSettings)
                myLogical = myGPS(:,3) == superOrderSettings(i);
                myGPS2(myLogical,3) = i;
            end
            obj.settings_binning = obj.settings_binning(superOrderSettings);
            obj.settings_channel = obj.settings_channel(superOrderSettings);
            obj.settings_exposure = obj.settings_exposure(superOrderSettings);
            obj.settings_function = obj.settings_function(superOrderSettings);
            obj.settings_logical = obj.settings_logical(superOrderSettings);
            obj.settings_period_multiplier = obj.settings_period_multiplier(superOrderSettings);
            obj.settings_timepoints = obj.settings_timepoints(superOrderSettings,:);
            obj.settings_z_origin_offset = obj.settings_z_origin_offset(superOrderSettings);
            obj.settings_z_stack_lower_offset = obj.settings_z_stack_lower_offset(superOrderSettings);
            obj.settings_z_stack_upper_offset = obj.settings_z_stack_upper_offset(superOrderSettings);
            obj.settings_z_step_size = obj.settings_z_step_size(superOrderSettings);
            %% update GPS
            %
            obj.gps = myGPS2;
            obj.orderVector = 1:size(myGPS2,1);
            %%
            %
            obj.refreshIndAndOrder;
        end
        %% newNumberOfTimepoints
        % Method to change the number of timepoints
        function obj = newNumberOfTimepoints(obj,mynum)
            %%%
            % check to see that number of timepoints is a reasonable number
            % , i.e. it must be a positive integer
            if mynum < 1
                return
            end
            %%%
            % update other dependent parameters
            obj.number_of_timepoints = round(mynum);
            obj.duration = obj.fundamental_period*(obj.number_of_timepoints-1);
            obj.clock_relative = 0:obj.fundamental_period:obj.duration;
            obj.validateSettingsTimepoints;
        end
        %% newFundamentalPeriod
        % a method to change the fundamental period (units in seconds)
        function obj = newFundamentalPeriod(obj,mynum)
            %%%
            % check to see that number of timepoints is a reasonable number
            % , i.e. it must be greater than zero
            if mynum <= 0
                return
            end
            %%%
            % update other dependent parameters
            obj.fundamental_period = mynum;
            obj.number_of_timepoints = floor(obj.duration/obj.fundamental_period)+1; %ensures fundamental period and duration are consistent with each other
            obj.duration = obj.fundamental_period*(obj.number_of_timepoints-1);
            obj.clock_relative = 0:obj.fundamental_period:obj.duration;
            obj.validateSettingsTimepoints;
        end
        %% newDuration
        % a method to change the duration
        function obj = newDuration(obj,mynum)
            %%%
            % check to see that number of timepoints is a reasonable number
            % , i.e. it must zero of greater
            if mynum < 0
                return
            end
            %%%
            % update other dependent parameters
            obj.duration = mynum;
            obj.number_of_timepoints = floor(obj.duration/obj.fundamental_period)+1; %ensures fundamental period and duration are consistent with each other
            obj.duration = obj.fundamental_period*(obj.number_of_timepoints-1);
            obj.clock_relative = 0:obj.fundamental_period:obj.duration;
            obj.validateSettingsTimepoints;
        end
        %% validateSettingsTimepoints
        %
        function obj = validateSettingsTimepoints(obj)
            timepointDifference = size(obj.settings_timepoints,2) - obj.number_of_timepoints;
            if timepointDifference < 0
                obj.settings_timepoints = horzcat(obj.settings_timepoints,ones(size(obj.settings_timepoints,1),-timepointDifference));
            elseif timepointDifference > 0
                obj.settings_timepoints(:,end-timepointDifference+1) = [];
            end
        end
        %% dropEmpty
        % The following conditions will be considered empty and will
        % therefore be dropped:
        %
        % * A group that has no positions
        % * A position that has no settings
        % * A position that is not in any group
        % * A settings that is not in any position
        function obj = dropEmpty(obj)
            %%% A group that has no positions
            % the number arrays will show if a group or position is empty
            myGInd = 1:numel(obj.group_logical);
            myGInd = myGInd(obj.number_position == 0);
            obj.group_logical(myGInd) = false;
            myGIndLogical = ismember(obj.ind_group,myGInd);
            obj.ind_group(myGIndLogical) = [];
            myGIndLogical = ismember(obj.order_group,myGInd);
            obj.order_group(myGIndLogical) = [];
            %%% A position that has no settings
            %
            myPInd = 1:numel(obj.position_logical);
            myPInd = myPInd(obj.number_settings == 0);
            obj.position_logical(myPInd) = false;
            for i = obj.ind_group
                myPIndLogical = ismember(obj.ind_position{i},myPInd);
                obj.ind_position{i}(myPIndLogical) = [];
                myPIndLogical = ismember(obj.order_position{i},myPInd);
                obj.order_position{i}(myPIndLogical) = [];
            end
            %%% A position that is not in any group
            %
            allPosition = unique(...
                horzcat(obj.ind_position{...
                obj.ind_group})); %from order and ind
            obj.position_logical = false(numel(obj.position_logical),1);
            obj.position_logical(allPosition) = true;
            %%% A settings that is not in any position
            %
            allSettings = unique(...
                horzcat(obj.ind_settings{...
                allPosition})); %from order and ind
            obj.settings_logical = false(numel(obj.settings_logical),1);
            obj.settings_logical(allSettings) = true;
            %%%
            % update the pointers and numbers
            obj.find_pointer_next_group;
            obj.find_pointer_next_position;
            obj.find_pointer_next_settings;
            obj.number_group = numel(obj.ind_group);
            for i = 1:numel(obj.group_logical)
                obj.number_position(i) = numel(obj.ind_position{i});
            end
            for i = 1:numel(obj.position_logical)
                obj.number_settings(i) = numel(obj.ind_settings{i});
            end
        end
        %% refresh
        %
        function [obj] = refreshIndAndOrder(obj)
            %%% ind_group and number_group
            %
            gpsGrp = 1:numel(obj.group_logical);
            obj.ind_group = gpsGrp(obj.group_logical);
            obj.number_group = sum(obj.group_logical);
            %%% pointers
            %
            obj.find_pointer_next_group;
            obj.find_pointer_next_position;
            obj.find_pointer_next_settings;
            %%% ind_position and number_position
            %
            obj.ind_position = cell(length(obj.group_logical),1);
            obj.number_position = zeros(length(obj.group_logical),1);
            for i = obj.ind_group
                gpsPosLogical = obj.gps(:,1) == i;
                gpsPos = obj.gps(gpsPosLogical,2);
                obj.ind_position{i} = transpose(unique(gpsPos,'sorted'));
                obj.number_position(i) = numel(obj.ind_position{i});
            end
            %%% ind_settings and number_settings
            %
            obj.ind_settings = cell(length(obj.position_logical),1);
            obj.number_settings = zeros(length(obj.position_logical),1);
            for i = obj.ind_group
                posInd = obj.ind_position{i};
                gpsPosLogical = obj.gps(:,1) == i;
                for j = posInd
                    gpsSetLogical = obj.gps(:,2) == j;
                    gpsSet = obj.gps(gpsPosLogical & gpsSetLogical,3);
                    obj.ind_settings{j} = transpose(unique(gpsSet,'sorted'));
                    obj.number_settings(j) = numel(obj.ind_settings{j});
                end
            end
            %%% order_group
            %
            gpsOrder = obj.gps(obj.orderVector,:);
            gpsGrp = gpsOrder(:,1);
            obj.order_group = transpose(unique(gpsGrp,'stable'));
            %%% order_position
            %
            obj.order_position = cell(length(obj.group_logical),1);
            for i = obj.ind_group
                gpsPosLogical = gpsOrder(:,1) == i;
                gpsPos = gpsOrder(gpsPosLogical,2);
                obj.order_position{i} = transpose(unique(gpsPos,'stable'));
            end
            %%% order_settings
            %
            obj.order_settings = cell(length(obj.position_logical),1);
            for i = obj.ind_group
                posInd = obj.ind_position{i};
                gpsPosLogical = gpsOrder(:,1) == i;
                for j = posInd
                    gpsSetLogical = gpsOrder(:,2) == j;
                    gpsSet = gpsOrder(gpsPosLogical & gpsSetLogical,3);
                    obj.order_settings{j} = transpose(unique(gpsSet,'stable'));
                end
            end
        end
        %% Group: methods
        %
        %% newGroup
        % A single group is created.
        %
        % * pNum: add _pNum_ new positions to this group
        % * sNum: each added position will share _sNum_ new settings
        function g = newGroup(obj,varargin)
            %%%
            % parse the input
            q = inputParser;
            addRequired(q, 'obj', @(x) isa(x,'itinerary_class'));
            addOptional(q, 'pNum',0, @(x) mod(x,1)==0);
            addOptional(q, 'sNum',0, @(x) mod(x,1)==0);
            parse(q,obj,varargin{:});
            
            %%% create new group
            % Each group property needs a new row. Use the first group as a template
            % for the newest group.
            g = obj.pointer_next_group;
            obj.group_function_after{g} = obj.group_function_after{1};
            obj.group_function_before{g} = obj.group_function_before{1};
            obj.group_label{g} = sprintf('group%d',g);
            obj.group_logical(g) = true;
            
            %%% update order, indices, and pointers
            %
            obj.find_pointer_next_group;
            obj.number_group = obj.number_group + 1;
            obj.number_position(g) = 0;
            obj.ind_group = sort(horzcat(obj.ind_group,g));
            obj.order_group(end+1) = g;
            obj.ind_position{g} = [];
            obj.order_position{g} = [];
        end
        %% dropGroup
        % a group and all the positions and settings therin shall be
        % "forgotten". Positions and settings unique to that group are
        % removed.
        %
        % * g: the index of the group to be dropped.
        function obj = dropGroup(obj,g)
            %%%
            % parse the input
            existingG = 1:numel(obj.group_logical);
            existingG = existingG(obj.group_logical);
            q = inputParser;
            addRequired(q, 'obj', @(x) isa(x,'itinerary_class'));
            addRequired(q, 'g', @(x) ismember(x,existingG));
            parse(q,obj,g);
            g = q.Results.g;
            %%%
            % Find the positions and settings unique to the group
            myPInd = obj.ind_position{g};
            myPIndOthers = unique(...
                horzcat(...
                obj.ind_position{...
                obj.ind_group(obj.ind_group ~= g)}));
            myPIndUniq2Grp = setdiff(myPInd,...
                intersect(myPInd,myPIndOthers));
            mySInd = unique(horzcat(obj.ind_settings{myPInd}));
            mySIndOthers = unique(...
                horzcat(...
                obj.ind_settings{...
                myPIndOthers}));
            mySIndUniq2Pos = setdiff(mySInd,...
                intersect(mySInd,mySIndOthers));
            %%%
            % remove the group and its unique positions and settings from
            % the logical arrays
            obj.group_logical(g) = false;
            obj.position_logical(myPIndUniq2Grp) = false;
            obj.settings_logical(mySIndUniq2Pos) = false;
            %%%
            % remove the group and its unique positions and settings from
            % the ind and order arrays
            obj.ind_group(obj.ind_group == g) = [];
            obj.ind_position{g} = [];
            [obj.ind_settings{myPIndUniq2Grp}] = deal([]);
            obj.order_group(obj.order_group == g) = [];
            obj.order_position{g} = [];
            [obj.order_settings{myPIndUniq2Grp}] = deal([]);
            %%%
            % update the numbers and pointers
            obj.number_group = numel(obj.ind_group);
            obj.number_position(g) = 0;
            for i = myPIndUniq2Grp
                obj.number_settings(i) = 0;
            end
            obj.find_pointer_next_group;
            obj.find_pointer_next_position;
            obj.find_pointer_next_settings;
        end
        %% find_pointer_next_group
        %
        function obj = find_pointer_next_group(obj)
            if any(~obj.group_logical)
                obj.pointer_next_group = find(~obj.group_logical,1,'first');
            else
                obj.pointer_next_group = numel(obj.group_logical) + 1;
            end
        end
        %% Position: methods
        %
        %% newPosition
        % A single position is created.
        %
        % * sNum: this position will have _sNum_ new settings
        function p = newPosition(obj, varargin)
            %%%
            % parse the input
            q = inputParser;
            addRequired(q, 'obj', @(x) isa(x,'itinerary_class'));
            addOptional(q, 'microscope', [], @(x) isa(x,'microscope_class'));
            parse(q,obj,varargin{:});
            microscope = q.Results.microscope;
            %%% create new group
            % Each group property needs a new row. Use the first group as a template
            % for the newest group.
            p = obj.pointer_next_position;
            % add the new position properties reflecting the current objective
            % position
            if isempty(microscope)
                obj.position_continuous_focus_offset(p) = obj.position_continuous_focus_offset(1);
                obj.position_xyz(p,:) = obj.position_xyz(1,:);
            else
                obj.position_continuous_focus_offset(p) = str2double(microscope.core.getProperty(microscope.AutoFocusDevice,'Position'));
                obj.position_xyz(p,:) = microscope.getXYZ;
            end            
            obj.position_continuous_focus_bool(p) = true;
            obj.position_function_after{p} = obj.position_function_after{1};
            obj.position_function_before{p} = obj.position_function_before{1};
            obj.position_label{p} = sprintf('position%d',p);
            obj.position_logical(p) = true;
            
            %%% update order, indices, and pointers
            %
            obj.number_settings(p) = 0;
            obj.find_pointer_next_position;
            obj.ind_settings{p} = [];
            obj.order_settings{p} = [];
        end
        %% dropPosition
        % a position and settings therin shall be "forgotten". Settings
        % unique to that position are removed.
        %
        % * p: the index of the position to be dropped.
        function obj = dropPosition(obj,p)
            %%%
            % parse the input
            existingP = 1:numel(obj.position_logical);
            existingP = existingP(obj.position_logical);
            q = inputParser;
            addRequired(q, 'obj', @(x) isa(x,'itinerary_class'));
            addRequired(q, 'p', @(x) ismember(x,existingP));
            parse(q,obj,p);
            %%%
            % Find the settings unique to the position
            p = q.Results.p;
            myPIndOthers = setdiff(existingP,p);
            mySInd = unique(horzcat(obj.ind_settings{p}));
            mySIndOthers = unique(...
                horzcat(...
                obj.ind_settings{...
                myPIndOthers}));
            mySIndUniq2Pos = setdiff(mySInd,...
                intersect(mySInd,mySIndOthers));
            %%%
            % remove the position and its unique settings from the logical
            % arrays
            obj.position_logical(p) = false;
            obj.settings_logical(mySIndUniq2Pos) = false;
            %%%
            % find the group(s) that contains the position
            myGInd4PosLogical = cellfun(@(x) ismember(p,x),obj.ind_position);
            myGInd4Pos = 1:numel(obj.group_logical);
            myGInd4Pos = myGInd4Pos(myGInd4PosLogical);
            %%%
            % remove the position and its unique settings from the ind and
            % order arrays
            for i = myGInd4Pos
                obj.ind_position{i} = obj.ind_position{i}(obj.ind_position{i} ~= p);
                obj.order_position{i} = obj.order_position{i}(obj.order_position{i} ~= p);
            end
            obj.ind_settings{p} = [];
            obj.order_settings{p} = [];
            %%%
            % update the numbers and pointers
            for i = myGInd4Pos
                obj.number_position(i) = numel(obj.ind_position{i});
            end
            for i = p
                obj.number_settings(i) = 0;
            end
            obj.find_pointer_next_position;
            obj.find_pointer_next_settings;
        end
        %%
        %
        function obj = find_pointer_next_position(obj)
            if any(~obj.position_logical)
                obj.pointer_next_position = find(~obj.position_logical,1,'first');
            else
                obj.pointer_next_position = numel(obj.position_logical) + 1;
            end
        end
        %% Settings: methods
        %      
        %% newSettings
        %
        function s = newSettings(obj,varargin)
            %%%
            % parse the input
            q = inputParser;
            addRequired(q, 'obj', @(x) isa(x,'itinerary_class'));
            addOptional(q, 'sNum',0, @(x) mod(x,1)==0);
            parse(q,obj,varargin{:});
            
            %%% create new settings
            % Each settings property needs a new row. Use the first
            % settings as a template for the newest settings.
            s = obj.pointer_next_settings;
            obj.settings_binning(s) = obj.settings_binning(1);
            obj.settings_channel(s) = obj.settings_channel(1);
            obj.settings_exposure(s) = obj.settings_exposure(1);
            obj.settings_function{s} = obj.settings_function{1};
            obj.settings_logical(s) = true;
            obj.settings_period_multiplier(s) = obj.settings_period_multiplier(1);
            obj.settings_timepoints(s,:) = obj.settings_timepoints(1,:);
            obj.settings_z_origin_offset(s) = obj.settings_z_origin_offset(1);
            obj.settings_z_stack_lower_offset(s) = obj.settings_z_stack_lower_offset(1);
            obj.settings_z_stack_upper_offset(s) = obj.settings_z_stack_upper_offset(1);
            obj.settings_z_step_size(s) = obj.settings_z_step_size(1);
            
            %%% update order, indices, and pointers
            %
            obj.find_pointer_next_settings;
        end
        %% dropSettings
        % a settings shall be "forgotten".
        %
        % * s: the index of the settings to be dropped.
        function obj = dropSettings(obj,s)
            %%%
            % parse the input
            existingS = 1:numel(obj.settings_logical);
            existingS = existingS(obj.settings_logical);
            q = inputParser;
            addRequired(q, 'obj', @(x) isa(x,'itinerary_class'));
            addRequired(q, 's', @(x) ismember(x,existingS));
            parse(q,obj,s);
            %%%
            % remove the settings from the logical arrays
            obj.settings_logical(s) = false;
            %%%
            % find the position(s) that contains the settings
            myPInd4SetLogical = cellfun(@(x) ismember(s,x),obj.ind_settings);
            myPInd4Set = 1:numel(obj.position_logical);
            myPInd4Set = myPInd4Set(myPInd4SetLogical);
            %%%
            % remove settings from the ind and order arrays
            for i = myPInd4Set
                obj.ind_settings{i} = obj.ind_settings{i}(obj.ind_settings{i} ~= s);
                obj.order_settings{i} = obj.order_settings{i}(obj.order_settings{i} ~= s);
            end
            %%%
            % update the numbers and pointers
            for i = myPInd4Set
                obj.number_settings(i) = numel(obj.ind_settings{i});
            end
            obj.find_pointer_next_settings;
        end
        %%
        %
        function obj = find_pointer_next_settings(obj)
            if any(~obj.settings_logical)
                obj.pointer_next_settings = find(~obj.settings_logical,1,'first');
            else
                obj.pointer_next_settings = numel(obj.settings_logical) + 1;
            end
        end
        %%
        % Take all the settings for a given position, p, and mirror
        % these settings across all positions
        function obj = mirrorSettings(obj,p,varargin)
            %%%
            % parse the input
            q = inputParser;
            addRequired(q, 'obj', @(x) isa(x,'itinerary_class'));
            addOptional(q, 'g',0, @(x) mod(x,1)==0);
            parse(q,obj,varargin{:});
            g = q.Results.g;
            if g == 0
                g = obj.order_group;
            end
            %%%
            %
            mySettingsOrder = obj.order_settings{p};
            mySettingsInd = obj.ind_settings{p};
            mySettingsNum = obj.number_settings(p);
            for i = g
                p = obj.order_position{g};
                [obj.order_settings{p}] = deal(mySettingsOrder);
                [obj.ind_settings{p}] = deal(mySettingsInd);
                [obj.number_settings(p)] = deal(mySettingsNum);
            end
        end
        %%
        %
        function obj = copySettings(obj,sfrom,sto)
            obj.settings_binning(sto) = obj.settings_binning(sfrom);
            obj.settings_channel(sto) = obj.settings_channel(sfrom);
            obj.settings_exposure(sto) = obj.settings_exposure(sfrom);
            obj.settings_function{sto} = obj.settings_function{sfrom};
            obj.settings_logical(sto) = obj.settings_logical(sfrom);
            obj.settings_period_multiplier(sto) = obj.settings_period_multiplier(sfrom);
            obj.settings_timepoints(sto,:) = obj.settings_timepoints(sfrom,:);
            obj.settings_z_origin_offset(sto) = obj.settings_z_origin_offset(sfrom);
            obj.settings_z_stack_lower_offset(sto) = obj.settings_z_stack_lower_offset(sfrom);
            obj.settings_z_stack_upper_offset(sto) = obj.settings_z_stack_upper_offset(sfrom);
            obj.settings_z_step_size(sto) = obj.settings_z_step_size(sfrom);
        end
        %% Grid: methods
        %
        
    end
end