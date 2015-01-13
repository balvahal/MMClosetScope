function [] = SCAN6_timer_function(scan6)
%% Map Refresh
% refresh the map every second
if scan6.mapRefreshCounter > 25 %1 second b/c period is 1/25 of a second.
    scan6.mapRefreshCounter = 1;
    mm = scan6.mm;
    imageHeight = mm.core.getPixelSizeUm*mm.core.getImageHeight;
    imageWidth = mm.core.getPixelSizeUm*mm.core.getImageWidth;
    try
        mm.getXYZ;
    catch
        return
    end
    x = mm.pos(1);
    y = mm.pos(2);
    handles = guidata(scan6.gui_axes);
    set(handles.rectangleCurrentPosition,'Position',[x-imageWidth/2,y-imageHeight/2,imageWidth,imageHeight]);
    set(handles.patchCurrentPosition1,'XData',x,'YData',y);
    set(handles.patchCurrentPosition2,'XData',x,'YData',y);
    
    handles2 = guidata(scan6.gui_main);
    set(handles2.rectangleCurrentPosition,'Position',[x-imageWidth/2,y-imageHeight/2,imageWidth,imageHeight]);
    set(handles2.patchCurrentPosition1,'XData',x,'YData',y);
    set(handles2.patchCurrentPosition2,'XData',x,'YData',y);
else
    scan6.mapRefreshCounter = scan6.mapRefreshCounter + 1;
end
%% Read the gamepad
%
scan6.gamepad.read;