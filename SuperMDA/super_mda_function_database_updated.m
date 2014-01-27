function [] = super_mda_function_database_updated(figUpdate,src,evnt)
handles = guidata(figUpdate);
imshow(evnt.mmhandle.I,[],'Parent',handles.axes_imageLastTaken);
SuperMDA = evnt.mmhandle.SuperMDA;
t = SuperMDA.runtime_index(1); %time
i = SuperMDA.runtime_index(2); %group
j = SuperMDA.runtime_index(3); %position
k = SuperMDA.runtime_index(4); %settings
mystr = sprintf('%s_s%d_w%d%s_t%d_z%d.png',SuperMDA.group(i).label,j,SuperMDA.group(i).position(j).settings(k).channel,SuperMDA.channel_names{SuperMDA.group(i).position(j).settings(k).channel},SuperMDA.runtime_index(1),SuperMDA.runtime_index(5));
title(mystr);