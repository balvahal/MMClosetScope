%% The SuperMDAItineraryTimeFixed_object
%   ___                    __  __ ___   _
%  / __|_  _ _ __  ___ _ _|  \/  |   \ /_\
%  \__ \ || | '_ \/ -_) '_| |\/| | |) / _ \
%  |___/\_,_| .__/\___|_| |_|  |_|___/_/ \_\
%   ___ _   |_|
%  |_ _| |_(_)_ _  ___ _ _ __ _ _ _ _  _
%   | ||  _| | ' \/ -_) '_/ _` | '_| || |
%  |___|\__|_|_||_\___|_| \__,_|_|  \_, |
%   _____ _           ___ _         |__/
%  |_   _(_)_ __  ___| __(_)_ _____ __| |
%    | | | | '  \/ -_) _|| \ \ / -_) _` |
%    |_| |_|_|_|_\___|_| |_/_\_\___\__,_|
%
% The SuperMDA allows multiple multi-dimensional-acquisitions to be run
% simulataneously. Each group consists of 1 or more positions. Each
% position consists of 1 or more settings. Hi.
classdef SuperMDAItineraryTimeFixed_object < handle
    %% Properties
    %   ___                       _   _
    %  | _ \_ _ ___ _ __  ___ _ _| |_(_)___ ___
    %  |  _/ '_/ _ \ '_ \/ -_) '_|  _| / -_|_-<
    %  |_| |_| \___/ .__/\___|_|  \__|_\___/__/
    %              |_|
    %
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
        % * imageHeightNoBin
        % * imageWidthNoBin
        
        channel_names;
        database_filenamePNG;
        gps;
        gps_logical;
        mm;
        orderVector;
        output_directory = fullfile(pwd,'SuperMDA');
        png_path;
        imageHeightNoBin
        imageWidthNoBin
        
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
        
        %%% Pointers
        %
        pointer_first_group; % as many rows as groups. each row holds the gps row where the group begins
        pointer_last_group; % as many rows as groups. each row holds the gps row where the group ends
        pointer_next_gps;
        pointer_next_group;
        pointer_next_position;
        pointer_next_settings;
        
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
    %   __  __     _   _            _
    %  |  \/  |___| |_| |_  ___  __| |___
    %  | |\/| / -_)  _| ' \/ _ \/ _` (_-<
    %  |_|  |_\___|\__|_||_\___/\__,_/__/
    %
    % In general each method was created to help construct a valid,
    % self-consistent itinerary. An itinerary can be constructed without
    % the use of any of these methods, but there are no guaruntees that a
    % logical error may not be present. By using these methods to construct
    % an itinerary there will be no doubt about its logic and validity.
    %
    % *GROUP*
    %
    % * addGroup
    % * dropGroup
    % * find_pointer_next_group
    %
    % *POSITION*
    % * addPosition
    % * dropPosition
    % * find_pointer_next_position
    
    methods
        %% The first method is the constructor
        %    ___             _               _
        %   / __|___ _ _  __| |_ _ _ _  _ __| |_ ___ _ _
        %  | (__/ _ \ ' \(_-<  _| '_| || / _|  _/ _ \ '_|
        %   \___\___/_||_/__/\__|_|  \_,_\__|\__\___/_|
        %
        function obj = SuperMDAItineraryTimeFixed_object(mm)
            %%%
            % if micro-manager is unavailable, then do not follow through
            % with initialization. Itineraries can still be imported, but
            % some methods may throw errors.
            if nargin == 0
                return
            end
            %%%
            %
            if ~isdir(obj.output_directory)
                mkdir(obj.output_directory)
            end
            if ~isa(mm,'Core_MicroManagerHandle')
                error('obj:input','The input was not a Core_MicroManagerHandle_object');
            end
            obj.channel_names = mm.Channel;
            obj.gps = [1,1,1];
            obj.gps_logical = true;
            obj.mm = mm;
            obj.orderVector = 1;
            mm.binningfun(mm,1);
            obj.imageHeightNoBin = mm.core.getImageHeight;
            obj.imageWidthNoBin = mm.core.getImageWidth;
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
            obj.pointer_next_group = 2;
            obj.pointer_next_position = 2;
            obj.pointer_next_settings = 2;
            obj.ind_position = 1;
            obj.ind_settings = 1;
            obj.order_group = 1;
            obj.order_position = 1;
            obj.order_settings = 1;
        end
        %% Group: methods
        %    ___
        %   / __|_ _ ___ _  _ _ __
        %  | (_ | '_/ _ \ || | '_ \
        %   \___|_| \___/\_,_| .__/
        %                    |_|
        %% addGroup
        % A single group is created.
        %
        % * pNum: add _pNum_ new positions to this group
        % * sNum: each added position will share _sNum_ new settings
        function obj = addGroup(obj,varargin)
            %%%
            % parse the input
            p = inputParser;
            addRequired(p, 'obj', @(x) isa(x,'SuperMDAItineraryTimeFixed_object'));
            addOptional(p, 'pNum',0, @(x) mod(x,1)==0);
            addOptional(p, 'sNum',0, @(x) mod(x,1)==0);
            parse(p,obj,varargin{:});
            
            %%% create new group
            % Each group property needs a new row. Use the first group as a template
            % for the newest group.
            g = obj.pointer_next_group;
            obj.group_function_after(g) = obj.group_function_after{1};
            obj.group_function_before(g) = obj.group_function_before{1};
            obj.group_label(g) = sprintf('group%d',g);
            obj.group_logical(g) = true;
            
            %%% update order, indices, and pointers
            %
            obj.find_pointer_next_group;
        end
        %% dropGroup
        % a group and all the positions and settings therin shall be
        % "forgotten". Positions and settings unique to that group are
        % removed.
        %
        % *g: the index of the group to be dropped.
        function obj = dropGroup(obj,g)
            %%%
            % determine if this is the only group
            if obj.number_group == 1
                % if there is only a single group do not remove it
                warning('obj:oneGrp','There is only a single group, so it will not be dropped.');
                return;
            end
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
            obj.ind_settings{myPIndUniq2Grp} = [];
            obj.order_group(obj.order_group == g) = [];
            obj.order_position{g} = [];
            obj.order_settings{myPIndUniq2Grp} = [];
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
        %   ___        _ _   _
        %  | _ \___ __(_) |_(_)___ _ _
        %  |  _/ _ (_-< |  _| / _ \ ' \
        %  |_| \___/__/_|\__|_\___/_||_|
        %
                %% addPosition
        % A single position is created.
        %
        % * sNum: this position will have _sNum_ new settings
        function obj = addPosition(obj,varargin)
            %%%
            % parse the input
            p = inputParser;
            addRequired(p, 'obj', @(x) isa(x,'SuperMDAItineraryTimeFixed_object'));
            addOptional(p, 'pNum',0, @(x) mod(x,1)==0);
            addOptional(p, 'sNum',0, @(x) mod(x,1)==0);
            parse(p,obj,varargin{:});
            
            %%% create new group
            % Each group property needs a new row. Use the first group as a template
            % for the newest group.
            p = obj.pointer_next_position;
            % add the new position properties reflecting the current objective
            % position
            obj.position_continuous_focus_offset(p) = str2double(obj.mm.core.getProperty(obj.mm.AutoFocusDevice,'Position'));
            obj.position_continuous_focus_bool(p) = true;
            obj.position_function_after{p} = obj.position_function_after{1};
            obj.position_function_before{p} = obj.position_function_before{1};
            obj.position_label{p} = sprintf('position%d',p);
            obj.position_logical(p) = true;
            obj.position_xyz(p,:) = obj.mm.getXYZ;
            %%% update order, indices, and pointers
            %
            obj.find_pointer_next_position;
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
        %%
        %
        function obj = find_pointer_next_settings(obj)
            if any(~obj.settings_logical)
                obj.pointer_next_settings = find(~obj.settings_logical,1,'first');
            else
                obj.pointer_next_settings = numel(obj.settings_logical) + 1;
            end
        end
    end
end