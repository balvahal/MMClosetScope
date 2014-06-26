%%
% Create a group by augmenting the group_order vector and taking advantage
% of the the pre-allocation, or create a new group built on the |Itinerary|
% prototypes.
function obj = SuperMDATravelAgent_method_addGroup(obj,varargin)
p = inputParser;
addRequired(p, 'obj', @(x) isa(x,'SuperMDATravelAgent_object'));
addOptional(p,'gNum',1, @(x) mod(x,1)==0);
parse(p,obj,varargin{:});

if p.Results.gNum ==1
    obj.itinerary.group_order(end+1) = length(obj.itinerary.group_order)+1;
    if length(obj.itinerary.group_order) < length(obj.itinerary.group)
        % First check to see if a group has been preallocated, which means
        % a new group does not need to be created, only added to the
        % group_order vector.
        return
    else
        %% Create a new group using the prototypes
        % update prototypes
        obj.mm.getXYZ;
        %%
        % create a new group
        obj.itinerary.group(end+1) = obj.itinerary.group(1);
        obj.itinerary.group(end).position_order = 1;
        obj.itinerary.group(end).position(1).xyz = ones(obj.itinerary.number_of_timepoints,3);
        obj.itinerary.group(end).position(1).xyz(:,1) = obj.mm.pos(1);
        obj.itinerary.group(end).position(1).xyz(:,2) = obj.mm.pos(2);
        obj.itinerary.group(end).position(1).xyz(:,3) = obj.mm.pos(3);
        obj.itinerary.group(end).position(1).continuous_focus_offset = str2double(obj.mm.core.getProperty(obj.mm.AutoFocusDevice,'Position'));
        obj.createOrdinalLabels(length(obj.itinerary.group));
    end
else
    obj.itinerary.group_order(end+1:end+p.Results.gNum) = (length(obj.itinerary.group_order)+1):(length(obj.itinerary.group_order)+p.Results.gNum);
    myDiff = length(obj.itinerary.group_order) - length(obj.itinerary.group);
    if myDiff <= 0
        % then there are more groups pre-allocated than needed to expand
        % the group_order property
        return;
    else
        obj.itinerary.group(end+1:end+myDiff) = repmat(obj.itinerary.group(1),myDiff,1);
    end
end
end