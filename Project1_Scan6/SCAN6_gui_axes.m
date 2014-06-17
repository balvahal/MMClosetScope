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

textBackgroundColorRegion1 = [176 224 230]/255; %PowderBlue
buttonBackgroundColorRegion1 = [135 206 235]/255; %SkyBlue
textBackgroundColorRegion2 = [144 238 144]/255; %LightGreen
buttonBackgroundColorRegion2 = [50 205  50]/255; %LimeGreen
textBackgroundColorRegion3 = [255 250 205]/255; %LemonChiffon
buttonBackgroundColorRegion3 = [255 215 0]/255; %Gold
textBackgroundColorRegion4 = [255 192 203]/255; %Pink
buttonBackgroundColorRegion4 = [255 160 122]/255; %Salmon
buttonSize = [20 3.0769]; %[100/ppChar(3) 40/ppChar(4)];
region1 = [0 52]; %[0 676/ppChar(4)]; %180 pixels
region2 = [0 34]; %[0 442/ppChar(4)]; %180 pixels
region3 = [0 0]; %[0 182/ppChar(4)]; %370 pixels
region4 = [0 0]; %180 pixels

%% Assemble Region 4
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

%%
% store the uicontrol handles in the figure handles via guidata()
handles.axesStageMap = haxesStageMap;
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
        disp('hello');
        
    end
end
