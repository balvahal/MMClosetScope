%% SuperMDA_gui_main2
% a simple gui to pause, stop, and resume a running MDA
function [f] = SuperMDA_gui_main2(smdaTA)
%% Create the figure
%
myunits = get(0,'units');
set(0,'units','pixels');
Pix_SS = get(0,'screensize');
set(0,'units','characters');
Char_SS = get(0,'screensize');
ppChar = Pix_SS./Char_SS;
set(0,'units',myunits);
fwidth = 136.6; %683/ppChar(3);
fheight = 70; %910/ppChar(4);
fx = Char_SS(3) - (Char_SS(3)*.1 + fwidth);
fy = Char_SS(4) - (Char_SS(4)*.1 + fheight);
f = figure('Visible','off','Units','characters','MenuBar','none','Position',[fx fy fwidth fheight],...
    'CloseRequestFcn',{@fDeleteFcn},'Name','Main');

textBackgroundColorRegion1 = [176 224 230]/255; %PowderBlue
buttonBackgroundColorRegion1 = [135 206 235]/255; %SkyBlue
textBackgroundColorRegion2 = [144 238 144]/255; %LightGreen
buttonBackgroundColorRegion2 = [50 205  50]/255; %LimeGreen
textBackgroundColorRegion3 = [255 250 205]/255; %LemonChiffon
buttonBackgroundColorRegion3 = [255 215 0]/255; %Gold
textBackgroundColorRegion4 = [255 192 203]/255; %Pink
buttonBackgroundColorRegion4 = [255 160 122]/255; %Salmon
buttonSize = [20 3.0769]; %[100/ppChar(3) 40/ppChar(4)];
region1 = [0 56.1538]; %[0 730/ppChar(4)]; %180 pixels
region2 = [0 42.3077]; %[0 550/ppChar(4)]; %180 pixels
region3 = [0 13.8462]; %[0 180/ppChar(4)]; %370 pixels
region4 = [0 0]; %180 pixels

%% Assemble Region 1
%
%% Time Info
%
hpopupmenuUnitsOfTime = uicontrol('Style','popupmenu','Units','characters',...
    'FontSize',14,'FontName','Verdana',...
    'String',{'seconds','minutes','hours','days'},...
    'Position',[region1(1)+2, region1(2)+0.7692, buttonSize(1),buttonSize(2)],...
    'Callback',{@popupmenuUnitsOfTime_Callback});

uicontrol('Style','text','Units','characters','String','Units of Time',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
    'Position',[region1(1)+2, region1(2)+4.2308, buttonSize(1),1.5385]);

heditFundamentalPeriod = uicontrol('Style','edit','Units','characters',...
    'FontSize',14,'FontName','Verdana',...
    'String',num2str(smdaTA.itinerary.fundamental_period),...
    'Position',[region1(1)+2, region1(2)+6.5385, buttonSize(1),buttonSize(2)],...
    'Callback',{@editFundamentalPeriod_Callback});

uicontrol('Style','text','Units','characters','String','Fundamental Period',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
    'Position',[region1(1)+2, region1(2)+10, buttonSize(1),2.6923]);

heditDuration = uicontrol('Style','edit','Units','characters',...
    'FontSize',14,'FontName','Verdana',...
    'String',num2str(smdaTA.itinerary.duration),...
    'Position',[region1(1)+24, region1(2)+0.7692, buttonSize(1),buttonSize(2)],...
    'Callback',{@editDuration_Callback});

uicontrol('Style','text','Units','characters','String','Duration',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
    'Position',[region1(1)+24, region1(2)+4.2308, buttonSize(1),1.5385]);

heditNumberOfTimepoints = uicontrol('Style','edit','Units','characters',...
    'FontSize',14,'FontName','Verdana',...
    'String',num2str(smdaTA.itinerary.number_of_timepoints),...
    'Position',[region1(1)+24, region1(2)+6.5385, buttonSize(1),buttonSize(2)],...
    'Callback',{@editNumberOfTimepoints_Callback});

uicontrol('Style','text','Units','characters','String','Number of Timepoints',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
    'Position',[region1(1)+24, region1(2)+10, buttonSize(1),2.6923]);
%% Output directory
%
heditOutputDirectory = uicontrol('Style','edit','Units','characters',...
    'FontSize',12,'FontName','Verdana','HorizontalAlignment','left',...
    'String',num2str(smdaTA.itinerary.output_directory),...
    'Position',[region1(1)+46, region1(2)+0.7692, buttonSize(1)*3.5,buttonSize(2)],...
    'Callback',{@editOutputDirectory_Callback});

uicontrol('Style','text','Units','characters','String','Output Directory',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
    'Position',[region1(1)+46, region1(2)+4.2308, buttonSize(1)*3.5,1.5385]);

hpushbuttonOutputDirectory = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',20,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion1,...
    'String','...',...
    'Position',[region1(1)+48+buttonSize(1)*3.5, region1(2)+0.7692, buttonSize(1)*.5,buttonSize(2)],...
    'Callback',{@pushbuttonOutputDirectory_Callback});
%% Save or load current SuperMDAItinerary
%
hpushbuttonSave = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion1,...
    'String','Save',...
    'Position',[region1(1)+46, region1(2)+6.5385, buttonSize(1),buttonSize(2)],...
    'Callback',{@pushbuttonSave_Callback});

uicontrol('Style','text','Units','characters','String','Save an Itinerary',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
    'Position',[region1(1)+46, region1(2)+10, buttonSize(1),2.6923]);

hpushbuttonLoad = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion1,...
    'String','Load',...
    'Position',[region1(1)+68, region1(2)+6.5385, buttonSize(1),buttonSize(2)],...
    'Callback',{@pushbuttonLoad_Callback});

uicontrol('Style','text','Units','characters','String','Load an Itinerary',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
    'Position',[region1(1)+68, region1(2)+10, buttonSize(1),2.6923]);
%% Assemble Region 2
%
%% The group table
%
htableGroup = uitable('Units','characters',...
    'BackgroundColor',[textBackgroundColorRegion2;buttonBackgroundColorRegion2],...
    'ColumnName',{'label','group #','# of positions','function before','function after'},...
    'ColumnEditable',logical([1,0,0,0,0]),...
    'ColumnFormat',{'char','numeric','numeric','char','char'},...
    'ColumnWidth',{30*ppChar(3) 'auto' 'auto' 30*ppChar(3) 30*ppChar(3)},...
    'FontSize',8,'FontName','Verdana',...
    'CellEditCallback',@tableGroup_CellEditCallback,...
    'CellSelectionCallback',@tableGroup_CellSelectionCallback,...
    'Position',[region2(1)+2, region2(2)+0.7692, 91.6, 13.0769]);
%% add or drop a group
%
hpushbuttonGroupAdd = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion2,...
    'String','Add',...
    'Position',[fwidth - 4 - buttonSize(1)*1.25, region2(2)+7.6923, buttonSize(1)*.75,buttonSize(2)],...
    'Callback',{@pushbuttonGroupAdd_Callback});

uicontrol('Style','text','Units','characters','String','Add a group',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion2,...
    'Position',[fwidth - 4 - buttonSize(1)*1.25, region2(2)+11.1538, buttonSize(1)*.75,2.6923]);

hpushbuttonGroupDrop = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion2,...
    'String','Drop',...
    'Position',[fwidth - 4 - buttonSize(1)*1.25, region2(2)+0.7692, buttonSize(1)*.75,buttonSize(2)],...
    'Callback',{@pushbuttonGroupDrop_Callback});

uicontrol('Style','text','Units','characters','String','Drop a group',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion2,...
    'Position',[fwidth - 4 - buttonSize(1)*1.25, region2(2)+4.2308, buttonSize(1)*.75,2.6923]);
%% change group functions
%
uicontrol('Style','text','Units','characters','String',sprintf('Group\nFunction\nBefore'),...
    'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion2,...
    'Position',[fwidth - 2 - buttonSize(1)*0.5, region2(2)+4.2308, buttonSize(1)*0.5,2.6923]);

hpushbuttonGroupFunctionBefore = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',20,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion2,...
    'String','...',...
    'Position',[fwidth - 2 - buttonSize(1)*0.5, region2(2)+0.7692, buttonSize(1)*.5,buttonSize(2)],...
    'Callback',{@pushbuttonGroupFunctionBefore_Callback});

uicontrol('Style','text','Units','characters','String',sprintf('Group\nFunction\nAfter'),...
    'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion2,...
    'Position',[fwidth - 2 - buttonSize(1)*0.5, region2(2)+11.1538, buttonSize(1)*0.5,2.6923]);

hpushbuttonGroupFunctionAfter = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',20,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion2,...
    'String','...',...
    'Position',[fwidth - 2 - buttonSize(1)*0.5, region2(2)+7.6923, buttonSize(1)*.5,buttonSize(2)],...
    'Callback',{@pushbuttonGroupFunctionAfter_Callback});
%% Change group order
%
uicontrol('Style','text','Units','characters','String',sprintf('Move\nGroup\nDown'),...
    'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion2,...
    'Position',[fwidth - 6 - buttonSize(1)*1.75, region2(2)+4.2308, buttonSize(1)*0.5,2.6923]);

hpushbuttonGroupDown = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion2,...
    'String','Dn',...
    'Position',[fwidth - 6 - buttonSize(1)*1.75, region2(2)+0.7692, buttonSize(1)*.5,buttonSize(2)],...
    'Callback',{@pushbuttonGroupDown_Callback});

uicontrol('Style','text','Units','characters','String',sprintf('Move\nGroup\nUp'),...
    'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion2,...
    'Position',[fwidth - 6 - buttonSize(1)*1.75, region2(2)+11.1538, buttonSize(1)*0.5,2.6923]);

hpushbuttonGroupUp = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion2,...
    'String','Up',...
    'Position',[fwidth - 6 - buttonSize(1)*1.75, region2(2)+7.6923, buttonSize(1)*.5,buttonSize(2)],...
    'Callback',{@pushbuttonGroupUp_Callback});
%% Assemble Region 3
%
%% The position table
%
htablePosition = uitable('Units','characters',...
    'BackgroundColor',[textBackgroundColorRegion3;buttonBackgroundColorRegion3],...
    'ColumnName',{'label','position #','X','Y','Z','PFS','PFS offset','function before','function after','# of settings'},...
    'ColumnEditable',logical([1,0,1,1,1,1,1,0,0,0]),...
    'ColumnFormat',{'char','numeric','numeric','numeric','numeric',{'yes','no'},'numeric','char','char','numeric'},...
    'ColumnWidth',{30*ppChar(3) 'auto' 'auto' 'auto' 'auto' 'auto' 'auto' 30*ppChar(3) 30*ppChar(3) 'auto'},...
    'FontSize',8,'FontName','Verdana',...
    'CellEditCallback',@tablePosition_CellEditCallback,...
    'CellSelectionCallback',@tablePosition_CellSelectionCallback,...
    'Position',[region3(1)+2, region3(2)+0.7692, 91.6, 28.1538]);
%% add or drop positions
%
hpushbuttonPositionAdd = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
    'String','Add',...
    'Position',[fwidth - 4 - buttonSize(1)*1.25, region3(2)+14.0769+7.6923, buttonSize(1)*.75,buttonSize(2)],...
    'Callback',{@pushbuttonPositionAdd_Callback});

uicontrol('Style','text','Units','characters','String','Add a position',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
    'Position',[fwidth - 4 - buttonSize(1)*1.25, region3(2)+14.0769+11.1538, buttonSize(1)*.75,2.6923]);

hpushbuttonPositionDrop = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
    'String','Drop',...
    'Position',[fwidth - 4 - buttonSize(1)*1.25, region3(2)+14.0769+0.7692, buttonSize(1)*.75,buttonSize(2)],...
    'Callback',{@pushbuttonPositionDrop_Callback});

uicontrol('Style','text','Units','characters','String','Drop a position',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
    'Position',[fwidth - 4 - buttonSize(1)*1.25, region3(2)+14.0769+4.2308, buttonSize(1)*.75,2.6923]);
%% change position order
%
uicontrol('Style','text','Units','characters','String',sprintf('Move\nPosition\nDown'),...
    'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
    'Position',[fwidth - 6 - buttonSize(1)*1.75, region3(2)+14.0769+4.2308, buttonSize(1)*0.5,2.6923]);

hpushbuttonPositionDown = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
    'String','Dn',...
    'Position',[fwidth - 6 - buttonSize(1)*1.75, region3(2)+14.0769+0.7692, buttonSize(1)*.5,buttonSize(2)],...
    'Callback',{@pushbuttonPositionDown_Callback});

uicontrol('Style','text','Units','characters','String',sprintf('Move\nPosition\nUp'),...
    'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
    'Position',[fwidth - 6 - buttonSize(1)*1.75, region3(2)+14.0769+11.1538, buttonSize(1)*0.5,2.6923]);

hpushbuttonPositionUp = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
    'String','Up',...
    'Position',[fwidth - 6 - buttonSize(1)*1.75, region3(2)+14.0769+7.6923, buttonSize(1)*.5,buttonSize(2)],...
    'Callback',{@pushbuttonPositionUp_Callback});
%% move to a position
%
hpushbuttonPositionMove = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
    'String','Move',...
    'Position',[fwidth - 6 - buttonSize(1)*1.75, region3(2)+7.6923, buttonSize(1),buttonSize(2)],...
    'Callback',{@pushbuttonPositionMove_Callback});

uicontrol('Style','text','Units','characters','String',sprintf('Move the stage\nto the\nselected position'),...
    'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
    'Position',[fwidth - 6 - buttonSize(1)*1.75, region3(2)+11.1538, buttonSize(1),2.6923]);
%% change a position value to the current position
%
hpushbuttonPositionSet = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
    'String','Set',...
    'Position',[fwidth - 6 - buttonSize(1)*1.75, region3(2)+0.7692, buttonSize(1),buttonSize(2)],...
    'Callback',{@pushbuttonPositionSet_Callback});

uicontrol('Style','text','Units','characters','String',sprintf('Set the position\nto the current\nstage position'),...
    'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
    'Position',[fwidth - 6 - buttonSize(1)*1.75, region3(2)+4.2308, buttonSize(1),2.6923]);
%% add a grid
%
hpushbuttonPositionGrid = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
    'String',sprintf('GRID'),...
    'Position',[fwidth - 2 - buttonSize(1)*.75, region3(2)+7.6923, buttonSize(1)*.75,buttonSize(2)],...
    'Callback',{@pushbuttonPositionGrid_Callback});

uicontrol('Style','text','Units','characters','String',sprintf('Add a grid\nof positions'),...
    'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
    'Position',[fwidth - 2 - buttonSize(1)*.75, region3(2)+11.1538, buttonSize(1)*.75,2.6923]);
%% change position functions
%
uicontrol('Style','text','Units','characters','String',sprintf('Position\nFunction\nBefore'),...
    'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
    'Position',[fwidth - 2 - buttonSize(1)*0.5, region3(2)+14.0769+4.2308, buttonSize(1)*0.5,2.6923]);

hpushbuttonPositionFunctionBefore = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',20,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
    'String','...',...
    'Position',[fwidth - 2 - buttonSize(1)*0.5, region3(2)+14.0769+0.7692, buttonSize(1)*.5,buttonSize(2)],...
    'Callback',{@pushbuttonPositionFunctionBefore_Callback});

uicontrol('Style','text','Units','characters','String',sprintf('Position\nFunction\nAfter'),...
    'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
    'Position',[fwidth - 2 - buttonSize(1)*0.5, region3(2)+14.0769+11.1538, buttonSize(1)*0.5,2.6923]);

hpushbuttonPositionFunctionAfter = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',20,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
    'String','...',...
    'Position',[fwidth - 2 - buttonSize(1)*0.5, region3(2)+14.0769+7.6923, buttonSize(1)*.5,buttonSize(2)],...
    'Callback',{@pushbuttonPositionFunctionAfter_Callback});
%% Assemble Region 4
%
%% The settings table
%

htableSettings = uitable('Units','characters',...
    'BackgroundColor',[textBackgroundColorRegion4;buttonBackgroundColorRegion4],...
    'ColumnName',{'channel','exposure','binning','gain','Z step size','Z upper','Z lower','# of Z steps','Z offset','period mult.','function','settings #'},...
    'ColumnEditable',logical([1,1,1,1,1,1,1,0,1,1,0,0]),...
    'ColumnFormat',{transpose(smdaTA.mm.Channel),'numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','char','numeric'},...
    'ColumnWidth',{'auto' 'auto' 'auto' 'auto' 'auto' 'auto' 'auto' 'auto' 'auto' 'auto' 'auto' 'auto'},...
    'FontSize',8,'FontName','Verdana',...
    'CellEditCallback',@tableSettings_CellEditCallback,...
    'CellSelectionCallback',@tableSettings_CellSelectionCallback,...
    'Position',[region4(1)+2, region4(2)+0.7692, 79.6, 13.0769]);
%% add or drop a group
%
hpushbuttonSettingsAdd = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion4,...
    'String','Add',...
    'Position',[fwidth - 6 - buttonSize(1)*1.75, region4(2)+7.6923, buttonSize(1)*.75,buttonSize(2)],...
    'Callback',{@pushbuttonSettingsAdd_Callback});

uicontrol('Style','text','Units','characters','String','Add a settings',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion4,...
    'Position',[fwidth - 6 - buttonSize(1)*1.75, region4(2)+11.1538, buttonSize(1)*.75,2.6923]);

hpushbuttonSettingsDrop = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion4,...
    'String','Drop',...
    'Position',[fwidth - 6 - buttonSize(1)*1.75, region4(2)+0.7692, buttonSize(1)*.75,buttonSize(2)],...
    'Callback',{@pushbuttonSettingsDrop_Callback});

uicontrol('Style','text','Units','characters','String','Drop a settings',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion4,...
    'Position',[fwidth - 6 - buttonSize(1)*1.75, region4(2)+4.2308, buttonSize(1)*.75,2.6923]);
%% change Settings functions
%
uicontrol('Style','text','Units','characters','String',sprintf('Settings\nFunction'),...
    'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion4,...
    'Position',[fwidth - 2 - buttonSize(1)*0.5, region4(2)+11.1538, buttonSize(1)*0.5,2.6923]);

hpushbuttonSettingsFunction = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',20,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion4,...
    'String','...',...
    'Position',[fwidth - 2 - buttonSize(1)*0.5, region4(2)+7.6923, buttonSize(1)*.5,buttonSize(2)],...
    'Callback',{@pushbuttonSettingsFunction_Callback});
%% Change Settings order
%
uicontrol('Style','text','Units','characters','String',sprintf('Move\nSettings\nDown'),...
    'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion4,...
    'Position',[fwidth - 8 - buttonSize(1)*2.25, region4(2)+4.2308, buttonSize(1)*0.5,2.6923]);

hpushbuttonSettingsDown = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion4,...
    'String','Dn',...
    'Position',[fwidth - 8 - buttonSize(1)*2.25, region4(2)+0.7692, buttonSize(1)*.5,buttonSize(2)],...
    'Callback',{@pushbuttonSettingsDown_Callback});

uicontrol('Style','text','Units','characters','String',sprintf('Move\nSettings\nUp'),...
    'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion4,...
    'Position',[fwidth - 8 - buttonSize(1)*2.25, region4(2)+11.1538, buttonSize(1)*0.5,2.6923]);

hpushbuttonSettingsUp = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion4,...
    'String','Up',...
    'Position',[fwidth - 8 - buttonSize(1)*2.25, region4(2)+7.6923, buttonSize(1)*.5,buttonSize(2)],...
    'Callback',{@pushbuttonSettingsUp_Callback});
%% Set Z upper or Z lower boundaries
%
uicontrol('Style','text','Units','characters','String',sprintf('Set Z\nLower'),...
    'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion4,...
    'Position',[fwidth - 4 - buttonSize(1), region4(2)+4.2308, buttonSize(1)*0.5,2.6923]);

hpushbuttonSettingsZLower = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion4,...
    'String','Z-',...
    'Position',[fwidth - 4 - buttonSize(1), region4(2)+0.7692, buttonSize(1)*.5,buttonSize(2)],...
    'Callback',{@pushbuttonSettingsZLower_Callback});

uicontrol('Style','text','Units','characters','String',sprintf('Set Z\nUpper'),...
    'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion4,...
    'Position',[fwidth - 4 - buttonSize(1), region4(2)+11.1538, buttonSize(1)*0.5,2.6923]);

hpushbuttonSettingsZUpper = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion4,...
    'String','Z+',...
    'Position',[fwidth - 4 - buttonSize(1), region4(2)+7.6923, buttonSize(1)*.5,buttonSize(2)],...
    'Callback',{@pushbuttonSettingsZUpper_Callback});
%%
% store the uicontrol handles in the figure handles via guidata()
handles.popupmenuUnitsOfTime = hpopupmenuUnitsOfTime;
handles.editFundamentalPeriod = heditFundamentalPeriod;
handles.editDuration = heditDuration;
handles.editNumberOfTimepoints = heditNumberOfTimepoints;
handles.editOutputDirectory = heditOutputDirectory;
handles.pushbuttonOutputDirectory = hpushbuttonOutputDirectory;
handles.pushbuttonSave = hpushbuttonSave;
handles.pushbuttonLoad = hpushbuttonLoad;
handles.pushbuttonGroupAdd = hpushbuttonGroupAdd;
handles.pushbuttonGroupDrop = hpushbuttonGroupDrop;
handles.pushbuttonGroupFunctionBefore = hpushbuttonGroupFunctionBefore;
handles.pushbuttonGroupFunctionAfter = hpushbuttonGroupFunctionAfter;
handles.pushbuttonGroupDown = hpushbuttonGroupDown;
handles.pushbuttonGroupUp = hpushbuttonGroupUp;
handles.pushbuttonPositionAdd = hpushbuttonPositionAdd;
handles.pushbuttonPositionDown = hpushbuttonPositionDown;
handles.pushbuttonPositionDrop = hpushbuttonPositionDrop;
handles.pushbuttonPositionMove = hpushbuttonPositionMove;
handles.pushbuttonPositionSet = hpushbuttonPositionSet;
handles.pushbuttonPositionUp = hpushbuttonPositionUp;
handles.hpushbuttonSettingsDown = hpushbuttonSettingsDown;
handles.pushbuttonSettingsFunction = hpushbuttonSettingsFunction;
handles.pushbuttonSettingsUp = hpushbuttonSettingsUp;
handles.pushbuttonSettingsZUpper = hpushbuttonSettingsZUpper;
handles.pushbuttonSettingsZLower = hpushbuttonSettingsZLower;
handles.tableGroup = htableGroup;
handles.tablePosition = htablePosition;
handles.tableSettings = htableSettings;
guidata(f,handles);
%%
% make the gui visible
set(f,'Visible','on');

%% Callbacks
%
%%
%
    function fDeleteFcn(~,~)
        %do nothing. This means only the master object can close this
        %window.
    end

%%
%
    function editFundamentalPeriod_Callback(~,~)
        myValue = str2double(get(heditFundamentalPeriod,'String'))*smdaTA.uot_conversion;
        smdaTA.itinerary.newFundamentalPeriod(myValue);
        smdaTA.refresh_gui_main;
    end
%%
%
    function editDuration_Callback(~,~)
        myValue = str2double(get(heditDuration,'String'))*smdaTA.uot_conversion;
        smdaTA.itinerary.newDuration(myValue);
        smdaTA.refresh_gui_main;
    end
%%
%
    function editNumberOfTimepoints_Callback(~,~)
        myValue = str2double(get(heditNumberOfTimepoints,'String'));
        smdaTA.itinerary.newNumberOfTimepoints(myValue);
        smdaTA.refresh_gui_main;
    end

%%
%
    function editOutputDirectory_Callback(~,~)
        folder_name = get(heditOutputDirectory,'String');
        if exist(folder_name,'dir')
            smdaTA.itinerary.output_directory = folder_name;
        else
            str = sprintf('''%s'' is not a directory',folder_name);
            disp(str);
        end
        smdaTA.refresh_gui_main;
    end
%%
%
    function popupmenuUnitsOfTime_Callback(~,~)
        seconds2array = [1,60,3600,86400];
        smdaTA.uot_conversion = seconds2array(get(hpopupmenuUnitsOfTime,'Value'));
        smdaTA.refresh_gui_main;
    end
%%
%
    function pushbuttonGroupAdd_Callback(~,~)
        smdaTA.addGroup;
        smdaTA.pointerGroup = length(smdaTA.itinerary.group_order);
        smdaTA.refresh_gui_main;
    end

%%
%
    function pushbuttonGroupDown_Callback(~,~)
        %%
        % What follows below might have a more elegant solution.
        % essentially all selected rows are moved down 1.
        if max(smdaTA.pointerGroup) == length(smdaTA.itinerary.group_order)
            return
        end
        currentOrder = 1:length(smdaTA.itinerary.group_order); % what the table looks like now
        movingGroup = smdaTA.pointerGroup+1; % where the selected rows want to go
        reactingGroup = setdiff(currentOrder,smdaTA.pointerGroup); % the rows that are not moving
        fillmeinArray = zeros(1,length(currentOrder)); % a vector to store the new order
        fillmeinArray(movingGroup) = smdaTA.pointerGroup; % the selected rows are moved
        fillmeinArray(fillmeinArray==0) = reactingGroup; % the remaining rows are moved
        smdaTA.itinerary.group_order = smdaTA.itinerary.group_order(fillmeinArray); % this rearrangement is performed on the group_order
        smdaTA.pointerGroup = movingGroup;
        smdaTA.refresh_gui_main;
    end
%%
%
    function pushbuttonGroupDrop_Callback(~,~)
        if length(smdaTA.itinerary.group_order)==1
            return
        elseif length(smdaTA.pointerGroup) == length(smdaTA.itinerary.group_order)
            smdaTA.pointerGroup(1) = [];
        end
        smdaTA.dropGroup(smdaTA.pointerGroup);
        smdaTA.pointerGroup = length(smdaTA.itinerary.group_order);
        smdaTA.refresh_gui_main;
    end

%%
%
    function pushbuttonGroupFunctionAfter_Callback(~,~)
        
        smdaTA.refresh_gui_main;
    end
%%
%
    function pushbuttonGroupFunctionBefore_Callback(~,~)
        
        smdaTA.refresh_gui_main;
    end
%%
%
    function pushbuttonGroupUp_Callback(~,~)
        %%
        % What follows below might have a more elegant solution.
        % essentially all selected rows are moved up 1.
        if min(smdaTA.pointerGroup) == 1
            return
        end
        currentOrder = 1:length(smdaTA.itinerary.group_order); % what the table looks like now
        movingGroup = smdaTA.pointerGroup-1; % where the selected rows want to go
        reactingGroup = setdiff(currentOrder,smdaTA.pointerGroup); % the rows that are not moving
        fillmeinArray = zeros(1,length(currentOrder)); % a vector to store the new order
        fillmeinArray(movingGroup) = smdaTA.pointerGroup; % the selected rows are moved
        fillmeinArray(fillmeinArray==0) = reactingGroup; % the remaining rows are moved
        smdaTA.itinerary.group_order = smdaTA.itinerary.group_order(fillmeinArray); % this rearrangement is performed on the group_order
        smdaTA.pointerGroup = movingGroup;
        smdaTA.refresh_gui_main;
    end
%%
%
    function pushbuttonPositionAdd_Callback(~,~)
        gInd = smdaTA.itinerary.group_order(smdaTA.pointerGroup(1));
        smdaTA.addPosition(gInd);
        smdaTA.pointerPosition = length(smdaTA.itinerary.group(gInd).position_order);
        smdaTA.refresh_gui_main;
    end
%%
%
    function pushbuttonPositionDown_Callback(~,~)
        %%
        % What follows below might have a more elegant solution.
        % essentially all selected rows are moved down 1.
        gInd = smdaTA.itinerary.group_order(smdaTA.pointerGroup(1));
        if max(smdaTA.pointerPosition) == length(smdaTA.itinerary.group(gInd).position_order)
            return
        end
        currentOrder = 1:length(smdaTA.itinerary.group(gInd).position_order); % what the table looks like now
        movingPosition = smdaTA.pointerPosition+1; % where the selected rows want to go
        reactingPosition = setdiff(currentOrder,smdaTA.pointerPosition); % the rows that are not moving
        fillmeinArray = zeros(1,length(currentOrder)); % a vector to store the new order
        fillmeinArray(movingPosition) = smdaTA.pointerPosition; % the selected rows are moved
        fillmeinArray(fillmeinArray==0) = reactingPosition; % the remaining rows are moved
        smdaTA.itinerary.group(gInd).position_order = smdaTA.itinerary.group(gInd).position_order(fillmeinArray); % this rearrangement is performed on the group_order
        smdaTA.pointerPosition = movingPosition;
        smdaTA.refresh_gui_main;
    end
%%
%
    function pushbuttonPositionDrop_Callback(~,~)
        gInd = smdaTA.itinerary.group_order(smdaTA.pointerGroup(1));
        if length(smdaTA.itinerary.group(gInd).position_order)==1
            return
        elseif length(smdaTA.pointerPosition) == length(smdaTA.itinerary.group(gInd).position_order)
            smdaTA.pointerPosition(1) = [];
        end
        smdaTA.dropPosition(gInd,smdaTA.pointerPosition);
        smdaTA.pointerPosition = length(smdaTA.itinerary.group(gInd).position_order);
        smdaTA.refresh_gui_main;
    end
%%
%
    function pushbuttonPositionFunctionAfter_Callback(~,~)
        gInd = smdaTA.itinerary.group_order(smdaTA.pointerGroup(1));
        mypwd = pwd;
        cd(smdaTA.itinerary.output_directory);
        [filename,pathname] = uigetfile({'*.m'},'Choose the position-function-after');
        if exist(fullfile(pathname,filename),'file')
            smdaTA.itinerary.prototype_position.position_function_after_name = char(regexp(filename,'.*(?=\.m)','match'));
            smdaTA.changeAllPosition(gInd,'position_function_after_name');
        else
            disp('The position-function-after selection was invalid.');
        end
        cd(mypwd);
        smdaTA.refresh_gui_main;
    end
%%
%
    function pushbuttonPositionFunctionBefore_Callback(~,~)
        gInd = smdaTA.itinerary.group_order(smdaTA.pointerGroup(1));
        mypwd = pwd;
        cd(smdaTA.itinerary.output_directory);
        [filename,pathname] = uigetfile({'*.m'},'Choose the position-function-before');
        if exist(fullfile(pathname,filename),'file')
            smdaTA.itinerary.prototype_position.position_function_before_name = char(regexp(filename,'.*(?=\.m)','match'));
            smdaTA.changeAllPosition(gInd,'position_function_before_name');
        else
            disp('The position-function-before selection was invalid.');
        end
        cd(mypwd);
        smdaTA.refresh_gui_main;
    end
%%
%
    function pushbuttonPositionMove_Callback(~,~)
        gInd = smdaTA.itinerary.group_order(smdaTA.pointerGroup(1));
        pInd = smdaTA.itinerary.group(gInd).position_order(smdaTA.pointerPosition(1));
        xyz = smdaTA.itinerary.group(gInd).position(pInd).xyz(1,:);
        if smdaTA.itinerary.group(gInd).position(pInd).continuous_focus_bool
            %% PFS lock-on will be attempted
            %
            smdaTA.mm.setXYZ(xyz(1:2)); % setting the z through the focus device will disable the PFS. Therefore, the stage is moved in the XY direction before assessing the status of the PFS system.
            smdaTA.mm.core.waitForDevice(smdaTA.mm.xyStageDevice);
            if strcmp(smdaTA.mm.core.getProperty(smdaTA.mm.AutoFocusStatusDevice,'State'),'Off')
                %%
                % If the PFS is |OFF|, then the scope is moved to an
                % absolute z that will give the system the best chance of
                % locking onto the correct z.
                smdaTA.mm.setXYZ(xyz(3),'direction','z');
                smdaTA.mm.core.waitForDevice(smdaTA.mm.FocusDevice);
                smdaTA.mm.core.setProperty(smdaTA.mm.AutoFocusDevice,'Position',smdaTA.itinerary.group(gInd).position(pInd).continuous_focus_offset);
                smdaTA.mm.core.fullFocus(); % PFS will return to |OFF|
            else
                %%
                % If the PFS system is already on, then changing the offset
                % will adjust the z-position. fullFocus() will have the
                % system wait until the new z-position has been reached.
                smdaTA.mm.core.setProperty(smdaTA.mm.AutoFocusDevice,'Position',smdaTA.itinerary.group(gInd).position(pInd).continuous_focus_offset);
                smdaTA.mm.core.fullFocus(); % PFS will remain |ON|
            end
        else
            %% PFS will not be utilized
            %
            smdaTA.mm.setXYZ(xyz);
            smdaTA.mm.core.waitForDevice(smdaTA.mm.FocusDevice);
            smdaTA.mm.core.waitForDevice(smdaTA.mm.xyStageDevice);
        end
    end
%%
%
    function pushbuttonPositionSet_Callback(~,~)
        gInd = smdaTA.itinerary.group_order(smdaTA.pointerGroup(1));
        pInd = smdaTA.itinerary.group(gInd).position_order(smdaTA.pointerPosition(1));
        smdaTA.mm.getXYZ;
        smdaTA.itinerary.group(gInd).position(pInd).xyz = ones(smdaTA.itinerary.number_of_timepoints,3);
        smdaTA.itinerary.group(gInd).position(pInd).xyz(:,1) = smdaTA.mm.pos(1);
        smdaTA.itinerary.group(gInd).position(pInd).xyz(:,2) = smdaTA.mm.pos(2);
        smdaTA.itinerary.group(gInd).position(pInd).xyz(:,3) = smdaTA.mm.pos(3);
        smdaTA.itinerary.group(gInd).position(pInd).continuous_focus_offset = str2double(smdaTA.mm.core.getProperty(smdaTA.mm.AutoFocusDevice,'Position'));
        smdaTA.refresh_gui_main;
    end
%%
%
    function pushbuttonPositionUp_Callback(~,~)
        %%
        % What follows below might have a more elegant solution.
        % essentially all selected rows are moved up 1.
        gInd = smdaTA.itinerary.group_order(smdaTA.pointerGroup(1));
        if min(smdaTA.pointerPosition) == 1
            return
        end
        currentOrder = 1:length(smdaTA.itinerary.group(gInd).position_order); % what the table looks like now
        movingPosition = smdaTA.pointerPosition-1; % where the selected rows want to go
        reactingPosition = setdiff(currentOrder,smdaTA.pointerPosition); % the rows that are not moving
        fillmeinArray = zeros(1,length(currentOrder)); % a vector to store the new order
        fillmeinArray(movingPosition) = smdaTA.pointerPosition; % the selected rows are moved
        fillmeinArray(fillmeinArray==0) = reactingPosition; % the remaining rows are moved
        smdaTA.itinerary.group(gInd).position_order = smdaTA.itinerary.group(gInd).position_order(fillmeinArray); % this rearrangement is performed on the group_order
        smdaTA.pointerPosition = movingPosition;
        smdaTA.refresh_gui_main;
    end
%%
%
    function pushbuttonLoad_Callback(~,~)
        uiwait(warndlg('The current SuperMDA will be erased!','Load a SuperMDA','modal'));
        mypwd = pwd;
        cd(smdaTA.itinerary.output_directory);
        [filename,pathname] = uigetfile({'*.mat'},'Load a SuperMDAItinerary');
        cd(mypwd);
        if exist(fullfile(pathname,filename),'file')
            load(fullfile(pathname,filename),'myitinerary');
            if isa(myitinerary,'SuperMDAItinerary')
                smdaTA.itinerary = myitinerary;
                smdaTA.itinerary.mm = smdaTA.mm;
                disp('import successful');
            else
                disp('a valid SuperMDAItinerary object was not found');
            end
        else
            disp('The SuperMDAItinerary file selected was invalid.');
        end
        smdaTA.refresh_gui_main;
    end
%%
%
    function pushbuttonOutputDirectory_Callback(~,~)
        folder_name = uigetdir;
        if folder_name==0
            return
        elseif exist(folder_name,'dir')
            smdaTA.itinerary.output_directory = folder_name;
        else
            str = sprintf('''%s'' is not a directory',folder_name);
            disp(str);
        end
        smdaTA.refresh_gui_main;
    end
%%
%
    function pushbuttonSave_Callback(~,~)
        myitinerary = smdaTA.itinerary;
        myitinerary.mm = [];
        warning('off','all');
        save(fullfile(myitinerary.output_directory,'mySuperMDAItinerary.mat'),'myitinerary');
        warning('on','all');
    end
%%
%
    function pushbuttonSettingsAdd_Callback(~,~)
        smdaTA.itinerary.prototype_settings(end+1) = smdaTA.itinerary.prototype_settings(end);
        smdaTA.itinerary.prototype_position.settings_order(end+1) =  length(smdaTA.itinerary.prototype_settings);
        smdaTA.pointerSettings= length(smdaTA.itinerary.prototype_settings);
        smdaTA.refresh_gui_main;
    end
%%
%
    function pushbuttonSettingsDown_Callback(~,~)
        %%
        % What follows below might have a more elegant solution.
        % essentially all selected rows are moved down 1.
        if max(smdaTA.pointerSettings) == length(smdaTA.itinerary.prototype_position.settings_order)
            return
        end
        currentOrder = 1:length(smdaTA.itinerary.prototype_position.settings_order); % what the table looks like now
        movingSettings = smdaTA.pointerSettings+1; % where the selected rows want to go
        reactingSettings = setdiff(currentOrder,smdaTA.pointerSettings); % the rows that are not moving
        fillmeinArray = zeros(1,length(currentOrder)); % a vector to store the new order
        fillmeinArray(movingSettings) = smdaTA.pointerSettings; % the selected rows are moved
        fillmeinArray(fillmeinArray==0) = reactingSettings; % the remaining rows are moved
        smdaTA.itinerary.prototype_position.settings_order = smdaTA.itinerary.prototype_position.settings_order(fillmeinArray); % this rearrangement is performed on the group_order
        smdaTA.pointerSettings = movingSettings;
        smdaTA.refresh_gui_main;
    end
%%
%
    function pushbuttonSettingsDrop_Callback(~,~)
        if length(smdaTA.itinerary.prototype_settings)==1
            return
        elseif length(smdaTA.pointerSettings) == length(smdaTA.itinerary.prototype_settings)
            smdaTA.pointerSettings(1) = [];
        end
        smdaTA.itinerary.prototype_settings(smdaTA.pointerSettings) = [];
        smdaTA.itinerary.prototype_position.settings_order(smdaTA.pointerSettings) = [];
        smdaTA.pointerSettings = length(smdaTA.itinerary.prototype_settings);
        %%
        % Next, edit the group_order so that the numbers within are
        % sequential (although not necessarily in order).
        newNum = transpose(1:length(smdaTA.itinerary.prototype_position.settings_order));
        oldNum = transpose(smdaTA.itinerary.prototype_position.settings_order);
        funArray = [oldNum,newNum];
        funArray = sortrows(funArray,1);
        smdaTA.itinerary.prototype_position.settings_order = transpose(funArray(:,2)); % the group_order must remain a row so that it can be properly looped over.
        smdaTA.refresh_gui_main;
    end
%%
%
    function pushbuttonSettingsFunction_Callback(~,~)
        mypwd = pwd;
        cd(smdaTA.itinerary.output_directory);
        [filename,pathname] = uigetfile({'*.m'},'Choose the settings-function');
        if exist(fullfile(pathname,filename),'file')
            smdaTA.itinerary.prototype_settings.settings_function_name = char(regexp(filename,'.*(?=\.m)','match'));
        else
            disp('The settings-function selection was invalid.');
        end
        cd(mypwd);
        smdaTA.refresh_gui_main;
    end
%%
%
    function pushbuttonSettingsUp_Callback(~,~)
        %%
        % What follows below might have a more elegant solution.
        % essentially all selected rows are moved up 1.
        if min(smdaTA.pointerSettings) == 1
            return
        end
        currentOrder = 1:length(smdaTA.itinerary.prototype_position.settings_order); % what the table looks like now
        movingSettings = smdaTA.pointerSettings-1; % where the selected rows want to go
        reactingSettings = setdiff(currentOrder,smdaTA.pointerSettings); % the rows that are not moving
        fillmeinArray = zeros(1,length(currentOrder)); % a vector to store the new order
        fillmeinArray(movingSettings) = smdaTA.pointerSettings; % the selected rows are moved
        fillmeinArray(fillmeinArray==0) = reactingSettings; % the remaining rows are moved
        smdaTA.itinerary.prototype_position.settings_order = smdaTA.itinerary.prototype_position.settings_order(fillmeinArray); % this rearrangement is performed on the group_order
        smdaTA.pointerGroup = movingSettings;
        smdaTA.refresh_gui_main;
    end
%%
%
    function pushbuttonSettingsZLower_Callback(~,~)
        gInd = smdaTA.pointerGroup(1);
        pInd = smdaTA.pointerPosition(1);
        smdaTA.mm.getXYZ;
        xyz = smdaTA.mm.pos;
        offset = smdaTA.itinerary.group(gInd).position(pInd).xyz(1,3)-xyz(3);
        if offset <0
            smdaTA.itinerary.prototype_settings(smdaTA.pointerSettings).z_stack_lower_offset = 0;
        else
            smdaTA.itinerary.prototype_settings(smdaTA.pointerSettings).z_stack_lower_offset = -offset;
        end
        smdaTA.refresh_gui_main;
    end
%%
%
    function pushbuttonSettingsZUpper_Callback(~,~)
        gInd = smdaTA.pointerGroup(1);
        pInd = smdaTA.pointerPosition(1);
        smdaTA.mm.getXYZ;
        xyz = smdaTA.mm.pos;
        offset = xyz(3)-smdaTA.itinerary.group(gInd).position(pInd).xyz(1,3);
        if offset <0
            smdaTA.itinerary.prototype_settings(smdaTA.pointerSettings).z_stack_upper_offset = 0;
        else
            smdaTA.itinerary.prototype_settings(smdaTA.pointerSettings).z_stack_upper_offset = offset;
        end
        smdaTA.refresh_gui_main;
    end
%%
%
    function tableGroup_CellEditCallback(~, eventdata)
        %%
        % |smdaTA.pointerGroup| should always be a singleton in this case
        myCol = eventdata.Indices(2);
        myRow = smdaTA.itinerary.group_order(eventdata.Indices(1));
        switch myCol
            case 1 %label change
                if isempty(eventdata.NewData) || any(regexp(eventdata.NewData,'\W'))
                    return
                else
                    smdaTA.itinerary.group(myRow).label = eventdata.NewData;
                end
        end
        smdaTA.refresh_gui_main;
    end
%%
%
    function tableGroup_CellSelectionCallback(~, eventdata)
        %%
        % The main purpose of this function is to keep the information
        % displayed in the table consistent with the Itinerary object.
        % Changes to the object either through the command line or the gui
        % can affect the information that is displayed in the gui and this
        % function will keep the gui information consistent with the
        % Itinerary information.
        %
        % The pointer of the TravelAgent should always point to a valid
        % group from the the group_order.
        if isempty(eventdata.Indices)
            % if nothing is selected, which triggers after deleting data,
            % make sure the pointer is still valid
            if any(smdaTA.pointerGroup > length(smdaTA.itinerary.group_order))
                % move pointer to last entry
                smdaTA.pointerGroup = length(smdaTA.itinerary.group_order);
            end
            return
        else
            smdaTA.pointerGroup = sort(unique(eventdata.Indices(:,1)));
        end
        smdaTA.refresh_gui_main;
    end
%%
%
    function tablePosition_CellEditCallback(~, eventdata)
        %%
        % |smdaTA.pointerPosition| should always be a singleton in this
        % case
        gInd = smdaTA.itinerary.group_order(smdaTA.pointerGroup(1));
        myCol = eventdata.Indices(2);
        myRow = smdaTA.itinerary.group(gInd).position_order(eventdata.Indices(1));
        switch myCol
            case 1 %label change
                if isempty(eventdata.NewData) || any(regexp(eventdata.NewData,'\W'))
                    return
                else
                    smdaTA.itinerary.group(gInd).position(myRow).label = eventdata.NewData;
                end
            case 3 %X
                smdaTA.itinerary.group(gInd).position(myRow).xyz(:,1) = eventdata.NewData;
            case 4 %Y
                smdaTA.itinerary.group(gInd).position(myRow).xyz(:,2) = eventdata.NewData;
            case 5 %Z
                smdaTA.itinerary.group(gInd).position(myRow).xyz(:,3) = eventdata.NewData;
            case 6 %PFS
                if strcmp(eventdata.NewData,'yes')
                    smdaTA.itinerary.group(gInd).position(myRow).continuous_focus_bool = true;
                    smdaTA.itinerary.prototype_position.continuous_focus_bool = true;
                else
                    smdaTA.itinerary.group(gInd).position(myRow).continuous_focus_bool = false;
                    smdaTA.itinerary.prototype_position.continuous_focus_bool = false;
                end
                smdaTA.changeAllPosition(gInd,'continuous_focus_bool');
            case 7 %PFS offset
                smdaTA.itinerary.group(gInd).position(myRow).continuous_focus_offset = eventdata.NewData;
                smdaTA.itinerary.prototype_position.continuous_focus_offset = eventdata.NewData;
        end
        smdaTA.refresh_gui_main;
    end
%%
%
    function tablePosition_CellSelectionCallback(~, eventdata)
        %%
        % The main purpose of this function is to keep the information
        % displayed in the table consistent with the Itinerary object.
        % Changes to the object either through the command line or the gui
        % can affect the information that is displayed in the gui and this
        % function will keep the gui information consistent with the
        % Itinerary information.
        %
        % The pointer of the TravelAgent should always point to a valid
        % position from the the position_order in a given group.
        gInd = smdaTA.itinerary.group_order(smdaTA.pointerGroup(1));
        if isempty(eventdata.Indices)
            % if nothing is selected, which triggers after deleting data,
            % make sure the pointer is still valid
            if any(smdaTA.pointerPosition > length(smdaTA.itinerary.group(gInd).position_order))
                % move pointer to last entry
                smdaTA.pointerPosition = length(smdaTA.itinerary.group(gInd).position_order);
            end
            return
        else
            smdaTA.pointerPosition = sort(unique(eventdata.Indices(:,1)));
        end
        smdaTA.refresh_gui_main;
    end
%%
%
    function tableSettings_CellEditCallback(~, eventdata)
        %%
        % |smdaTA.pointerSettings| should always be a singleton in this
        % case
        myCol = eventdata.Indices(2);
        myRow = smdaTA.itinerary.prototype_position.settings_order(eventdata.Indices(1));
        switch myCol
            case 1 %channel
                smdaTA.itinerary.prototype_settings(myRow).channel = find(strcmp(eventdata.NewData,smdaTA.mm.Channel));
            case 2 %exposure
                smdaTA.itinerary.prototype_settings(myRow).exposure = eventdata.NewData;
            case 3 %binning
                smdaTA.itinerary.prototype_settings(myRow).binning = eventdata.NewData;
            case 4 %gain
                smdaTA.itinerary.prototype_settings(myRow).gain = eventdata.NewData;
            case 5 %Z step size
                smdaTA.itinerary.prototype_settings(myRow).z_step_size = eventdata.NewData;
            case 6 %Z upper
                smdaTA.itinerary.prototype_settings(myRow).z_stack_upper_offset = eventdata.NewData;
            case 7 %Z lower
                smdaTA.itinerary.prototype_settings(myRow).z_stack_lower_offset = eventdata.NewData;
            case 9 %Z offset
                smdaTA.itinerary.prototype_settings(myRow).z_origin_offset = eventdata.NewData;
            case 10 %period multiplier
                smdaTA.itinerary.prototype_settings(myRow).period_multiplier = eventdata.NewData;
        end
        smdaTA.refresh_gui_main;
    end
%%
%
    function tableSettings_CellSelectionCallback(~, eventdata)
        %%
        % The |Travel Agent| aims to recreate the experience that
        % microscope users expect from a multi-dimensional acquistion tool.
        % Therefore, most of the customizability is masked by the
        % |TravelAgent| to provide a streamlined presentation and simple
        % manipulation of the |Itinerary|. Unlike the group and position
        % tables, which edit the itinerary directly, the settings table
        % will modify the the prototype, which will then be pushed to all
        % positions in a group.
        if isempty(eventdata.Indices)
            % if nothing is selected, which triggers after deleting data,
            % make sure the pointer is still valid
            if any(smdaTA.pointerSettings > length(smdaTA.itinerary.prototype_settings))
                % move pointer to last entry
                smdaTA.pointerSettings = length(smdaTA.itinerary.prototype_settings);
            end
            return
        else
            smdaTA.pointerSettings = sort(unique(eventdata.Indices(:,1)));
        end
        smdaTA.refresh_gui_main;
    end
end