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
        button
        controller_timer
        function_read_controller
        joystk
        pov
        %% Microscope relevant properties
        % The left joystick will control movement of the stage. Two
        % pertinent pieces of information will be the direction the
        % joystick is pointing and the magnitude the joystick is tilted in
        % that direction. The control over the microscope is mediated by a
        % stage controller. The stage controller is periodically sent
        % signals from MATLAB to update its movement.
        %
        joystk_left_dir
        joystk_left_dir_old
        joystk_left_mag
        joystk_left_mag_old
        joystk_right_mag
        joystk_right_mag_old
        joystk_right_dir
        joystk_right_dir_old
        microscope
        stageport
        pov_speed = [25,50,100,200,400,800,1600]; %speed of microscope movement in microns per second
        
        %% The read command
        % The read command returns three MATLAB values: joystk, button,
        % pov.
        %
        % * joystk = a four value array representing the x and y direction
        % of the two joysticks. [stk_left_x, stk_left_y, stk_right_x,
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
        
        function_button_x %1
        function_button_a %2
        function_button_b %3
        function_button_y %4
        function_button_lb %5
        function_button_rb %6
        function_button_lt %7
        function_button_rt %8
        function_button_back %9
        function_button_start %10
        function_button_stk_left %11
        function_button_stk_right %12
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
        
        function_pov_dpad
        %% joystk
        % There are two joystk that represent the left and right joysticks.
        % The joystk values range from -1 to 1 in a continous fashion with
        % 4 decimal precision. Each joystick has an x-axis and y-axis value
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
        
        function_joystk_left
        function_joystk_right
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
        %%
        % data collection
        mydata = zeros(10000,2);
        mydataind = 1;
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
            if strcmp(computerName,'LB89-6A-45FA')
                %%
                % Closet Scope
                obj.stageport = 'COM3';
            elseif strcmp(computerName,'LAHAVSCOPE002')
                %%
                % Curtain Scope
                obj.stageport = 'COM3';
            elseif strcmp(computerName,'KISHONYWAB111A')
                %%
                % Kishony Scope
                obj.stageport = 'COM3';
            else
                obj.stageport = 'COM3';
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
        %%
        %
        function delete(obj)
            stop(obj.controller_timer);
            delete(obj.controller_timer);
        end
        %%
        %
        function obj = read_joystk(obj)
            %%
            % dpad
            [obj.joystk,obj.button,obj.pov] = read(obj.gamepad);
            obj.pov_dpad = obj.pov;
            obj.function_pov_dpad(obj);
            obj.pov_dpad_old = obj.pov_dpad;
            %%
            % joystick left
            obj.joystk_left_x = obj.joystk(1); %1
            obj.joystk_left_y = obj.joystk(2); %2

            obj.joystk_left_dir = obj.angle_joystk_left;
            obj.joystk_left_mag = obj.magnitude_joystk_left;
            
            obj.function_joystk_left(obj);
            
            obj.joystk_left_dir_old = obj.joystk_left_dir;
            obj.joystk_left_mag_old = obj.joystk_left_mag;
            %%
            % joystick right
            obj.joystk_right_x = obj.joystk(3); %3
            obj.joystk_right_y = obj.joystk(4); %4
            
            obj.joystk_right_dir = obj.angle_joystk_right;
            obj.joystk_right_mag = obj.magnitude_joystk_right;
            
            obj.function_joystk_right(obj);
            
            obj.joystk_right_dir_old = obj.joystk_right_dir;
            obj.joystk_right_mag_old = obj.joystk_right_mag;
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
            
            obj.function_button_x(obj); %1
            obj.function_button_a(obj); %2
            obj.function_button_b(obj); %3
            obj.function_button_y(obj); %4
            obj.function_button_lb(obj); %5
            obj.function_button_rb(obj); %6
            obj.function_button_lt(obj); %7
            obj.function_button_rt(obj); %8
            obj.function_button_back(obj); %9
            obj.function_button_start(obj); %10
            obj.function_button_stk_left(obj); %11
            obj.function_button_stk_right(obj); %12
            
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
        
        function obj = read_controller(obj)
            obj.read_button;
            obj.read_joystk;
            obj.function_read_controller(obj);
        end
        %%
        %
        function my_angle = angle_joystk_left(obj)
            y = obj.joystk_left_y;
            x = obj.joystk_left_x;
            my_angle = atan2d(y,x);
            if my_angle < 0
                my_angle = my_angle + 360;
            end
            %%
            % convert angle into lookup table index
            my_angle = round(my_angle/15.6522) + 1; %15.6522 = 1/(24-1)
        end
        %%
        % I have observed that when holding the joystick in any of the four
        % diagonal directions that the magnitude is greater than 1 and
        % reaches values around 1.2. I wonder if imbalance between the x
        % and y signals also leads to faulty angles, but I cannot tell just
        % by looking at a string of numbers. With regards to magnitude,
        % values greater than 1 will be reduced to 1.
        
        function my_magnitude = magnitude_joystk_left(obj)
            y = obj.joystk_left_y;
            x = obj.joystk_left_x;
            my_magnitude = hypot(y,x);
            if my_magnitude > 1
                my_magnitude = 1;
            end
            %%
            % convert magnitude into a lookup table index
            my_magnitude = round(my_magnitude*11) + 1;
        end
        %%
        %
        function my_angle = angle_joystk_right(obj)
            y = obj.joystk_right_y;
            x = obj.joystk_right_x;
            my_angle = atan2d(y,x);
            if my_angle < 0
                my_angle = my_angle + 360;
            end
            %%
            % convert angle into lookup table index
            my_angle = round(my_angle/15.6522) + 1; %15.6522 = 1/(24-1)
        end
        %%
        %
        function my_magnitude = magnitude_joystk_right(obj)
            y = obj.joystk_right_y;
            x = obj.joystk_right_x;
            my_magnitude = hypot(y,x);
            if my_magnitude > 1
                my_magnitude = 1;
            end
            %%
            % convert magnitude into a lookup table index
            my_magnitude = round(my_magnitude*11) + 1;
        end
        %%
        %
        function obj = connectController(obj)
            start(obj.controller_timer);
        end
        
    end
    methods (Static)
        %%
        %
        
    end
end