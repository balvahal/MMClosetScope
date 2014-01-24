function [] = super_mda_function_database_updated(figUpdate,src,evnt)
handles = guidata(figUpdate);
imshow(evnt.I,[],'Parent',handles.axes_imageLastTaken);