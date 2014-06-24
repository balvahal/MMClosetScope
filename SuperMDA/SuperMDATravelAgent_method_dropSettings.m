function obj = SuperMDATravelAgent_method_dropSettings(obj,gInd,pInd,dropInd)
p = inputParser;
addRequired(p, 'obj', @(x) isa(x,'SuperMDATravelAgent_object'));
addRequired(p, 'gInd', @(x) isrow(x) && all(ismember(x,1:length(obj.itinerary.group))));
addRequired(p, 'pInd', @(x) isrow(x) && all(ismember(x,1:length(obj.itinerary.group(gInd).position))));
addRequired(p, 'dropInd', @(x) isrow(x) && all(ismember(x,1:length(obj.itinerary.group(gInd).position(pInd).settings))));
parse(p,obj,gInd,pInd,dropInd);


dropInd2 = obj.itinerary.group(gInd).position(pInd).settings_order == dropInd;
obj.itinerary.group(gInd).position(pInd).settings(dropInd) = [];
obj.itinerary.group(gInd).position(pInd).settings_order(dropInd2) = [];
%%
% Next, edit the group_order so that the numbers within are sequential
% (although not necessarily in order).
subVector = zeros(size(obj.intinerary.group(gInd).position(pInd).settings_order));
for i=1:length(dropInd)
    subVector(obj.itinerary.group(gInd).position(pInd).settings_order >= dropInd(i)) = subVector(obj.itinerary.group(gInd).position(pInd).settings_order >= dropInd(i))-1;
end
obj.itinerary.group(gInd).position(pInd).settings_order = obj.itinerary.group(gInd).position(pInd).settings_order + subVector;
end