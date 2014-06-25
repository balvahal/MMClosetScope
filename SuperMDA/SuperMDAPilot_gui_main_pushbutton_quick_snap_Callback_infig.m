%%
%
function [] = SuperMDA_gui_main_pushbutton_quick_snap_Callback_infig(hObject)
handles = guidata(hObject);
handles.quick_snap_count = handles.quick_snap_count+1;
%% Set all microscope settings for the image acquisition
% Set the microscope settings according to the settings at this position
i = handles.SuperMDA_index(1); %group
j = handles.SuperMDA_index(2); %position
k = handles.SuperMDA_index(3); %settings
handles.mm.core.setConfig('Channel',handles.smda.channel_names{handles.smda.group(i).position(j).settings(k).channel});
handles.mm.core.setExposure(handles.mm.CameraDevice,handles.smda.group(i).position(j).settings(k).exposure(1));
handles.mm.core.waitForSystem();
%% Check to make sure the directory tree exists to store image files
%
pngpath = fullfile(handles.smda.output_directory,'quick_snap');
if ~isdir(pngpath)
    mkdir(pngpath);
end
%% Snap and Image
%
handles.mm = Core_general_snapImage(handles.mm);
filenamePNG = sprintf('w%d%s_exp%d_t%d.png',handles.smda.group(i).position(j).settings(k).channel,handles.smda.channel_names{handles.smda.group(i).position(j).settings(k).channel},handles.smda.group(i).position(j).settings(k).exposure(1),handles.quick_snap_count);
imwrite(handles.mm.I,fullfile(pngpath,filenamePNG),'png','bitdepth',16);
guidata(hObject,handles);