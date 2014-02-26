%%
%
function [] = StageMap_gui_main_update(hObject)
handles = guidata(hObject);
cla(handles.axes_StageMap,'reset')
hold(handles.axes_StageMap,'on');
% plot the quadrangle shape of the image that will appear if a snap image
% is taken
my_pos = handles.mm.pos;
x1 = my_pos(1);
x2 = my_pos(1)+handles.imageWidth;
y1 = my_pos(2);
y2 = my_pos(2)+handles.imageHeight;
set(handles.axes_StageMap,'YDir','reverse');
xrange = handles.mm.xyStageLimits(2)-handles.mm.xyStageLimits(1);
yrange = handles.mm.xyStageLimits(4)-handles.mm.xyStageLimits(3);
set(handles.axes_StageMap,'XLim',[handles.mm.xyStageLimits(1)-0.05*xrange,handles.mm.xyStageLimits(2)+0.05*xrange]);
set(handles.axes_StageMap,'YLim',[handles.mm.xyStageLimits(3)-0.05*yrange,handles.mm.xyStageLimits(4)+0.05*yrange]);
set(handles.axes_StageMap,'XAxisLocation','top');
set(handles.axes_StageMap,'TickDir','out');
set(handles.axes_StageMap,'Box','on');
%fill([x1;x2;x2;x1],...
%    [y1;y1;y2;y2],...
%    [0,0,0],'LineWidth',1.5,'FaceColor','none','EdgeColor',[0 0 0]/255,'Parent',handles.axes_StageMap);
p2 = plot(handles.axes_StageMap,x1,y1,'+');
set(p2,'MarkerSize',8);
set(p2,'LineWidth',0.5);
set(p2,'MarkerEdgeColor',[0,0,0]/255);
p1 = plot(handles.axes_StageMap,x1,y1,'o');
set(p1,'MarkerSize',8);
set(p1,'LineWidth',2);
set(p1,'MarkerEdgeColor',[255,0,0]/255);
hold(handles.axes_StageMap,'off');