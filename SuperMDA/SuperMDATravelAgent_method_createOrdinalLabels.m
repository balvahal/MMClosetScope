function obj = SuperMDATravelAgent_method_createOrdinalLabels(obj,varargin)
p = inputParser;
addRequired(p, 'obj', @(x) isa(x,'SuperMDATravelAgent_object'));
addOptional(p, 'gInd', 1:length(obj.itinerary.group), @(x) isrow(x) && all(ismember(x,1:length(obj.itinerary.group))));
parse(p,obj,varargin{:});
for i = p.Results.gInd
    mystr = sprintf('group%d',i);
    obj.itinerary.group(i).label = mystr;
    for j = 1:length(obj.itinerary.group(i).position)
        mystr = sprintf('position%d',j);
%         obj.itinerary.group(end).position(j).label = mystr;
    end
end
end