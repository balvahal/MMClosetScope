%%
%
function [gamepad] = Gamepad_function_joystk_left(gamepad)
if (abs(gamepad.joystk_left_mag_old - gamepad.joystk_left_mag) < 0.02) && (abs(gamepad.joystk_left_dir_old - gamepad.joystk_left_dir) < 5)
    return; %user input is smoothed out and if no one is using the controller an m-file directing the stage will still work.
end

my_mag = gamepad.joystk_left_mag - 0.1;
if my_mag <= 0
    % stop the joystick movement
    gamepad.microscope.core.setSerialPortCommand('COM3','VS,0,0',sprintf('\r'));
    %e.g.
    %gamepad.microscope.core.setSerialPortCommand('COM3','GR,1000,1000',sprintf('\r'));
    % after setting JXD to 0, read back the answer with...
    % gamepad.microscope.core.getSerialPortAnswer('COM3',sprintf('\r'));
    % send a query request and then getSerialPortAnswer: gamepad.microscope.core.setSerialPortCommand('COM3','O',sprintf('\r'));
    return;
end
%%
% The 2nd order polynomial has a nice gradual increase in speed for small
% magnitudes that gives the joystick movement some fine touch.
% the manual recommends setting the joystick between -8000 and 8000 microns
% per second, though the max speed is [-30000,30000]
my_speed = round(15000*(my_mag^2)); %a percentage between 1 and 100 %speed of scope [1,250] with default = 100. acceleration of scope [1,150] with default = 100;

my_dir = gamepad.joystk_left_dir + 180; %the default of the joystick has 0 degrees pointing East and degrees increase clockwise. For the scope we want 0 degrees pointing West increasing clockwise.
%gamepad.microscope.core.stop(gamepad.microscope.xyStageDevice);
my_command = sprintf('VS,%d,%d',my_speed*cosd(my_dir),my_speed*sind(my_dir));
gamepad.microscope.core.setSerialPortCommand('COM3',my_command,sprintf('\r'));
fprintf('%3.2d   %3.2d \r\n',my_mag,my_dir);
end