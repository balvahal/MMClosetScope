%%
% dropInd can be a vector of indices...
%
% First, remove the group(s) and the corresponding indices in the
% group_order.
function obj = SuperMDATravelAgent_method_dropGroup(obj,dropInd)
p = inputParser;
addRequired(p, 'obj', @(x) isa(x,'SuperMDATravelAgent_object'));
addRequired(p, 'dropInd', @(x) isrow(x) && all(ismember(x,1:length(obj.itinerary.group))));
parse(p,obj,dropInd);
dropInd2 = obj.itinerary.group_order == dropInd;
obj.itinerary.group(dropInd) = [];
obj.itinerary.group_order(dropInd2) = [];
%%
% Next, edit the group_order so that the numbers within are sequential
% (although not necessarily in order).
subVector = zeros(size(obj.intinerary.group_order));
for i=1:length(dropInd)
    subVector(obj.itinerary.group_order >= dropInd(i)) = subVector(obj.itinerary.group_order >= dropInd(i))-1;
end
obj.itinerary.group_order = obj.itinerary.group_order + subVector;
end