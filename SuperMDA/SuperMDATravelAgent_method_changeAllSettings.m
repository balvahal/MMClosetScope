function obj = SuperMDATravelAgent_method_changeAllSettings(obj,param,val,varargin)
%% validate inputs
%
namesOfParameters = {'binning',...
    'channel',...
    'gain',...
    'settings_function_name',...
    'settings_function_after_name',...
    'settings_function_before_name',...
    'exposure',...
    'period_multiplier',...
    'timepoints',...
    'user_data',...
    'z_origin_offset',...
    'z_stack',...
    'z_stack_upper_offset',...
    'z_stack_lower_offset',...
    'z_step_size'};

p = inputParser;
addRequired(p, 'obj', @(x) isa(x,'SuperMDATravelAgent_object'));
addRequired(p, 'param', @(x) any(strcmp(x,namesOfParameters)));
addRequired(p, 'val', @(x) true);
addOptional(p, 'gInd',1, @(x) isrow(x) && all(ismember(x,1:length(obj.itinerary.group))));
addOptional(p, 'pInd',[], @(x) isrow(x) || iscell(x));
parse(p,obj,param,val,varargin{:});
gInd = p.Results.gInd;
if isempty(p.Results.pInd)
    pInd = cell(size(gInd));
    for i = 1:length(gInd)
        pInd{i} = 1:length(obj.itinerary.group(gInd(i)).position);
    end
elseif ~iscell(p.Results.pInd)
    pInd{1} = p.Results.pInd;
end
if ~inputCheckPInd(obj,gInd,pInd)
    error('smdaTA:chngAll','The position index is not consistent with the group struct.');
end

%%
%
switch p.Results.param
    case 'binning'
        for i = 1:length(gInd)
            for j = pInd{i}
                for k = obj.itinerary.group(gInd(i)).position(j).settings_order
                    obj.itinerary.group(gInd(i)).position(j).settings(k).binning = p.Results.val;
                end
            end
        end
    case 'channel'
        for i = 1:length(gInd)
            for j = pInd{i}
                for k = obj.itinerary.group(gInd(i)).position(j).settings_order
                    obj.itinerary.group(gInd(i)).position(j).settings(k).channel = p.Results.val;
                end
            end
        end
    case 'gain'
        for i = 1:length(gInd)
            for j = pInd{i}
                for k = obj.itinerary.group(gInd(i)).position(j).settings_order
                    obj.itinerary.group(gInd(i)).position(j).settings(k).gain = p.Results.val;
                end
            end
        end
    case 'settings_function_name'
        for i = 1:length(gInd)
            for j = pInd{i}
                for k = obj.itinerary.group(gInd(i)).position(j).settings_order
                    obj.itinerary.group(gInd(i)).position(j).settings(k).settings_function_name = p.Results.val;
                end
            end
        end
    case 'settings_function_after_name'
        for i = 1:length(gInd)
            for j = pInd{i}
                for k = obj.itinerary.group(gInd(i)).position(j).settings_order
                    obj.itinerary.group(gInd(i)).position(j).settings(k).settings_function_after_name = p.Results.val;
                end
            end
        end
    case 'settings_function_before_name'
        for i = 1:length(gInd)
            for j = pInd{i}
                for k = obj.itinerary.group(gInd(i)).position(j).settings_order
                    obj.itinerary.group(gInd(i)).position(j).settings(k).settings_function_before_name = p.Results.val;
                end
            end
        end
    case 'exposure'
        for i = 1:length(gInd)
            for j = pInd{i}
                for k = obj.itinerary.group(gInd(i)).position(j).settings_order
                    obj.itinerary.group(gInd(i)).position(j).settings(k).exposure = p.Results.val;
                end
            end
        end
    case 'period_multiplier'
        for i = 1:length(gInd)
            for j = pInd{i}
                for k = obj.itinerary.group(gInd(i)).position(j).settings_order
                    obj.itinerary.group(gInd(i)).position(j).settings(k).period_multiplier = p.Results.val;
                end
            end
        end
    case 'timepoints'
        for i = 1:length(gInd)
            for j = pInd{i}
                for k = obj.itinerary.group(gInd(i)).position(j).settings_order
                    obj.itinerary.group(gInd(i)).position(j).settings(k).timepoints = p.Results.val;
                end
            end
        end
    case 'user_data'
        for i = 1:length(gInd)
            for j = pInd{i}
                for k = obj.itinerary.group(gInd(i)).position(j).settings_order
                    obj.itinerary.group(gInd(i)).position(j).settings(k).user_data = p.Results.val;
                end
            end
        end
    case 'z_origin_offset'
        for i = 1:length(gInd)
            for j = pInd{i}
                for k = obj.itinerary.group(gInd(i)).position(j).settings_order
                    obj.itinerary.group(gInd(i)).position(j).settings(k).z_origin_offset = p.Results.val;
                end
            end
        end
    case 'z_stack'
        for i = 1:length(gInd)
            for j = pInd{i}
                for k = obj.itinerary.group(gInd(i)).position(j).settings_order
                    obj.itinerary.group(gInd(i)).position(j).settings(k).z_stack = p.Results.val;
                end
            end
        end
    case 'z_stack_upper_offset'
        for i = 1:length(gInd)
            for j = pInd{i}
                for k = obj.itinerary.group(gInd(i)).position(j).settings_order
                    obj.itinerary.group(gInd(i)).position(j).settings(k).z_stack_upper_offset = p.Results.val;
                end
            end
        end
    case 'z_stack_lower_offset'
        for i = 1:length(gInd)
            for j = pInd{i}
                for k = obj.itinerary.group(gInd(i)).position(j).settings_order
                    obj.itinerary.group(gInd(i)).position(j).settings(k).z_stack_lower_offset = p.Results.val;
                end
            end
        end
    case 'z_step_size'
        for i = 1:length(gInd)
            for j = pInd{i}
                for k = obj.itinerary.group(gInd(i)).position(j).settings_order
                    obj.itinerary.group(gInd(i)).position(j).settings(k).z_step_size = p.Results.val;
                end
            end
        end
end
end

function logicOut = inputCheckPInd(obj,gInd,pInd)
logicOut = true;
for i = 1:length(pInd)
    if isrow(pInd{i}) && all(ismember(pInd{i},1:length(obj.itinerary.group(gInd(i)).position)))
        logicOut = false;
    end
end
end