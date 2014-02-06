%%
%
function [gamepad] = Gamepad_function_joystk_left(gamepad)
    if (abs(gamepad.joystk_left_mag_old - gamepad.joystk_left_mag) < 0.02) && (abs(gamepad.joystk_left_dir_old - gamepad.joystk_left_dir) < 5)
        return; %user input is smoothed out and if no one is using the controller an m-file directing the stage will still work.
    end
    
    my_mag = gamepad.joystk_left_mag - 0.1;
    if my_mag <= 0
        gamepad.microscope.core.stop(gamepad.microscope.xyStageDevice);
        return;
    end
    %%
    % The 2nd order polynomial has a nice gradual increase in speed for
    % small magnitudes that gives the joystick movement some find touch.
    my_speed = round(185*(my_mag^2))+1; %speed of scope [1,250] with default = 100. acceleration of scope [1,150] with default = 100;
    
    my_dir = gamepad.joystk_left_dir + 180; %the default of the joystick has 0 degrees pointing East and degrees increase clockwise. For the scope we want 0 degrees pointing West increasing clockwise.
    my_pos = gamepad.microscope.pos + 1e6*[cosd(my_dir),sind(my_dir),0];
    gamepad.microscope.core.stop(gamepad.microscope.xyStageDevice);
    gamepad.microscope.core.setProperty(gamepad.microscope.xyStageDevice,'MaxSpeed',my_speed);
    gamepad.microscope.setXYZ(my_pos);
end