%% SuperMDA_gui_pause_stop_resume
% a simple gui to pause, stop, and resume a running MDA
function [f] = SuperMDA_gui_lastImage(smdaPilot)
Isize = size(smdaPilot.mm.I);
Iheight = Isize(1);
Iwidth = Isize(2);
if Iwidth > Iheight
    hwidth = 768;
    hheight = 768*Iheight/Iwidth;
else
    hheight = 768;
    hwidth = 768*Iwidth/Iheight;
end
%% Create the figure
%
myunits = get(0,'units');
set(0,'units','pixels');
Pix_SS = get(0,'screensize');
set(0,'units','characters');
Char_SS = get(0,'screensize');
ppChar = Pix_SS./Char_SS;
set(0,'units',myunits);
fwidth = 768/ppChar(3);
fheight = 768/ppChar(4);
fx = Char_SS(3) - (Char_SS(3)*.1 + fwidth);
fy = Char_SS(4) - (Char_SS(4)*.1 + fheight);
%% Create the figure
%
mycolormap = colormap(jet(255));
f = figure('Visible','off','Units','characters','MenuBar','none','Position',[fx fy fwidth fheight],...
    'Colormap',mycolormap,'CloseRequestFcn',{@fDeleteFcn});
%% Add an axes for the image
%
hwidth = hwidth/ppChar(3);
hheight = hheight/ppChar(4);
hx = (fwidth - hwidth)/2;
hy = (fheight - hheight)/2;
haxesLastImage = axes('Units','characters','DrawMode','fast',...
    'Position',[hx hy hwidth  hheight],'YDir','reverse','Visible','off',...
    'XLim',[1,Iwidth],'YLim',[1,Iheight]);
%% add the image object
%
sourceImage = image('Parent',haxesLastImage,'CData',smdaPilot.mm.I);
%%
% store the uicontrol handles in the figure handles via guidata()
handles.axesLastImage = haxesLastImage;
handles.I = sourceImage;
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
end