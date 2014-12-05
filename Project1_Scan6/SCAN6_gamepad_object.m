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
        
    end
    %%
    %
    properties (SetObservable)
       
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
            obj.gamepad = vrjoystick(1); %assumes the F310 is the only gamepad connected to the computer.
            obj.microscope = mmhandle; %this gamepad is meant to interact with a microscope and mmhandle is the object that grants control over the microscope
            [obj.joystk,obj.button,obj.pov] = read(obj.gamepad);
            %%
            %
            obj.button_x = obj.button(1); %1
            obj.button_a = obj.button(2); %2
            obj.button_b = obj.button(3); %3
            obj.button_y = obj.button(4); %4
            obj.button_lb = obj.button(5); %5
            obj.button_rb = obj.button(6); %6
            obj.button_lt = obj.button(7); %7
            obj.button_rt = obj.button(8); %8
            obj.button_back = obj.button(9); %9
            obj.button_start = obj.button(10); %10
            obj.button_stk_left = obj.button(11); %11
            obj.button_stk_right = obj.button(12); %12
            
            obj.pov_dpad = obj.pov;
            obj.pov_dpad_old = obj.pov;
            
            obj.joystk_left_x = obj.joystk(1); %1
            obj.joystk_left_y = obj.joystk(2); %2
            obj.joystk_left_dir = obj.angle_joystk_left;
            obj.joystk_left_mag = obj.magnitude_joystk_left;
            obj.joystk_right_x = obj.joystk(3); %3
            obj.joystk_right_y = obj.joystk(4); %4
            
            obj.joystk_right_dir = obj.angle_joystk_right;
            obj.joystk_right_mag = obj.magnitude_joystk_right;
            
            obj.button_x_old = obj.button(1); %1
            obj.button_a_old = obj.button(2); %2
            obj.button_b_old = obj.button(3); %3
            obj.button_y_old = obj.button(4); %4
            obj.button_lb_old = obj.button(5); %5
            obj.button_rb_old = obj.button(6); %6
            obj.button_lt_old = obj.button(7); %7
            obj.button_rt_old = obj.button(8); %8
            obj.button_back_old = obj.button(9); %9
            obj.button_start_old = obj.button(10); %10
            obj.button_stk_left_old = obj.button(11); %11
            obj.button_stk_right_old = obj.button(12); %12
            
            obj.pov_dpad_old = obj.pov;
            
            obj.joystk_left_x_old = obj.joystk(1); %1
            obj.joystk_left_y_old = obj.joystk(2); %2
            obj.joystk_right_x_old = obj.joystk(3); %3
            obj.joystk_right_y_old = obj.joystk(4); %4
            
            %%
            %
            obj.joystk_left_dir_old = obj.angle_joystk_left;
            obj.joystk_left_mag_old = obj.magnitude_joystk_left;
            obj.joystk_right_dir_old = obj.angle_joystk_right;
            obj.joystk_right_mag_old = obj.magnitude_joystk_right;
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
            %%
            %
            obj.listener_joystk_right = addlistener(obj,'joystk_right_dir','PostSet',@Gamepad_listener_joystk_right);
        end
    end
end