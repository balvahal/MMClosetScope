%%
%
function [obj] = super_mda_method_finalize_MDA(obj)
%%
% initialize the table that will store the history of
% the MDA.
obj.database = table;

SuperMDAtable = table(...
    obj.number_of_timepoints,...
    {obj.output_directory},...
    obj.duration,...
    obj.fundamental_period,...
    'VariableNames',{'number_of_timepoints','output_directory','duration','fundamental_period'});
writetable(SuperMDAtable,fullfile(obj.output_directory,'SuperMDA_config.txt'),'Delimiter','\t');
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