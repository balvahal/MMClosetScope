%%
% Create a position by augmenting the position_order vector and taking
% advantage of the the pre-allocation, or create a new position built on
% the |Itinerary| prototypes.
function smdaTA = SuperMDATravelAgent_method_addSettings(smdaTA,gInd,varargin)
%%
% parse the input
p = inputParser;
addRequired(p, 'smdaTA', @(x) isa(x,'SuperMDATravelAgent_object'));
addRequired(p, 'gInd', @(x) ismember(x,smdaTA.itinerary.ind_group));
addOptional(p, 'sNum',1, @(x) mod(x,1)==0);
parse(p,smdaTA,gInd,varargin{:});
smdaITF = smdaTA.itinerary;
%%
%
if p.Results.sNum == 1
    smdaITF.addSettings2AllPosition(gInd);
else
    error('smdaTA:addSettingsN','this part of the code needs to be created');
end
end