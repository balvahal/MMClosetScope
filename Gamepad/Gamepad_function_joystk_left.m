%%
%
function [gamepad] = Gamepad_function_joystk_left(gamepad)
if (abs(gamepad.joystk_left_mag_old - gamepad.joystk_left_mag) < 0.02) && (abs(gamepad.joystk_left_dir_old - gamepad.joystk_left_dir) < 5)
    return; %user input is smoothed out and if no one is using the controller an m-file directing the stage will still work.
end

my_mag = gamepad.joystk_left_mag - 0.1;
if my_mag <= 0
    my_command = sprintf('JXD,0\r'); %stop X movement
    gamepad.microscope.core.writeToSerialPort(gamepad.microscope.xyStageDevice,my_command);
    my_command = sprintf('JYD,0\r'); %stop Y movement
    gamepad.microscope.core.writeToSerialPort(gamepad.microscope.xyStageDevice,my_command);
    return;
end
%%
% The 2nd order polynomial has a nice gradual increase in speed for small
% magnitudes that gives the joystick movement some fine touch.
my_speed = round(99*(my_mag^2))+1; %a percentage between 1 and 100 %speed of scope [1,250] with default = 100. acceleration of scope [1,150] with default = 100;

my_dir = gamepad.joystk_left_dir + 180; %the default of the joystick has 0 degrees pointing East and degrees increase clockwise. For the scope we want 0 degrees pointing West increasing clockwise.
%gamepad.microscope.core.stop(gamepad.microscope.xyStageDevice);
my_command = sprintf('JXD,%d\r',cosd(my_dir)); % X movement
gamepad.microscope.core.writeToSerialPort(gamepad.microscope.xyStageDevice,my_command);
my_command = sprintf('JYD,%d\r',sind(my_dir)); % Y movement
gamepad.microscope.core.writeToSerialPort(gamepad.microscope.xyStageDevice,my_command);
my_command = sprintf('O,%d\r',my_speed); % speed as percentage of current speed setting
gamepad.microscope.core.writeToSerialPort(gamepad.microscope.xyStageDevice,my_command);
end