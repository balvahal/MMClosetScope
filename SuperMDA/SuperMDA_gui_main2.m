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

buttonSize = [100/ppChar(3) 75/ppChar(4)];
region1 = [0 705/ppChar(4)]; %175 pixels
region2 = [0 350/ppChar(4)]; %355 pixels
region3 = [0 175/ppChar(4)]; %175 pixels
region4 = [0 0];

%% Assemble Region 1
%
hpopupmenuUnitsOfTime = uicontrol('Style','popupmenu','Units','characters',...
    'FontSize',14,'FontName','Verdana',...
    'String',{'seconds','minutes','hours','days'},...
    'Position',[region1(1)+10/ppChar(3), region1(2)+12.5/ppChar(4), buttonSize(1),buttonSize(2)],...
    'Callback',{@popupmenuUnitsOfTime_Callback});

heditFundamentalPeriod = uicontrol('Style','edit','Units','characters',...
        'FontSize',14,'FontName','Verdana',...
    'String',num2str(smdaTA.itinerary.fundamental_period),...
    'Position',[region1(1)+10/ppChar(3), region1(2)+87.5/ppChar(4), buttonSize(1),buttonSize(2)],...
    'Callback',{@editFundamentalPeriod_Callback});

heditDuration = uicontrol('Style','edit','Units','characters',...
        'FontSize',14,'FontName','Verdana',...
    'String',num2str(smdaTA.itinerary.duration),...
    'Position',[region1(1)+120/ppChar(3), region1(2)+12.5/ppChar(4), buttonSize(1),buttonSize(2)],...
    'Callback',{@editDuration_Callback});

heditNumberOfTimepoints = uicontrol('Style','edit','Units','characters',...
        'FontSize',14,'FontName','Verdana',...
    'String',num2str(smdaTA.itinerary.number_of_timepoints),...
    'Position',[region1(1)+120/ppChar(3), region1(2)+87.5/ppChar(4), buttonSize(1),buttonSize(2)],...
    'Callback',{@editNumberOfTimepoints_Callback});
%% Construct the components
% The pause, stop, and resume buttons
hwidth = 100/ppChar(3);
hheight = 70/ppChar(4);
hx = 20/ppChar(3);
hygap = (fheight - 3*hheight)/4;
hy = fheight - (hygap + hheight);
hpushbuttonPause = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',[255 215 0]/255,...
    'String','Pause','Position',[hx hy hwidth hheight],...
    'Callback',{@pushbuttonPause_Callback});

hy = hy - (hygap + hheight);
hpushbuttonResume = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',[60 179 113]/255,...
    'String','Resume','Position',[hx hy hwidth hheight],...
    'Callback',{@pushbuttonResume_Callback});

hy = hy - (hygap + hheight);
hpushbuttonStop = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',[205 92 92]/255,...
    'String','Stop','Position',[hx hy hwidth hheight],...
    'Callback',{@pushbuttonStop_Callback});

align([hpushbuttonPause,hpushbuttonResume,hpushbuttonStop],'Center','None');
%%
% A text box showing the time until the next acquisition
hwidth = 250/ppChar(3);
hheight = 100/ppChar(4);
hx = (fwidth - (20/ppChar(3) + 100/ppChar(3) + hwidth))/2 + 20/ppChar(3) + 100/ppChar(3);
hygap = (fheight - hheight)/2;
hy = fheight - (hygap + hheight);
htextTime = uicontrol('Style','text','String','No Acquisition',...
    'Units','characters','FontSize',20,'FontWeight','bold',...
    'FontName','Courier New',...
    'Position',[hx hy hwidth hheight]);
%%
% store the uicontrol handles in the figure handles via guidata()
handles.popupmenuUnitsOfTime = hpopupmenuUnitsOfTime;
handles.editFundamentalPeriod = heditFundamentalPeriod;
handles.editDuration = heditDuration;
handles.editNumberOfTimepoints = heditNumberOfTimepoints;
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
end