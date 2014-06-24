%%
% dropInd can be a vector of indices...
%
% dropping a group happens with respect to the group_order property. The
% corresponding group as indicated by the number in the group_order at the
% dropInd will be eliminated all together and permanently deleted from the
% group struct.
%
% First, remove the group(s) and the corresponding indices in the
% group_order.
function obj = SuperMDATravelAgent_method_dropGroupOrder(obj,dropInd)
p = inputParser;
addRequired(p, 'obj', @(x) isa(x,'SuperMDATravelAgent_object'));
addRequired(p, 'dropInd', @(x) isrow(x) && all(ismember(x,obj.itinerary.group_order)));
parse(p,obj,dropInd);
dropInd2 = obj.itinerary.group_order(dropInd);
obj.itinerary.group(dropInd2) = [];
obj.itinerary.group_order(dropInd) = [];
%%
% Next, edit the group_order so that the numbers within are sequential
% (although not necessarily in order).
subVector = zeros(size(obj.intinerary.group_order));
for i=1:length(dropInd2)
    subVector(obj.itinerary.group_order >= dropInd2(i)) = subVector(obj.itinerary.group_order >= dropInd2(i))-1;
end
obj.itinerary.group_order = obj.itinerary.group_order + subVector;
% newNum = transpose(1:length(obj.itinerary.group_order));
% oldNum = transpose(obj.itinerary.group_order);
% funArray = [oldNum,newNum];
% funArray = sortrows(funArray,1);
% obj.itinerary.group_order = transpose(funArray(:,2)); % the group_order must remain a row so that it can be properly looped over.
end