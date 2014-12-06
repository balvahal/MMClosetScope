function obj = SuperMDATravelAgent_method_createOrdinalLabels(obj,varargin)
p = inputParser;
addRequired(p, 'obj', @(x) isa(x,'SuperMDATravelAgent_object'));
parse(p,obj,varargin{:});
for i = obj.itinerary.ind_group
    counter = 1;
    for j = obj.itinerary.order_position{i}
        obj.itinerary.position_label{j} = sprintf('position%d',counter);
        counter = counter + 1;
    end
end

end