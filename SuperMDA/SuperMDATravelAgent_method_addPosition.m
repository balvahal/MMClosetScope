%%
% Create a position by augmenting the position_order vector and taking
% advantage of the the pre-allocation, or create a new position built on
% the |Itinerary| prototypes.
function obj = SuperMDATravelAgent_method_addPosition(obj,gInd,varargin)
p = inputParser;
addRequired(p, 'obj', @(x) isa(x,'SuperMDATravelAgent_object'));
addRequired(p, 'gInd', @(x) ismember(x,1:length(obj.itinerary.group)));
addOptional(p, 'pNum',1, @(x) mod(x,1)==0);
parse(p,obj,gInd,varargin{:});

if p.Results.pNum == 1
obj.itinerary.group(gInd).position_order(end+1) = length(obj.itinerary.group(gInd).position_order)+1;
pInd = obj.itinerary.group(gInd).position_order(end);
if length(obj.itinerary.group(gInd).position_order) < length(obj.itinerary.group(gInd).position)
    % First check to see if a position has been preallocated, which means a
    % new position does not need to be created, only added to the
    % position_order vector.
    obj.mm.getXYZ;
    obj.itinerary.group(gInd).position(pInd).xyz = ones(obj.itinerary.number_of_timepoints,3);
    obj.itinerary.group(gInd).position(pInd).xyz(:,1) = obj.mm.pos(1);
    obj.itinerary.group(gInd).position(pInd).xyz(:,2) = obj.mm.pos(2);
    obj.itinerary.group(gInd).position(pInd).xyz(:,3) = obj.mm.pos(3);
    obj.itinerary.group(gInd).position(pInd).continuous_focus_offset = str2double(obj.mm.core.getProperty(obj.mm.AutoFocusDevice,'Position'));
    return
else
    %% Create a new position using the prototypes
    % update prototypes
    obj.itinerary.group(gInd).position(pInd) = obj.itinerary.group(gInd).position(1);
    obj.mm.getXYZ;
    obj.itinerary.group(gInd).position(pInd).xyz = ones(obj.itinerary.number_of_timepoints,3);
    obj.itinerary.group(gInd).position(pInd).xyz(:,1) = obj.mm.pos(1);
    obj.itinerary.group(gInd).position(pInd).xyz(:,2) = obj.mm.pos(2);
    obj.itinerary.group(gInd).position(pInd).xyz(:,3) = obj.mm.pos(3);
    obj.itinerary.group(gInd).position(pInd).continuous_focus_offset = str2double(obj.mm.core.getProperty(obj.mm.AutoFocusDevice,'Position'));
    %%
    % update the labels in this postion
    mystr = sprintf('position%d',length(obj.itinerary.group(gInd).position));
    obj.itinerary.group(gInd).position(end).label = mystr;
end
else
    obj.itinerary.group(gInd).position_order(end+1:end+p.Results.pNum) = ...
        (length(obj.itinerary.group(gInd).position_order)+1):(length(obj.itinerary.group(gInd).position_order)+p.Results.pNum);
    myDiff = length(obj.itinerary.group(gInd).position_order)...
        - length(obj.itinerary.group(gInd).position);
    if myDiff <= 0
        % then there are more settings pre-allocated than needed to expand
        % the group_order property
        return;
    else
        obj.itinerary.group(gInd).position(end+1:end+myDiff) = repmat(obj.itinerary.group(gInd).position(1),myDiff,1);
    end
end
end