%%
%
classdef Core_MicroManagerHandle < handle
    properties
        gui
        core
        mda
        computerName
        xyStageDevice
        FocusDevice
        AutoFocusDevice
        AutoFocusStatusDevice
        CameraDevice
        calibrationAngle
        Channel
        ShutterDevice
        xyStageLimits
        zLimits
        stageport
        binningfun
        twitter;
        twitterBool = false;
    end
    properties (SetObservable)
        I
        pos
    end
    methods
        %% The constructor
        % This function will fire when the object is created
        function obj = Core_MicroManagerHandle()
            %%
            % Load uM and assign general uM objects to obj properties
            hmsg = msgbox('Click ''OK'' after the micromanager configuration file has been loaded.','Wait For Configuration');
            import org.micromanager.internal.MMStudio;
            obj.gui = MMStudio(0);
            uiwait(hmsg); %the uM gui must load the correct configuration and relys upon user input. MATLAB will wait until the user confirms that uM loaded properly.
            obj.core = obj.gui.getCMMCore;
            obj.mda = obj.gui.getAcquisitionEngine();
            %%
            % Change a few settings
            obj.core.enableStderrLog(0); %Log info sent to MATLAB command window is suppressed
            obj.core.enableDebugLog(0); %Debug info will not be saved to the log file
            obj.core.setProperty('Core', 'TimeoutMs', 19999); %The Nikon TI-e supposedly has an internal timeout of 20000ms.
            %% A NOTE ABOUT ALL DEVICES
            % * |core.deviceBusy| = boolean that indicates if the device is
            % in use. Very useful for handingshaking between MATLAB and the
            % microscope. Without specifically telling MATLAB to wait for
            % the microscope to finish a process, e.g. moving the stage or
            % taking an image, the MATLAB code will continue running and
            % will crash. The microscope may behave erratically if the code
            % depends upon the completion of the microscope process
            % mentioned earlier. |core.deviceBusy| is a boolean that can be
            % used as the key variable in a while loop that will pause
            % MATLAB until the microscope process has completed. This is a
            % very crucial command and hopefully this is reflected by the
            % verbose explanation.
            % * |core.getDevicePropertyNames(DeviceName).toArray| = if
            % there is ever any question about what properties can be |set|
            % or |get| by a device this handy command with print a list of
            % all the possible properties.
            % * |core.getProperty(DeviceName,'Property')| = For example,
            % the see what the binning setting is for the camera:
            % |core.getProperty(mmhandle.CameraDevice,'Binning')|.
            % * |core.setProperty(DeviceName,'Property',x)| = For example,
            % to set the binning setting for the camera to 2:
            % |core.setProperty(mmhandle.CameraDevice,'Binning',2)|.
            % *
            % |core.getAllowedPropertyValues(DeviceName,'Property').toArray|
            % = if there is ever a question about the set of values that
            % can be assigned to a property, then this command will list
            % this set. If a property can take on a range of values use
            % |core.getPropertyLowerLimit(DeviceName,'Property'| and
            % |core.getPropertyUpperLimit(DeviceName,'Property')|.
            %% Find the xy device and the focus device
            % Popular commands with (x,y,z) movement devices are:
            % * core.setOrigin = sets an origin for z that is stored in the
            % hardware
            % * core.setOriginXY = sets an origin for (x,y) that is stored
            % in the hardware
            % * core.setXYPosition = sets the (x,y) position
            % * core.setPosition = sets the z position
            % * core.getXPosition
            % * core.getYPosition
            % * core.getPosition = reads the current z position
            % * core.stop = stops (x,y) movement
            %
            % The FocusDevice is the z-drive in the microscope. The
            % AutoFocusDevice controls the perfect focus system of the
            % microscope. The AutoFocusStatusDevice reports the the status
            % of the perfect focus system.
            %
            % For the Nikon Ti Eclipse that we use in the Lahav Lab the
            % Z-drive and perfect focus system are both defined as
            % "FocusDevice". To get the label of each device the names must
            % be known ahead of time and hard-coded below. The section of
            % code below is therefore unique to the Lahav Lab setup and
            % will likely cause an error on scopes that are not Nikon Ti
            % Eclipse. To remedy this error determine the names of the
            % focus drives using the micro-manager gui and exploring the
            % device/property browser.
            %
            % The computer name will be used as a unique identifier to know
            % when the computer that is connected to the Nikon Ti Eclipse
            % is in use.
            %% Assign microscope specific devices to obj properties
            % SuperMDA has been tested on the following systems:
            % * Nikon Ti-e with PFS
            %%
            % The following devices are stored as object properties (tested
            % device):
            %
            % * xyStageDevice (Prior ProScan)
            % * FocusDevice (Nikon TI Z-Drive)
            % * AutoFocusDevice (Nikon PFS System)
            % * AutoFocusStatusDevice (Another part of the Nikon PFS
            % System)
            % * CameraDevice (Hamamatsu Orca R2)
            % * Channels (A reflection of the Channels group in uM)
            % * ShutterDevice
            % * xyStageLimits (predefined by the user)
            % * zLimits (predefined by the user)
            %
            % Note that the stage limits are predefined by the user. A text
            % file must be created containing this information. This can be
            % created manually by moving the objective to its highest and
            % lowest position and recording the values. The stage should
            % have its values recorde at the upper-left and and lower-right
            % corner.
            %% Channel Presets
            % In micromanager, there are the concepts of "Groups" and
            % "Presets". Groups are sets of parameters that are changed
            % togther. For instance, a simple group would consist of a
            % filter and a shutter. This is a fundamental pairing in
            % Micromanager and a special group called *Channel* is reserved
            % for this very purpose.
            %
            % Presets are values assigned to the parameters in a Group to
            % make repeated changes easier.The YFP filter will always be
            % paired with the shutter to the fluorescence lamp and a
            % brightfield image will always be paired with the shutter to
            % the brightfield lamp. Taking consecutive images between the
            % brightfield channel and the YFP channel would consist of
            % changing the presets in the *Channel* group from *YFP* to
            % *BF* for instance.
            %
            % Apparently, this check can also be made using the method
            % |core.getChannelGroup|.
            %
            % This function assumes the Channel group exists, but a check
            % is made first...
            obj.CameraDevice = obj.core.getCameraDevice;
            
            groups = obj.core.getAvailableConfigGroups.toArray; %the output is a java.lang.String[]
            groups = cell(groups);
            if ~any(strcmp('Channel',groups))
                error('CoreInit:noChannel','The group ''Channel'' could not be found. Please make sure ''Channel'' is created before starting MM through MATLAB.');
            end
            %%
            % The *Presets* or *Configs* for the *Channel* group are
            % identified.
            %
            % Should the closet scope and curtain scope have different
            % names for their presets? The filters are physically
            % different, yet are often the same part number. I am not
            % certain what the best approach is.
            %
            % Configs can be check in MATLAB via the following commands
            % (example given):
            % # |a = core.getConfigData('Channel','Cy5');|
            % # |b = a.getVerbose;|
            % # |b = char(b);|
            my_Channel = obj.core.getAvailableConfigs('Channel').toArray;
            obj.Channel = cell(my_Channel);
            obj.ShutterDevice = obj.core.getShutterDevice;
            %%
            % We found some settings are specific to a device and these
            % settings are assigned below to a given microscope using the
            % computer hostname as a unique identifier.
            
            obj.computerName = obj.core.getHostName.toCharArray'; %the hostname is used as a unique identifier
            customFileName = sprintf('Core_microscopeFcn_%s',obj.computerName);
            customFileName = regexprep(customFileName,'-','');
            if exist(customFileName,'file')
                microscopeFcn = str2func(customFileName);
            else
                microscopeFcn = @Core_microscopeFcn_NOSCOPE;
            end
            obj = microscopeFcn(obj);
            %%
            % update stage position initialize image "buffer".
            obj.pos = obj.getXYZ;
            obj.I = zeros(obj.core.getImageHeight,obj.core.getImageWidth);
            %% twitter
            %
            obj.twitter = Core_twitter;
        end
        %% Methods
        % These methods are meant to make life a little easier by having
        % quick calls to common activities
        % * getXYZ() = get the XYZ coordinates of the stage
        % * setXYZ() = move the stage to a desired position
        % * snapImage() = take a picture
        %% Get x, y, and z position of microscope
        %
        function [pos] = getXYZ(obj)
            try
                pos = Core_method_getXYZ(obj);
            catch
                if obj.twitter.active
                    obj.twitter.update_status(sprintf('Error in reading XYZ from the %s microscope.',obj.computerName));
                end
                pos = Core_method_getXYZ(obj);
            end
        end
        %% Get x, y, and z position of microscope
        %
        function [obj] = setXYZ(obj,pos,varargin)
            %%
            % I've gotten in the habit of creating separate m-files for
            % longer methods. When the methods use a varargin input the
            % following if statement unpacks the varargin, so that the
            % m-file sees the data as if this "middle-method" did not
            % exist.
            %
            % Note that setting the Z will turn off PFS.
            try
                if isempty(varargin)
                    Core_method_setXYZ(obj,pos);
                else
                    Core_method_setXYZ(obj,pos,varargin{:});
                end
            catch
                if obj.twitter.active
                    obj.twitter.update_status(sprintf('Error in sending XYZ to the %s microscope.',obj.computerName));
                end
                if isempty(varargin)
                    Core_method_setXYZ(obj,pos);
                else
                    Core_method_setXYZ(obj,pos,varargin{:});
                end
            end
        end
        %% Get x, y, and z position of microscope
        %
        function [I] = snapImage(obj,varargin)
            %%
            % I've gotten in the habit of creating separate m-files for
            % longer methods. When the methods use a varargin input the
            % following if statement unpacks the varargin, so that the
            % m-file sees the data as if this "middle-method" did not
            % exist.
            try
                if isempty(varargin)
                    I = Core_method_snapImage(obj);
                else
                    I = Core_method_snapImage(obj,varargin{:});
                end
            catch
                if obj.twitter.active
                    obj.twitter.update_status(sprintf('Error in capturing an image on the %s microscope.',obj.computerName));
                end
                if isempty(varargin)
                    I = Core_method_snapImage(obj);
                else
                    I = Core_method_snapImage(obj,varargin{:});
                end
            end
        end
        %% Calibrate Sensor Alignment
        % The XY axis of the stage is typically rotated relative to the XY
        % axis of the camera's image sensor. This becomes clear when the an
        % uncalibrated scopes collects tiled images. The borders of the
        % image will not align and consecutive images will appear to be
        % shifted in both the X and Y direction instead of just one or the
        % other. This relative rotation can be measured directly and used
        % to plan out stage movement in a way that takes this information
        % into account.
        function [obj] = calibrateSensorAlignment(obj)
            Core_method_calibrateSensorAlignment(obj);
        end
    end
    %     methods (Static) end
end