%%
% Create a position by augmenting the position_order vector and taking
% advantage of the the pre-allocation, or create a new position built on
% the |Itinerary| prototypes.
function smdaTA = SuperMDATravelAgent_method_addPosition(smdaTA,gInd,varargin)
%%
% parse the input
p = inputParser;
addRequired(p, 'smdaTA', @(x) isa(x,'SuperMDATravelAgent_object'));
addRequired(p, 'gInd', @(x) ismember(x,smdaTA.itinerary.indOfGroup));
addOptional(p, 'pNum',1, @(x) mod(x,1)==0);
parse(p,smdaTA,gInd,varargin{:});
smdaITF = smdaTA.itinerary;
mm = smdaTA.mm;
%%
%
if p.Results.pNum == 1
    %%
    % only a single position is to be added
    %
    % the position will have the xyz at the current scope position and the
    % settings will be the same as the settings for the first position in
    % this group.
    %
    % add the new position properties reflecting the current smdaTAective
    % position
    pInd = smdaTA.itinerary.indOfPosition(gInd);
    pInd = pInd(1);
    
    smdaITF.position_continuous_focus_offset(smdaITF.ind_next_position) = str2double(mm.core.getProperty(mm.AutoFocusDevice,'Position'));
    smdaITF.position_continuous_focus_bool(smdaITF.ind_next_position) = true;
    smdaITF.position_function_after{smdaITF.ind_next_position} = smdaITF.position_function_after{pInd};
    smdaITF.position_function_before{smdaITF.ind_next_position} = smdaITF.position_function_before{pInd};
    smdaITF.position_label{smdaITF.ind_next_position} = sprintf('position%d',smdaITF.numberOfPosition(gInd)+1);
    smdaITF.position_xyz(smdaITF.ind_next_position,:) = mm.getXYZ;
    % find how many settings there are for position at pInd.
    firstPositionSettings = smdaITF.indOfSettings(gInd,pInd);
    % refer to these settings in the gps and update gps
    for i = 1:length(firstPositionSettings)
        % update gps, order vector, and settings index
        smdaITF.gps(smdaITF.ind_next_gps,:) = [gInd,smdaITF.ind_next_position,firstPositionSettings(i)];
        smdaITF.orderVector(end+1) = smdaITF.ind_next_gps;
        smdaITF.ind_next_gps = smdaITF.ind_next_gps + 1;
    end
    smdaITF.ind_next_position = smdaITF.ind_next_position + 1;
else
    error('smdaTA:addPositionN','this part of the code needs to be created');
end
end