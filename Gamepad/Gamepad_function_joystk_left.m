%%
%
function [gamepad] = Gamepad_function_joystk_left(gamepad)
%%
% if the position of the joystick is not changing then do not take any
% further action
if (abs(gamepad.joystk_left_mag_old - gamepad.joystk_left_mag) < 0.02) && (abs(gamepad.joystk_left_dir_old - gamepad.joystk_left_dir) < 5)
    return; %user input is smoothed out and if no one is using the controller an m-file directing the stage will still work.
end

%%
% define a dead zone where the no movement will occur.
deadzone = 0.1;
my_mag = gamepad.joystk_left_mag - deadzone;
if my_mag <= 0
    % stop the joystick movement
    gamepad.microscope.core.setSerialPortCommand(gamepad.stageport,'VS,0,0',sprintf('\r'));
    %e.g.
    %gamepad.microscope.core.setSerialPortCommand('COM3','GR,1000,1000',sprintf('\r'));
    % after setting JXD to 0, read back the answer with...
    % gamepad.microscope.core.getSerialPortAnswer('COM3',sprintf('\r'));
    % send a query request and then getSerialPortAnswer: gamepad.microscope.core.setSerialPortCommand('COM3','O',sprintf('\r'));
    return;
elseif my_mag > (1-deadzone)
        my_mag = (1-deadzone);
end
%%
% The 2nd order polynomial has a nice gradual increase in speed for small
% magnitudes that gives the joystick movement some fine touch.
% the manual recommends setting the joystick between -8000 and 8000 microns
% per second, though the max speed is [-30000,30000]
gamepad.speed_old = gamepad.speed;
gamepad.speed = round(15000*((my_mag/(1-deadzone))^2)); %a percentage between 1 and 100 %speed of scope [1,250] with default = 100. acceleration of scope [1,150] with default = 100;
% if gamepad.speed - gamepad.speed_old > 500
%     gamepad.speed = gamepad.speed_old + 500;
% elseif gamepad.speed - gamepad.speed_old < -500
%     gamepad.speed = gamepad.speed_old - 500;
% end

gamepad.dir = gamepad.joystk_left_dir + 180; %the default of the joystick has 0 degrees pointing East and degrees increase clockwise. For the scope we want 0 degrees pointing West increasing clockwise.
%%
% send new direction information to the stage
my_command = sprintf('VS,%d,%d',my_speed*cosd(my_dir),my_speed*sind(my_dir));
gamepad.microscope.core.setSerialPortCommand(gamepad.stageport,my_command,sprintf('\r'));
%%
% collect joystk data for algorithm development
%         gamepad.mydata(gamepad.mydataind,:) = [my_speed, my_dir];
%         gamepad.mydataind = gamepad.mydataind + 1;
%         if gamepad.mydataind > 10000
%             gamepad.mydataind = 1;
%         end
end