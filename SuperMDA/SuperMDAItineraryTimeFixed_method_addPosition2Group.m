function smdaITF = SuperMDAItineraryTimeFixed_method_addPosition2Group(smdaITF,gInd,pInd,varargin)
%%
% parse the input
p = inputParser;
addRequired(p, 'smdaITF', @(x) isa(x,'SuperMDAItineraryTimeFixed_object'));
addRequired(p, 'gInd', @(x) ismember(x,smdaITF.indOfGroup));
addRequired(p, 'pInd', @(x) ismember(x,1:length(smdaITF.position_logical)));
addOptional(p, 'sNum',1, @(x) mod(x,1)==0);
parse(p,smdaITF,gInd,pInd,varargin{:});

%%
%
if p.Results.sNum == 1
    %%
    % only a single settings is to be added
    %
    % find the order of the last position at a given group
    % find the order of the last position in the given group
    myPOrder = smdaITF.orderOfPosition(gInd);
    mySOrder = smdaITF.orderOfSettings(gInd,myPOrder(end));
    [~,myInd] = ismember([gInd,myPOrder(end),mySOrder(end)],smdaITF.gps,'rows');
    myInd = find(smdaITF.orderVector == myInd,1,'first');
    % find how many settings there are for position at pInd.
    firstPositionSettings = smdaITF.orderOfSettings(gInd,pInd);
    % refer to these settings in the gps and update gps
    for i = 1:length(firstPositionSettings)
        % update gps, order vector, and settings index
        smdaITF.orderVectorInsert(myInd+i);
        smdaITF.gps(smdaITF.ind_next_gps,:) = [gInd,pInd,firstPositionSettings(i)];
        smdaITF.gps_logical(smdaITF.ind_next_gps) = true;
        smdaITF.find_ind_next('gps');
    end
else
error('smdaITF:addPosition2GroupN','this part of the code needs to be created');
end
end