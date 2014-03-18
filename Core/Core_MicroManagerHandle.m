%%
%
classdef Core_MicroManagerHandle < handle
    properties
        gui
        core
        mda
        xyStageDevice
        FocusDevice
        AutoFocusDevice
        AutoFocusStatusDevice
        CameraDevice
        Channel
        ShutterDevice
        xyStageLimits
        zLimits
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
            import org.micromanager.MMStudioMainFrame; 
            obj.gui = MMStudioMainFrame(false);
            obj.gui.show; %this opens the uM gui that can be used at the same time MATLAB is open. Closing this gui closes MATLAB and vice versa.
            uiwait(hmsg); %the uM gui must load the correct configuration and relys upon user input. MATLAB will wait until the user confirms that uM loaded properly.
            obj.core = obj.gui.getMMCore;
            obj.mda = obj.gui.getAcquisitionEngine();
            %%
            % Change a few settings
            obj.core.enableStderrLog(0); %Log info sent to MATLAB command window is suppressed
            obj.core.enableDebugLog(0); %Debug info will not be saved to the log file
            obj.core.setProperty('Core', 'TimeoutMs', 19999); %The Nikon TI-e supposedly has an internal timeout of 20000ms.
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
            
            obj.CameraDevice = obj.core.getCameraDevice;
            
            groups = obj.core.getAvailableConfigGroups.toArray; %the output is a java.lang.String[]
            groups = cell(groups);
            if ~any(strcmp('Channel',groups))
                error('CoreInit:noChannel','The group ''Channel'' could not be found.');
            end
            
            my_Channel = obj.core.getAvailableConfigs('Channel').toArray;
            obj.Channel = cell(my_Channel);
            obj.ShutterDevice = obj.core.getShutterDevice;
            %%
            % We found some settings are specific to a device and these
            % settings are assigned below to a given microscope using the
            % computer hostname as a unique identifier. 
            my_comp_name = obj.core.getHostName.toCharArray'; %the hostname is used as a unique identifier
            if strcmp(my_comp_name,'LB89-6A-45FA')
                %% 
                % Closet Scope
                obj.xyStageDevice = obj.core.getXYStageDevice;
                obj.core.setFocusDevice('TIZDrive'); %this is specific to the Nikon TI that we use
                obj.FocusDevice = obj.core.getFocusDevice;
                obj.core.setFocusDevice('TIPFSOffset'); %this is specific to the Nikon TI that we use
                obj.AutoFocusDevice = obj.core.getFocusDevice;
                obj.AutoFocusStatusDevice = obj.core.getAutoFocusDevice;
                obj.core.setProperty(obj.xyStageDevice,'TransposeMirrorX',1);
                obj.core.setProperty(obj.xyStageDevice,'TransposeMirrorY',1);
                [mfilepath,~,~] = fileparts(mfilename('fullpath'));
                mytable = readtable(fullfile(mfilepath,'settings_LB89-6A-45FA.txt'));
                obj.xyStageLimits = [mytable.xlim1,mytable.xlim2,mytable.ylim1,mytable.ylim2];
                obj.zLimits = [mytable.zmin,mytable.zmax];
                obj.core.setProperty(obj.xyStageDevice,'MaxSpeed',70); % 'MaxSpeed' range of [0,100].
            elseif strcmp(my_comp_name,'LB89-68-A06F')
                %% 
                % Curtain Scope
                obj.xyStageDevice = obj.core.getXYStageDevice;
                obj.core.setFocusDevice('TIZDrive'); %this is specific to the Nikon TI that we use
                obj.FocusDevice = obj.core.getFocusDevice;
                obj.core.setFocusDevice('TIPFSOffset'); %this is specific to the Nikon TI that we use
                obj.AutoFocusDevice = obj.core.getFocusDevice;
                obj.AutoFocusStatusDevice = obj.core.getAutoFocusDevice;
                obj.core.setProperty(obj.xyStageDevice,'TransposeMirrorX',1);
                obj.core.setProperty(obj.xyStageDevice,'TransposeMirrorY',1);
                [mfilepath,~,~] = fileparts(mfilename('fullpath'));
                mytable = readtable(fullfile(mfilepath,'settings_LB89-68-A06F.txt'));
                obj.xyStageLimits = [mytable.xlim1,mytable.xlim2,mytable.ylim1,mytable.ylim2];
                obj.zLimits = [mytable.zmin,mytable.zmax];
                obj.core.setProperty(obj.xyStageDevice,'MaxSpeed',50); %There was concern of slippage and slowing the scope down was thought to be a solution to prevent this. 'MaxSpeed' range of [0,100].
            elseif strcmp(my_comp_name,'KISHONYWAB111A')
                %% 
                % Kishony Scope
                obj.xyStageDevice = obj.core.getXYStageDevice;
                obj.core.setFocusDevice('TIZDrive'); %this is specific to the Nikon TI that we use
                obj.FocusDevice = obj.core.getFocusDevice;
                obj.core.setFocusDevice('TIPFSOffset'); %this is specific to the Nikon TI that we use
                obj.AutoFocusDevice = obj.core.getFocusDevice;
                obj.AutoFocusStatusDevice = obj.core.getAutoFocusDevice;
                obj.core.setProperty(obj.xyStageDevice,'TransposeMirrorX',1);
                obj.core.setProperty(obj.xyStageDevice,'TransposeMirrorY',1);
                [mfilepath,~,~] = fileparts(mfilename('fullpath'));
                mytable = readtable(fullfile(mfilepath,'settings_LB89-68-A06F.txt'));
                obj.xyStageLimits = [mytable.xlim1,mytable.xlim2,mytable.ylim1,mytable.ylim2];
                obj.zLimits = [mytable.zmin,mytable.zmax];
                obj.core.setProperty(obj.xyStageDevice,'MaxSpeed',70); % 'MaxSpeed' range of [0,100].
            else
                obj.xyStageDevice = obj.core.getXYStageDevice;
                obj.FocusDevice = obj.core.getFocusDevice;
                obj.AutoFocusDevice = obj.core.getFocusDevice;
                obj.AutoFocusStatusDevice = obj.core.getAutoFocusDevice;
            end
        end
%% Methods
% These methods are meant to make life a little easier by having quick
% calls to common activities
% * getXYZ() = get the XYZ coordinates of the stage
% * setXYZ() = move the stage to a desired position
% * snapImage() = take a picture
        %% Get x, y, and z position of microscope
        %
        function [obj] = getXYZ(obj)
            Core_method_getXYZ(obj);
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
            if isempty(varargin)
                Core_method_setXYZ(obj,pos);
            else
                Core_method_setXYZ(obj,pos,varargin{:});
            end
        end
        %% Get x, y, and z position of microscope
        %
        function [obj] = snapImage(obj,varargin)
            %%
            % I've gotten in the habit of creating separate m-files for
            % longer methods. When the methods use a varargin input the
            % following if statement unpacks the varargin, so that the
            % m-file sees the data as if this "middle-method" did not
            % exist.
            if isempty(varargin)
                Core_method_snapImage(obj);
            else
                Core_method_snapImage(obj,varargin{:});
            end
        end
    end
%     methods (Static)
%     end
end