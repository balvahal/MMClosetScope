function obj = SuperMDATravelAgent_method_dropPosition(obj,gInd,dropInd)
p = inputParser;
addRequired(p, 'obj', @(x) isa(x,'SuperMDATravelAgent_object'));
addRequired(p, 'gInd', @(x) isrow(x) && all(ismember(x,1:length(obj.itinerary.group))));
addRequired(p, 'dropInd', @(x) isrow(x) && all(ismember(x,1:length(obj.itinerary.group(gInd).position))));
parse(p,obj,gInd,dropInd);

dropInd2 = obj.itinerary.group(gInd).position_order == dropInd;
obj.itinerary.group(gInd).position(dropInd) = [];
obj.itinerary.group(gInd).position_order(dropInd2) = [];
%%
% Next, edit the group_order so that the numbers within are sequential
% (although not necessarily in order).
subVector = zeros(size(obj.intinerary.group(gInd).position_order));
for i=1:length(dropInd)
    subVector(obj.itinerary.group(gInd).position_order >= dropInd(i)) = subVector(obj.itinerary.group(gInd).position_order >= dropInd(i))-1;
end
obj.itinerary.group(gInd).position_order = obj.itinerary.group(gInd).position_order + subVector;
end