%%
% dropInd can be a vector of indices...
%
% First, remove the group(s) and the corresponding indices in the
% group_order.
function obj = SuperMDATravelAgent_method_dropGroup(obj,dropInd)
p = inputParser;
addRequired(p, 'obj', @(x) isa(x,'SuperMDATravelAgent_object'));
addRequired(p, 'dropInd', @(x) isrow(x) && all(ismember(x,obj.itinerary.ind_group)));
parse(p,obj,dropInd);
for i = 1:length(dropInd)
    obj.itinerary.dropGroup(dropInd(i));
end
end