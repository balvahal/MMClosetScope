%%
% Create a position by augmenting the position_order vector and taking
% advantage of the the pre-allocation, or create a new position built on
% the |Itinerary| prototypes.
function smdaITF = SuperMDAItineraryTimeFixed_method_addSettings2AllPosition(smdaITF,gInd,varargin)
%%
% parse the input
p = inputParser;
addRequired(p, 'smdaITF', @(x) isa(x,'SuperMDAItineraryTimeFixed_object'));
addRequired(p, 'gInd', @(x) ismember(x,smdaITF.indOfGroup));
addOptional(p, 'sNum',1, @(x) mod(x,1)==0);
parse(p,smdaITF,gInd,varargin{:});
%%
%
if p.Results.sNum == 1
    %%
    % only a single settings is to be added
    %
    % The new settings will be the same as the first settings of the first
    % position in the group that contains the pInd.
    %
    % add the new settings to all positions in a group
    pIndices = smdaITF.indOfPosition(gInd);
    pIndFirst = pIndices(1);
    newSettingsInd = smdaITF.ind_next_settings;
    smdaITF.newSettings(gInd,pIndFirst);
    if length(pIndices) > 1
        for i = 2:length(pIndices)
            smdaITF.addSettings2Position(gInd,pIndices(i),newSettingsInd);
        end
    end
else
error('smdaITF:addSettingsN','this part of the code needs to be created');
end
end