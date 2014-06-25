function obj = SuperMDATravelAgent_method_changeAllGroup(obj,param,val,varargin)
%% validate inputs
%
namesOfParameters = {'label',...
    'group_function_after_name',...
    'group_function_before_name',...
    'position_order',...
    'user_data',...
    'position'};

p = inputParser;
addRequired(p, 'obj', @(x) isa(x,'SuperMDATravelAgent_object'));
addRequired(p, 'param', @(x) any(strcmp(x,namesOfParameters)));
addRequired(p, 'val', @(x) true);
parse(p,obj,param,val,varargin{:});
%%
%
switch p.Results.param
    case 'label'
        for i=obj.itinerary.group_order
            obj.itinerary.group(i).label = p.Results.val;
        end
    case 'group_function_after_name'
        for i=obj.itinerary.group_order
            obj.itinerary.group(i).group_function_after_name = p.Results.val;
        end
    case 'group_function_before_name'
        for i=obj.itinerary.group_order
            obj.itinerary.group(i).group_function_before_name = p.Results.val;
        end
    case 'position_order'
        for i=obj.itinerary.group_order
            obj.itinerary.group(i).position_order = p.Results.val;
        end
    case 'user_data'
        for i=obj.itinerary.group_order
            obj.itinerary.group(i).user_data = p.Results.val;
        end
    case 'position'
        for i=obj.itinerary.group_order
            obj.itinerary.group(i).position = obj.itinerary.group(1).position;
        end
end