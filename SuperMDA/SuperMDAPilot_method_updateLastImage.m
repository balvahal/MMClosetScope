function [smdaP] = SuperMDAPilot_method_updateLastImage(smdaP)
I = uint8(bitshift(smdaP.mm.I, -8)); %assumes 16-bit depth
Isize = size(I);
Iheight = Isize(1);
Iwidth = Isize(2);
handles = guidata(smdaP.gui_lastImage);
set(handles.axesLastImage,'XLim',[1,Iwidth]);
set(handles.axesLastImage,'YLim',[1,Iheight]);
I2 = reshape(I,[],1);
I2 = sort(I2);
I = (I-I2(round(0.1*length(I2))))*(255/I2(round(0.99*length(I2))));
set(handles.I,'CData',I);

%% Create an informative title
%
t = smdaP.t; %time
i = smdaP.gps_current(1); %group
j = smdaP.gps_current(2); %position
k = smdaP.gps_current(3); %settings
channelName = smdaP.mm.Channel{smdaP.itinerary.settings_channel(k)};
mytitle = sprintf('Channel: %s, Timepoint: %d',channelName,t);
set(smdaP.gui_lastImage,'Name',mytitle);