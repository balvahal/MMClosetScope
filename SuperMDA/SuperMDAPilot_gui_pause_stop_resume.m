%% SuperMDAPilot_gui_pause_stop_resume
% a simple gui to pause, stop, and resume a running MDA
function [f] = SuperMDAPilot_gui_pause_stop_resume(smdaPilot)
%% Create the figure
%
myunits = get(0,'units');
set(0,'units','pixels');
Pix_SS = get(0,'screensize');
set(0,'units','characters');
Char_SS = get(0,'screensize');
ppChar = Pix_SS./Char_SS;
set(0,'units',myunits);
fwidth = 450/ppChar(3);
fheight = 300/ppChar(4);
fx = Char_SS(3) - (Char_SS(3)*.1 + fwidth);
fy = Char_SS(4) - (Char_SS(4)*.1 + fheight);
f = figure('Visible','off','Units','characters','MenuBar','none','Position',[fx fy fwidth fheight],...
    'CloseRequestFcn',{@fDeleteFcn},'Name','Pause Stop Resume');
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
handles.textTime = htextTime;
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
        smdaPilot.delete;
    end
%%
%
    function pushbuttonPause_Callback(~,~)
        smdaPilot.pause_acquisition;
    end
%%
%
    function pushbuttonResume_Callback(~,~)
        smdaPilot.resume_acquisition;
    end
%%
%
    function pushbuttonStop_Callback(~,~)
        smdaPilot.stop_acquisition;
    end
end