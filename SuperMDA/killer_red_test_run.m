mmhandle = Core_startup_initialize;
%%
%
mmhandle.SuperMDA = SuperMDALevel1Primary(mmhandle);
%% Primary Level Settings
% set the imaging period to be 1.5 minutes
mmhandle.SuperMDA.fundamental_period = 90;
% set the duration to be 16 hours or 57600 seconds
mmhandle.SuperMDA.duration = 57600;
% set the output directory to be...
mmhandle.SuperMDA.output_directory = 'C:\Users\Kyle\Documents\MATLAB\killeredtest';%'C:\Users\kk128\Documents\Test';%'D:\Kyle\killerredtest';
% Group Level Settings
% set the label to something informative
mmhandle.SuperMDA.group.label = 'killer_red_test1';
%% Settings Level
%
mmhandle.SuperMDA.group.position.new_settings;
mmhandle.SuperMDA.group.position.new_settings;
mmhandle.SuperMDA.group.position.settings(2).channel = 2;
mmhandle.SuperMDA.group.position.settings(3).channel = 3;
mmhandle.SuperMDA = mmhandle.SuperMDA.configure_clock_relative;
mmhandle.SuperMDA.group.position(1).settings(1).exposure(1) = 200;
mmhandle.SuperMDA.group.position(1).settings(2).exposure(1) = 300;
mmhandle.SuperMDA.update_children_to_reflect_number_of_timepoints;
mmhandle.SuperMDA.group.position.settings(3).timepoints = zeros(size(mmhandle.SuperMDA.group.position.settings(3).timepoints));
mmhandle.SuperMDA.group.position.settings(3).timepoints(1:3) = 1;
mmhandle.SuperMDA.group.position.settings(3).timepoints_custom_bool = true;
%% Pause here to choose your positions
%
mmhandle.SuperMDA.group.new_position;
mmhandle.SuperMDA.group.position(2).xyz = [100,101,2];
mmhandle.SuperMDA.group.new_position;
mmhandle.SuperMDA.group.new_position;
mmhandle.SuperMDA.group.new_position;
mmhandle.SuperMDA.group.new_position;
mmhandle.SuperMDA.group.new_position;
mmhandle.SuperMDA.group.new_position;
mmhandle.SuperMDA.group.new_position;
mmhandle.SuperMDA.group.change_all_position('continuous_focus_bool',false);
%% There will be 9 positions and each position will have a different exposure
%
mmhandle.SuperMDA.group.position(1).settings(3).exposure(1) = 100;
mmhandle.SuperMDA.group.position(2).settings(3).exposure(1) = 100;
mmhandle.SuperMDA.group.position(3).settings(3).exposure(1) = 100;
mmhandle.SuperMDA.group.position(4).settings(3).exposure(1) = 100;
mmhandle.SuperMDA.group.position(5).settings(3).exposure(1) = 100;
mmhandle.SuperMDA.group.position(6).settings(3).exposure(1) = 100;
mmhandle.SuperMDA.group.position(7).settings(3).exposure(1) = 100;
mmhandle.SuperMDA.group.position(8).settings(3).exposure(1) = 100;
mmhandle.SuperMDA.group.position(9).settings(3).exposure(1) = 100;
mmhandle.SuperMDA.group.position(1).settings(3).exposure(2) = 1800;
mmhandle.SuperMDA.group.position(2).settings(3).exposure(2) = 900;
mmhandle.SuperMDA.group.position(3).settings(3).exposure(2) = 450;
mmhandle.SuperMDA.group.position(4).settings(3).exposure(2) = 225;
mmhandle.SuperMDA.group.position(5).settings(3).exposure(2) = 112;
mmhandle.SuperMDA.group.position(6).settings(3).exposure(2) = 66;
mmhandle.SuperMDA.group.position(7).settings(3).exposure(2) = 33;
mmhandle.SuperMDA.group.position(8).settings(3).exposure(2) = 16;
mmhandle.SuperMDA.group.position(9).settings(3).exposure(2) = 8;
mmhandle.SuperMDA.group.position(1).settings(3).exposure(3) = 100;
mmhandle.SuperMDA.group.position(2).settings(3).exposure(3) = 100;
mmhandle.SuperMDA.group.position(3).settings(3).exposure(3) = 100;
mmhandle.SuperMDA.group.position(4).settings(3).exposure(3) = 100;
mmhandle.SuperMDA.group.position(5).settings(3).exposure(3) = 100;
mmhandle.SuperMDA.group.position(6).settings(3).exposure(3) = 100;
mmhandle.SuperMDA.group.position(7).settings(3).exposure(3) = 100;
mmhandle.SuperMDA.group.position(8).settings(3).exposure(3) = 100;
mmhandle.SuperMDA.group.position(9).settings(3).exposure(3) = 100;
mmhandle.SuperMDA.group.position.change_all_settings('exposure_custom_bool',true);
%% Save the MDA
%
SuperMDA = mmhandle.SuperMDA;
save('killerRedMDA.mat','SuperMDA');
%% Run the MDA
%   
super_mda_acquisition_start(mmhandle);