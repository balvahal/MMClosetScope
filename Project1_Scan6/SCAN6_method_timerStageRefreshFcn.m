function [] = SCAN6_method_timerStageRefreshFcn(scan6)
mm = scan6.mm;
imageHeight = mm.core.getPixelSizeUm*mm.core.getImageHeight;
imageWidth = mm.core.getPixelSizeUm*mm.core.getImageWidth;

mm.getXYZ;
x = mm.pos(1);
y = mm.pos(2);
handles = guidata(scan6.gui_axes);
set(handles.rectangleCurrentPosition,'Position',[x,y,imageWidth,imageHeight]);
end