function obj = SuperMDATravelAgent_method_addPositionSet(obj,gInd,grid)
p = inputParser;
addRequired(p, 'obj', @(x) isa(x,'SuperMDATravelAgent_object'));
addRequired(p, 'gInd', @(x) (numel(x) == 1) && all(ismember(x,1:length(obj.itinerary.group))));
addRequired(p, 'pSet', @(x) isstruct(x));
parse(p,obj,gInd,grid);

obj.group(gInd).position = repmat(obj.group(1).position(1),size(pSet,1),1);
for i = 1:size(pSet,1)
            obj.group(1).position(1).xyz(:,1) = obj.mm.pos(1);
            obj.group(1).position(1).xyz(:,2) = obj.mm.pos(2);
            obj.group(1).position(1).xyz(:,3) = obj.mm.pos(3);
end