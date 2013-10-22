mmhandle = Core_startup_initialize;
mmhandle.SuperMDA = SuperMDALevel1Primary(mmhandle);
%% Primary Level Settings
% set the imaging period to be 10 minutes
mmhandle.SuperMDA.fundamental_period = 600;
% set the duration to be 16 hours or 57600 seconds
mmhandle.SuperMDA.duration = 57600;
% set the output directory to be...
mmhandle.SuperMDA.output_directory = 'D:\Kyle\killerredtest';
%% Group Level Settings
% set the label to something informative
mmhandle.SuperMDA.group.label = 'killer_red_test1';
%% Settings Level
%
mmhandle.SuperMDA.group.position.settings(2) = mmhandle.mmhandle.SuperMDA.group.position.settings(1);
mmhandle.SuperMDA.group.position.settings(2).Channel = 7;
mmhandle.SuperMDA.group.position.settings(3) = mmhandle.mmhandle.SuperMDA.group.position.settings(1);
mmhandle.SuperMDA.group.position.settings(3).Channel = 6;
mmhandle.SuperMDA.group.position.settings(3).calculate_timepoints;
mmhandle.SuperMDA.group.position.settings(3).timepoints = zeros(size(timepoints));
mmhandle.SuperMDA.group.position.settings(3).timepoints(1:3) = 1;
mmhandle.SuperMDA.group.position.settings(3).timepoints_custom_bool = true;
%% Pause here to choose your positions
%

%% There will be 9 positions and each position will have a different exposure
%

%% Run the MDA
%

