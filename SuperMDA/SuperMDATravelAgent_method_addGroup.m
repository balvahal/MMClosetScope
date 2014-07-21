%%
% Create a group by augmenting the group_order vector and taking advantage
% of the the pre-allocation, or create a new group built on the |Itinerary|
% prototypes.
function smdaTA = SuperMDATravelAgent_method_addGroup(smdaTA,varargin)
%%
% parse the input
p = inputParser;
addRequired(p, 'smdaTA', @(x) isa(x,'SuperMDATravelAgent_object'));
addOptional(p,'gNum',1, @(x) mod(x,1)==0);
parse(p,smdaTA,varargin{:});
smdaITF = smdaTA.itinerary;
%%
%
if p.Results.gNum ==1
    smdaITF.newGroup;
else
    smdaITF.newGroup(p.Results.gNum);
end
end