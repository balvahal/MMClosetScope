%% SCAN6_gui_main
% a simple gui to pause, stop, and resume a running MDA
function [f] = SCAN6_gui_axes(scan6)
%% Create the figure
%
myunits = get(0,'units');
set(0,'units','pixels');
Pix_SS = get(0,'screensize');
set(0,'units','characters');
Char_SS = get(0,'screensize');
ppChar = Pix_SS./Char_SS;
set(0,'units',myunits);
fwidth = 243; %1215/ppChar(3);
fheight = 70; %910/ppChar(4);
fx = Char_SS(3) - (Char_SS(3)*.1 + fwidth);
fy = Char_SS(4) - (Char_SS(4)*.1 + fheight);
f = figure('Visible','off','Units','characters','MenuBar','none','Position',[fx fy fwidth fheight],...
    'CloseRequestFcn',{@fDeleteFcn},'Name','Main');

%% Assemble the Map
%
%%
%
% Resize axes so that the width and height are the same ratio as the
% physical xy stage
xyLim = scan6.mm.xyStageLimits;
axesRatio = (0.9*fwidth*ppChar(3))/(0.9*fheight*ppChar(4)); % based on space set aside for the map on the gui
if (xyLim(2)- xyLim(1)) > (xyLim(4) - xyLim(3)) && (xyLim(2)- xyLim(1))/(xyLim(4) - xyLim(3)) >= axesRatio
    smapWidth = 0.9*fwidth*ppChar(3);
    smapHeight = smapWidth*(xyLim(4) - xyLim(3))/(xyLim(2)- xyLim(1));
else
    smapHeight = 0.9*fheight*ppChar(4);
    smapWidth = smapHeight*(xyLim(2) - xyLim(1))/(xyLim(4)- xyLim(3));
end
%convert from pixels to characters
smapWidth = round(smapWidth)/ppChar(3);
smapHeight = round(smapHeight)/ppChar(4);

haxesStageMap = axes(...    % Axes for plotting location of dishes/groups and positions
                 'Parent', f, ...
                 'Units', 'characters', ...
                 'HandleVisibility','callback', ...
                 'XLim',[xyLim(1) xyLim(2)],...
                 'YLim',[xyLim(3) xyLim(4)],...
                 'YDir','reverse',...
                 'TickDir','out',...
                 'Position',[(fwidth-smapWidth)/2, (fheight-smapHeight)/2, smapWidth,smapHeight],...
                 'ButtonDownFcn',{@axesStageMap_ButtonDownFcn});
%% Patches
% # current objective position
% # the perimeter of up to 6 dishes
% # the positions chosen for mda
mm = scan6.mm;
imageHeight = mm.core.getPixelSizeUm*mm.core.getImageHeight;
imageWidth = mm.core.getPixelSizeUm*mm.core.getImageWidth;

mm.getXYZ;
x1 = mm.pos(1);
x2 = mm.pos(1)+imageWidth;
y1 = mm.pos(2);
y2 = mm.pos(2)+imageHeight;
hpatchCurrentPosition = patch('Parent',haxesStageMap,...
    'XData',[x1;x2;x2;x1],...
    'YData',[y1;y1;y2;y2],...
    'ZData',ones(4,1),...
    'EdgeColor',[255 215 0]/255,...
    'LineWidth',2);
%%
% store the uicontrol handles in the figure handles via guidata()
handles.axesStageMap = haxesStageMap;
handles.patchCurrentPosition = hpatchCurrentPosition;
%handles.patchDishPerimeter = hpatchDishPerimeter;
%handles.patchSmdaPositions = hpatchSmdaPositions;
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
    function axesStageMap_ButtonDownFcn(a,b)
        disp('hello button push');
        
    end
end
