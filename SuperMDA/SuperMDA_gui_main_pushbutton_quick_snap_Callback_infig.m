%%
%
function [] = SuperMDA_gui_main_pushbutton_quick_snap_Callback_infig(hObject)
handles = guidata(hObject);
%% Set all microscope settings for the image acquisition
% Set the microscope settings according to the settings at this position
t = handles.smda.runtime_index(1); %time
i = handles.smda.runtime_index(2); %group
j = handles.smda.runtime_index(3); %position
k = handles.smda.runtime_index(4); %settings
handles.mm.core.setConfig('Channel',handles.smda.channel_names{handles.smda.group(i).position(j).settings(k).channel});
handles.mm.core.setExposure(handles.mm.CameraDevice,handles.smda.group(i).position(j).settings(k).exposure(t));
%% Check to make sure the directory tree exists to store image files
%
pngpath = fullfile(handles.smda.output_directory,'quick_snap');
if ~isdir(pngpath)
    mkdir(pngpath);
end
%% Set PFS
%
if handles.smda.group(i).position(j).continuous_focus_bool
    handles.mm.core.setProperty(handles.mm.AutoFocusDevice,'Position',handles.smda.group(i).position(j).continuous_focus);
    handles.mm.core.setProperty(handles.mm.AutoFocusStatusDevice,'State','On')
    %% For each z-position
    %
    for h = 1:length(handles.smda.group(i).position(j).settings(k).z_stack)
        handles.smda.runtime_index(5) = h;
        %% Move the z-position
        %
        pos_z = handles.smda.group(i).position(j).settings(k).z_origin_offset + handles.smda.group(i).position(j).settings(k).z_stack(h)+handles.smda.group(i).position(j).continuous_focus;
        handles.mm.core.setProperty(handles.mm.AutoFocusDevice,'Position',pos_z);
        %% Snap and Image
        %
        handles.mm = Core_general_snapImage(handles.mm);
        filenamePNG = sprintf('%s_s%d_w%d%s_t%d_z%d.png',handles.smda.group(i).label,j,handles.smda.group(i).position(j).settings(k).channel,handles.smda.channel_names{handles.smda.group(i).position(j).settings(k).channel},handles.smda.runtime_index(1),handles.smda.runtime_index(5));
        imwrite(handles.mm.I,fullfile(pngpath,filenamePNG),'png','bitdepth',16);
        %% Update the database
        %
        image_description = '';
        handles.smda.update_database(filenamePNG,image_description);
    end
else
    handles.mm.core.setProperty(handles.mm.AutoFocusStatusDevice,'State','Off')
    %% For each z-position
    %
    for h = 1:length(handles.smda.group(i).position(j).settings(k).z_stack)
        handles.smda.runtime_index(5) = h;
        %% Move the z-position
        %
        pos_z = handles.smda.group(i).position(j).settings(k).z_origin_offset + handles.smda.group(i).position(j).settings(k).z_stack(h)+handles.smda.group(i).position(j).xyz(t,3);
        handles.mm = Core_general_setXYZ(handles.mm,pos_z,'direction','z');
        %% Snap and Image
        %
        handles.mm = Core_general_snapImage(handles.mm);
        filenamePNG = sprintf('%s_s%d_w%d%s_t%d_z%d.png',handles.smda.group(i).label,j,handles.smda.group(i).position(j).settings(k).channel,handles.smda.channel_names{handles.smda.group(i).position(j).settings(k).channel},handles.smda.runtime_index(1),handles.smda.runtime_index(5));
        imwrite(handles.mm.I,fullfile(pngpath,filenamePNG),'png','bitdepth',16);
        %% Update the database
        %
        image_description = '';
        handles.smda.update_database(filenamePNG,image_description);
    end
end
