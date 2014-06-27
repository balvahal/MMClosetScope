function obj = SuperMDATravelAgent_method_dropSettingsOrder(obj,gInd,pInd,dropInd)
p = inputParser;
addRequired(p, 'obj', @(x) isa(x,'SuperMDATravelAgent_object'));
addRequired(p, 'gInd', @(x) isrow(x) && all(ismember(x,1:length(obj.itinerary.group))));
addRequired(p, 'pInd', @(x) isrow(x) && all(ismember(x,1:length(obj.itinerary.group(gInd).position))));
addRequired(p, 'dropInd', @(x) isrow(x) && all(ismember(x,obj.itinerary.group(gInd).position(pInd).settings_order)));
parse(p,obj,gInd,pInd,dropInd);
dropInd2 = obj.itinerary.group(gInd).position(pInd).settings_order(dropInd);
obj.itinerary.group(gInd).position(pInd).settings(dropInd2) = [];
obj.itinerary.group(gInd).position(pInd).settings_order(dropInd) = [];
%%
% 
subVector = zeros(size(obj.itinerary.group(gInd).position(pInd).settings_order));
for i=1:length(dropInd2)
    subVector(obj.itinerary.group(gInd).position(pInd).settings_order >= dropInd2(i)) = subVector(obj.itinerary.group(gInd).position(pInd).settings_order >= dropInd2(i))-1;
end
obj.itinerary.group(gInd).position(pInd).settings_order = obj.itinerary.group(gInd).position(pInd).settings_order + subVector;
end