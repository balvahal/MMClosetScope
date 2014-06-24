function obj = SuperMDATravelAgent_method_dropPositionOrder(obj,gInd,dropInd)
p = inputParser;
addRequired(p, 'obj', @(x) isa(x,'SuperMDATravelAgent_object'));
addRequired(p, 'gInd', @(x) isrow(x) && all(ismember(x,1:length(obj.itinerary.group))));
addRequired(p, 'dropInd', @(x) isrow(x) && all(ismember(x,obj.itinerary.group(gInd).position_order)));
parse(p,obj,gInd,dropInd);
p = inputParser;
addRequired(p, 'obj', @(x) isa(x,'SuperMDATravelAgent_object'));
addRequired(p, 'dropInd', @(x) isrow(x) && all(ismember(x,obj.itinerary.group_order)));
parse(p,obj,dropInd);
dropInd2 = obj.itinerary.group(gInd).position_order(dropInd);
obj.itinerary.group(gInd).position(dropInd2) = [];
obj.itinerary.group(gInd).position_order(dropInd) = [];
%%
% Next, edit the group_order so that the numbers within are sequential
% (although not necessarily in order).
subVector = zeros(size(obj.intinerary.group(gInd).position_order));
for i=1:length(dropInd2)
    subVector(obj.itinerary.group(gInd).position_order >= dropInd2(i)) = subVector(obj.itinerary.group(gInd).position_order >= dropInd2(i))-1;
end
obj.itinerary.group(gInd).position_order = obj.itinerary.group(gInd).position_order + subVector;
end