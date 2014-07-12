%%
% Create a position by augmenting the position_order vector and taking
% advantage of the the pre-allocation, or create a new position built on
% the |Itinerary| prototypes.
function smdaITF = SuperMDAItineraryTimeFixed_method_addSettings2Position(smdaITF,gInd,pInd,sInd,varargin)
%%
% parse the input
p = inputParser;
addRequired(p, 'smdaITF', @(x) isa(x,'SuperMDAItineraryTimeFixed_object'));
addRequired(p, 'gInd', @(x) ismember(x,smdaITF.indOfGroup));
addRequired(p, 'pInd', @(x) ismember(x,smdaITF.indOfPosition(gInd)));
addRequired(p, 'sInd', @(x) ismember(x,1:length(smdaITF.settings_binning)));
addOptional(p, 'sNum',1, @(x) mod(x,1)==0);
parse(p,smdaITF,gInd,pInd,sInd,varargin{:});

%%
%
if p.Results.sNum == 1
    %%
    % only a single settings is to be added
    %
    % find the order of the last settings at the given position
    mySOrder = smdaITF.orderOfSettings(gInd,pInd);
    [~,myInd] = ismember([gInd,pInd,mySOrder(end)],smdaITF.gps,'rows');
    myInd = find(smdaITF.orderVector == myInd,1,'first');
    smdaITF.orderVectorInsert(myInd+1);
    % update gps, order vector, and settings index
    smdaITF.gps(smdaITF.ind_next_gps,:) = [gInd,pInd,sInd];
    smdaITF.ind_next_gps = smdaITF.ind_next_gps + 1;
else
error('smdaITF:addSettingsN','this part of the code needs to be created');
end
end