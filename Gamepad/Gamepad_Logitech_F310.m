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
        %%% Core
        % These properties contain the _vrjoystick_ object and its
        % properties: _button_, _joystk_, and _pov_. The exception is the
        % _gamepad_timer_. In order to use the gamepad in an interactive
        % way a timer at a high speed checks the states of all the buttons,
        % bumpers, and joysticks. The speed was empirically chosen to be
        % faster than can be detected by a human. That is to say when a
        % button is pressed there are very good odds that a timer will
        % trigger and detect this change, even if the button is pushed
        % briefly. The timer speed was chosen to be just beyond this
        % threshold to spare MATLAB some CPU cycles for other activities.
        % For reference, the fixed rate to read the controller state is
        % 1/25th of a second.
        gamepad
        button
        gamepad_timer
        joystk
        pov
        %%% The read command
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
        %%% buttons
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
        
        %%% povs
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
        
        %%% joystk
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
        
        %%% direction and magnitude
        % To help interpret the joystick values, the cartesian sense of x
        % and y can be converted into polar coordinates described by a
        % direction and magnitude. Note that the direction and magnitude
        % has been discretized, because the joystick has been empiraclly
        % found to be a touch sensitive in use. Therefore, the magnitude is
        % expressed as an integer [1,12] and the direction as an integer
        % [1,24]. Together this represents 288 possibilities, which is an
        % order of magnitude more than the d-pad/pov has available.
        % Although, the magnitude integer of 1 represents the zero vector
        % which is directionless, so more practically speaking there are
        % 265 possiblities.
        joystk_left_dir
        joystk_left_mag
        joystk_right_mag
        joystk_right_dir
        
        %%% Prior States
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
        joystk_left_dir_old
        joystk_left_mag_old
        joystk_right_mag_old
        joystk_right_dir_old
        
        %%% Functions
        %
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
        
        function_pov_dpad
        
        function_joystk_left
        function_joystk_right
    end
    %%
    %
    events
        % none yet
    end
    %%
    %
    % * angle_joystk_left
    % * angle_joystk_right
    % * delete
    % * magnitude_joystk_left
    % * magnitude_joystk_right
    % * read_button
    % * read_controller
    % * read_joystk
    
    methods
        %% The constructor method
        % The constructor method was designed to only be called by its
        % parent object. The idea is to have a hierarchy of objects to
        % provide structure to the configuration of an MDA without
        % sacraficing to much customization. After the creation of the
        % SuperMDA tiered-object use the new_position method to add another
        % position object.
        function obj = Gamepad_Logitech_F310()
            obj.gamepad = vrjoystick(1); %assumes the F310 is the only gamepad connected to the computer.
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
            % the TimerFcn will automatically pass in two input arguments.
            % These are not needed, so they are thrown away using the
            % syntax (~,~).
            obj.gamepad_timer = timer('ExecutionMode','fixedRate','BusyMode','drop','Period',0.04,'TimerFcn',@(~,~) obj.read_controller);
            %%
            %
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
        end
        %%
        % The output _my_angle_ will be an integer [1,24]. A circle, having
        % 360 degrees, was divided into 24 equally spaced possibilities.
        % Each wedge between two possibilities is 15 degrees.
        function my_angle = angle_joystk_left(obj)
            y = obj.joystk_left_y;
            x = obj.joystk_left_x;
            my_angle = atan2d(y,x);
            if my_angle < 0
                my_angle = my_angle + 360;
            end
            %%%
            % convert angle into lookup table index
            my_angle = round(my_angle/15) + 1; %15 = 360/24.
            if my_angle == 25
                my_angle = 1;
            end
        end
        %%
        % The output _my_angle_ will be an integer [1,24]. A circle, having
        % 360 degrees, was divided into 24 equally spaced possibilities.
        % Each wedge between two possibilities is 15 degrees.
        function my_angle = angle_joystk_right(obj)
            y = obj.joystk_right_y;
            x = obj.joystk_right_x;
            my_angle = atan2d(y,x);
            if my_angle < 0
                my_angle = my_angle + 360;
            end
            %%%
            % convert angle into lookup table index. 1 must be added to the
            % output, because the first index in MATLAB is 1 and the angle
            % could be rounded to 0.
            my_angle = round(my_angle/15) + 1; %15 = 360/24.
            if my_angle == 25
                my_angle = 1;
            end
        end
        %%
        %
        function delete(obj)
            stop(obj.gamepad_timer);
            delete(obj.gamepad_timer);
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
            %%%
            % convert magnitude into a lookup table index
            my_magnitude = ceil(my_magnitude*12);
        end
        %%
        % The output _my_magnitude_ will be an integer [1,12]. The possible
        % magnitude of the joystick, values between 0 and 1, was divided
        % into 12 equally spaced possiblities.
        function my_magnitude = magnitude_joystk_right(obj)
            y = obj.joystk_right_y;
            x = obj.joystk_right_x;
            my_magnitude = hypot(y,x);
            if my_magnitude > 1
                my_magnitude = 1;
            end
            %%%
            % convert magnitude into a lookup table index
            my_magnitude = ceil(my_magnitude*12);
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
        %%
        %
        function obj = read_controller(obj)
            obj.read_button;
            obj.read_joystk;
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
    end
end