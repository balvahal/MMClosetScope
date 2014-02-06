%%
%
function [] = StageMap_gui_main_update(hObject)
handles = guidata(hObject);
cla(handles.axes_StageMap,'reset')
hold(handles.axes_StageMap,'on');
% plot the quadrangle shape of the image that will appear if a snap image
% is taken
x1 = handles.mm.pos(1);
x2 = handles.mm.pos(1)+handles.imageWidth;
y1 = handles.mm.pos(2);
y2 = handles.mm.pos(2)+handles.imageHeight;
fill([x1;x2;x2;x1],...
    [y1;y1;y2;y2],...
    [0,0,0],'LineWidth',1.5,'FaceColor','none','EdgeColor',[255 215 0]/255,'Parent',handles.axes_StageMap);
set(handles.axes_StageMap,'YDir','reverse');
set(handles.axes_StageMap,'XLim',[handles.mm.xyStageLimits(1),handles.mm.xyStageLimits(2)]);
set(handles.axes_StageMap,'YLim',[handles.mm.xyStageLimits(3),handles.mm.xyStageLimits(4)]);
set(handles.axes_StageMap,'XAxisLocation','top');
set(handles.axes_StageMap,'TickDir','out');
hold(handles.axes_StageMap,'off');