function obj = SuperMDATravelAgent_method_changeAllPosition(obj,param,val,varargin)
%% validate inputs
%
namesOfParameters = {'continuous_focus_offset',...
    'continuous_focus_bool',...
    'label',...
    'position_function_after_name',...
    'position_function_before_name',...
    'settings_order',...
    'user_data',...
    'xyz',...
    'settings'};

p = inputParser;
addRequired(p, 'obj', @(x) isa(x,'SuperMDATravelAgent_object'));
addRequired(p, 'param', @(x) any(strcmp(x,namesOfParameters)));
addRequired(p, 'val', @(x) true);
addOptional(p, 'gInd',1, @(x) isrow(x) && all(ismember(x,1:length(obj.itinerary.group))));
parse(p,obj,param,val,varargin{:});
gInd = p.Results.gInd;
%%
%
switch p.Results.param
    case 'continuous_focus_offset'
        for i = 1:length(gInd)
            for j=obj.itinerary.group(gInd(i)).position_order
                obj.itinerary.group(gInd(i)).position(j).continuous_focus_offset = p.Results.val;
            end
        end
    case 'continuous_focus_bool'
        for i = 1:length(gInd)
            for j=obj.itinerary.group(gInd(i)).position_order
                obj.itinerary.group(gInd(i)).position(j).continuous_focus_bool = p.Results.val;
            end
        end
    case 'label'
        for i = 1:length(gInd)
            for j=obj.itinerary.group(gInd(i)).position_order
                obj.itinerary.group(gInd(i)).position(j).label = p.Results.val;
            end
        end
    case 'position_function_after_name'
        for i = 1:length(gInd)
            for j=obj.itinerary.group(gInd(i)).position_order
                obj.itinerary.group(gInd(i)).position(j).position_function_after_name = p.Results.val;
            end
        end
    case 'position_function_before_name'
        for i = 1:length(gInd)
            for j=obj.itinerary.group(gInd(i)).position_order
                obj.itinerary.group(gInd(i)).position(j).position_function_before_name = p.Results.val;
            end
        end
    case 'settings_order'
        for i = 1:length(gInd)
            for j=obj.itinerary.group(gInd(i)).position_order
                obj.itinerary.group(gInd(i)).position(j).settings_order = p.Results.val;
            end
        end
    case 'user_data'
        for i = 1:length(gInd)
            for j=obj.itinerary.group(gInd(i)).position_order
                obj.itinerary.group(gInd(i)).position(j).user_data = p.Results.val;
            end
        end
    case 'xyz'
        for i = 1:length(gInd)
            for j=obj.itinerary.group(gInd(i)).position_order
                obj.itinerary.group(gInd(i)).position(j).xyz = p.Results.val;
            end
        end
    case 'settings'
        for i = 1:length(gInd)
            for j = obj.itinerary.group(gInd).position_order
                obj.itinerary.group(gInd(i)).position(j).settings = obj.itinerary.group(gInd).position(1).settings;
                obj.itinerary.group(gInd(i)).position(j).settings_order = obj.itinerary.group(gInd).position(1).settings_order;
            end
        end
end
end