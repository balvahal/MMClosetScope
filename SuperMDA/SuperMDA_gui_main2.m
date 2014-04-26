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
fwidth = 660/ppChar(3);
fheight = 880/ppChar(4);
fx = Char_SS(3) - (Char_SS(3)*.1 + fwidth);
fy = Char_SS(4) - (Char_SS(4)*.1 + fheight);
f = figure('Visible','off','Units','characters','MenuBar','none','Position',[fx fy fwidth fheight],...
    'CloseRequestFcn',{@fDeleteFcn},'Name','Main');

textBackgroundColor = [176 224 230]/255; %PowderBlue
buttonBackgroundColor = [216 191 216]/255; %Thistle
buttonSize = [100/ppChar(3) 40/ppChar(4)];
region1 = [0 705/ppChar(4)]; %175 pixels
region2 = [0 350/ppChar(4)]; %355 pixels
region3 = [0 175/ppChar(4)]; %175 pixels
region4 = [0 0];

%% Assemble Region 1
%
%% Time Info
%
hpopupmenuUnitsOfTime = uicontrol('Style','popupmenu','Units','characters',...
    'FontSize',14,'FontName','Verdana',...
    'String',{'seconds','minutes','hours','days'},...
    'Position',[region1(1)+10/ppChar(3), region1(2)+10/ppChar(4), buttonSize(1),buttonSize(2)],...
    'Callback',{@popupmenuUnitsOfTime_Callback});

uicontrol('Style','text','Units','characters','String','Units of Time',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColor,...
    'Position',[region1(1)+10/ppChar(3), region1(2)+(10+40+5)/ppChar(4), buttonSize(1),20/ppChar(4)]);

heditFundamentalPeriod = uicontrol('Style','edit','Units','characters',...
    'FontSize',14,'FontName','Verdana',...
    'String',num2str(smdaTA.itinerary.fundamental_period),...
    'Position',[region1(1)+10/ppChar(3), region1(2)+85/ppChar(4), buttonSize(1),buttonSize(2)],...
    'Callback',{@editFundamentalPeriod_Callback});

uicontrol('Style','text','Units','characters','String','Fundamental Period',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColor,...
    'Position',[region1(1)+10/ppChar(3), region1(2)+(130)/ppChar(4), buttonSize(1),35/ppChar(4)]);

heditDuration = uicontrol('Style','edit','Units','characters',...
    'FontSize',14,'FontName','Verdana',...
    'String',num2str(smdaTA.itinerary.duration),...
    'Position',[region1(1)+120/ppChar(3), region1(2)+10/ppChar(4), buttonSize(1),buttonSize(2)],...
    'Callback',{@editDuration_Callback});

uicontrol('Style','text','Units','characters','String','Duration',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColor,...
    'Position',[region1(1)+120/ppChar(3), region1(2)+(10+40+5)/ppChar(4), buttonSize(1),20/ppChar(4)]);

heditNumberOfTimepoints = uicontrol('Style','edit','Units','characters',...
    'FontSize',14,'FontName','Verdana',...
    'String',num2str(smdaTA.itinerary.number_of_timepoints),...
    'Position',[region1(1)+120/ppChar(3), region1(2)+85/ppChar(4), buttonSize(1),buttonSize(2)],...
    'Callback',{@editNumberOfTimepoints_Callback});

uicontrol('Style','text','Units','characters','String','Number of Timepoints',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColor,...
    'Position',[region1(1)+120/ppChar(3), region1(2)+(130)/ppChar(4), buttonSize(1),35/ppChar(4)]);
%% Output directory
%
heditOutputDirectory = uicontrol('Style','edit','Units','characters',...
    'FontSize',12,'FontName','Verdana','HorizontalAlignment','left',...
    'String',num2str(smdaTA.itinerary.output_directory),...
    'Position',[region1(1)+230/ppChar(3), region1(2)+10/ppChar(4), buttonSize(1)*3.5,buttonSize(2)],...
    'Callback',{@editOutputDirectory_Callback});

uicontrol('Style','text','Units','characters','String','Output Directory',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColor,...
    'Position',[region1(1)+230/ppChar(3), region1(2)+(10+40+5)/ppChar(4), buttonSize(1)*3.5,20/ppChar(4)]);

hpushbuttonOutputDirectory = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',20,'FontName','Verdana',...
    'String','...',...
    'Position',[region1(1)+(230+10)/ppChar(3)+buttonSize(1)*3.5, region1(2)+10/ppChar(4), buttonSize(1)*.5,buttonSize(2)],...
    'Callback',{@pushbuttonOutputDirectory_Callback});
%% Save or load current SuperMDAItinerary
%
hpushbuttonSave = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColor,...
    'String','Save',...
    'Position',[region1(1)+230/ppChar(3), region1(2)+85/ppChar(4), buttonSize(1),buttonSize(2)],...
    'Callback',{@pushbuttonSave_Callback});

uicontrol('Style','text','Units','characters','String','Save an Itinerary',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColor,...
    'Position',[region1(1)+230/ppChar(3), region1(2)+(130)/ppChar(4), buttonSize(1),35/ppChar(4)]);

hpushbuttonLoad = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColor,...
    'String','Load',...
    'Position',[region1(1)+340/ppChar(3), region1(2)+85/ppChar(4), buttonSize(1),buttonSize(2)],...
    'Callback',{@pushbuttonLoad_Callback});

uicontrol('Style','text','Units','characters','String','Load an Itinerary',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColor,...
    'Position',[region1(1)+340/ppChar(3), region1(2)+(130)/ppChar(4), buttonSize(1),35/ppChar(4)]);
%% Assemble Region 2
%

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
    function popupmenuUnitsOfTime_Callback(~,~)
        seconds2array = [1,60,3600,86400];
        smdaTA.uot_conversion = seconds2array(get(hpopupmenuUnitsOfTime,'Value'));
        smdaTA.refresh_gui_main;
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
end