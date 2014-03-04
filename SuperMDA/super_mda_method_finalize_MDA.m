%%
%
function [obj] = super_mda_method_finalize_MDA(obj)
%% Update the dependent parameters in the MDA object
% Some parameters in the MDA object are dependent on others.
% This dependency came about from combining parameters that are
% easy to configure by a user interface into data structures
% that are convenient to code with.
if isempty(obj.group_order) || ...
        ~isempty(setdiff(obj.group_order,(1:obj.my_length))) || ...
        length(obj.group_order)~=obj.my_length
    obj.group_order = (1:obj.my_length);
end
for i = 1:obj.my_length
    obj.group(i).group_function_before_handle = str2func(obj.group(i).group_function_before_name);
    if isempty(obj.group(i).position_order) || ...
            ~isempty(setdiff(obj.group(i).position_order,(1:obj.group(i).my_length))) || ...
            length(obj.group(i).position_order)~=obj.group(i).my_length
        obj.group(i).position_order = (1:obj.group(i).my_length);
    end
    if isempty(obj.group(i).label)
        mystr = sprintf('group%d',i);
        obj.group(i).label = mystr;
    end
    for j = 1:max(size(obj.group(i).position))
        obj.group(i).position(j).position_function_before_handle = str2func(obj.group(i).position(j).position_function_before_name);
        for k = 1:max(size(obj.group(i).position(j).settings))
            obj.group(i).position(j).settings(k).create_z_stack_list;
            obj.group(i).position(j).settings(k).settings_function_handle = str2func(obj.group(i).position(j).settings(k).settings_function_name);
        end
        obj.group(i).position(j).position_function_after_handle = str2func(obj.group(i).position(j).position_function_after_name);
        if isempty(obj.group(i).position(j).settings_order) || ...
                ~isempty(setdiff(obj.group(i).position(j).settings_order,(1:obj.group(i).position(j).my_length))) || ...
                length(obj.group(i).position(j).settings_order)~=obj.group(i).position(j).my_length
            obj.group(i).position(j).settings_order = (1:obj.group(i).position(j).my_length);
        end
    end
    obj.group(i).group_function_after_handle = str2func(obj.group(i).group_function_after_name);
end
obj.reflect_number_of_timepoints;
%% Calculate the number of images
% The number of images will be used to pre-allocate memory for the
% database. Without memory pre-allocation the SuperMDA will grind to a
% halt.
image_counter = 0;
for i = 1:obj.my_length
    for j = 1:max(size(obj.group(i).position))
        for k = 1:max(size(obj.group(i).position(j).settings))
           image_counter = image_counter + sum(obj.group(i).position(j).settings.timepoints);
        end
    end
end
%% Pre-allocate the database
%
pre_allocation_cell = {'channel name','filename','group label','position label',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'image description'};
pre_allocation_cell = repmat(pre_allocation_cell,image_counter,1);
obj.database = cell2table(pre_allocation_cell,'VariableNames',{'channel_name','filename','group_label','position_label','binning','channel_number','continuous_focus_offset','continuous_focus_bool','exposure','group_number','group_order','matlab_serial_date_number','position_number','position_order','settings_number','settings_order','timepoint','x','y','z','z_order','image_description'});
myfid = fopen(database_filename,'w');
fprintf(myfid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n','channel_name','filename','group_label','position_label','binning','channel_number','continuous_focus_offset','continuous_focus_bool','exposure','group_number','group_order','matlab_serial_date_number','position_number','position_order','settings_number','settings_order','timepoint','x','y','z','z_order','image_description');
fclose(myfid);
%%
% Save the SuperMDA in a text or xml format, so that it can be reloaded
% later on. SuperMDA is an object and objects don't necessarily load
% properly, especially if listeners are involved.
SuperMDAtable = table(...
    obj.number_of_timepoints,...
    {obj.output_directory},...
    obj.duration,...
    obj.fundamental_period,...
    'VariableNames',{'number_of_timepoints','output_directory','duration','fundamental_period'});
writetable(SuperMDAtable,fullfile(obj.output_directory,'SuperMDA_config.txt'),'Delimiter','\t');