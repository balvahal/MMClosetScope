%%
% Create a position by augmenting the position_order vector and taking
% advantage of the the pre-allocation, or create a new position built on
% the |Itinerary| prototypes.
function obj = SuperMDATravelAgent_method_addSettings(obj,gInd,pInd,varargin)
p = inputParser;
addRequired(p, 'obj', @(x) isa(x,'SuperMDATravelAgent_object'));
addRequired(p, 'gInd', @(x) ismember(x,1:length(obj.itinerary.group)));
addRequired(p, 'pInd', @(x) ismember(x,1:length(obj.itinerary.group(gInd).position)));
addOptional(p, 'sNum',1, @(x) mod(x,1)==0);
parse(p,obj,gInd,pInd,varargin{:});

if p.Results.sNum == 1
    obj.itinerary.group(gInd).position(pInd).settings_order(end+1) = length(obj.itinerary.group(gInd).position(pInd).settings_order)+1;
    if length(obj.itinerary.group(gInd).position(pInd).settings_order) < length(obj.itinerary.group(gInd).position(pInd).settings)
        return
    else
        obj.itinerary.group(gInd).position(pInd).settings(end+1) = obj.itinerary.group(gInd).position(pInd).settings(1);
    end
else
    obj.itinerary.group(gInd).position(pInd).settings_order(end+1:end+p.Results.sNum) = ...
        (length(obj.itinerary.group(gInd).position(pInd).settings_order)+1):(length(obj.itinerary.group(gInd).position(pInd).settings_order)+p.Results.sNum);
    myDiff = length(obj.itinerary.group(gInd).position(pInd).settings_order)...
        - length(obj.itinerary.group(gInd).position(pInd).settings);
    if myDiff <= 0
        % then there are more settings pre-allocated than needed to expand
        % the group_order property
        return;
    else
        obj.itinerary.group(gInd).position(pInd).settings(end+1:end+myDiff) = repmat(obj.itinerary.group(gInd).position(pInd).settings(1),myDiff,1);
    end
end
end