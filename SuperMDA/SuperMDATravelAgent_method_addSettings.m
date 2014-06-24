%%
% Create a position by augmenting the position_order vector and taking
% advantage of the the pre-allocation, or create a new position built on
% the |Itinerary| prototypes.
function obj = SuperMDATravelAgent_method_addSettings(obj,gInd,pInd)
obj.itinerary.group(gInd).position(pInd).settings_order(end+1) = length(obj.itinerary.group(gInd).position(pInd).settings_order)+1;
if length(obj.itinerary.group(gInd).position(pInd).settings_order) < length(obj.itinerary.group(gInd).position(pInd).settings)
    return
else
    obj.itinerary.group(gInd).position(pInd).settings(end+1) = obj.itinerary.group(gInd).position(pInd).settings(1);
end
end