%% itinerary, the class that contains multi-dimensional acquisition data 
%
%% Inputs
% * microscope: the object that utilizes the uManager API.
% * itinerary: the object that stores the multi-dimensional-acquisition
% plan and information.
%% Outputs
% * obj: the object with helper functions to manipulate the *itinerary*
% with a gui.
classdef travelagent_class < handle
    %% Properties
    %
    properties
        itinerary;
        gui_main;
        microscope;
        pointerGroup = 1;
        pointerPosition = 1;
        pointerSettings = 1;
        uot_conversion = 1;
    end
    %% Methods
    %
    methods
        %% The first method is the constructor
        % |smdai| is the itinerary that has been initalized with the
        % micromanager core handler object
        function obj = travelagent_class(microscope,itinerary)
            %%%
            % parse the input
            q = inputParser;
            addRequired(q, 'microscope', @(x) isa(x,'microscope_class'));
            addRequired(q, 'itinerary', @(x) isa(x,'itinerary_class'));
            parse(q,microscope,itinerary);
            warning('ta:settings','Changes made to the settings using the travelagent gui will be applied to all positions in the selected group and overwrite any prior customization.');
            %% Initialzing the SuperMDA object
            %
            obj.microscope = q.Results.microscope;
            obj.itinerary = q.Results.itinerary;
            %% Create a gui to enable pausing and stopping
            %
            % Create the figure
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
                'CloseRequestFcn',{@obj.fDeleteFcn},'Name','Travel Agent Main');
            
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
            %%% Time Info
            %
            hpopupmenuUnitsOfTime = uicontrol('Style','popupmenu','Units','characters',...
                'FontSize',14,'FontName','Verdana',...
                'String',{'seconds','minutes','hours','days'},...
                'Position',[region1(1)+2, region1(2)+0.7692, buttonSize(1),buttonSize(2)],...
                'Callback',{@obj.popupmenuUnitsOfTime_Callback});
            
            uicontrol('Style','text','Units','characters','String','Units of Time',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
                'Position',[region1(1)+2, region1(2)+4.2308, buttonSize(1),1.5385]);
            
            heditFundamentalPeriod = uicontrol('Style','edit','Units','characters',...
                'FontSize',14,'FontName','Verdana',...
                'String',num2str(obj.itinerary.fundamental_period),...
                'Position',[region1(1)+2, region1(2)+6.5385, buttonSize(1),buttonSize(2)],...
                'Callback',{@obj.editFundamentalPeriod_Callback});
            
            uicontrol('Style','text','Units','characters','String','Fundamental Period',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
                'Position',[region1(1)+2, region1(2)+10, buttonSize(1),2.6923]);
            
            heditDuration = uicontrol('Style','edit','Units','characters',...
                'FontSize',14,'FontName','Verdana',...
                'String',num2str(obj.itinerary.duration),...
                'Position',[region1(1)+24, region1(2)+0.7692, buttonSize(1),buttonSize(2)],...
                'Callback',{@obj.editDuration_Callback});
            
            uicontrol('Style','text','Units','characters','String','Duration',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
                'Position',[region1(1)+24, region1(2)+4.2308, buttonSize(1),1.5385]);
            
            heditNumberOfTimepoints = uicontrol('Style','edit','Units','characters',...
                'FontSize',14,'FontName','Verdana',...
                'String',num2str(obj.itinerary.number_of_timepoints),...
                'Position',[region1(1)+24, region1(2)+6.5385, buttonSize(1),buttonSize(2)],...
                'Callback',{@obj.editNumberOfTimepoints_Callback});
            
            uicontrol('Style','text','Units','characters','String','Number of Timepoints',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
                'Position',[region1(1)+24, region1(2)+10, buttonSize(1),2.6923]);
            %%% Output directory
            %
            heditOutputDirectory = uicontrol('Style','edit','Units','characters',...
                'FontSize',12,'FontName','Verdana','HorizontalAlignment','left',...
                'String',obj.itinerary.output_directory,...
                'Position',[region1(1)+46, region1(2)+0.7692, buttonSize(1)*3.5,buttonSize(2)],...
                'Callback',{@obj.editOutputDirectory_Callback});
            
            uicontrol('Style','text','Units','characters','String','Output Directory',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
                'Position',[region1(1)+46, region1(2)+4.2308, buttonSize(1)*3.5,1.5385]);
            
            hpushbuttonOutputDirectory = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',20,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion1,...
                'String','...',...
                'Position',[region1(1)+48+buttonSize(1)*3.5, region1(2)+0.7692, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonOutputDirectory_Callback});
            %%% Save or load current SuperMDAItinerary
            %
            hpushbuttonSave = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion1,...
                'String','Save',...
                'Position',[region1(1)+46, region1(2)+6.5385, buttonSize(1),buttonSize(2)],...
                'Callback',{@obj.pushbuttonSave_Callback});
            
            uicontrol('Style','text','Units','characters','String','Save an Itinerary',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
                'Position',[region1(1)+46, region1(2)+10, buttonSize(1),2.6923]);
            
            hpushbuttonLoad = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion1,...
                'String','Load',...
                'Position',[region1(1)+68, region1(2)+6.5385, buttonSize(1),buttonSize(2)],...
                'Callback',{@obj.pushbuttonLoad_Callback});
            
            uicontrol('Style','text','Units','characters','String','Load an Itinerary',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
                'Position',[region1(1)+68, region1(2)+10, buttonSize(1),2.6923]);
            %% Assemble Region 2
            %
            %%% The group table
            %
            htableGroup = uitable('Units','characters',...
                'BackgroundColor',[textBackgroundColorRegion2;buttonBackgroundColorRegion2],...
                'ColumnName',{'label','group #','# of positions','function before','function after'},...
                'ColumnEditable',logical([1,0,0,0,0]),...
                'ColumnFormat',{'char','numeric','numeric','char','char'},...
                'ColumnWidth',{30*ppChar(3) 'auto' 'auto' 30*ppChar(3) 30*ppChar(3)},...
                'FontSize',8,'FontName','Verdana',...
                'CellEditCallback',@obj.tableGroup_CellEditCallback,...
                'CellSelectionCallback',@obj.tableGroup_CellSelectionCallback,...
                'Position',[region2(1)+2, region2(2)+0.7692, 91.6, 13.0769]);
            %%% add or drop a group
            %
            hpushbuttonGroupAdd = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion2,...
                'String','Add',...
                'Position',[fwidth - 4 - buttonSize(1)*1.25, region2(2)+7.6923, buttonSize(1)*.75,buttonSize(2)],...
                'Callback',{@obj.pushbuttonGroupAdd_Callback});
            
            uicontrol('Style','text','Units','characters','String','Add a group',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion2,...
                'Position',[fwidth - 4 - buttonSize(1)*1.25, region2(2)+11.1538, buttonSize(1)*.75,2.6923]);
            
            hpushbuttonGroupDrop = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion2,...
                'String','Drop',...
                'Position',[fwidth - 4 - buttonSize(1)*1.25, region2(2)+0.7692, buttonSize(1)*.75,buttonSize(2)],...
                'Callback',{@obj.pushbuttonGroupDrop_Callback});
            
            uicontrol('Style','text','Units','characters','String','Drop a group',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion2,...
                'Position',[fwidth - 4 - buttonSize(1)*1.25, region2(2)+4.2308, buttonSize(1)*.75,2.6923]);
            %%% change group functions
            %
            uicontrol('Style','text','Units','characters','String',sprintf('Group\nFunction\nBefore'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion2,...
                'Position',[fwidth - 2 - buttonSize(1)*0.5, region2(2)+4.2308, buttonSize(1)*0.5,2.6923]);
            
            hpushbuttonGroupFunctionBefore = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',20,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion2,...
                'String','...',...
                'Position',[fwidth - 2 - buttonSize(1)*0.5, region2(2)+0.7692, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonGroupFunctionBefore_Callback});
            
            uicontrol('Style','text','Units','characters','String',sprintf('Group\nFunction\nAfter'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion2,...
                'Position',[fwidth - 2 - buttonSize(1)*0.5, region2(2)+11.1538, buttonSize(1)*0.5,2.6923]);
            
            hpushbuttonGroupFunctionAfter = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',20,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion2,...
                'String','...',...
                'Position',[fwidth - 2 - buttonSize(1)*0.5, region2(2)+7.6923, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonGroupFunctionAfter_Callback});
            %%% Change group order
            %
            uicontrol('Style','text','Units','characters','String',sprintf('Move\nGroup\nDown'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion2,...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region2(2)+4.2308, buttonSize(1)*0.5,2.6923]);
            
            hpushbuttonGroupDown = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion2,...
                'String','Dn',...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region2(2)+0.7692, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonGroupDown_Callback});
            
            uicontrol('Style','text','Units','characters','String',sprintf('Move\nGroup\nUp'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion2,...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region2(2)+11.1538, buttonSize(1)*0.5,2.6923]);
            
            hpushbuttonGroupUp = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion2,...
                'String','Up',...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region2(2)+7.6923, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonGroupUp_Callback});
            %% Assemble Region 3
            %
            %%% The position table
            %
            htablePosition = uitable('Units','characters',...
                'BackgroundColor',[textBackgroundColorRegion3;buttonBackgroundColorRegion3],...
                'ColumnName',{'label','position #','X','Y','Z','PFS','PFS offset','function before','function after','# of settings'},...
                'ColumnEditable',logical([1,0,1,1,1,1,1,0,0,0]),...
                'ColumnFormat',{'char','numeric','numeric','numeric','numeric',{'yes','no'},'numeric','char','char','numeric'},...
                'ColumnWidth',{30*ppChar(3) 'auto' 'auto' 'auto' 'auto' 'auto' 'auto' 30*ppChar(3) 30*ppChar(3) 'auto'},...
                'FontSize',8,'FontName','Verdana',...
                'CellEditCallback',{@obj.tablePosition_CellEditCallback},...
                'CellSelectionCallback',{@obj.tablePosition_CellSelectionCallback},...
                'Position',[region3(1)+2, region3(2)+0.7692, 91.6, 28.1538]);
            %%% add or drop positions
            %
            hpushbuttonPositionAdd = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
                'String','Add',...
                'Position',[fwidth - 4 - buttonSize(1)*1.25, region3(2)+14.0769+7.6923, buttonSize(1)*.75,buttonSize(2)],...
                'Callback',{@obj.pushbuttonPositionAdd_Callback});
            
            uicontrol('Style','text','Units','characters','String','Add a position',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
                'Position',[fwidth - 4 - buttonSize(1)*1.25, region3(2)+14.0769+11.1538, buttonSize(1)*.75,2.6923]);
            
            hpushbuttonPositionDrop = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
                'String','Drop',...
                'Position',[fwidth - 4 - buttonSize(1)*1.25, region3(2)+14.0769+0.7692, buttonSize(1)*.75,buttonSize(2)],...
                'Callback',{@obj.pushbuttonPositionDrop_Callback});
            
            uicontrol('Style','text','Units','characters','String','Drop a position',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
                'Position',[fwidth - 4 - buttonSize(1)*1.25, region3(2)+14.0769+4.2308, buttonSize(1)*.75,2.6923]);
            %%% change position order
            %
            uicontrol('Style','text','Units','characters','String',sprintf('Move\nPosition\nDown'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region3(2)+14.0769+4.2308, buttonSize(1)*0.5,2.6923]);
            
            hpushbuttonPositionDown = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
                'String','Dn',...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region3(2)+14.0769+0.7692, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonPositionDown_Callback});
            
            uicontrol('Style','text','Units','characters','String',sprintf('Move\nPosition\nUp'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region3(2)+14.0769+11.1538, buttonSize(1)*0.5,2.6923]);
            
            hpushbuttonPositionUp = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
                'String','Up',...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region3(2)+14.0769+7.6923, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonPositionUp_Callback});
            %%% move to a position
            %
            hpushbuttonPositionMove = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
                'String','Move',...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region3(2)+7.6923, buttonSize(1),buttonSize(2)],...
                'Callback',{@obj.pushbuttonPositionMove_Callback});
            
            uicontrol('Style','text','Units','characters','String',sprintf('Move the stage\nto the\nselected position'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region3(2)+11.1538, buttonSize(1),2.6923]);
            %%% change a position value to the current position
            %
            hpushbuttonPositionSet = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
                'String','Set',...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region3(2)+0.7692, buttonSize(1),buttonSize(2)],...
                'Callback',{@obj.pushbuttonPositionSet_Callback});
            
            uicontrol('Style','text','Units','characters','String',sprintf('Set the position\nto the current\nstage position'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region3(2)+4.2308, buttonSize(1),2.6923]);
            %%% add a grid
            %
            hpushbuttonSetAllZ = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
                'String',sprintf('Set All Z'),...
                'Position',[fwidth - 2 - buttonSize(1)*.75, region3(2)+7.6923, buttonSize(1)*.75,buttonSize(2)],...
                'Callback',{@obj.pushbuttonSetAllZ_Callback});
            
            uicontrol('Style','text','Units','characters','String',sprintf('Add a grid\nof positions'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
                'Position',[fwidth - 2 - buttonSize(1)*.75, region3(2)+11.1538, buttonSize(1)*.75,2.6923]);
            %%% change position functions
            %
            uicontrol('Style','text','Units','characters','String',sprintf('Position\nFunction\nBefore'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
                'Position',[fwidth - 2 - buttonSize(1)*0.5, region3(2)+14.0769+4.2308, buttonSize(1)*0.5,2.6923]);
            
            hpushbuttonPositionFunctionBefore = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',20,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
                'String','...',...
                'Position',[fwidth - 2 - buttonSize(1)*0.5, region3(2)+14.0769+0.7692, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonPositionFunctionBefore_Callback});
            
            uicontrol('Style','text','Units','characters','String',sprintf('Position\nFunction\nAfter'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
                'Position',[fwidth - 2 - buttonSize(1)*0.5, region3(2)+14.0769+11.1538, buttonSize(1)*0.5,2.6923]);
            
            hpushbuttonPositionFunctionAfter = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',20,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
                'String','...',...
                'Position',[fwidth - 2 - buttonSize(1)*0.5, region3(2)+14.0769+7.6923, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonPositionFunctionAfter_Callback});
            %% Assemble Region 4
            % 
            %%% The settings table
            %
            
            htableSettings = uitable('Units','characters',...
                'BackgroundColor',[textBackgroundColorRegion4;buttonBackgroundColorRegion4],...
                'ColumnName',{'channel','exposure','binning','Z step size','Z upper','Z lower','# of Z steps','Z offset','period mult.','function','settings #'},...
                'ColumnEditable',logical([1,1,1,1,1,1,0,1,1,0,0]),...
                'ColumnFormat',{transpose(obj.microscope.Channel),'numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','char','numeric'},...
                'ColumnWidth',{'auto' 'auto' 'auto' 'auto' 'auto' 'auto' 'auto' 'auto' 'auto' 'auto' 'auto'},...
                'FontSize',8,'FontName','Verdana',...
                'CellEditCallback',@obj.tableSettings_CellEditCallback,...
                'CellSelectionCallback',@obj.tableSettings_CellSelectionCallback,...
                'Position',[region4(1)+2, region4(2)+0.7692, 79.6, 13.0769]);
            %%% add or drop a group
            %
            hpushbuttonSettingsAdd = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion4,...
                'String','Add',...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region4(2)+7.6923, buttonSize(1)*.75,buttonSize(2)],...
                'Callback',{@obj.pushbuttonSettingsAdd_Callback});
            
            uicontrol('Style','text','Units','characters','String','Add a settings',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion4,...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region4(2)+11.1538, buttonSize(1)*.75,2.6923]);
            
            hpushbuttonSettingsDrop = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion4,...
                'String','Drop',...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region4(2)+0.7692, buttonSize(1)*.75,buttonSize(2)],...
                'Callback',{@obj.pushbuttonSettingsDrop_Callback});
            
            uicontrol('Style','text','Units','characters','String','Drop a settings',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion4,...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region4(2)+4.2308, buttonSize(1)*.75,2.6923]);
            %%% change Settings functions
            %
            uicontrol('Style','text','Units','characters','String',sprintf('Settings\nFunction'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion4,...
                'Position',[fwidth - 2 - buttonSize(1)*0.5, region4(2)+11.1538, buttonSize(1)*0.5,2.6923]);
            
            hpushbuttonSettingsFunction = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',20,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion4,...
                'String','...',...
                'Position',[fwidth - 2 - buttonSize(1)*0.5, region4(2)+7.6923, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonSettingsFunction_Callback});
            %%% Change Settings order
            %
            uicontrol('Style','text','Units','characters','String',sprintf('Move\nSettings\nDown'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion4,...
                'Position',[fwidth - 8 - buttonSize(1)*2.25, region4(2)+4.2308, buttonSize(1)*0.5,2.6923]);
            
            hpushbuttonSettingsDown = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion4,...
                'String','Dn',...
                'Position',[fwidth - 8 - buttonSize(1)*2.25, region4(2)+0.7692, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonSettingsDown_Callback});
            
            uicontrol('Style','text','Units','characters','String',sprintf('Move\nSettings\nUp'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion4,...
                'Position',[fwidth - 8 - buttonSize(1)*2.25, region4(2)+11.1538, buttonSize(1)*0.5,2.6923]);
            
            hpushbuttonSettingsUp = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion4,...
                'String','Up',...
                'Position',[fwidth - 8 - buttonSize(1)*2.25, region4(2)+7.6923, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonSettingsUp_Callback});
            %%% Set Z upper or Z lower boundaries
            %
            uicontrol('Style','text','Units','characters','String',sprintf('Set Z\nLower'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion4,...
                'Position',[fwidth - 4 - buttonSize(1), region4(2)+4.2308, buttonSize(1)*0.5,2.6923]);
            
            hpushbuttonSettingsZLower = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion4,...
                'String','Z-',...
                'Position',[fwidth - 4 - buttonSize(1), region4(2)+0.7692, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonSettingsZLower_Callback});
            
            uicontrol('Style','text','Units','characters','String',sprintf('Set Z\nUpper'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion4,...
                'Position',[fwidth - 4 - buttonSize(1), region4(2)+11.1538, buttonSize(1)*0.5,2.6923]);
            
            hpushbuttonSettingsZUpper = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion4,...
                'String','Z+',...
                'Position',[fwidth - 4 - buttonSize(1), region4(2)+7.6923, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonSettingsZUpper_Callback});
            %% Handles
            % 
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
            handles.pushbuttonPositionFunctionAfter = hpushbuttonPositionFunctionAfter;
            handles.pushbuttonPositionFunctionBefore = hpushbuttonPositionFunctionBefore;
            handles.pushbuttonPositionMove = hpushbuttonPositionMove;
            handles.pushbuttonPositionSet = hpushbuttonPositionSet;
            handles.pushbuttonPositionUp = hpushbuttonPositionUp;
            handles.pushbuttonSetAllZ = hpushbuttonSetAllZ;
            handles.pushbuttonSettingsAdd = hpushbuttonSettingsAdd;
            handles.pushbuttonSettingsDown = hpushbuttonSettingsDown;
            handles.pushbuttonSettingsDrop = hpushbuttonSettingsDrop;
            handles.pushbuttonSettingsFunction = hpushbuttonSettingsFunction;
            handles.pushbuttonSettingsUp = hpushbuttonSettingsUp;
            handles.pushbuttonSettingsZUpper = hpushbuttonSettingsZUpper;
            handles.pushbuttonSettingsZLower = hpushbuttonSettingsZLower;
            handles.tableGroup = htableGroup;
            handles.tablePosition = htablePosition;
            handles.tableSettings = htableSettings;
            guidata(f,handles);
            %%%
            % make the gui visible
            set(f,'Visible','on');
            
            obj.gui_main = f;
            obj.refresh_gui_main;
        end
        %% Callbacks for gui_main
        % 
        %%
        %
        function obj = fDeleteFcn(obj,~,~)
            obj.delete;
        end
        %% Callbacks for Region 1
        % 
        %% popupmenuUnitsOfTime_Callback
        %
        function obj = popupmenuUnitsOfTime_Callback(obj,~,~)
            handles = guidata(obj.gui_main);
            seconds2array = [1,60,3600,86400];
            obj.uot_conversion = seconds2array(handles.popupmenuUnitsOfTime.Value);
            obj.refresh_gui_main;
        end
        %% editFundamentalPeriod_Callback
        %
        function obj = editFundamentalPeriod_Callback(obj,~,~)
            handles = guidata(obj.gui_main);
            myValue = str2double(handles.editFundamentalPeriod.String)*obj.uot_conversion;
            obj.itinerary.newFundamentalPeriod(myValue);
            obj.refresh_gui_main;
        end
        %% editDuration_Callback
        %
        function obj = editDuration_Callback(obj,~,~)
            handles = guidata(obj.gui_main);
            myValue = str2double(handles.editDuration.String)*obj.uot_conversion;
            obj.itinerary.newDuration(myValue);
            obj.refresh_gui_main;
        end
        %% editNumberOfTimepoints_Callback
        %
        function obj = editNumberOfTimepoints_Callback(obj,~,~)
            handles = guidata(obj.gui_main);
            myValue = str2double(handles.editNumberOfTimepoints.String);
            obj.itinerary.newNumberOfTimepoints(myValue);
            obj.refresh_gui_main;
        end
        %% editOutputDirectory_Callback
        %
        function obj = editOutputDirectory_Callback(obj,~,~)
            handles = guidata(obj.gui_main);
            folder_name = handles.editOutputDirectory.String;
            if exist(folder_name,'dir')
                obj.itinerary.output_directory = folder_name;
            else
                str = sprintf('''%s'' is not a directory',folder_name);
                disp(str);
            end
            obj.refresh_gui_main;
        end
        %% pushbuttonOutputDirectory_Callback
        %
        function obj = pushbuttonOutputDirectory_Callback(obj,~,~)
            folder_name = uigetdir;
            if folder_name==0
                return
            elseif exist(folder_name,'dir')
                obj.itinerary.output_directory = folder_name;
            else
                str = sprintf('''%s'' is not a directory',folder_name);
                disp(str);
            end
            obj.refresh_gui_main;
        end
        %% pushbuttonSave_Callback
        %
        function obj = pushbuttonSave_Callback(obj,~,~)
            obj.itinerary.export;
        end
        %%
        %
        function obj = pushbuttonLoad_Callback(obj,~,~)
            uiwait(warndlg('The current SuperMDA will be erased!','Load a SuperMDA','modal'));
            mypwd = pwd;
            cd(obj.itinerary.output_directory);
            [filename,pathname] = uigetfile({'*.mat'},'Load a SuperMDAItinerary');
            cd(mypwd);
            if exist(fullfile(pathname,filename),'file')
                obj.itinerary.import(fullfile(pathname,filename));
            else
                disp('The SuperMDAItinerary file selected was invalid.');
            end
            obj.refresh_gui_main;
        end
        %% Callbacks for Region 2
        %   
        %% tableGroup_CellEditCallback
        %
        function obj = tableGroup_CellEditCallback(obj,~,eventdata)
            %%
            % |obj.pointerGroup| should always be a singleton in this case
            myCol = eventdata.Indices(2);
            myGroupOrder = obj.itinerary.order_group;
            myRow = myGroupOrder(eventdata.Indices(1));
            switch myCol
                case 1 %label change
                    if isempty(eventdata.NewData) || any(regexp(eventdata.NewData,'\W'))
                        return
                    else
                        obj.itinerary.group_label{myRow} = eventdata.NewData;
                    end
            end
            obj.refresh_gui_main;
        end
        %% tableGroup_CellSelectionCallback
        %
        function obj = tableGroup_CellSelectionCallback(obj,~,eventdata)
            %%
            % The main purpose of this function is to keep the information
            % displayed in the table consistent with the Itinerary object.
            % Changes to the object either through the comicroscopeand line or the gui
            % can affect the information that is displayed in the gui and this
            % function will keep the gui information consistent with the
            % Itinerary information.
            %
            % The pointer of the TravelAgent should always point to a valid
            % group from the the group_order.
            if isempty(eventdata.Indices)
                % if nothing is selected, which triggers after deleting data,
                % make sure the pointer is still valid
                if any(obj.pointerGroup > obj.itinerary.number_group)
                    % move pointer to last entry
                    obj.pointerGroup = obj.itinerary.number_group;
                end
                return
            else
                obj.pointerGroup = sort(unique(eventdata.Indices(:,1)));
            end
            myGroupOrder = obj.itinerary.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            if any(obj.pointerPosition > obj.itinerary.number_position(gInd))
                % move pointer to first entry
                obj.pointerPosition = 1;
            end
            obj.refresh_gui_main;
        end
        %% pushbuttonGroupAdd_Callback
        %
        function obj = pushbuttonGroupAdd_Callback(obj,~,~)
            gInd = obj.itinerary.newGroup;
            obj.pointerGroup = obj.itinerary.number_group;
            pInd = obj.itinerary.newPosition;
            obj.itinerary.connectGPS('g',gInd,'p',pInd,'s',obj.itinerary.order_settings{1});
            obj.refresh_gui_main;
        end
        %% pushbuttonGroupDrop_Callback
        %
        function obj = pushbuttonGroupDrop_Callback(obj,~,~)
            if obj.itinerary.number_group == 1
                return
            elseif length(obj.pointerGroup) == obj.itinerary.number_group
                obj.pointerGroup(1) = [];
            end
            myGroupOrder = obj.itinerary.order_group;
            gInds = myGroupOrder(obj.pointerGroup);
            for i = 1:length(gInds)
                obj.itinerary.dropGroup(gInds(i));
            end
            obj.pointerGroup = obj.itinerary.number_group;
            obj.refresh_gui_main;
        end
        %% pushbuttonGroupFunctionBefore_Callback
        %
        function obj = pushbuttonGroupFunctionBefore_Callback(obj,~,~)
            myGroupInd = obj.itinerary.ind_group;
            mypwd = pwd;
            cd(obj.itinerary.output_directory);
            [filename,pathname] = uigetfile({'*.m'},'Choose the group-function-before');
            if exist(fullfile(pathname,filename),'file')
                [obj.itinerary.group_function_before{myGroupInd}] = deal(char(regexp(filename,'.*(?=\.m)','match')));
            else
                disp('The group-function-before selection was invalid.');
            end
            cd(mypwd);
            obj.refresh_gui_main;
        end
        %% pushbuttonGroupFunctionAfter_Callback
        %
        function obj = pushbuttonGroupFunctionAfter_Callback(obj,~,~)
            myGroupInd = obj.itinerary.ind_group;
            mypwd = pwd;
            cd(obj.itinerary.output_directory);
            [filename,pathname] = uigetfile({'*.m'},'Choose the group-function-after');
            if exist(fullfile(pathname,filename),'file')
                [obj.itinerary.group_function_after{myGroupInd}] = deal(char(regexp(filename,'.*(?=\.m)','match')));
            else
                disp('The group-function-after selection was invalid.');
            end
            cd(mypwd);
            obj.refresh_gui_main;
        end
        %% pushbuttonGroupDown_Callback
        %
        function obj = pushbuttonGroupDown_Callback(obj,~,~)
            %%
            % What follows below might have a more elegant solution.
            % essentially all selected rows are moved down 1.
            if max(obj.pointerGroup) == obj.itinerary.number_group
                return
            end
            currentOrder = 1:obj.itinerary.number_group; % what the table looks like now
            movingGroup = obj.pointerGroup+1; % where the selected rows want to go
            reactingGroup = setdiff(currentOrder,obj.pointerGroup); % the rows that are not moving
            fillmeinArray = zeros(1,length(currentOrder)); % a vector to store the new order
            fillmeinArray(movingGroup) = obj.pointerGroup; % the selected rows are moved
            fillmeinArray(fillmeinArray==0) = reactingGroup; % the remaining rows are moved
            % use the fillmeinArray to rearrange the groups
            obj.itinerary.order_group = obj.itinerary.order_group(fillmeinArray);
            %
            obj.pointerGroup = movingGroup;
            obj.refresh_gui_main;
        end
        %% pushbuttonGroupUp_Callback
        %
        function obj = pushbuttonGroupUp_Callback(obj,~,~)
            %%
            % What follows below might have a more elegant solution.
            % essentially all selected rows are moved up 1.
            if min(obj.pointerGroup) == 1
                return
            end
            currentOrder = 1:obj.itinerary.number_group; % what the table looks like now
            movingGroup = obj.pointerGroup-1; % where the selected rows want to go
            reactingGroup = setdiff(currentOrder,obj.pointerGroup); % the rows that are not moving
            newOrderArray = zeros(1,length(currentOrder)); % a vector to store the new order
            newOrderArray(movingGroup) = obj.pointerGroup; % the selected rows are moved
            newOrderArray(newOrderArray==0) = reactingGroup; % the remaining rows are moved
            % use the newOrderArray to rearrange the groups
            obj.itinerary.order_group = obj.itinerary.order_group(newOrderArray);
            %
            obj.pointerGroup = movingGroup;
            obj.refresh_gui_main;
        end
        %% Callbacks for Region 3
        %  
        %% tablePosition_CellEditCallback
        %
        function obj = tablePosition_CellEditCallback(obj,~,eventdata)
            %%
            % |obj.pointerPosition| should always be a singleton in this
            % case
            myGroupOrder = obj.itinerary.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            myCol = eventdata.Indices(2);
            myPositionOrder = obj.itinerary.order_position{gInd};
            myRow = myPositionOrder(eventdata.Indices(1));
            switch myCol
                case 1 %label change
                    if isempty(eventdata.NewData) || any(regexp(eventdata.NewData,'\W'))
                        return
                    else
                        obj.itinerary.position_label{myRow} = eventdata.NewData;
                    end
                case 3 %X
                    obj.itinerary.position_xyz(myRow,1) = eventdata.NewData;
                case 4 %Y
                    obj.itinerary.position_xyz(myRow,2) = eventdata.NewData;
                case 5 %Z
                    obj.itinerary.position_xyz(myRow,3) = eventdata.NewData;
                case 6 %PFS
                    if strcmp(eventdata.NewData,'yes')
                        obj.itinerary.position_continuous_focus_bool(myRow) = true;
                    else
                        obj.itinerary.position_continuous_focus_bool(myRow) = false;
                    end
                    obj.itinerary.position_continuous_focus_bool(myPositionOrder) = obj.itinerary.position_continuous_focus_bool(myRow);
                case 7 %PFS offset
                    obj.itinerary.position_continuous_focus_offset(myRow) = eventdata.NewData;
            end
            obj.refresh_gui_main;
        end
        %% tablePosition_CellSelectionCallback
        %
        function obj = tablePosition_CellSelectionCallback(obj,~,eventdata)
            %%
            % The main purpose of this function is to keep the information
            % displayed in the table consistent with the Itinerary object.
            % Changes to the object either through the comicroscopeand line or the gui
            % can affect the information that is displayed in the gui and this
            % function will keep the gui information consistent with the
            % Itinerary information.
            %
            % The pointer of the TravelAgent should always point to a valid
            % position from the the position_order in a given group.
            myGroupOrder = obj.itinerary.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            if isempty(eventdata.Indices)
                % if nothing is selected, which triggers after deleting data,
                % make sure the pointer is still valid
                if any(obj.pointerPosition > obj.itinerary.number_position(gInd))
                    % move pointer to last entry
                    obj.pointerPosition = obj.itinerary.number_position(gInd);
                end
                return
            else
                obj.pointerPosition = sort(unique(eventdata.Indices(:,1)));
            end
            obj.refresh_gui_main;
        end
        %% pushbuttonPositionAdd_Callback
        %
        function obj = pushbuttonPositionAdd_Callback(obj,~,~)
            myGroupOrder = obj.itinerary.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            pFirst = obj.itinerary.order_position{gInd}(1);
            pInd = obj.itinerary.newPosition;
            obj.itinerary.connectGPS('g',gInd,'p',pInd,'s',obj.itinerary.order_settings{pFirst});
            obj.pointerPosition = obj.itinerary.number_position(gInd);
            obj.refresh_gui_main;
        end
        %% pushbuttonPositionDrop_Callback
        %
        function obj = pushbuttonPositionDrop_Callback(obj,~,~)
            myGroupOrder = obj.itinerary.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            if obj.itinerary.number_position(gInd)==1
                return
            elseif length(obj.pointerPosition) == obj.itinerary.number_position(gInd)
                obj.pointerPosition(1) = [];
            end
            myPositionInd = obj.itinerary.order_position{gInd};
            for i = 1:length(obj.pointerPosition)
                obj.itinerary.dropPosition(myPositionInd(obj.pointerPosition(i)));
            end
            obj.pointerPosition = obj.itinerary.number_position(gInd);
            obj.refresh_gui_main;
        end
        %% pushbuttonPositionDown_Callback
        %
        function obj = pushbuttonPositionDown_Callback(obj,~,~)
            %%
            % What follows below might have a more elegant solution.
            % essentially all selected rows are moved down 1.
            myGroupOrder = obj.itinerary.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            if max(obj.pointerPosition) == obj.itinerary.number_position(gInd)
                return
            end
            currentOrder = 1:obj.itinerary.number_position(gInd); % what the table looks like now
            movingPosition = obj.pointerPosition+1; % where the selected rows want to go
            reactingPosition = setdiff(currentOrder,obj.pointerPosition); % the rows that are not moving
            fillmeinArray = zeros(1,length(currentOrder)); % a vector to store the new order
            fillmeinArray(movingPosition) = obj.pointerPosition; % the selected rows are moved
            fillmeinArray(fillmeinArray==0) = reactingPosition; % the remaining rows are moved
            % use the fillmeinArray to rearrange the positions
            obj.itinerary.order_position{gInd} = obj.itinerary.order_position{gInd}(fillmeinArray);
            %
            obj.pointerPosition = movingPosition;
            obj.refresh_gui_main;
        end
        %% pushbuttonPositionUp_Callback
        %
        function obj = pushbuttonPositionUp_Callback(obj,~,~)
            %%
            % What follows below might have a more elegant solution.
            % essentially all selected rows are moved up 1.
            myGroupOrder = obj.itinerary.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            if min(obj.pointerPosition) == 1
                return
            end
            currentOrder = 1:obj.itinerary.number_position(gInd); % what the table looks like now
            movingPosition = obj.pointerPosition-1; % where the selected rows want to go
            reactingPosition = setdiff(currentOrder,obj.pointerPosition); % the rows that are not moving
            fillmeinArray = zeros(1,length(currentOrder)); % a vector to store the new order
            fillmeinArray(movingPosition) = obj.pointerPosition; % the selected rows are moved
            fillmeinArray(fillmeinArray==0) = reactingPosition; % the remaining rows are moved
            % use the fillmeinArray to rearrange the positions
            obj.itinerary.order_position{gInd} = obj.itinerary.order_position{gInd}(fillmeinArray);
            %
            obj.pointerPosition = movingPosition;
            obj.refresh_gui_main;
        end
        %% pushbuttonPositionMove_Callback
        %
        function obj = pushbuttonPositionMove_Callback(obj,~,~)
            myGroupOrder = obj.itinerary.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            pInd = obj.itinerary.order_position{gInd};
            pInd = pInd(obj.pointerPosition(1));
            xyz = obj.itinerary.position_xyz(pInd,:);
            if obj.itinerary.position_continuous_focus_bool(pInd)
                %% PFS lock-on will be attempted
                %
                obj.microscope.setXYZ(xyz(1:2)); % setting the z through the focus device will disable the PFS. Therefore, the stage is moved in the XY direction before assessing the status of the PFS system.
                obj.microscope.core.waitForDevice(obj.microscope.xyStageDevice);
                if strcmp(obj.microscope.core.getProperty(obj.microscope.AutoFocusStatusDevice,'State'),'Off')
                    %%
                    % If the PFS is |OFF|, then the scope is moved to an
                    % absolute z that will give the system the best chance of
                    % locking onto the correct z.
                    obj.microscope.setXYZ(xyz(3),'direction','z');
                    obj.microscope.core.waitForDevice(obj.microscope.FocusDevice);
                    obj.microscope.core.setProperty(obj.microscope.AutoFocusDevice,'Position',obj.itinerary.position_continuous_focus_offset(pInd));
                    obj.microscope.core.fullFocus(); % PFS will return to |OFF|
                else
                    %%
                    % If the PFS system is already on, then changing the offset
                    % will adjust the z-position. fullFocus() will have the
                    % system wait until the new z-position has been reached.
                    obj.microscope.core.setProperty(obj.microscope.AutoFocusDevice,'Position',obj.itinerary.position_continuous_focus_offset(pInd));
                    obj.microscope.core.fullFocus(); % PFS will remain |ON|
                end
            else
                %% PFS will not be utilized
                %
                obj.microscope.setXYZ(xyz);
                obj.microscope.core.waitForDevice(obj.microscope.FocusDevice);
                obj.microscope.core.waitForDevice(obj.microscope.xyStageDevice);
            end
        end
        %% pushbuttonPositionSet_Callback
        %
        function obj = pushbuttonPositionSet_Callback(obj,~,~)
            myGroupOrder = obj.itinerary.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            pInd = obj.itinerary.order_position{gInd};
            pInd = pInd(obj.pointerPosition(1));
            obj.microscope.getXYZ;
            obj.itinerary.position_xyz(pInd,:) = obj.microscope.pos;
            obj.itinerary.position_continuous_focus_offset(pInd) = str2double(obj.microscope.core.getProperty(obj.microscope.AutoFocusDevice,'Position'));
            obj.refresh_gui_main;
        end
        %% pushbuttonSetAllZ_Callback
        %
        function obj = pushbuttonSetAllZ_Callback(obj,~,~)
            myGroupOrder = obj.itinerary.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            myPInd = obj.itinerary.ind_position{gInd};
            obj.itinerary.position_continuous_focus_offset(myPInd) = str2double(obj.microscope.core.getProperty(obj.microscope.AutoFocusDevice,'Position'));
            xyz = obj.microscope.getXYZ;
            obj.itinerary.position_xyz(myPInd,3) = xyz(3);
            fprintf('positions in group %d have Z postions updated!\n',gInd);
        end
        %% pushbuttonPositionFunctionBefore_Callback
        %
        function obj = pushbuttonPositionFunctionBefore_Callback(obj,~,~)
            myGroupOrder = obj.itinerary.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            mypwd = pwd;
            myPositionInd = obj.itinerary.ind_position{gInd};
            cd(obj.itinerary.output_directory);
            [filename,pathname] = uigetfile({'*.m'},'Choose the position-function-before');
            if exist(fullfile(pathname,filename),'file')
                [obj.itinerary.position_function_before{myPositionInd}] = deal(char(regexp(filename,'.*(?=\.m)','match')));
            else
                disp('The position-function-before selection was invalid.');
            end
            cd(mypwd);
            obj.refresh_gui_main;
        end
        %% pushbuttonPositionFunctionAfter_Callback
        %
        function obj = pushbuttonPositionFunctionAfter_Callback(obj,~,~)
            myGroupOrder = obj.itinerary.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            mypwd = pwd;
            myPositionInd = obj.itinerary.ind_position{gInd};
            cd(obj.itinerary.output_directory);
            [filename,pathname] = uigetfile({'*.m'},'Choose the position-function-after');
            if exist(fullfile(pathname,filename),'file')
                [obj.itinerary.position_function_after{myPositionInd}] = deal(char(regexp(filename,'.*(?=\.m)','match')));
            else
                disp('The position-function-before selection was invalid.');
            end
            cd(mypwd);
            obj.refresh_gui_main;
        end
        %% Callbacks for Region 4
        %  
        %% tableSettings_CellEditCallback
        %
        function obj = tableSettings_CellEditCallback(obj,~,eventdata)
            %%
            % |obj.pointerSettings| should always be a singleton in this
            % case
            myGroupOrder = obj.itinerary.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            pInd = obj.itinerary.ind_position{gInd};
            pInd = pInd(1);
            myCol = eventdata.Indices(2);
            mySettingsOrder = obj.itinerary.order_settings{pInd};
            myRow = mySettingsOrder(eventdata.Indices(1));
            switch myCol
                case 1 %channel
                    obj.itinerary.settings_channel(myRow) = find(strcmp(eventdata.NewData,obj.microscope.Channel));
                case 2 %exposure
                    obj.itinerary.settings_exposure(myRow) = eventdata.NewData;
                case 3 %binning
                    obj.itinerary.settings_binning(myRow) = eventdata.NewData;
                case 4 %Z step size
                    obj.itinerary.settings_z_step_size(myRow) = eventdata.NewData;
                case 5 %Z upper
                    obj.itinerary.settings_z_stack_upper_offset(myRow) = eventdata.NewData;
                case 6 %Z lower
                    obj.itinerary.settings_z_stack_lower_offset(myRow) = eventdata.NewData;
                case 8 %Z offset
                    obj.itinerary.settings_z_origin_offset(myRow) = eventdata.NewData;
                case 9 %period multiplier
                    obj.itinerary.settings_period_multiplier(myRow) = eventdata.NewData;
            end
            obj.refresh_gui_main;
        end
        %% tableSettings_CellSelectionCallback
        %
        function obj = tableSettings_CellSelectionCallback(obj,~,eventdata)
            %%
            % The |Travel Agent| aims to recreate the experience that
            % microscope users expect from a multi-dimensional acquistion tool.
            % Therefore, most of the customizabilitinerary is masked by the
            % |TravelAgent| to provide a streamlined presentation and simple
            % manipulation of the |Itinerary|. Unlike the group and position
            % tables, which edit the itinerary directly, the settings table
            % will modify the the prototype, which will then be pushed to all
            % positions in a group.
            myGroupOrder = obj.itinerary.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            pInd = obj.itinerary.ind_position{gInd};
            pInd = pInd(1);
            if isempty(eventdata.Indices)
                % if nothing is selected, which triggers after deleting data,
                % make sure the pointer is still valid
                if any(obj.pointerSettings > obj.itinerary.number_settings(pInd))
                    % move pointer to last entry
                    obj.pointerSettings = obj.itinerary.number_settings(pInd);
                end
                return
            else
                obj.pointerSettings = sort(unique(eventdata.Indices(:,1)));
            end
            obj.refresh_gui_main;
        end
        %% pushbuttonSettingsAdd_Callback
        %
        function obj = pushbuttonSettingsAdd_Callback(obj,~,~)
            myGroupOrder = obj.itinerary.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            pFirst = obj.itinerary.order_position{gInd}(1);
            sInd = obj.itinerary.newSettings;
            obj.itinerary.connectGPS('p',pFirst,'s',sInd);
            obj.itinerary.mirrorSettings(pFirst,gInd);
            obj.pointerSettings = obj.itinerary.number_settings(pFirst);
            obj.refresh_gui_main;
        end
        %% pushbuttonSettingsDrop_Callback
        %
        function obj = pushbuttonSettingsDrop_Callback(obj,~,~)
            myGroupOrder = obj.itinerary.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            pInd = obj.itinerary.ind_position{gInd};
            pInd = pInd(1);
            if obj.itinerary.number_settings(pInd) == 1
                return
            elseif length(obj.pointerSettings) == obj.itinerary.number_settings(pInd)
                obj.pointerSettings(1) = [];
            end
            mySettingsInd = obj.itinerary.order_settings{pInd};
            for i = 1:length(obj.pointerSettings)
                obj.itinerary.dropSettings(mySettingsInd(obj.pointerSettings(i)));
            end
            obj.pointerSettings = obj.itinerary.number_settings(pInd);
            obj.refresh_gui_main;
        end
        %% pushbuttonSettingsFunction_Callback
        %
        function obj = pushbuttonSettingsFunction_Callback(obj,~,~)
            myGroupOrder = obj.itinerary.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            pInd = obj.itinerary.ind_position{gInd};
            pInd = pInd(1);
            sInds = obj.itinerary.ind_settings{pInd};
            mypwd = pwd;
            cd(obj.itinerary.output_directory);
            [filename,pathname] = uigetfile({'*.m'},'Choose the settings-function');
            if exist(fullfile(pathname,filename),'file')
                [obj.itinerary.settings_function{sInds}] = deal(char(regexp(filename,'.*(?=\.m)','match')));
            else
                disp('The settings-function selection was invalid.');
            end
            cd(mypwd);
            obj.refresh_gui_main;
        end
        %% pushbuttonSettingsDown_Callback
        %
        function obj = pushbuttonSettingsDown_Callback(obj,~,~)
            %%
            % What follows below might have a more elegant solution.
            % essentially all selected rows are moved down 1.
            myGroupOrder = obj.itinerary.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            pInd = obj.itinerary.ind_position{gInd};
            pInd = pInd(1);
            if max(obj.pointerSettings) == obj.itinerary.number_settings(pInd);
                return
            end
            currentOrder = 1:obj.itinerary.number_settings(pInd); % what the table looks like now
            movingSettings = obj.pointerSettings+1; % where the selected rows want to go
            reactingSettings = setdiff(currentOrder,obj.pointerSettings); % the rows that are not moving
            fillmeinArray = zeros(1,length(currentOrder)); % a vector to store the new order
            fillmeinArray(movingSettings) = obj.pointerSettings; % the selected rows are moved
            fillmeinArray(fillmeinArray==0) = reactingSettings; % the remaining rows are moved
            % use the fillmeinArray to rearrange the settings
            obj.itinerary.order_settings{pInd} = obj.itinerary.order_settings{pInd}(fillmeinArray);
            obj.pointerSettings = movingSettings;
            obj.itinerary.mirrorSettings(pInd,gInd);
            obj.refresh_gui_main;
        end
        %% pushbuttonSettingsUp_Callback
        %
        function obj = pushbuttonSettingsUp_Callback(obj,~,~)
            %%
            % What follows below might have a more elegant solution.
            % essentially all selected rows are moved up 1. This will only work
            % if all positions have the same settings
            myGroupOrder = obj.itinerary.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            pInd = obj.itinerary.ind_position{gInd};
            pInd = pInd(obj.pointerPosition(1));
            if min(obj.pointerSettings) == 1
                return
            end
            currentOrder = 1:obj.itinerary.number_settings(pInd); % what the table looks like now
            movingSettings = obj.pointerSettings-1; % where the selected rows want to go
            reactingSettings = setdiff(currentOrder,obj.pointerSettings); % the rows that are not moving
            fillmeinArray = zeros(1,length(currentOrder)); % a vector to store the new order
            fillmeinArray(movingSettings) = obj.pointerSettings; % the selected rows are moved
            fillmeinArray(fillmeinArray==0) = reactingSettings; % the remaining rows are moved
            % use the fillmeinArray to rearrange the settings
            obj.itinerary.order_settings{pInd} = obj.itinerary.order_settings{pInd}(fillmeinArray);
            obj.pointerSettings = movingSettings;
            obj.itinerary.mirrorSettings(pInd,gInd);
            obj.refresh_gui_main;
        end
        %% pushbuttonSettingsZLower_Callback
        %
        function obj = pushbuttonSettingsZLower_Callback(obj,~,~)
            myGroupOrder = obj.itinerary.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            pInd = obj.itinerary.ind_position{gInd};
            pInd = pInd(obj.pointerPosition(1));
            mySettingsOrder = obj.itinerary.ind_settings{pInd};
            sInd = mySettingsOrder(obj.pointerSettings);
            obj.microscope.getXYZ;
            xyz = obj.microscope.pos;
            if strcmp(smdaPilot.microscope.core.getProperty(smdaPilot.microscope.AutoFocusDevice,'Status'),'On')
                currentPFS = str2double(smdaPilot.microscope.core.getProperty(smdaPilot.microscope.AutoFocusDevice,'Position'));
                offset = obj.itinerary.position_continuous_focus_offset(pInd) - currentPFS;
            else
                offset = obj.itinerary.position_xyz(pInd,3)-xyz(3);
            end
            if offset <0
                obj.itinerary.settings_z_stack_lower_offset(sInd) = 0;
            else
                obj.itinerary.settings_z_stack_lower_offset(sInd) = -offset;
            end
            obj.refresh_gui_main;
        end
        %% pushbuttonSettingsZUpper_Callback
        %
        function obj = pushbuttonSettingsZUpper_Callback(obj,~,~)
            myGroupOrder = obj.itinerary.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            pInd = obj.itinerary.ind_position{gInd};
            pInd = pInd(obj.pointerPosition(1));
            mySettingsOrder = obj.itinerary.ind_settings{pInd};
            sInd = mySettingsOrder(obj.pointerSettings);
            obj.microscope.getXYZ;
            xyz = obj.microscope.pos;
            if strcmp(smdaPilot.microscope.core.getProperty(smdaPilot.microscope.AutoFocusDevice,'Status'),'On')
                currentPFS = str2double(smdaPilot.microscope.core.getProperty(smdaPilot.microscope.AutoFocusDevice,'Position'));
                offset = currentPFS - obj.itinerary.position_continuous_focus_offset(pInd);
            else
                offset = xyz(3)-obj.itinerary.position_xyz(pInd,3);
            end
            if offset <0
                obj.itinerary.settings_z_stack_upper_offset(sInd) = 0;
            else
                obj.itinerary.settings_z_stack_upper_offset(sInd) = offset;
            end
            obj.refresh_gui_main;
        end
        %% General Methods
        % 
        %%
        %
        function obj = createOrdinalLabels(obj,varargin)
            p = inputParser;
            addRequired(p, 'obj', @(x) isa(x,'travelagent_class'));
            parse(p,obj,varargin{:});
            for i = obj.itinerary.ind_group
                counter = 1;
                for j = obj.itinerary.order_position{i}
                    obj.itinerary.position_label{j} = sprintf('position%d',counter);
                    counter = counter + 1;
                end
            end
        end
        %%
        %
        function obj = refresh_gui_main(obj)
            handles = guidata(obj.gui_main);
            %% Region 1
            %
            %% Time elements
            %
            set(handles.editFundamentalPeriod,'String',num2str(obj.itinerary.fundamental_period/obj.uot_conversion));
            set(handles.editDuration,'String',num2str(obj.itinerary.duration/obj.uot_conversion));
            set(handles.editNumberOfTimepoints,'String',num2str(obj.itinerary.number_of_timepoints));
            %% Output Directory
            %
            set(handles.editOutputDirectory,'String',obj.itinerary.output_directory);
            %% Region 2
            %
            %% Group Table
            % Show the data in the itinerary |group_order| property
            tableGroupData = cell(obj.itinerary.number_group,...
                length(get(handles.tableGroup,'ColumnName')));
            n=1;
            for i = obj.itinerary.order_group
                tableGroupData{n,1} = obj.itinerary.group_label{i};
                tableGroupData{n,2} = i;
                tableGroupData{n,3} = obj.itinerary.number_position(i);
                tableGroupData{n,4} = obj.itinerary.group_function_before{i};
                tableGroupData{n,5} = obj.itinerary.group_function_after{i};
                n = n + 1;
            end
            set(handles.tableGroup,'Data',tableGroupData);
            %% Region 3
            %
            %% Position Table
            % Show the data in the itinerary |position_order| property for a given
            % group
            myGroupOrder = obj.itinerary.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            myPositionOrder = obj.itinerary.order_position{gInd};
            if isempty(myPositionOrder)
                set(handles.tablePosition,'Data',cell(1,10));
            else
                tablePositionData = cell(length(myPositionOrder),...
                    length(get(handles.tablePosition,'ColumnName')));
                n=1;
                for i = myPositionOrder
                    tablePositionData{n,1} = obj.itinerary.position_label{i};
                    tablePositionData{n,2} = i;
                    tablePositionData{n,3} = obj.itinerary.position_xyz(i,1);
                    tablePositionData{n,4} = obj.itinerary.position_xyz(i,2);
                    tablePositionData{n,5} = obj.itinerary.position_xyz(i,3);
                    if obj.itinerary.position_continuous_focus_bool(i)
                        tablePositionData{n,6} = 'yes';
                    else
                        tablePositionData{n,6} = 'no';
                    end
                    tablePositionData{n,7} = obj.itinerary.position_continuous_focus_offset(i);
                    tablePositionData{n,8} = obj.itinerary.position_function_before{i};
                    tablePositionData{n,9} = obj.itinerary.position_function_after{i};
                    tablePositionData{n,10} = obj.itinerary.number_settings(i);
                    n = n + 1;
                end
                set(handles.tablePosition,'Data',tablePositionData);
            end
            %% Region 4
            %
            %% Settings Table
            % Show the prototype_settings
            pInd = obj.itinerary.order_position{gInd}(1);
            mySettingsOrder = obj.itinerary.order_settings{pInd};
            if isempty(mySettingsOrder)
                set(handles.tableSettings,'Data',cell(1,11));
            else
                tableSettingsData = cell(length(mySettingsOrder),...
                    length(get(handles.tableSettings,'ColumnName')));
                n=1;
                for i = mySettingsOrder
                    tableSettingsData{n,1} = obj.itinerary.channel_names{obj.itinerary.settings_channel(i)};
                    tableSettingsData{n,2} = obj.itinerary.settings_exposure(i);
                    tableSettingsData{n,3} = obj.itinerary.settings_binning(i);
                    tableSettingsData{n,4} = obj.itinerary.settings_z_step_size(i);
                    tableSettingsData{n,5} = obj.itinerary.settings_z_stack_upper_offset(i);
                    tableSettingsData{n,6} = obj.itinerary.settings_z_stack_lower_offset(i);
                    tableSettingsData{n,7} = length(obj.itinerary.settings_z_stack_lower_offset(i)...
                        :obj.itinerary.settings_z_step_size(i)...
                        :obj.itinerary.settings_z_stack_upper_offset(i));
                    tableSettingsData{n,8} = obj.itinerary.settings_z_origin_offset(i);
                    tableSettingsData{n,9} = obj.itinerary.settings_period_multiplier(i);
                    tableSettingsData{n,10} = obj.itinerary.settings_function{i};
                    tableSettingsData{n,11} = i;
                    n = n + 1;
                end
                set(handles.tableSettings,'Data',tableSettingsData);
            end
        end
        %% delete
        % for a clean delete make sure the objects that are stored as
        % properties are also deleted.
        function delete(obj)
            delete(obj.gui_main);
        end
        %%
        %
        function obj = addPositionGrid(obj,gInd,grid)
            %%
            %
            p = inputParser;
            addRequired(p, 'obj', @(x) isa(x,'travelagent_class'));
            addRequired(p, 'gInd', @(x) ismember(x,obj.itinerary.ind_group));
            addRequired(p, 'grid', @(x) isstruct(x));
            parse(p,obj,gInd,grid);
            
            if  obj.itinerary.number_position(gInd) == 1
                %replace the first position when assigning grid numbers if only 1
                %position exists. It is assumed this was the default/place-holder
                %position.
                myposition_labels = grid.position_labels; %when cells are embedded into structs MATLAB grinds to a halt
                pInd = obj.itinerary.ind_position{gInd};
                obj.itinerary.position_xyz(pInd,:) = grid.positions(1,:);
                obj.itinerary.position_label{pInd} = myposition_labels{1};
                for i = 2:size(grid.positions,1)
                    pInd = obj.itinerary.newPosition;
                    obj.itinerary.connectGPS('g',gInd,'p',pInd,'s',obj.itinerary.order_settings{1});
                    obj.itinerary.position_xyz(pInd,:) = grid.positions(i,:);
                    obj.itinerary.position_label{pInd} = myposition_labels{i};
                end
            else
                %else, append grid to exisiting positions
                myposition_labels = grid.position_labels; %when cells are embedded into structs MATLAB grinds to a halt
                for i = 1:size(grid.positions,1)
                    pInd = obj.itinerary.newPosition;
                    obj.itinerary.connectGPS('g',gInd,'p',pInd,'s',obj.itinerary.order_settings{1});
                    obj.itinerary.position_xyz(pInd,:) = grid.positions(i,:);
                    obj.itinerary.position_label{pInd} = myposition_labels{i};
                end
            end
        end
    end
end