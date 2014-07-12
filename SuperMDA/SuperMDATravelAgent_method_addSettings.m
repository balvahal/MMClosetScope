%%
% Create a position by augmenting the position_order vector and taking
% advantage of the the pre-allocation, or create a new position built on
% the |Itinerary| prototypes.
function smdaTA = SuperMDATravelAgent_method_addSettings(smdaTA,gInd,varargin)
%%
% parse the input
p = inputParser;
addRequired(p, 'smdaTA', @(x) isa(x,'SuperMDATravelAgent_object'));
addRequired(p, 'gInd', @(x) ismember(x,smdaTA.itinerary.indOfGroup));
addOptional(p, 'sNum',1, @(x) mod(x,1)==0);
parse(p,smdaTA,gInd,varargin{:});
smdaITF = smdaTA.itinerary;
%%
%
if p.Results.sNum == 1
    %%
    % only a single settings is to be added
    %
    % The new settings will be the same as the first settings of the first
    % position in the group that contains the pInd.
    %
    % add the new settings
    pIndices = smdaTA.itinerary.indOfPosition(gInd);
    pIndFirst = pIndices(1);
    newSettingsInd = smdaITF.ind_next_settings;
    smdaITF.newSettings(gInd,pIndFirst);
    if length(pIndices) > 1
        for i = 2:length(pIndices)
            smdaITF.addSettings2Position(gInd,pIndices(2),newSettingsInd);
        end
    end
else
error('smdaTA:addSettingsN','this part of the code needs to be created');
end
end