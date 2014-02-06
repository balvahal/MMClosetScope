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
classdef Gamepad_Logitech_F310 < handle
    %%
    %
    properties
        gamepad
        joy_timer
        button
        button_timer
        joystk
        pov
        %% Microscope relevant properties
        % The left joystick will control movement of the stage. Two
        % pertinent pieces of information will be the direction the
        % joystick is pointing and the magnitude the joystick is tilted in
        % that direction. The control over the microscope is mediated by a
        % stage controller. The stage controller is periodically sent
        % signals from MATLAB to update its movement.
        joystk_left_dir
        joystk_left_dir_old
        joystk_left_mag
        joystk_left_mag_old
        microscope
        
        %% The read command
        % The read command returns three MATLAB values: joystk, button,
        % pov.
        %
        % * joystk = a four value array representing the x and y direction of
        % the two joysticks. [stk_left_x, stk_left_y, stk_right_x,
        % stk_right_y].
        % * buttons = a 12 value logical array where each position
        % represents a button. As far as I can tell only the "mode" button
        % and the "Logitech" button are not detected by the @vrjoystick.
        % * povs = a single value reporting on the direction of the d-pad.
        %% buttons
        % buttons = a 1x12 logical
        %
        % the buttons are ordered in the place they appear in the logical
        % array
        button_x %1
        button_a %2
        button_b %3
        button_y %4
        button_lb %5
        button_rb %6
        button_lt %7
        button_rt %8
        button_back %9
        button_start %10
        button_stk_left %11
        button_stk_right %12
        %% povs
        % Eight values that range from 0 to 315 representing 360 degrees in
        % a circle. The values increase in a clockwise fashion when looking
        % down at the gamepad.
        %
        % * -1 means the d-pad is centered or not being used
        % * 0 = N
        % * 45 = NE
        % * 90 = E
        % * 135 = SE
        % * 180 = S
        % * 225 = SW
        % * 270 = W
        % * 315 = NW
        pov_dpad
        %% joystk
        % There are two joystk that represent the left and right joysticks.
        % The joystk values range from -1 to 1 in a continous fashion with 4
        % decimal precision. Each joystick has an x-axis and y-axis value
        % and a abs(joystk(n)) = 1 means that  the stick is pushed to its
        % furtherest position. The resting position does not necessarily
        % equal [0,0,0,0], so be sure to calibrate the gamepad by
        % remembering the starting values to avoid unintentional drift;
        % also consider a "dead zone" where the user must push the sticks a
        % minimum distance before response, because the joysticks may not
        % always return to the same position when released.
        %
        % * S/down or E/right = 1
        % * N/up or W/left = -1
        joystk_left_x %1
        joystk_left_y %2
        joystk_right_x %3
        joystk_right_y %4
        %% Prior States
        % Knowing the previous state of a button determines whether or not
        % a button has been pressed and released or is being held down.
        button_x_old %1
        button_a_old %2
        button_b_old %3
        button_y_old %4
        button_lb_old %5
        button_rb_old %6
        button_lt_old %7
        button_rt_old %8
        button_back_old %9
        button_start_old %10
        button_stk_left_old %11
        button_stk_right_old %12
        
        pov_dpad_old
        
        joystk_left_x_old %1
        joystk_left_y_old %2
        joystk_right_x_old %3
        joystk_right_y_old %4
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
        function obj = Gamepad_Logitech_F310(mmhandle)
            obj.gamepad = vrjoystick(1); %assumes the F310 is the only gamepad connected to the computer.
            obj.microscope = mmhandle; %this gamepad is meant to interact with a microscope and mmhandle is the object that grants control over the microscope
            
            [obj.joystk,obj.button,obj.pov] = read(obj.gamepad);
                       
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
            
            obj.joystk_left_x = obj.joystk(1); %1
            obj.joystk_left_y = obj.joystk(2); %2
            obj.joystk_left_dir = obj.angle_joystk_left;
            obj.joystk_left_mag = obj.magnitude_joystk_left;
            obj.joystk_right_x = obj.joystk(3); %3
            obj.joystk_right_y = obj.joystk(4); %4
            
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
            
            %%
            % the TimerFcn will automatically pass in two input arguments.
            % These are not needed, so they are thrown away using the
            % syntax (~,~).
            obj.joy_timer = timer('ExecutionMode','fixedRate','Period',0.005,'TimerFcn',@(~,~) obj.read_joystk);
            obj.button_timer = timer('ExecutionMode','fixedRate','BusyMode','queue','Period',0.005,'TimerFcn',@(~,~) obj.read_button);
            start(obj.joy_timer);
            start(obj.button_timer);
        end
        %%
        %
        function delete(obj)
            stop(obj.joy_timer);
            delete(obj.joy_timer);
            stop(obj.button_timer);
            delete(obj.button_timer);
        end
        %%
        %
        function obj = read_joystk(obj)
            [obj.joystk,obj.button,obj.pov] = read(obj.gamepad);                     
            obj.pov_dpad = obj.pov;
            
            Gamepad_function_pov_dpad(obj);
            
            obj.joystk_left_x = obj.joystk(1); %1
            obj.joystk_left_y = obj.joystk(2); %2
            obj.joystk_left_dir = obj.angle_joystk_left;
            obj.joystk_left_mag = obj.magnitude_joystk_left;
            obj.joystk_right_x = obj.joystk(3); %3
            obj.joystk_right_y = obj.joystk(4); %4
            
            Gamepad_function_joystk_left(obj);
            
            obj.joystk_left_dir_old = obj.joystk_left_dir;
            obj.joystk_left_mag_old = obj.joystk_left_mag;
        end
        %%
        %
        function obj = read_button(obj)
            [obj.joystk,obj.button,obj.pov] = read(obj.gamepad);
                       
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
            
            Gamepad_function_button_x(obj);
            Gamepad_function_button_rt(obj);
            
            obj.button_x_old = obj.button_x; %1
            obj.button_a_old = obj.button_a; %2
            obj.button_b_old = obj.button_b; %3
            obj.button_y_old = obj.button_y; %4
            obj.button_lb_old = obj.button_lb; %5
            obj.button_rb_old = obj.button_rb; %6
            obj.button_lt_old = obj.button_lt; %7
            obj.button_rt_old = obj.button_rt; %8
            obj.button_back_old = obj.button_back; %9
            obj.button_start_old = obj.button_start; %10
            obj.button_stk_left_old = obj.button_stk_left; %11
            obj.button_stk_right_old = obj.button_stk_right; %12
        end
        %%
        % 
        function my_angle = angle_joystk_left(obj)
            my_angle = atan2d(obj.joystk_left_y,obj.joystk_left_x);
            if my_angle < 0
                my_angle = my_angle + 360;
            end
        end
        %%
        % I have observed that when holding the joystick in any of the four
        % diagonal directions that the magnitude is greater than 1 and
        % reaches values around 1.2. I wonder if imbalance between the x
        % and y signals also leads to faulty angles, but I cannot tell just
        % by looking at a string of numbers. With regards to magnitude,
        % values greater than 1 will be reduced to 1.
        function my_magnitude = magnitude_joystk_left(obj)
            my_magnitude = hypot(obj.joystk_left_y,obj.joystk_left_x);
            if my_magnitude > 1
                my_magnitude = 1;
            end
        end
    end
    methods (Static)
        %%
        %
        
    end
end