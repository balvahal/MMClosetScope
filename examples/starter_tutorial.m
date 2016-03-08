%% Connecting to the Microscope
% Create a microscope object.
microscope = sda.microscope;
%% Snap an Image with the Microscope
%
microscope.snapImage;
%%% Display this image in a new figure.
% 
myfig = figure;
im = imagesc(microscope.I);
myaxes = im.Parent;
%%%
% By default, MATLAB is not aware that pixels in an image are *square*. The
% code that lies between this comment and the next are all about making an
% image display properly. Skip ahead unless you are really curious about
% the details of working with MATLAB figures.
myunits = get(0,'units');
set(0,'units','pixels');
Pix_SS = get(0,'screensize');
set(0,'units','characters');
Char_SS = get(0,'screensize');
ppChar = Pix_SS./Char_SS;
ppChar = ppChar([3,4]);
set(0,'units',myunits);
Isize = size(microscope.I);
image_height = Isize(1);
image_width = Isize(2);
screenpct = 0.6;
if image_width > image_height
    if image_width/image_height >= Pix_SS(3)/Pix_SS(4)
        fwidth = screenpct*Pix_SS(3);
        fheight = fwidth*image_height/image_width;
    else
        fheight = screenpct*Pix_SS(4);
        fwidth = fheight*image_width/image_height;
    end
else
    if image_height/image_width >= Pix_SS(4)/Pix_SS(3)
        fheight = screenpct*Pix_SS(4);
        fwidth = fheight*image_width/image_height;
    else
        fwidth = screenpct*Pix_SS(3);
        fheight = fwidth*image_height/image_width;
    end
end
fwidth = fwidth/ppChar(1);
fheight = fheight/ppChar(2);
myfig.Units = 'characters';
myfig.Position = [(Char_SS(3)-fwidth)/2 (Char_SS(4)-fheight)/2 fwidth fheight];
myfig.Name = 'Starter Tutorial: snap an image';
myaxes.Units = 'characters';
myaxes.Position = [0 0 fwidth fheight];
myaxes.YDir = 'reverse';
myaxes.XLim = [0.5,image_width+0.5];
myaxes.YLim = [0.5,image_height+0.5];
%% Create an itinerary
%
itinerary = sda.itinerary(microscope);
%% The travelagent
% Scripting together an itinerary can be cumbersome for traditional
% multi-dimensional acquisitions. For these cases the travelagent, a gui
% that manipulates an itinerary, is recommended.
%
% Note that the settings in the first position of each group are the only
% settings represented in the table. This is by design. Any changes made to
% the settings table will affect all positions within the selected group.
% To customize the settings at a paticular position either create a new
% group or use scripting after using the travelagent. The travelagent will
% overwrite existing customization.
travelagent = sda.travelagent(microscope,itinerary);
%% Scripting with the sda
% When the itinerary is created there is by default 1 group, 1 position,
% and 1 settings. When new groups, positions, and settings are created
% these defaults are used as a template.
%
% When a new position is created with the input of the microscope object,
% then the current location of the microscope will be used
itinerary.newPosition(microscope);
itinerary.newPosition(microscope);
itinerary.newPosition(microscope);
itinerary.newSettings;
%%
% Verify the existence of the new positions in the _position_logical_ and
% _settings_logical_ properties.
fprintf('Number of positions %d\n', sum(itinerary.position_logical));
fprintf('Number of settings %d\n', sum(itinerary.settings_logical));
%%%
% In the group-position-settings hierarchy of the sda requires each layer
% to be connected to each other to be valid. For example, a group with no
% positions is invalid. Creating a group, position, or settings does not
% define their relationship within the hierarchy. This relationship is
% defined by the _connectGPS_ method. The numerical label for each group,
% position, or settings is their row number in the group, position, or
% settings property arrays. Enter the connection between the GPS hierarchy
% as follows:
itinerary.connectGPS('g',1,'p',2,'s',1);
itinerary.connectGPS('g',1,'p',3,'s',2);
itinerary.connectGPS('g',1,'p',4,'s',[1,2]);
%%%
% Position 4 will have two settings. To confirm this is true look at
% _ind_settings_ cell array in the 4th column.
fprintf('Position 4 contains settings %d\n',itinerary.ind_settings{4});
%%%
% The settings property _settings_channel_ must be contained within the
% _channel_names_ property. The _settings_channel_ property is an array of
% integers representing the rows within the _channel_names_ cell. To change
% the channel of a settings try the following:
itinerary.settings_channel(2) = 2;
%% Set duration and interval of acquisition
% If the duration is not an integer multiple of the fundamental period,
% which is the interval of acquisition, then the remainder time is ignored.
itinerary.newFundamentalPeriod(30);
itinerary.newDuration(75);
fprintf('The duration of the acquisition is %d seconds,\nand there are %d timepoints\n',itinerary.duration,itinerary.number_of_timepoints);
%%%
% If you only want to image a particular settings at specific timepoints,
% specify this in the _settings_timepoints_ logical array. For example, to
% only image settings 2 on the second timepoint do the following:
itinerary.settings_timepoints(2,:) = zeros(size(itinerary.settings_timepoints(2,:)));
itinerary.settings_timepoints(2,2) = 1;
%% Validating an Itinerary
% Configuring an itinerary through scripting can be challenging, because of
% the rules that the groups, positions, and settings must comply to.
% Before, running an acquisition with the sda it is advised to run the
% method that validates and cleans up the itinerary.
itinerary.organizeByOrder;
%% Running an acquisition
%
pilot = sda.pilot(microscope,itinerary);