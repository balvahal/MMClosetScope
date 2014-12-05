%% Gamepad_Logitech_F310
% A MATLAB object that interfaces the Logitech F310 gamepad with MATLAB. It
% provides a means for the gamepad to interact with a MATLAB program. The
% class depends on the Simulink 3D Animation toolbox and @vrjoystick class.
% When the F310 is plugged into the computer it will automatically be
% detected when the @vrjoystick object is created. Make sure the F310 is
% set to "Direct Input" as indicated by the switch underneath the gamepad.
%
% button presses will have listener objects that will respond to their
% indentation.
%
% pov and joystk will be polled continously by a timer object.
classdef SCAN6_gamepad_object < Gamepad_Logitech_F310
    properties
        %%
        % scan6 project specifics
        smdaITF
        ITFpointer = 0;
        scan6
        %% Microscope relevant properties
        % The left joystick will control movement of the stage. Two
        % pertinent pieces of information will be the direction the
        % joystick is pointing and the magnitude the joystick is tilted in
        % that direction. The control over the microscope is mediated by a
        % stage controller. The stage controller is periodically sent
        % signals from MATLAB to update its movement.
        %
        microscope
        stageport
        pov_speed = [25,50,100,200,400,800,1600]; %speed of microscope movement in microns per second
        %% joy stick lookup table
        % It has been emperically determined that the joystick is unwieldy
        % when relying upon some formula to determine velocity. The root of
        % this lies in the communication with the stage. The signal needs
        % to be broken up when a heading is to be maintained; constantly
        % sending signals to change direction confounds the stage.
        % Therefore, I will craft a lookup table that divide a circle into
        % 24 directions spaced 15 degrees apart. The magnitude will be
        % divided into 12 regions. The first region will be a deadzone.
        % The next 6 regions will provide fine control over the stage. The
        % last 5 regions will provide rapid movement.
        joystk_left_lookup
        magArraySlow = [0,20,30,50,70,90,120,150,200,250,350,475,600];
        magArrayFast = [0,150,250,450,750,1500,2250,3500,5000,6000,7000,8000];
        joystk_left_speedMode
        joystk_right_lookup
        joystk_right_speedMode
    end
    %%
    %
    events
        % none yet
    end
    %%
    %
    methods
        %% The constructor method
        % The constructor method was designed to only be called by its
        % parent object. The idea is to have a hierarchy of objects to
        % provide structure to the configuration of an MDA without
        % sacraficing to much customization. After the creation of the
        % SuperMDA tiered-object use the new_position method to add another
        % position object.
        function obj = SCAN6_gamepad_object(mmhandle)
            obj.microscope = mmhandle; %this gamepad is meant to interact with a microscope and mmhandle is the object that grants control over the microscope
            %%
            %
            magArray = obj.magArraySlow;
            degVec = 0:15:345;
            obj.joystk_left_lookup = cell(12,24);
            for i = 1:12
                for j = 1:24
                    obj.joystk_left_lookup{i,j} = magArray(i)*[cosd(degVec(j)),sind(degVec(j))];
                end
            end
            
            obj.joystk_left_speedMode = 'slow';
            %%
            %
            magArray = obj.magArraySlow;
            degVec = 0:15:345;
            obj.joystk_right_lookup = cell(12,24);
            for i = 1:12
                for j = 1:24
                    obj.joystk_right_lookup{i,j} = magArray(i)*[cosd(degVec(j)),sind(degVec(j))];
                end
            end
            
            obj.joystk_right_speedMode = 'slow';
            %%
            % the TimerFcn will automatically pass in two input arguments.
            % These are not needed, so they are thrown away using the
            % syntax (~,~).
            obj.controller_timer = timer('ExecutionMode','fixedRate','BusyMode','drop','Period',0.04,'TimerFcn',@(~,~) obj.read_controller);

            %%
            %
            computerName = mmhandle.core.getHostName.toCharArray'; %the hostname is used as a unique identifier
            if strcmp(computerName,'LAHAVSCOPE0001')
                %%
                % Closet Scope
                obj.stageport = 'COM1';
            elseif strcmp(computerName,'LAHAVSCOPE002')
                %%
                % Curtain Scope
                obj.stageport = 'COM3';
            elseif strcmp(computerName,'KISHONYWAB111A')
                %%
                % Kishony Scope
                obj.stageport = 'COM2';
            else
                obj.stageport = 'COM1';
            end
            %%
            % define functions for the controller
            obj.function_button_x = @Gamepad_function_button_x; %1
            obj.function_button_a = @Gamepad_function_button_a; %2
            obj.function_button_b = @Gamepad_function_button_b; %3
            obj.function_button_y = @Gamepad_function_button_y; %4
            obj.function_button_lb = @Gamepad_function_button_lb; %5
            obj.function_button_rb = @Gamepad_function_button_rb; %6
            obj.function_button_lt = @Gamepad_function_button_lt; %7
            obj.function_button_rt = @Gamepad_function_button_rt; %8
            obj.function_button_back = @Gamepad_function_button_back; %9
            obj.function_button_start = @Gamepad_function_button_start; %10
            obj.function_button_stk_left = @Gamepad_function_button_stk_left; %11
            obj.function_button_stk_right = @Gamepad_function_button_stk_right; %12
            obj.function_pov_dpad = @Gamepad_function_pov_dpad;
            obj.function_joystk_left = @Gamepad_function_joystk_left;
            obj.function_joystk_right = @Gamepad_function_joystk_right;
            obj.function_read_controller = @Gamepad_function_read_controller;
        end
        %%
        %
        function obj = makeJoyStkLeftLookup(obj,mystr)
            switch lower(mystr)
                case 'slow'
                    magArray = obj.magArraySlow;
                case 'fast'
                    magArray = obj.magArrayFast;
                otherwise
                    magArray = obj.magArraySlow;
            end
            
            degVec = 0:15:345;
            obj.joystk_left_lookup = cell(12,24);
            for i = 1:12
                for j = 1:24
                    obj.joystk_left_lookup{i,j} = magArray(i)*[cosd(degVec(j)),sind(degVec(j))];
                end
            end
        end
        %%
        %
        function obj = makeJoyStkRightLookup(obj,mystr)
            switch lower(mystr)
                case 'slow'
                    magArray = obj.magArraySlow;
                case 'fast'
                    magArray = obj.magArrayFast;
                otherwise
                    magArray = obj.magArraySlow;
            end
            
            degVec = 0:15:345;
            obj.joystk_left_lookup = cell(12,24);
            for i = 1:12
                for j = 1:24
                    obj.joystk_left_lookup{i,j} = magArray(i)*[cosd(degVec(j)),sind(degVec(j))];
                end
            end
        end
    end
end