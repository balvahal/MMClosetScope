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
        Timer_pos
        Timer_pos_counter
        Timer_pos_previous_pos
        I
    end
    properties (SetObservable)
        pos
    end
    methods
        function obj = Core_MicroManagerHandle()
            hmsg = msgbox('Click ''OK'' after the micromanager configuration file has been loaded.','Wait For Configuration');
            import org.micromanager.MMStudioMainFrame;
            obj.gui = MMStudioMainFrame(false);
            obj.gui.show;
            uiwait(hmsg);
            obj.core = obj.gui.getMMCore;
            obj.mda = obj.gui.getAcquisitionEngine();
            
            my_comp_name = obj.core.getHostName.toCharArray';
            if strcmp(my_comp_name,'LB89-6A-45FA')
                obj.xyStageDevice = obj.core.getXYStageDevice;
                obj.core.setFocusDevice('TIZDrive'); %this is specific to the Nikon TI that we use
                obj.FocusDevice = obj.core.getFocusDevice;
                obj.core.setFocusDevice('TIPFSOffset'); %this is specific to the Nikon TI that we use
                obj.AutoFocusDevice = obj.core.getFocusDevice;
                obj.AutoFocusStatusDevice = obj.core.getAutoFocusDevice;
            else
                obj.xyStageDevice = obj.core.getXYStageDevice;
                obj.FocusDevice = obj.core.getFocusDevice;
                obj.AutoFocusDevice = obj.core.getFocusDevice;
                obj.AutoFocusStatusDevice = obj.core.getAutoFocusDevice;
            end
            obj.getXYZ;
            
            obj.CameraDevice = obj.core.getCameraDevice;
            
            groups = obj.core.getAvailableConfigGroups.toArray; %the output is a java.lang.String[]
            groups = cell(groups);
            if ~any(strcmp('Channel',groups))
                error('CoreInit:noChannel','The group ''Channel'' could not be found.');
            end
            
            my_Channel = obj.core.getAvailableConfigs('Channel').toArray;
            obj.Channel = cell(my_Channel);
            obj.ShutterDevice = obj.core.getShutterDevice;
            
            if strcmp(my_comp_name,'LB89-6A-45FA')
                obj.core.setProperty(obj.xyStageDevice,'TransposeMirrorX',1);
                obj.core.setProperty(obj.xyStageDevice,'TransposeMirrorY',1);
                [mfilepath,~,~] = fileparts(mfilename('fullpath'));
                mytable = readtable(fullfile(mfilepath,'settings_LB89-6A-45FA.txt'));
                obj.xyStageLimits = [mytable.xlim1,mytable.xlim2,mytable.ylim1,mytable.ylim2];
            end
            
            obj.Timer_pos_counter = 0;
            obj.Timer_pos_previous_pos = obj.pos;
            obj.Timer_pos = timer('ExecutionMode','fixedRate','Period',1,'TimerFcn',@(~,~) obj.getXYZ); %it seems to take approx. 0.2 seconds to read the position from the microscope. If a timer's callback takes longer to execute than the period MATLAB it will seem as if MATLAB is unresponsive from the command line.
            start(obj.Timer_pos);
        end
        %%
        % Called just before the object is destroyed.
        function delete(obj)
            delete(obj.Timer_pos);
        end
        %% Get x, y, and z position of microscope
        %
        function [obj] = getXYZ(obj)
            Core_general_getXYZ(obj);
            %%
            % The two if-statements below are meant to be a fail safe
            % should the stage not recognize that it has reached its
            % limits. The Prior stage is smart enough to recognize when its
            % limits are reached and power will quickly be shut off to the
            % motors. However, should there be anything in the path of the
            % objective the Prior stage will not recognize this and damage
            % could occur. I'm not going to test this scenario, because I
            % cannot think of a way to to do it without putting the
            % microscope at risk. Instead, I wrote this note and I have my
            % fingers crossed that should the following code ever be
            % required that it will successfully stop the motor.
            if (obj.core.deviceBusy(obj.xyStageDevice)) && (sum(abs(obj.pos-obj.Timer_pos_previous_pos))<50)
                %%
                % The stage may have reached one of its limits or is
                % physically impeded by part of the microscope (Yikes!).
                % This function assumes that the stage during normal
                % operation should be able to move 50 um in second and if
                % it is not then something is wrong.
                obj.Timer_pos_counter = obj.Timer_pos_counter+1;
            else
                obj.Timer_pos_counter = 0;
            end
            if obj.Timer_pos_counter > 2
                obj.core.stop(obj.xyStageDevice);
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
            if isempty(varargin)
                Core_general_setXYZ(obj,pos);
            else
                Core_general_setXYZ(obj,pos,celldisp(varargin));
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
                Core_general_snapImage(obj);
            else
                Core_general_snapImage(obj,celldisp(varargin));
            end
        end
    end
    methods (Static)
        
    end
end