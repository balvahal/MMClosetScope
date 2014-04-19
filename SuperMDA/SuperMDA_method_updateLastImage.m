function [obj] = SuperMDA_method_updateLastImage(obj)
I = uint8(bitshift(obj.mm.I, -4)); %assumes 12-bit depth
Isize = size(I);
Iheight = Isize(1);
Iwidth = Isize(2);
handles = guidata(obj.gui_lastImage);
set(handles.axesLastImage,'XLim',[1,Iwidth]);
set(handles.axesLastImage,'YLim',[1,Iheight]);
I2 = reshape(I,[],1);
I2 = sort(I2);
I = (I-I2(round(0.1*length(I2))))*(255/I2(round(0.99*length(I2))));
set(handles.I,'CData',I);

%% Create an informative title
%
t = obj.runtime_index(1); %time
i = obj.runtime_index(2); %group
j = obj.runtime_index(3); %position
k = obj.runtime_index(4); %settings
channelName = obj.mm.Channel{obj.itinerary.group(i).position(j).settings(k).channel};
mytitle = sprintf('Channel: %s, Timepoint: %d',channelName,t);
set(obj.gui_lastImage,'Name',mytitle);