function [] = SCAN6_method_timerStageRefreshFcn(scan6)
mm = scan6.mm;
imageHeight = mm.core.getPixelSizeUm*mm.core.getImageHeight;
imageWidth = mm.core.getPixelSizeUm*mm.core.getImageWidth;

mm.getXYZ;
x1 = mm.pos(1);
x2 = mm.pos(1)+imageWidth;
y1 = mm.pos(2);
y2 = mm.pos(2)+imageHeight;
handles = guidata(scan6.gui_axes);
set(handles.patchCurrentPosition,...
    'XData',[x1;x2;x2;x1],...
    'YData',[y1;y1;y2;y2]);
end